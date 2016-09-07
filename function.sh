function sum()
{
	echo $1,$2;
	#tempNumber=$[ $1 + $2 ];
	return 0;
	#return $(($1+$2));
}

#sum "hufeng.txt" "fgewgew";
#echo $?;

#在函数里打印什么，返回值就是什么
#value=$(sum "regergrgerg.txt" "ghrth");

#echo "value=$value";


	

#切割字符串，获取工程名HFBuild
#a="/Users/hufeng/Documents/HFBackupCode/HFBuild/HFBuild.xcodeproj/project.pbxproj"
function serahProjectName()
{
	address=$1;
	#要将$address分割开，可以这样：
	OLD_IFS="$IFS"
	IFS="/"
	arr=($address)
	IFS="$OLD_IFS"

	count=${#arr[@]};
	projectName=${arr[$[count-2]]};
	
	IFS=".";
	arr=($projectName);

	echo ${arr[0]};

	return 0;
}




#传入一个工程文件，返回一个最终的类的文件
function searchAllClassFromProject()
{
	testFile=$1; #第一参数为文件目录

	#sed -n '/.m in Sources /p' $testFile > sourceFile.txt; #找出所有包含指定字符创的行，并存储为文件
	sed -n '/Begin PBXBuildFile section/,/End PBXBuildFile section/p' $testFile > PBXBuildFile.txt; #找出指定的一段文本，并存储为文本
	#sed -n '/Begin PBXBuildFile section/,/End PBXBuildFile section/p' $testFile | grep -Ev '(^Begin)' > tempClassList.txt;

	line_count=`cat PBXBuildFile.txt | wc -l`; #计算文件行数

	#echo "line_count=${line_count}";

	end_line=$[line_count-1]; #做数字运算

	sed -n "2,$[line_count-1]p" PBXBuildFile.txt > tempClassList.txt; #去掉第一行和最后一行

	#sed是行匹配，awk是列匹配，此处为提取第3列的内容
	awk '{print $3}' tempClassList.txt > realClassList.txt; #提取所有的类和其他文件，此时包含storyboard和xib

	#grep ".m" realClassList.txt > hufengReal.txt; #提取出所有的.m文件，差不多是相当于所有的类
	grep "\.m" realClassList.txt | grep -v "Tests.m$" | grep -v "Tests.mm$" | grep -v "Test.m$" | grep -v "Test.mm" | grep -v "+" > classListUsed.txt; #这是双grep实现逻辑与的操作，提取出所有的类，注意文件的位置

	fileName=$2;
	echo "fileName=${fileName}";
	if [ ! -d $fileName ]; then
		mkdir -p $fileName; #-p表示多重目录
	else
		echo "dir already exsit";
	fi
	
	#echo "fileName=${fileName}";

	sed "s/\.m\{1,2\}$/ /" classListUsed.txt | sort -u > $fileName/finalClassList.txt; #去掉.m和.mm，只留下类的名称，原理是把.m字符用空格替换掉,同时去重


}


	filePath=$1; #文件目录
	fileExtension="pbxproj";

	#找出指定目录下的所有指定格式的文件
	#find $filePath -name "*.${fileExtension}" > fileAllList.txt;

	#把搜索结果传递给数组
	fileArray=($(find $filePath -name "*.${fileExtension}"));
	echo ${fileArray[0]}; #取出数组第一个元素

for tempName in ${fileArray[*]}; do
	#echo "tempName=${tempName}";
	#tempName=${fileArray[4]};
	projectName=$(serahProjectName ${tempName});
	echo "projectName=${projectName}";

	fullName="project/${projectName}";
	#echo "fullName=${fullName}";

	resultFile=$(searchAllClassFromProject ${tempName} ${fullName});
	echo "resultFile=${resultFile}";

done


#projectName=$(serahProjectName ${fileArray[0]});
#echo "projectName=${projectName}";

#resultFile=$(searchAllClassFromProject ${fileArray[0]} $projectName);
#echo "resultFile=${resultFile}";





