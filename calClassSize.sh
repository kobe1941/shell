export LC_CTYPE=C 
export LANG=C

filePath=$1;

echo $filePath;


#######这里主要把所有的类和其编号提取出来########
LANG=C sed -n '/# Object files:/,/# Sections:/p' $filePath > Object.txt; #找出指定的一段文本，并存储为文本

line_count=`cat Object.txt | wc -l`; #计算文件行数

echo "line_count=${line_count}";

end_line=$[line_count-1]; #做数字运算

sed -n "3,$[line_count-1]p" Object.txt > tempClassList.txt; #去掉前两行和最后一行

grep "\.o\|\.d" tempClassList.txt > ObjectCleanFile.txt; #把没有包含.o和.d的行去掉
#这里需要补上虽然没有.o或.d但是有.framework的数据
grep -v "\.o\|\.d" tempClassList.txt | grep "framework" >> ObjectCleanFile.txt;


sed "s/\/.*\///g" ObjectCleanFile.txt > ObjectClassList.txt; #用于把两个斜杠之间的字符删除，连同斜杠本身一起删除
#gsed "s/\/.\+\///g" ObjectCleanFile.txt > ObjectClassList.txt; #gsed是GUN版本的sed，各个版本的工具有些不一样

#分别去掉两个中括号
sed -e "s/\[//g" -e "s/\]//g" ObjectClassList.txt > ObjectClassListTest.txt; #-ｅ命令可以一个线程执行多个操作
sort -n  -k1   ObjectClassListTest.txt > ObjectClassListTemp.txt;  #按照第一列排序

echo "class get done.";
#########################################


#######这里主要把每个类所占的大小计算出来########
sed -n '/# Symbols:/,$p' $filePath > SymbolsTest.txt; #提取从匹配的一行直到最后
sed -n '/\[.*\]/p' SymbolsTest.txt > Symbols.txt;
echo "Symbols get done.";


gsed -i '1,2d' Symbols.txt; #去掉前两行，此处由于兼容问题，要使用gsed，如果未安装，执行brew install gnu-sed安装即可

#跟上方使用-e是一样的效果，只不过是两个线程，速度慢一些，另替换操作斜杠/也可以用#代替
sed "s#\[##g" Symbols.txt | sed "s#\]##g" > SymbolsTemp.txt;
# cat SymbolsTemp.txt | parallel --pipe | sort -n -k3 > SymbolsTempSort.txt;  #按照第三列排序
sort -n  -k3   SymbolsTemp.txt > SymbolsTempSort.txt;  #按照第三列排序

# sed "s#\[##g" Symbols.txt | sed "s#\]##g" | LC_ALL='C' sort -n -k3 > SymbolsTemp.txt;

#排序输出然后保存到文件里
awk '{sum[$3]+=$2} END{ 
	len=length(sum);
	for (i = 1; i < len; i++){
		print i, " ",sum[i];

	}

}' SymbolsTempSort.txt > classResultSize.txt;
########################################

############合并两个文件方便比较############
awk 'NR==FNR{a[i]=$0;i++}NR>FNR{printf "%-85s %-15s\n",a[j],$0;j++}' ObjectClassListTemp.txt classResultSize.txt > finalClassSizeList.txt; 
#######################################