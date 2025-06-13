#!/usr/bin/env bash

# �� INPUT / OUTPUT ��
input="frame.molden"   # your Molden-format file
output="gas_phase.xyz"    # desired XYZ file

# �� 1) Count how many atom�\lines follow the ��[Atoms]�� header ��
n_atoms=$(awk '
  /^\[Atoms\]/    { in_atoms=1;  next }      # once we hit [Atoms], start counting
  in_atoms && NF==6  { count++ }             # only count lines with 6 fields
  END { print count }
' "$input")

# �� 2) Write the XYZ header ��
printf "%d\nConverted from %s\n" "$n_atoms" "$input" > "$output"

# �� 3) Extract & reformat the atom lines ��
awk '
  /^\[Atoms\]/    { in_atoms=1;  next }      # skip header, then��
  in_atoms && NF==6  {
    # $1=element, $4=x, $5=y, $6=z
    printf "%-2s %12.10f %12.10f %12.10f\n", $1, $4, $5, $6
  }
' "$input" >> "$output"

echo "Wrote $output with $n_atoms atoms."
