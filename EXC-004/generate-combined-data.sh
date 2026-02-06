rm -rf COMBINED-DATA
mkdir COMBINED-DATA

for directory in RAW-DATA/DNA*
do
  culture_name=$(basename $directory)
  culture_name_new=$(grep $culture_name RAW-DATA/sample-translation.txt | awk '{print $2}')

mag_count=1
bin_count=1


cp $directory/checkm.txt COMBINED-DATA/$culture_name_new-CHECKM.txt
cp $directory/gtdb.gtdbtk.tax COMBINED-DATA/$culture_name_new-GTDB-TAX.txt

for fasta in "$directory/bins"/*.fasta
do
   bin_name=$(basename $fasta .fasta)

   compl=$(grep "$bin_name " $directory/checkm.txt | awk '{print $13}')
   contm=$(grep "$bin_name " $directory/checkm.txt | awk '{print $14}')
 #because of a space between Marker lineage content its not 12 and 13

  if [[ "$bin_name" == bin-unbinned ]]
  then 
    new_name="${culture_name_new}_UNBINNED.fa"
  else
    if (( $(echo "$compl >= 50" | bc -l) && $(echo "$contm < 5" | bc -l) )); then
        new_name="${culture_name_new}_MAG_$(printf "%03d" $mag_count).fa"
        ((mag_count++))
    else
        new_name="${culture_name_new}_BIN_$(printf "%03d" $bin_count).fa"
        ((bin_count++))
    fi
  fi
   
   cp $fasta COMBINED-DATA/$new_name

   for file in COMBINED-DATA/$culture_name_new-CHECKM.txt COMBINED-DATA/$culture_name_new-GTDB-TAX.txt; do
    sed "s/ms.*${bin_name}/$(basename "$new_name" .fa)/g" "$file" > temp && mv temp "$file"
done

   sed -E "s/^>(.*)/>${culture_name_new}_\1/" "$fasta" > "COMBINED-DATA/$new_name"

 done

done

 #how to go through all the directories to extract names using loops
 #how to extract names from every directory
 #assign them to files
 #nested loops with ifs and else