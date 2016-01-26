awk '{sum+=$1} END {print "Average = ", sum/NR}' $1 
