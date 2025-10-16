# Convergence Monitoring

## qe_convergence.sh
Extracts and plots total energies and forces from Quantum ESPRESSO output files.

**Requires:** `gnuplot` (install with `sudo apt install gnuplot` or equivalent).

**Usage:**
```bash
source monitors/qe_convergence.sh
energy-plt output.out  # Plot SCF energy convergence
force-plt output.out   # Plot ionic forces
