// =====================================================================
//  parts.scad – every printable part as a module.
//  The numbered files just include this and call one module; the
//  view_section_*.scad files assemble several of them.
// =====================================================================
include <cap_lib.scad>
include <03_flip_common.scad>
include <04_port_common.scad>

// ---------------------------------------------------------------- 02 VAULT
module vault_cap(loop = true, top_text = "", text_size = 8) {
    difference() {
        union() {
            cap_body();
            if (loop) d_loop();
        }
        if (top_text != "")
            translate([0, 0, -0.01]) mirror([1, 0, 0])   // mirrored because the bed face is read from outside
                linear_extrude(0.6) text(top_text, size = text_size, halign = "center", valign = "center",
                                         font = "Liberation Sans:style=Bold");
    }
}

// ---------------------------------------------------------------- 03 FLIP
module flip_base() {
    difference() {
        union() {
            cap_body();
            hinge_ears();
            latch_nub();
            // sealing-land boss under the ceiling (prints as a short tower)
            translate([spout_off, 0, top_t - 0.01]) cylinder(d = spout_d + 6, h = spout_boss_h + 0.01);
        }
        // drinking hole, chamfered both ends
        translate([spout_off, 0, -1]) cylinder(d = spout_d, h = top_t + spout_boss_h + 2);
        translate([spout_off, 0, -0.01]) cylinder(d1 = spout_d + 1.2, d2 = spout_d, h = 0.6);
        translate([spout_off, 0, top_t + spout_boss_h - 0.59]) cylinder(d1 = spout_d, d2 = spout_d + 1.2, h = 0.6);
        // pin hole through both ears (through-hole: flushes clean)
        translate([-(cap_od / 2 + hinge_out), 0, ear_r]) rotate([90, 0, 0])
            cylinder(d = pin_hole_d, h = ear_gap + 2 * ear_w + 2, center = true, $fn = 24);
    }
}

flip_knuckle_w   = 12;      // fits between the base ears
flip_tab_t       = 1.6;     // latch tab thickness (flexes)
flip_hook_clear  = 0.2;     // gap between hook and nub bearing face when closed
flip_cap_rim     = 1.0;     // lid overhangs the cap by this much
flip_seal_stem_d = 9.0;     // TPU stem passes through this hole
flip_seal_head_d = 12.4;    // counterbore on TOP for the TPU button (sits flush)
flip_seal_head_t = 1.2;

module flip_lid() {
    R      = cap_od / 2;
    lid_d  = cap_od + 2 * flip_cap_rim;
    tab_x  = R + latch_nub + 0.3;                       // inner face of the tab plate
    hook_z = lid_t + nub_bot_z + flip_hook_clear;       // top (bearing) face of the hook
    latch_drop = nub_bot_z + flip_hook_clear + 0.8 + 1.2;
    difference() {
        union() {
            hull() {                                                   // disc with a soft bed-side edge
                translate([0, 0, 0.8]) cylinder(d = lid_d, h = lid_t - 0.8);
                cylinder(d = lid_d - 1.6, h = 0.8);
            }
            translate([-(R + hinge_out), 0, 0])                        // hinge knuckle
                hull() {
                    translate([0, 0, lid_t + ear_r]) rotate([90, 0, 0]) cylinder(r = ear_r, h = flip_knuckle_w, center = true);
                    translate([hinge_out + 1.5, 0, lid_t / 2]) cube([3, flip_knuckle_w, lid_t], center = true);
                }
            // latch: bridge from disc -> tab plate -> thumb lip
            translate([R - 1.5, -latch_w / 2 - 1, 0]) cube([latch_nub + 1.8 + flip_tab_t + 3.5, latch_w + 2, lid_t]);
            translate([tab_x, -latch_w / 2, 0]) cube([flip_tab_t, latch_w, lid_t + latch_drop]);   // hanging tab
            hull() {                                                   // hook: flat top bears under the nub, ramped bottom
                translate([R + 0.3, -latch_w / 2 + 1, hook_z]) cube([tab_x - (R + 0.3) + 0.01, latch_w - 2, 0.8]);
                translate([tab_x - 0.01, -latch_w / 2 + 1, hook_z]) cube([0.01, latch_w - 2, 0.8 + 1.2]);
            }
        }
        translate([-(R + hinge_out), 0, lid_t + ear_r]) rotate([90, 0, 0])          // pin hole
            cylinder(d = pin_hole_d, h = flip_knuckle_w + 2, center = true, $fn = 24);
        translate([spout_off, 0, -1]) cylinder(d = flip_seal_stem_d, h = lid_t + 2);  // keyhole stem
        translate([spout_off, 0, -0.01]) cylinder(d = flip_seal_head_d, h = flip_seal_head_t); // flush button counterbore
        translate([spout_off, 0, lid_t - 0.6]) cylinder(d = spout_d + 6.4, h = 1);    // 0.6 mm flange recess (open)
        translate([R + latch_nub + 0.3 + flip_tab_t + 3.5, 0, -1]) rotate(45) cube([1.2, 1.2, lid_t + 2]); // thumb-lip edge
    }
}

flip_plug_squeeze = 0.5;    // plug is this much LARGER than the hole at its widest -> seal
flip_plug_h       = 6.0;
flip_flange_t     = 0.9;    // 0.6 in the recess + 0.3 proud = light face seal on the cap top

module flip_seal() {
    seal_head_d = flip_seal_head_d - 0.4;
    seal_head_t = flip_seal_head_t - 0.1;
    flange_d    = spout_d + 6.0;
    cylinder(d = seal_head_d, h = seal_head_t);                                                       // button
    translate([0, 0, seal_head_t - 0.01]) cylinder(d = flip_seal_stem_d - 0.3, h = lid_t - seal_head_t - 0.6 + 0.02); // stem
    translate([0, 0, lid_t - 0.6]) cylinder(d = flange_d, h = flip_flange_t);                         // flange
    translate([0, 0, lid_t - 0.6 + flip_flange_t - 0.01])                                             // tapered plug
        cylinder(d1 = spout_d + flip_plug_squeeze, d2 = spout_d - 2.0, h = flip_plug_h);
}

// ---------------------------------------------------------------- 04 PORT
module port_cap(loop = true) {
    difference() {
        union() {
            cap_body();
            if (loop) d_loop();
            translate([0, 0, top_t - 0.01]) cylinder(d = port_tube_od, h = port_tube_h + 0.01);   // port tube
        }
        translate([0, 0, -1]) cylinder(d = head_d + 2 * head_clear, h = head_sink + 1);              // head counterbore
        translate([0, 0, head_sink]) port_male_thread(clear_r = radial_clear, clear_z = axial_clear,
                                                      extend = port_tube_h + 5);                      // female thread
        translate([0, 0, top_t + port_tube_h - 1.0]) cylinder(d1 = port_major_d - 1.0, d2 = port_major_d + 2.0, h = 1.01);
    }
}

port_bar_w = 6;  port_bar_l = 26;  port_bar_depth = 2.0;   // finger/coin bar recess in the top face
port_stem_wall = 2.4;

module port_plug() {
    difference() {
        union() {
            difference() {                                   // head with scallops
                cylinder(d = head_d, h = head_h);
                for (i = [0 : 15]) rotate(i * 22.5)
                    translate([head_d / 2 + 1.6, 0, 1.2]) cylinder(d = 4, h = head_h);
                rotate_extrude() translate([head_d / 2, 0]) rotate(45) square([1.4, 1.4], center = true);
            }
            intersection() {                                 // threaded stem, trimmed to length
                translate([0, 0, head_h - 0.01]) port_male_thread();
                translate([0, 0, head_h]) cylinder(d = port_major_d + 4, h = port_stem_len);
            }
        }
        translate([0, 0, head_h + 1.0]) cylinder(d = port_minor_d - 2 * port_stem_wall, h = port_stem_len + 10); // hollow stem
        translate([0, 0, -0.01]) linear_extrude(port_bar_depth) square([port_bar_l, port_bar_w], center = true);
        translate([0, 0, head_h + port_stem_len - 1.0]) difference() {                                // tip chamfer
            cylinder(d = port_major_d + 4, h = 1.01);
            cylinder(d1 = port_major_d + 0.5, d2 = port_minor_d - 0.5, h = 1.0);
        }
    }
}

module port_gasket() {
    difference() {
        cylinder(d = head_d - 1.0, h = port_gasket_t);
        translate([0, 0, -1]) cylinder(d = port_major_d + 2 * radial_clear + 1.0, h = port_gasket_t + 2);
    }
}

// ---------------------------------------------------------------- 05 NECK GASKET
module neck_gasket() {
    gasket_od = neck_minor_d + 1.2 + 0.4;
    gasket_id = mouth_id - 3.0;
    difference() {
        cylinder(d = gasket_od, h = gasket_t);
        translate([0, 0, -1]) cylinder(d = gasket_id, h = gasket_t + 2);
        translate([0, 0, gasket_t - 0.4]) rotate_extrude() translate([gasket_od / 2, 0.4]) rotate(45) square([0.6, 0.6], center = true);
    }
}

// ---------------------------------------------------------------- 01 TEST RING
module test_ring() {
    ring_h = skirt_h + 1.0;
    difference() {
        grip_outer_solid(ring_h);
        translate([0, 0, -(z_lip - 1.0)]) cap_negative();
        translate([0, 0, -1]) cylinder(d = cap_bore_d, h = 3);
        for (a = [0, 120, 240]) rotate(a) translate([cap_od / 2, 0, ring_h / 2])
            rotate([0, 0, 45]) cube([2, 2, ring_h + 1], center = true);
    }
}
