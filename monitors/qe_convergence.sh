#!/bin/bash
# --- QE quick plots from output.out (gnuplot required) --------------------

alias force="grep 'Total force' output.out"
alias energy="grep '!    total energy' output.out"
alias scf="grep 'Self-consistent Calculation' output.out"

energy_plt() {
  local f="${1:-output.out}"
  command -v gnuplot >/dev/null || { echo "gnuplot not found in PATH"; return 1; }
  [[ -r "$f" ]] || { echo "file not found: $f"; return 1; }
  local tmp="$(mktemp /tmp/qe_energy.XXXXXX.dat)"
  awk '/^\s*!/ && /total energy/ { if (match($0, /=\s*([-+]?[0-9.]+([Ee][+-]?[0-9]+)?)/, m)) { print ++i, m[1] } }' "$f" > "$tmp"
  [[ -s "$tmp" ]] || { echo "no energy lines found in $f"; rm -f "$tmp"; return 1; }
  gnuplot -persist <<GNUPLOT
set title "QE energies: $f" offset 0,-0.5
set xlabel "Cycle"; set ylabel "Total energy (Ry)" offset -2,0
set grid; set tmargin 3; set bmargin 3; set lmargin 14; set rmargin 6
plot "$tmp" using 1:2 with linespoints notitle
GNUPLOT
  rm -f "$tmp"
}

force_plt() {
  local f="${1:-output.out}"
  command -v gnuplot >/dev/null || { echo "gnuplot not found in PATH"; return 1; }
  [[ -r "$f" ]] || { echo "file not found: $f"; return 1; }
  local tmp="$(mktemp /tmp/qe_force.XXXXXX.dat)"
  awk '/^\s*Total force *=/ { print ++i, $4 }' "$f" > "$tmp"
  [[ -s "$tmp" ]] || { echo "no force lines found in $f"; rm -f "$tmp"; return 1; }
  gnuplot -persist <<GNUPLOT
set title "QE forces: $f" offset 0,-0.5
set xlabel "Ionic step"; set ylabel "Total force (Ry/Bohr)" offset -2,0
set grid; set tmargin 3; set bmargin 3; set lmargin 14; set rmargin 6
plot "$tmp" using 1:2 with linespoints notitle
GNUPLOT
  rm -f "$tmp"
}

alias energy-plt='energy_plt'
alias force-plt='force_plt'
