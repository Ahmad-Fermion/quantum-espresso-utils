#!/bin/bash
echo " Installing Quantum ESPRESSO Utils..."
mkdir -p ~/bin
cp bin/* ~/bin/
echo 'export PATH="$PATH:$HOME/bin"' >> ~/.bashrc
echo '# Quantum ESPRESSO Utils' >> ~/.bashrc
echo 'source ~/quantum-espresso-utils/monitors/qe_convergence.sh' >> ~/.bashrc
echo "Done! Restart terminal or run: source ~/.bashrc"
