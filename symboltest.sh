


gsed -n "/literal /p" NineGameLinkMap.txt > symbolTestByHufeng.txt;

#排序输出然后保存到文件里
awk '{sum+=$2} END{ 

	print "sum = ",sum," byte";
	print "sum = ",sum/1024," kb";
	print "sum = ",sum/1024/1024," Mb";

}' symbolTestByHufeng.txt;