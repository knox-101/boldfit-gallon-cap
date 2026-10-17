// =====================================================================
//  threads.scad  –  helical thread sweep + bottle-neck model
//  Pure OpenSCAD, no external libraries needed.
// =====================================================================
include <params.scad>

// A right-hand helical thread of trapezoidal section.
//   r_root   : radius where the thread meets the core
//   r_crest  : radius of the crest
//   z_top    : z of the THREAD CENTRE at its upper end (near the lip)
//   z_bottom : z of the thread centre at its lower end
//   starts   : number of starts (spaced 360/starts apart)
module helix_thread(r_root, r_crest, pitch, starts, z_top, z_bottom,
                    crest_w, root_w, steps_per_turn = 96, overlap = 0.5) {
    lead  = pitch * starts;
    turns = (z_top - z_bottom) / lead;
    n     = max(2, ceil(turns * steps_per_turn));
    ri    = r_root - overlap;                    // bury the root inside the core
    for (s = [0 : starts - 1]) {
        a0 = s * 360 / starts;
        pts = [ for (i = [0 : n])
                let (a = i * 360 * turns / n, z = z_bottom + a / 360 * lead,
                     c = cos(a + a0), sn = sin(a + a0))
                each [ [ri * c,      ri * sn,      z - root_w  / 2],
                       [r_crest * c, r_crest * sn, z - crest_w / 2],
                       [r_crest * c, r_crest * sn, z + crest_w / 2],
                       [ri * c,      ri * sn,      z + root_w  / 2] ] ];
        // side quads are split into triangles: the helix makes them non-planar
        faces = concat(
            [[3, 2, 1, 0]],
            [ for (i = [0 : n - 1], j = [0 : 3])
                let (b = 4 * i, k = (j + 1) % 4) each [[b + k, b + k + 4, b + j + 4], [b + k, b + j + 4, b + j]] ],
            [[4 * n, 4 * n + 1, 4 * n + 2, 4 * n + 3]] );
        polyhedron(points = pts, faces = faces, convexity = 10);
    }
}

// The bottle neck in its natural frame: lip (top rim) at z = 0, bottle below.
//   clear_r / clear_z : grow the neck radially / axially – used when this
//                       model is SUBTRACTED from a cap to create the female thread.
//   thread_extend     : extra thread length BELOW the real thread so the groove
//                       in the cap runs all the way out of the skirt.
//   extra_core        : extend the core cylinder (through the cap's open end)
module neck(clear_r = 0, clear_z = 0, thread_extend = 0, extra_core = 0, show_bore = false) {
    rmin = neck_minor_d / 2 + clear_r;
    rmaj = neck_major_d / 2 + clear_r;
    z_top    = -thread_start_z - thread_crest_w / 2;
    z_bottom = z_top - thread_len - thread_extend;
    difference() {
        union() {
            // core
            translate([0, 0, -neck_height - extra_core])
                cylinder(r = rmin, h = neck_height + extra_core);
            // thread
            helix_thread(rmin, rmaj, thread_pitch, thread_starts, z_top, z_bottom,
                         thread_crest_w + 2 * clear_z, thread_root_w + 2 * clear_z);
        }
        if (show_bore)
            translate([0, 0, -neck_height - extra_core - 1])
                cylinder(d = mouth_id, h = neck_height + extra_core + 2);
    }
}

// Reference neck (what we THINK the bottle looks like) – render this to sanity
// check your measurements against the real bottle.
module neck_reference() {
    neck(show_bore = true);
    // shoulder/collar hint
    translate([0, 0, -neck_height - 3]) cylinder(d = neck_major_d + 14, h = 3);
}
