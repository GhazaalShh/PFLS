num_seq=$(grep '>' "$1" | wc -l)
total_length=$(awk '/^>/ {next} {sum += length} END {print sum}' "$1")
longest_seq=$(awk '/>/ {if (seq) print length (seq); print; seq=""; next} {seq=seq $0} END {print length (seq)}' $1 | sort -nr | head -n 1)
shortest_lenght=$(awk '/>/ {if (seq) print length (seq); print; seq=""; next} {seq=seq $0} END {print length (seq)}' $1 | grep -v '>' | sort -n | head -n 1)
avg_length=$((total_length / num_seq))
sequences=$(awk '!/^>/ {print}' "$1")
gc_count=$(echo "$sequences" | grep -o '[GC]' | wc -l)
gc_content=$(echo "$gc_count * 100 / $total_length" | bc -l)

echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences: $num_seq"
echo "Total length of sequences: $total_length"
echo "Length of the longest sequence: $longest_seq"
echo "Length of the shortest sequence: $shortest_lenght"
echo "Average sequence length: $avg_length"
echo "GC Content (%): $gc_content"

