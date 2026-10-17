// PREVIEW ONLY (F5): Port cap with plug screwed in, on the reference neck, cut in half.
include <parts.scad>
crush = 0.6;  pcrush = 0.4;

module cut(c) { color(c) difference() { rotate([180, 0, 0]) children(); color(c) translate([-100, -200, -100]) cube([200, 200, 200]); } }

cut("SteelBlue")      port_cap();
cut("CornflowerBlue") translate([0, 0, head_sink + port_gasket_t - pcrush - head_h]) port_plug();   // plug printed head-down
cut("Tomato")         translate([0, 0, head_sink - (port_gasket_t - pcrush)]) port_gasket();
cut("Tomato")         translate([0, 0, top_t]) neck_gasket();
cut("DarkSeaGreen")   translate([0, 0, z_lip - crush]) rotate([180, 0, 0]) neck_reference();
