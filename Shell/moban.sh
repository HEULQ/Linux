#!/bin/bash
# FILENAME = scppi
function Usage() {
	echo "Usage: scppi file_or_dir Username@piname:dest_file_or_dir"
	echo "Like This：scppi PiHealth pi@pi1:./new"
}
if [[ ! $# -eq 2  ]]; then
	Usage
	exit
fi
echo $2 | grep @ | grep : >/dev/null 2>&1
if [[ ! $? -eq 0 ]]; then
	echo "argument wrong！"
	Usage
	exit
fi
Username=`echo $2 | cut -d "@" -f 1`
if [[ ${Username}x == x ]]; then
	echo "Please input your username!"
	Usage
	exit
fi
Hostname=`echo $2 | cut -d "@" -f 2 | cut -d ":" -f 1`
if [[ ${Hostname}x == x ]]; then
	echo "Please input Hostname of Pi!"
	Usage
	exit
fi
echo $Hostname | grep -w "^pi[1-9][0-9]\?" >/dev/null 2>&1
if [[ ! $? -eq 0 ]]; then
	echo "Hostname is Wrong!"
	Usage
	exit
fi
dir_file=`echo $2 | cut -d "@" -f 2 | cut -d ":" -f 2`
if [[ ${dir_file}x == x ]]; then
	echo "Please input dest_file_or_dir of Pi!"
	Usage
	exit
fi
if [[ ! -e $1 ]]; then
	echo "$1: No such file or directory!"
	Usage
	exit
fi
flag=file
if [[ -d $1 ]]; then
	flag=directory
fi
HostNum=`echo $Hostname | cut -c 3-`

if [[ $HostNum -gt 20 ]]; then
	echo "Hostname is Wrong!"
	Usage
	exit
fi

port=$[6530 + $HostNum]
echo -e "\033[46;30m Coping $flag \033[46;31m$1\033[46;30m to \033[46;31m$dir_file\033[46;30m on \033[46;31m$Hostname\033[46;30m with Username \033[46;31m$Username\033[46;30m, enjoy it!\033[0m"
scp -P $port -r $1  ${Username}@zentao.haizeix.tech:$dir_file
