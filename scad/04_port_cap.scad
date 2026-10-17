// =====================================================================
//  04a  "PORT"  – twin-thread cap – MAIN CAP
//  A big cap with a 30 mm threaded drinking PORT in the centre, closed by a
//  small screw-in plug (04_port_plug.scad) with its own flat TPU gasket.
//  Zero hinges, zero snaps: everything unscrews, every surface is reachable.
//  The port's female thread is a through-tube hanging inside the cap, so it
//  prints top-down without supports and flushes clean.
//  Numbers: 04_port_common.scad   Geometry: parts.scad -> port_cap()
// =====================================================================
include <parts.scad>
port_cap(loop = true);
