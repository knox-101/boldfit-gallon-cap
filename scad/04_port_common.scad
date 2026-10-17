// Shared numbers for the PORT cap (main cap, plug, gasket)
head_d         = 42.0;   // plug head diameter
head_h         = 5.0;    // head thickness above the gasket
head_sink      = 1.5;    // head counterbore depth in the main cap (gasket lives here)
head_clear     = 0.5;    // radial clearance head / counterbore
port_gasket_t  = 1.5;

port_minor_d   = 30.0;   // male plug thread root diameter
port_major_d   = 33.0;   // male plug thread crest diameter
port_pitch     = 3.0;
port_starts    = 2;      // 2-start: a quarter turn opens it
port_turns     = 1.0;
port_crest_w   = 0.8;
port_root_w    = 1.9;
port_thread_h  = (port_major_d - port_minor_d) / 2;
port_tube_wall = 2.4;
port_tube_od   = port_major_d + 2 * radial_clear + 2 * port_tube_wall;
port_len       = port_pitch * port_starts * port_turns;        // axial length one start covers
port_tube_h    = head_sink + 1.5 + port_len + 2.0 - top_t;     // tube below the cap ceiling
port_stem_len  = 1.5 + port_len + 2.0;                         // plug stem below the head

// Male thread of the plug in the plug's natural frame: head underside at z = 0,
// threaded stem pointing +z.  Thread starts 1.5 mm from the head.
module port_male_thread(clear_r = 0, clear_z = 0, extend = 0) {
    rmin = port_minor_d / 2 + clear_r;
    rmaj = port_major_d / 2 + clear_r;
    z_bottom = 1.5 + port_crest_w / 2;             // near the head
    z_top    = z_bottom + port_len + extend;       // towards the stem tip
    union() {
        cylinder(r = rmin, h = z_top + 1);
        helix_thread(rmin, rmaj, port_pitch, port_starts, z_top, z_bottom,
                     port_crest_w + 2 * clear_z, port_root_w + 2 * clear_z);
    }
}
