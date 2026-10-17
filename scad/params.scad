// =====================================================================
//  Boldfit 2.2 L Gallon bottle – replacement cap system
//  SHARED PARAMETERS  (edit THIS file only; every design reads from it)
// =====================================================================
//
//  !!!  The neck numbers below are PLACEHOLDER GUESSES for a generic   !!!
//  !!!  Chinese 2.2 L gym jug.  Replace them with caliper readings     !!!
//  !!!  from the real bottle before printing a final cap.              !!!
//  See ../README.md  ->  "How to measure the neck".
//
// All dimensions in millimetres.

// ---------- BOTTLE NECK (measure these) ----------
neck_major_d   = 60.0;   // outside diameter ACROSS the thread crests
neck_minor_d   = 56.0;   // outside diameter at thread ROOT (bare neck wall)
mouth_id       = 50.0;   // inside diameter of the opening
neck_height    = 14.0;   // top lip  -> top of the shoulder / collar ring
thread_pitch   = 6.0;    // crest-to-crest spacing measured ALONG the axis
thread_starts  = 2;      // 1 = single start, 2 = two parallel threads (count where threads begin at the lip)
thread_turns   = 1.25;   // how many times ONE thread goes round the neck
thread_start_z = 2.0;    // distance from the top lip down to where the thread begins
thread_crest_w = 1.6;    // flat width of the thread crest (axial)
thread_root_w  = 3.6;    // width of the thread at its root (axial)

// ---------- FIT / PRINTER TUNING ----------
radial_clear   = 0.30;   // extra radius in the cap bore.  FDM 0.4 nozzle: 0.25-0.40
axial_clear    = 0.25;   // extra gap each side of the thread flank
wall           = 2.4;    // cap side wall (6 perimeters @ 0.4 mm)
top_t          = 3.0;    // cap top thickness
gasket_t       = 2.0;    // TPU / silicone gasket thickness
gasket_pocket  = 0.8;    // SHALLOW locating pocket – open, wipeable, gasket lifts out
skirt_extra    = 1.5;    // how far the skirt reaches below the thread
$fn            = 96;    // circular resolution (96 = 2 mm facets on a 60 mm cap, plenty for FDM)

// ---------- DERIVED (do not edit) ----------
thread_h       = (neck_major_d - neck_minor_d) / 2;            // radial height of the thread
thread_len     = thread_pitch * thread_starts * thread_turns;  // axial length ONE start covers
cap_bore_d     = neck_major_d + 2 * radial_clear;
cap_od         = cap_bore_d + 2 * wall;
skirt_h        = thread_start_z + thread_len + skirt_extra;
