
#!/bin/sh
# 第一步
# 需求：接收一个输入参数作为目录
# 1.先找出该目录下所有的.xcodeproj文件
# 2.解析每个.xcodeproj文件中的包含的类
# 3.把上述的结果汇总成一个表，写文件保存




# 第二步
# 需求：接收一个输入参数作为源文件 
# 1.先解析出该文件里所有的类
# 2.计算每个类在可执行文件里所占的大小
# 3.跟第一步的结果进行汇总，从而计算出每个工程在可执行文件里所占的大小

echo "Hello World!";


#yourname="hufeng";
#echo $yourname;
#unset yourname; #删除变量，只读变量不能删除
# yourname="haha"
#echo "${yourname}";
#readonly yourname='fgg';
#echo ${yourname};
# for file in `ls /etc`;do
# 	echo $file;
# done

filePath=$1; #文件目录
fileExtension="pbxproj";

#找出指定目录下的所有指定格式的文件
#find $filePath -name "*.${fileExtension}" > fileAllList.txt;

#把搜索结果传递给数组
fileArray=($(find $filePath -name "*.${fileExtension}"));
echo ${fileArray[0]}; #取出数组第一个元素

testFile=${fileArray[0]};
echo $testFile;

sed -n '/.m in Sources /p' $testFile > sourceFile.txt; #找出所有包含指定字符创的行，并存储为文件
sed -n '/Begin PBXBuildFile section/,/End PBXBuildFile section/p' $testFile > PBXBuildFile.txt; #找出指定的一段文本，并存储为文本
#sed -n '/Begin PBXBuildFile section/,/End PBXBuildFile section/p' $testFile | grep -Ev '(^Begin)' > tempClassList.txt;

line_count=`cat PBXBuildFile.txt | wc -l`; #计算文件行数

echo $line_count;

end_line=$[line_count-1]; #做数字运算

sed -n "2,$[line_count-1]p" PBXBuildFile.txt > tempClassList.txt; #去掉第一行和最后一行

#sed是行匹配，awk是列匹配，此处为提取第3列的内容
awk '{print $3}' tempClassList.txt > realClassList.txt; #提取所有的类和其他文件，此时包含storyboard和xib

#grep ".m" realClassList.txt > hufengReal.txt; #提取出所有的.m文件，差不多是相当于所有的类
grep ".m" realClassList.txt | grep -v "Tests.m" > classListUsed.txt; #这是双grep实现逻辑与的操作，提取出所有的类，注意文件的位置

sed "s/.m/\n/" classListUsed.txt > finalClassList.txt; #去掉.m，只留下类的名称，原理是把.m字符用回车换行替换掉

