# Pipelined RV32I RISC-V CPU

This repository contains a five-stage RV32I CPU with synchronous instruction,
data, and register-file interfaces. It supports the Zmmul subset, data-hazard
bypassing, load-use stalls, control-flow prediction, and Verilator execution of
linked C programs.

## Predictor timing

The target and direction predictors are deliberately separate:

- A 32-entry direct-mapped BTB is indexed by the fetch PC. Every hit predicts a
  transfer to its cached target during fetch.
- A 64-entry gshare table with six history bits is indexed in decode. For a
  conditional branch, it either confirms the BTB-taken path or redirects to the
  fall-through path.
- Execute resolves the branch, updates the BTB and the saved gshare counter
  index, and performs authoritative recovery on a mismatch.

## Decoupled cache issue

The frontend has a four-entry ordered fetch window. It submits a new request on
every cycle that `bsg_cache` accepts one, saves the PC and BTB prediction with
that request, and fills the corresponding entry when the ordered response
returns. Decode consumes completed entries independently. Branch recovery bumps
an epoch and discards stale responses without draining the cache pipeline first.

The data side has a four-entry ordered store queue. A store retires after its
address, data, and byte mask enter the queue; queued stores can then issue to the
BSG D-cache on consecutive cycles. Loads conservatively wait for all older
stores to receive cache responses, preserving program order without requiring
store-to-load forwarding.

## Multiply

`MUL`, `MULH`, `MULHSU`, and `MULHU` share one signedness-controlled 33x33
combinational product datapath. The current pre-layout timing result identifies
this as the next microarchitectural target: it should become multi-cycle or
pipelined before attempting a timing-clean physical design.

## Simulation and benchmarks

The default simulation environment uses Verilator and the RV32 Zmmul GNU
toolchain configured in `Sim/site-config.sh`.

```sh
make predictor-test
make cache-test
make attention
```

The directed regressions cover all four multiply results, predictable branch
traffic, and dirty evictions from a working set twice the D-cache capacity. The
deterministic 16x16 integer attention benchmark checks its input,
projection, Q/K/V, score, probability, and output tensor hashes against the
accelerator reference. MMIO markers delimit kernel-only cycle, retired
instruction, branch, and misprediction counters.

Both L1s are 8 KiB, two-way, write-back BaseJump STL `bsg_cache` instances with
32-byte lines. A four-entry metadata adapter preserves ordered CPU responses,
while a blocking line-DMA bridge converts refills and evictions to the
simulation memory's 32-bit transactions. The MMIO window at `0x0002fff0` is
uncached.

## Sky130 PPA

```sh
make ppa
```

This uses the OSS CAD Suite for synthesis and the OpenLane2 Nix environment for
OpenROAD timing and vectorless power. See `asic/README.md` for the synthesis
boundary and assumptions.
