#!/usr/bin/env python3
import argparse
from ase.io import read, write

def convert_qe_to_structures(input_file, cif_output, xyz_output):
    try:
        # Read QE output
        atoms = read(input_file, format='espresso-out')
        # Write to CIF
        write(cif_output, atoms, format='cif')
        # Write to XYZ
        write(xyz_output, atoms, format='xyz')
        print(f"✅ Generated {cif_output} and {xyz_output} from {input_file}")
    except Exception as e:
        print(f"Error: {e}")

def main():
    parser = argparse.ArgumentParser(description="Convert Quantum ESPRESSO output to CIF and XYZ formats.")
    parser.add_argument("-i", "--input", default="output.out", help="Input QE output file (default: output.out)")
    parser.add_argument("-c", "--cif", default="structure.cif", help="Output CIF file (default: structure.cif)")
    parser.add_argument("-x", "--xyz", default="structure.xyz", help="Output XYZ file (default: structure.xyz)")
    args = parser.parse_args()
    
    convert_qe_to_structures(args.input, args.cif, args.xyz)

if __name__ == "__main__":
    main()
