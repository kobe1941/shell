
filePath=$1;

echo $filePath;

sed -n '/# Object files:/,/# Sections:/p' $filePath > Object.txt; #找出指定的一段文本，并存储为文本

line_count=`cat Object.txt | wc -l`; #计算文件行数

echo "line_count=${line_count}";

end_line=$[line_count-1]; #做数字运算

sed -n "3,$[line_count-1]p" Object.txt > tempClassList.txt; #去掉前两行和最后一行

grep "\.o" tempClassList.txt > ObjectCleanFile.txt;


sed -n '/# Symbols:/,$p' $filePath > Symbols.txt; #提取从匹配的一行直到最后


echo | awk '{split({print $2},array,"/");print array[1]}';


