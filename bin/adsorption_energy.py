#!/usr/bin/env python3

def print_help():
    print("""
Adsorption Energy Calculator
---------------------------
This script calculates the adsorption energy (E_ads) using the formula:
E_ads = E_(slab+adsorbate) - (E_slab + E_adsorbate)

Example: For a water molecule (H₂O) adsorbed on a magnesium oxide (MgO) slab:
E_ads = E_(MgO+H₂O) - (E_MgO + E_H₂O)

Commands:
  -h, --help : Display this help message
  -r, --run  : Run the adsorption energy calculation
  -q, --quit : Exit the program

Instructions:
1. When prompted, enter the energy of the adsorbate (e.g., E_H₂O for water).
2. Enter the energy of the clean slab (e.g., E_MgO for MgO).
3. Specify the number of adsorption sites.
4. Enter the energy for each adsorption site (e.g., E_(MgO+H₂O)).
5. The script will compute and display the adsorption energy for each site in Rydberg (Ry), electron volts (eV), and kilojoules per mole (kJ/mol).

Note: All input energies should be in Rydberg (Ry) units, as typically output by quantum chemistry software like Quantum ESPRESSO.
Conversion factors used: 1 Ry = 13.605693122994 eV, 1 eV = 96.485332 kJ/mol.
---------------------------
""")

def calculate_adsorption_energy(e_slab_adsorbate, e_slab, e_adsorbate):
    e_ads_ry = e_slab_adsorbate - (e_slab + e_adsorbate)
    e_ads_ev = e_ads_ry * 13.605693122994  # Convert Ry to eV
    e_ads_kjmol = e_ads_ev * 96.485332      # Convert eV to kJ/mol
    return e_ads_ry, e_ads_ev, e_ads_kjmol

def main():
    while True:
        print("\nAdsorption Energy Calculator")
        print("Enter '-h' or '--help' for help, '-r' or '--run' to calculate, '-q' or '--quit' to exit.")
        command = input("Command: ").strip().lower()

        if command in ['-h', '--help']:
            print_help()
        elif command in ['-r', '--run']:
            try:
                # Get energy of adsorbate
                e_adsorbate = float(input("Enter the energy of the adsorbate (e.g., E_H₂O) in Ry: "))
                # Get energy of clean slab
                e_slab = float(input("Enter the energy of the clean slab (e.g., E_MgO) in Ry: "))
                # Get number of adsorption sites
                num_sites = int(input("Enter the number of adsorption sites: "))
                if num_sites <= 0:
                    print("Error: Number of sites must be positive.")
                    continue

                # Collect energies for each adsorption site
                site_energies = []
                for i in range(num_sites):
                    energy = float(input(f"Enter the energy for adsorption site {i+1} (e.g., E_(MgO+H₂O)) in Ry: "))
                    site_energies.append(energy)

                # Calculate and display adsorption energies
                print("\nAdsorption Energies:")
                for i, e_slab_adsorbate in enumerate(site_energies, 1):
                    e_ads_ry, e_ads_ev, e_ads_kjmol = calculate_adsorption_energy(e_slab_adsorbate, e_slab, e_adsorbate)
                    print(f"Site {i}:")
                    print(f"  E_ads = {e_ads_ry:.4f} Ry")
                    print(f"        = {e_ads_ev:.4f} eV")
                    print(f"        = {e_ads_kjmol:.4f} kJ/mol")
                    print(f"  (E_(slab+adsorbate) = {e_slab_adsorbate:.4f} Ry, E_slab = {e_slab:.4f} Ry, E_adsorbate = {e_adsorbate:.4f} Ry)")

            except ValueError:
                print("Error: Please enter valid numerical values.")
            except Exception as e:
                print(f"An error occurred: {e}")
        elif command in ['-q', '--quit']:
            print("Exiting program.")
            break
        else:
            print("Invalid command. Use '-h' or '--help' for assistance.")

if __name__ == "__main__":
    main()
