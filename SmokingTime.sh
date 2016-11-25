#!/bin/bash


RUN_PROJ=0
NO_POD=0
NO_BUILD_AND_RUN=0

function CheckWorkspaceFile() {
	#statements
	for file in *
	do
	    if test -d $file
	    then
				if [ ${file} = "TravelGuideMdd.xcworkspace" ]
				then
	        # echo 就是这个文件 $file

					CurrentDir=$(pwd)
					MFWWorkspaceFilePath=$CurrentDir"/"$file
					# echo $MFWWorkspaceFilePath
					break
				fi
	    fi
	done
}

function PodInstall() {
	#statements
	startPodTime=$(date +%s)
	pod install
	clear
	endPodTime=$(date +%s)
	interval=$(expr $endPodTime - $startPodTime)  #计算2个时间的差
	echo "Pod install 总共耗时 : "$interval" 秒"
}

function LoadMFWProject() {
	#statements
osascript <<SCRIPT
	tell application "Xcode"
		open "$MFWWorkspaceFilePath"
		set workspaceDocument to workspace document "TravelGuideMdd.xcworkspace"

		repeat 120 times
			if loaded of workspaceDocument is true then
				close workspaceDocument
				exit repeat
			end if
		end repeat

		open "$MFWWorkspaceFilePath"
		set workspaceDocument_new to workspace document "TravelGuideMdd.xcworkspace"
		set loadTime_Begin to (current date)

		repeat 1200 times
			if loaded of workspaceDocument_new is true then
				set loadTime_End to (current date)
				exit repeat
			end if
		end repeat

		log "Loading 开始时间" & (time string of (loadTime_Begin))
		log "Loading 开始结束" & (time string of (loadTime_End))
		log "Loading 总共耗时 :" & (loadTime_End - loadTime_Begin) & "秒"
	end tell
SCRIPT
}

function BuildMFWProject() {
	#statements
osascript <<SCRIPT
	tell application "Xcode"
		set actionResult to build workspace document 1
		set buildTime_Begin to (current date)

		repeat
			if completed of actionResult is true then
				set buildTime_End to (current date)
				exit repeat
			end if
		end repeat

		log "Build 开始时间" & (time string of (buildTime_Begin))
		log "Build 开始结束" & (time string of (buildTime_End))
		log "Build 总共耗时 :" & (buildTime_End - buildTime_Begin) & "秒"

	end tell

SCRIPT
}

function RunMFWProject() {
	#statements
osascript <<SCRIPT
	tell application "Xcode"
		set actionResult to run workspace document 1
		set runTime_Begin to (current date)

		repeat
			if status of actionResult is running then
				set runTime_End to (current date)
				exit repeat
			end if
		end repeat

		log "Run 开始时间" & (time string of (runTime_Begin))
		log "Run 开始结束" & (time string of (runTime_End))
		log "Run 总共耗时 :" & (runTime_End - runTime_Begin) & "秒"

	end tell

SCRIPT
}

function ControleProject() {
	#statements
	if [[ $NO_BUILD_AND_RUN == 1 ]]; then
		#statements
		echo "跳过Build或Run阶段"
	else
		#statements
		LoadMFWProject

		if [[ $RUN_PROJ == 1 ]]; then
			#statements
			RunMFWProject
		else
			#statements
			BuildMFWProject
		fi

	fi
}

##
#	代码的开头
##
CheckWorkspaceFile
if [[ $MFWWorkspaceFilePath ]]; then
	#statements
	echo "找到了 TravelGuideMdd.xcworkspace"
else
	echo "当前目录未找到 TravelGuideMdd.xcworkspace"
	exit
fi

for arg in "$@"
do
	if [[ $arg == "--no-pod" ]]; then
  	#statements
		NO_POD=1
  fi
	if [[ $arg == "--no-build" ]]; then
		#statements
		NO_BUILD_AND_RUN=1
	fi
	if [[ $arg == "--run" ]]; then
		#statements
		RUN_PROJ=1
	fi
done

if [[ $NO_POD == 1 ]]; then
	#statements
	echo "跳过 Pod Install 阶段"
else
	#statements
	PodInstall
fi

ControleProject

exit
