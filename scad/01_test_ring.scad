// =====================================================================
//  01  THREAD TEST RING  – print this FIRST (10-15 min, ~6 g)
//  Just the threaded skirt, no top.  Screw it on the bottle:
//    • too tight / will not start  -> raise radial_clear by 0.1 in params.scad
//    • sloppy / wobbles            -> lower radial_clear by 0.1
//    • binds half way              -> thread_pitch or thread_starts is wrong
//    • bottoms out before the lip  -> thread_start_z / thread_turns are off
// =====================================================================
include <parts.scad>
test_ring();
