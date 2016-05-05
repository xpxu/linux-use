awk 'BEGIN {min = 1999999} {if ($1<min) min=$1 fi} END {print "Min=", min}' $1
