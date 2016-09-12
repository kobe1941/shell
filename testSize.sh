
export LC_CTYPE=C 
export LANG=C

filePath=$1;

echo $filePath;

cat libFinal.txt | awk '{
	len=$1;
	# print "len ="len;
	{sed -n "1p" "$[filePath]"}
}'


awk '{sum+=$3} END{ 
	
	print "sum = " sum "kb";
	print "sum = " sum/1024 "Mb";
	# print "sum = " sum/1024/1024 "Mb";

}' $filePath;




