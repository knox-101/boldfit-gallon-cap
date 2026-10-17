// Shared numbers + hinge/latch modules for the FLIP cap (base and lid)
spout_d      = 22;      // drinking hole diameter
spout_off    = 10;      // hole centre offset from cap centre (towards +x, away from hinge)
spout_boss_h = 2.5;     // extra ring under the ceiling so the plug has a 5 mm sealing land
pin_hole_d   = 2.0;     // clearance hole for a 1.75 mm filament pin
ear_w        = 4;       // hinge ear thickness
ear_gap      = 12.6;    // gap between ears (lid knuckle 12 mm + clearance)
ear_r        = 4;       // ear radius around the pin
hinge_out    = 3.0;     // pin axis distance outside the skirt wall
latch_w      = 12;
latch_nub    = 1.0;     // how far the latch nub protrudes beyond the skirt (snap depth 0.7)
nub_top_z    = 1.5;     // (base frame) where the nub ramp starts at the wall
nub_bot_z    = 4.0;     // (base frame) flat bearing face of the nub
lid_t        = 3.0;

module hinge_ears() {
    for (s = [-1, 1])
        translate([-(cap_od / 2 + hinge_out), s * (ear_gap / 2 + ear_w / 2), 0])
            hull() {
                translate([0, 0, ear_r]) rotate([90, 0, 0]) cylinder(r = ear_r, h = ear_w, center = true);
                translate([hinge_out + 1.5, 0, ear_r]) cube([3, ear_w, 2 * ear_r], center = true);
            }
}
// nub: flat bottom face (bearing), ramped top face (lead-in for closing)
module latch_nub() {
    R = cap_od / 2;
    hull() {
        translate([R - 0.6, -latch_w / 2, nub_top_z]) cube([0.6, latch_w, nub_bot_z - nub_top_z]);
        translate([R + latch_nub - 0.3, -latch_w / 2 + 1, nub_bot_z - 0.8]) cube([0.3, latch_w - 2, 0.8]);
    }
}
