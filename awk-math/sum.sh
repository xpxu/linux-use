# 对文本的第n列求和
awk '{sum+=$1} END {print "Sum = ", sum}' $1 
