// =====================================================================
//  cap_lib.scad – shared cap body (female thread, gasket seat, grip, loop)
//  Every cap is modelled PRINT-READY: outer top face on z = 0 (the bed),
//  open skirt pointing UP.  No supports needed.
//
//  Hygiene rules baked in:
//   • thread groove runs OUT of the skirt – no dead-end helix to trap water
//   • gasket seat is a 0.8 mm open pocket with chamfered edge – gasket
//     lifts out, nothing hides behind it
//   • every inside corner is chamfered, outer grip is scallops (wipeable)
// =====================================================================
include <threads.scad>

z_lip = top_t + gasket_t;            // where the bottle lip rests (gasket uncompressed)
cap_h = z_lip + skirt_h;             // total cap height

// ---- grip ------------------------------------------------------------
grip_count   = 24;
scallop_d    = 5.0;        // scallop cutter diameter
scallop_bite = 0.9;        // how deep the scallop cuts into the wall

module grip_outer_solid(h = cap_h) {
    difference() {
        cylinder(d = cap_od, h = h);
        for (i = [0 : grip_count - 1]) rotate(i * 360 / grip_count)
            translate([cap_od / 2 + scallop_d / 2 - scallop_bite, 0, 1.6])
                cylinder(d = scallop_d, h = h);
        // bed-side edge chamfer for a clean first layer and a soft rim
        rotate_extrude() translate([cap_od / 2, 0]) rotate(45) square([1.7, 1.7], center = true);
        // skirt-mouth outer chamfer
        rotate_extrude() translate([cap_od / 2, h]) rotate(45) square([1.2, 1.2], center = true);
    }
}

// ---- the female thread + gasket seat, as a NEGATIVE ------------------
module cap_negative() {
    // bottle neck with clearances, flipped so the lip sits at z_lip
    translate([0, 0, z_lip]) rotate([180, 0, 0])
        neck(clear_r = radial_clear, clear_z = axial_clear,
             thread_extend = skirt_extra + 2 * thread_pitch, extra_core = 30);
    // shallow gasket seat with a 45° chamfered rim (no sharp inside corner)
    translate([0, 0, top_t]) cylinder(d = neck_minor_d + 1.2, h = gasket_pocket + 0.01);
    translate([0, 0, top_t + gasket_pocket - 0.01])
        cylinder(d1 = neck_minor_d + 1.2, d2 = neck_minor_d + 1.2 + 2 * gasket_pocket, h = gasket_pocket);
    // chamfer the ledge-to-bore corner
    translate([0, 0, z_lip - 1.0]) cylinder(d1 = cap_bore_d - 2.0, d2 = cap_bore_d, h = 1.01);
    // lead-in chamfer at the skirt mouth so the cap finds the thread easily
    translate([0, 0, cap_h - 1.2]) cylinder(d1 = cap_bore_d, d2 = cap_bore_d + 2.4, h = 1.21);
}

// ---- complete plain cap body ----------------------------------------
module cap_body() {
    difference() {
        grip_outer_solid();
        cap_negative();
    }
}

// ---- D-loop for the Boldfit strap / a carabiner ---------------------
loop_w  = 16;    // inside width
loop_t  = 4;     // bar thickness
loop_ht = 8;     // height (lies flat on the bed, beside the cap)

module d_loop() {
    translate([cap_od / 2 - 1.5, 0, 0]) difference() {
        hull() {
            translate([0, -(loop_w / 2 + loop_t), 0]) cube([1, loop_w + 2 * loop_t, loop_ht]);
            translate([loop_w / 2 + loop_t, 0, 0]) cylinder(d = loop_w + 2 * loop_t, h = loop_ht);
        }
        hull() {
            translate([loop_t, -loop_w / 2, -1]) cube([1, loop_w, loop_ht + 2]);
            translate([loop_w / 2 + loop_t, 0, -1]) cylinder(d = loop_w, h = loop_ht + 2);
        }
    }
}
