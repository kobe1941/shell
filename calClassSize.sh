
filePath=$1;

echo $filePath;


#######这里主要把所有的类和其编号提取出来########
LANG=C sed -n '/# Object files:/,/# Sections:/p' $filePath > Object.txt; #找出指定的一段文本，并存储为文本

line_count=`cat Object.txt | wc -l`; #计算文件行数

echo "line_count=${line_count}";

end_line=$[line_count-1]; #做数字运算

sed -n "3,$[line_count-1]p" Object.txt > tempClassList.txt; #去掉前两行和最后一行

grep "\.o" tempClassList.txt > ObjectCleanFile.txt; #把没有包含.o的行去掉


#PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
#ln -s $(which gsed) $(brew --prefix coreutils)/libexec/gnubin/sed
sed "s/\/.*\///g" ObjectCleanFile.txt > ObjectClassList.txt; #用于把两个斜杠之间的字符删除，连同斜杠本身一起删除
#gsed "s/\/.\+\///g" ObjectCleanFile.txt > ObjectClassList.txt; #gsed是GUN版本的sed，各个版本的工具有些不一样

echo "class get done.";
#########################################


#######这里主要把每个类所占的大小计算出来########
sed -n '/# Symbols:/,$p' $filePath > Symbols.txt; #提取从匹配的一行直到最后
echo "Symbols get done.";


# line_count=`cat Symbols.txt | wc -l`; #计算文件行数
# echo "line_count=${line_count}";
gsed -i '1,2d' Symbols.txt; #去掉前两行，此处由于兼容问题，要使用gsed

# awk '{print $2,   $3}' Symbols.txt;
# df  |awk '{sum+=$2} END{print sum}'

sed "s/\[//g" Symbols.txt | sed "s/\]//g" > SymbolsTemp.txt;


awk '{sum[$3]+=$2} END{ 
	for( i in sum){ 
		print i,":",sum[i]; 
	} 
}' SymbolsTemp.txt;
########################################


