// PREVIEW ONLY (F5): Vault cap + neck gasket screwed onto the reference neck, cut in half.
// Shows the gasket crush, thread clearance and the open-ended thread groove.
include <parts.scad>
crush = 0.6;   // how much the gasket is compressed when tight

module cut(c) { color(c) difference() { rotate([180, 0, 0]) children(); color(c) translate([-100, -200, -100]) cube([200, 200, 200]); } }

cut("SteelBlue")    vault_cap();
cut("Tomato")       translate([0, 0, top_t]) neck_gasket();
cut("DarkSeaGreen") translate([0, 0, z_lip - crush]) rotate([180, 0, 0]) neck_reference();
