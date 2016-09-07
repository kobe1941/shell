
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
fileExtension="xcodeproj";

#找出指定目录下的所有指定格式的文件
find $filePath -name "*.${fileExtension}";

