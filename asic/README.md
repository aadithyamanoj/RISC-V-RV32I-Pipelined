# Sky130 pre-layout PPA

`make ppa` at the repository root synthesizes `cached_core` with the OSS CAD Suite,
then runs OpenROAD/OpenSTA in the OpenLane2 Nix shell. The default comparison
point is Sky130 HD, TT/1.8 V/25 C, 20 MHz, and 10% vectorless activity.

The backing instruction/data memories are outside the synthesis boundary. Both
8 KiB BaseJump L1 data arrays are inside it: their sixteen 8x1024 byte banks map
to pinned VLSIDA Sky130 OpenRAM macros. The smaller cache tag/status arrays,
register file, BTB, and gshare tables remain inferred and are mapped to standard
cells. This is a pre-layout estimate with no extracted parasitics.

The current 20 MHz report does not close timing: WNS is -35.07 ns. Its worst
path starts at `pc[2]`, crosses the inferred BTB lookup, and ends in the 64-bit
BTB-hit profiling counter; it does not cross the registered multiplier. The
large unbuffered PC fanout makes this pre-layout result pessimistic. A meaningful
closure attempt needs placement-aware buffering and should pipeline the BTB-hit
event before the profiling counter (or exclude profiling counters from the
implementation build).
