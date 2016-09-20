
export LC_CTYPE=C 
export LANG=C

filePath=$1; #第一个参数为文件名

num=$2; #第二个参数为需要计算的列
# VAR=$num;

echo "filePath="$filePath;
echo "计算第 "$num" 列";
# echo "var="$VAR;

awk -v VAR=$num '{sum+=$VAR} END{ 
	
	print "sum = " sum "kb";
	print "sum = " sum/1024 "Mb";
	# print "sum = " sum/1024/1024 "Mb";

}' $filePath;


# echo "使用第二列的数值"

# awk '{sum+=$2} END{ 
	
# 	print "sum = " sum "kb";
# 	print "sum = " sum/1024 "Mb";
# 	# print "sum = " sum/1024/1024 "Mb";

# }' $filePath;

# echo "使用第三列的数值"
# awk '{sum+=$3} END{ 
	
# 	print "sum = " sum "kb";
# 	print "sum = " sum/1024 "Mb";
# 	# print "sum = " sum/1024/1024 "Mb";

# }' $filePath;