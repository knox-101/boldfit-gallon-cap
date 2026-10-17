// PREVIEW ONLY (F5): Flip cap closed on the neck, cut through the spout + hinge + latch.
include <parts.scad>
crush = 0.6;

module cut(c) { color(c) difference() { rotate([180, 0, 0]) children(); color(c) translate([-100, -200, -100]) cube([200, 200, 200]); } }

cut("SteelBlue")      flip_base();
cut("CornflowerBlue") translate([0, 0, -lid_t]) flip_lid();            // lid printed face-down: closed = shifted down by its thickness
cut("Tomato")         translate([spout_off, 0, -lid_t]) flip_seal();
cut("Tomato")         translate([0, 0, top_t]) neck_gasket();
cut("DarkSeaGreen")   translate([0, 0, z_lip - crush]) rotate([180, 0, 0]) neck_reference();
