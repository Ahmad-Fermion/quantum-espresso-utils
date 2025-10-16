#!/bin/bash

print_help() {
    echo "
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
"
}

calculate_adsorption_energy() {
    local e_slab_adsorbate=$1
    local e_slab=$2
    local e_adsorbate=$3
    # Use bc for floating-point arithmetic
    local e_ads_ry=$(echo "scale=4; $e_slab_adsorbate - ($e_slab + $e_adsorbate)" | bc)
    local e_ads_ev=$(echo "scale=4; $e_ads_ry * 13.605693122994" | bc)
    local e_ads_kjmol=$(echo "scale=4; $e_ads_ev * 96.485332" | bc)
    echo "$e_ads_ry $e_ads_ev $e_ads_kjmol"
}

is_number() {
    local input=$1
    if [[ $input =~ ^-?[0-9]*\.?[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

main() {
    while true; do
        echo -e "\nAdsorption Energy Calculator"
        echo "Enter '-h' or '--help' for help, '-r' or '--run' to calculate, '-q' or '--quit' to exit."
        read -p "Command: " command
        command=$(echo "$command" | tr '[:upper:]' '[:lower:]')

        case $command in
            -h|--help)
                print_help
                ;;
            -r|--run)
                # Get energy of adsorbate
                read -p "Enter the energy of the adsorbate (e.g., E_H₂O) in Ry: " e_adsorbate
                if ! is_number "$e_adsorbate"; then
                    echo "Error: Please enter a valid numerical value for E_adsorbate."
                    continue
                fi

                # Get energy of clean slab
                read -p "Enter the energy of the clean slab (e.g., E_MgO) in Ry: " e_slab
                if ! is_number "$e_slab"; then
                    echo "Error: Please enter a valid numerical value for E_slab."
                    continue
                fi

                # Get number of adsorption sites
                read -p "Enter the number of adsorption sites: " num_sites
                if [[ ! $num_sites =~ ^[0-9]+$ ]] || [ $num_sites -le 0 ]; then
                    echo "Error: Number of sites must be a positive integer."
                    continue
                fi

                # Collect energies for each adsorption site
                site_energies=()
                for ((i=1; i<=num_sites; i++)); do
                    read -p "Enter the energy for adsorption site $i (e.g., E_(MgO+H₂O)) in Ry: " energy
                    if ! is_number "$energy"; then
                        echo "Error: Please enter a valid numerical value for site $i."
                        continue 2
                    fi
                    site_energies+=("$energy")
                done

                # Calculate and display adsorption energies
                echo -e "\nAdsorption Energies:"
                for ((i=0; i<num_sites; i++)); do
                    read e_ads_ry e_ads_ev e_ads_kjmol <<< $(calculate_adsorption_energy "${site_energies[i]}" "$e_slab" "$e_adsorbate")
                    printf "Site %d:\n" $((i+1))
                    printf "  E_ads = %.4f Ry\n" "$e_ads_ry"
                    printf "        = %.4f eV\n" "$e_ads_ev"
                    printf "        = %.4f kJ/mol\n" "$e_ads_kjmol"
                    printf "  (E_(slab+adsorbate) = %.4f Ry, E_slab = %.4f Ry, E_adsorbate = %.4f Ry)\n" \
                        "${site_energies[i]}" "$e_slab" "$e_adsorbate"
                done
                ;;
            -q|--quit)
                echo "Exiting program."
                exit 0
                ;;
            *)
                echo "Invalid command. Use '-h' or '--help' for assistance."
                ;;
        esac
    done
}

main
