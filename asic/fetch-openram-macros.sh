#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
macro_root="${repo_root}/asic/macros/sky130_sram_macros"
revision="965df150c754fe2b3f93a0bd1f9883eb114279b2"
macro="sky130_sram_1kbyte_1rw1r_8x1024_8"

if [[ ! -d "${macro_root}/.git" ]]; then
  mkdir -p "$(dirname "${macro_root}")"
  git clone https://github.com/VLSIDA/sky130_sram_macros.git "${macro_root}"
fi

git -C "${macro_root}" fetch origin "${revision}"
git -C "${macro_root}" checkout --detach "${revision}"

for extension in v lef gds; do
  test -f "${macro_root}/${macro}/${macro}.${extension}"
done
test -f "${macro_root}/${macro}/${macro}_TT_1p8V_25C.lib"
