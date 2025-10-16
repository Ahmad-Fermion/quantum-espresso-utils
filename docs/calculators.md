# Energy Calculators

## Adsorption Energy
**Formula:** `E_ads = E_(slab+adsorbate) - (E_slab + E_adsorbate)`

**Units:** Input in Rydberg (Ry), output in Ry, eV, kJ/mol

**Example (H₂O on MgO):**
- E_H₂O = -16.8452 Ry
- E_MgO = -245.1234 Ry
- E_(MgO+H₂O, site1) = -261.7891 Ry
- **E_ads = -0.2205 Ry = -3.00 eV = -289.5 kJ/mol**

**Usage:**
```bash
./bin/adsorption_energy.py -r
# or
./bin/adsorption_energy.sh -r
