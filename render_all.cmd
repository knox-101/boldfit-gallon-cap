@echo off
REM Regenerates every STL and preview PNG from the .scad sources (Manifold backend, ~10 s total).
setlocal
cd /d "%~dp0"
set OSC=tools\OpenSCAD-nightly\openscad.com
for %%F in (01_test_ring 02_vault_cap 03_flip_base 03_flip_lid 03_flip_seal_tpu 04_port_cap 04_port_plug 04_port_gasket 05_neck_gasket neck_reference) do (
  echo Rendering %%F ...
  "%OSC%" --backend=Manifold -o "stl\%%F.stl" "scad\%%F.scad"
  "%OSC%" -o "preview\%%F.png" --imgsize=1000,750 --colorscheme=Tomorrow --camera=0,0,0,55,0,35,0 --autocenter --viewall --projection=p -D "$fn=48" "scad\%%F.scad"
)
for %%F in (view_section_vault view_section_flip view_section_port) do (
  "%OSC%" -o "preview\%%F.png" --imgsize=1400,900 --colorscheme=Tomorrow --camera=0,0,0,68,0,12,0 --autocenter --viewall --projection=o -D "$fn=64" "scad\%%F.scad"
)
echo Done. STLs are in stl\, previews in preview\.
pause
