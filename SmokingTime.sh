#!/bin/bash

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
		open "/Users/aldaron/Documents/Aldaron/IndepTravel-iOS-Cocoapods/IndepTravel/IndepTravel-iPhone/TravelGuideMdd.xcworkspace"
		set workspaceDocument to workspace document "TravelGuideMdd.xcworkspace"
		repeat 120 times
			if loaded of workspaceDocument is true then
				close workspaceDocument
				exit repeat
			end if
		end repeat

		open "/Users/aldaron/Documents/Aldaron/IndepTravel-iOS-Cocoapods/IndepTravel/IndepTravel-iPhone/TravelGuideMdd.xcworkspace"
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
		log "build 开始结束" & (time string of (buildTime_End))
		log "Build 总共耗时 :" & (buildTime_End - buildTime_Begin) & "秒"

	end tell

SCRIPT
}

function ControleProject() {
	#statements
	LoadMFWProject
	BuildMFWProject
}

##
#	代码的开头
##
if [[ $1 == "--no-pod" ]]; then
	#statements
	echo "跳过Pod阶段"
else
	#statements
	PodInstall
fi


if [[ $1 == "--no-build" ]]; then
	#statements
	echo "跳过Build阶段"
else
	#statements
	ControleProject
fi

exit
