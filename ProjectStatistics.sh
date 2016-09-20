########################
# 使用方法：传入一个文件目录，会把每个工程所使用的类所占用的size全部输出
# 该脚本依赖function.sh脚本和calClassSize.sh脚本，前两个脚本执行完毕后才最后执行，否则会找不到文件
#######################
export LC_CTYPE=C 
export LANG=C


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


	filePath=$1; #文件目录
	fileExtension="pbxproj";

	#把搜索结果传递给数组
	fileArray=($(find $filePath -name "*.${fileExtension}"));
	echo ${fileArray[0]}; #取出数组第一个元素

	#先删掉该文件
	if [ -f "finalProjectSizeList.txt" ]; then 
		 rm finalProjectSizeList.txt
 	fi 
	

for tempName in ${fileArray[*]}; do

	#先获取到工程名
	projectName=$(serahProjectName ${tempName});
	echo "projectName=${projectName} start...";

	#拼接成完整路径
	fullName="project/${projectName}";
	#echo "fullName=${fullName}";
	finalFileName="${fullName}/finalClassList.txt";

	
	#先删掉该文件
	if [ -f "${fullName}/projectSize.txt" ]; then 
		 rm "${fullName}/projectSize.txt";
 	fi 

 	if [ ! -f "${finalFileName}" ]; then 
		 continue; # 不存在则跳过
 	fi 

 	#进行一些过滤，白名单
 	whiteNameArray=("monitor_pbxproj" "GTMXcodePlugin.xcodeproj" "Calculator.xcodeproj" "Testable.xcodeproj" \
 		"Swift.xcodeproj" "KIF.xcodeproj" "GTM.xcodeproj" "GTMiPhone.xcodeproj" "AppleScript.xcodeproj" \
 		"DeveloperSpotlightImporters.xcodeproj" "InterfaceBuilder.xcodeproj" "TestData/test.xcodeproj" \
 		"XcodeProject.xcodeproj" "GTMXcode4Plugin.xcodeproj" "GTMXcodePlugin.xcodeproj");
 	flag="NO"
 	for whiteName in ${whiteNameArray[@]}; do
 		
 		checkResult=$(echo $tempName | grep "${whiteName}");
 		if [[ "$checkResult" != "" ]]; then
 			#目录包含该文件名，则跳过
 			flag="YES";
 			break;
 		fi
 	done
 	
 	if [[ "$flag" == "YES" ]]; then
 		continue;
 	fi


	# 一行行的读取进行处理
	cat $finalFileName | while read line
	do
    	# echo "${line}"
		#利用空格来做匹配比较合适，-E代表逻辑或,-w表示完全匹配
		grep -E " ${line}\.o |(${line}\.o)" finalClassSizeList.txt | awk '{print $1, $2, $4}' >> "${fullName}/projectSize.txt";
	done

	echo "projectName=${projectName} done.";


	#排序输出然后保存到文件里
	awk -v VAR=$projectName '{sum+=$3} END{ 
		print VAR" "sum/1024" kb";

	}' "${fullName}/projectSize.txt" >> finalProjectSizeList.txt;

done


sed '/Demo/d' finalProjectSizeList.txt > finalProjectSizeListDeleteDemo.txt

sort -n -r -k2	finalProjectSizeListDeleteDemo.txt > finalProjectSizeListSort.txt;



	# firstFile=${fileArray[1]};
	# projectName=$(serahProjectName ${firstFile});
	# echo "projectName=${projectName}";
	# #拼接成完整路径
	# fullName="project/${projectName}";
	# #echo "fullName=${fullName}";
	# finalFileName="${fullName}/finalClassList.txt";
	# echo "finalFileName=${finalFileName}";


	# 一行行的读取进行处理
	# cat $finalFileName | while read line
	# do
    	# echo "${line}"
	# 	#利用空格来做匹配比较合适，-E代表逻辑或,-w表示完全匹配
	# 	# grep -E " ${line}\.o |(${line}\.o) " finalClassSizeList.txt | awk '{print $1, $2, $4}' >> "${fullName}/projectSize.txt";
	# 	grep -E " ${line}\.o |(${line}\.o)" finalClassSizeList.txt | awk '{print $1, $2, $4}' >> "${fullName}/projectSize.txt";
	# done

	# #排序输出然后保存到文件里
	# awk -v VAR=$projectName '{sum+=$3} END{ 
	# 	print VAR" = "sum;

	# }' "${fullName}/projectSize.txt" >> finalProjectSizeList.txt;

