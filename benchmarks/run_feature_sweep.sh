#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
result_dir="${repo_root}/benchmarks/results"
csv="${result_dir}/feature_sweep.csv"

mkdir -p "${result_dir}"
printf '%s\n' \
  'config,workload,cycles,retired,branches,mispredicts,btb_hits,kernel_cycles,kernel_retired,kernel_branches,kernel_mispredicts,icache_hits,icache_misses,dcache_hits,dcache_misses,dcache_writebacks' \
  > "${csv}"

metric() {
  local log="$1"
  local record="$2"
  local key="$3"
  awk -v record="${record}" -v key="${key}" '
    $1 == record {
      for (field = 2; field <= NF; field++) {
        split($field, pair, "=")
        if (pair[1] == key) {
          print pair[2]
          exit
        }
      }
    }
  ' "${log}"
}

record_run() {
  local config="$1"
  local workload="$2"
  local log="$3"
  local halt

  halt="$(metric "${log}" HALT code)"
  if [[ "${halt}" != "0xc0de" ]]; then
    echo "${config}/${workload} failed with halt code ${halt}" >&2
    return 1
  fi

  printf '%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n' \
    "${config}" "${workload}" \
    "$(metric "${log}" PROFILE cycles)" \
    "$(metric "${log}" PROFILE retired)" \
    "$(metric "${log}" PROFILE branches)" \
    "$(metric "${log}" PROFILE mispredicts)" \
    "$(metric "${log}" PROFILE btb_hits)" \
    "$(metric "${log}" KERNEL_PROFILE cycles)" \
    "$(metric "${log}" KERNEL_PROFILE retired)" \
    "$(metric "${log}" KERNEL_PROFILE branches)" \
    "$(metric "${log}" KERNEL_PROFILE mispredicts)" \
    "$(metric "${log}" CACHE_PROFILE icache_hits)" \
    "$(metric "${log}" CACHE_PROFILE icache_misses)" \
    "$(metric "${log}" CACHE_PROFILE dcache_hits)" \
    "$(metric "${log}" CACHE_PROFILE dcache_misses)" \
    "$(metric "${log}" CACHE_PROFILE dcache_writebacks)" \
    >> "${csv}"
}

run_config() {
  local config="$1"
  local predict="$2"
  local fetch_depth="$3"
  local store_depth="$4"
  local metadata_depth="$5"
  local log

  make_args=(
    "PREDICT=${predict}"
    "FETCH_DEPTH=${fetch_depth}"
    "STORE_DEPTH=${store_depth}"
    "CACHE_META_DEPTH=${metadata_depth}"
  )

  cd "${repo_root}"
  make clean >/dev/null
  log="${result_dir}/${config}_predictor.log"
  make result-verilator TEST_C=tests/predictor_mul.c "${make_args[@]}" \
    | tee "${log}"
  record_run "${config}" predictor "${log}"

  while IFS=: read -r workload source; do
    log="${result_dir}/${config}_${workload}.log"
    make test "TEST_C=${source}" >/dev/null
    ./result-verilator | tee "${log}"
    record_run "${config}" "${workload}" "${log}"
  done <<'EOF'
cache:tests/cache_stress.c
attention:benchmarks/attention.c
smoke:tests/test.c
EOF
}

run_config minimum 0 1 1 1
run_config maximum 1 4 4 4
python3 "${repo_root}/benchmarks/render_feature_sweep.py" "${csv}" "${result_dir}"

echo "Saved benchmark data to ${csv}"
