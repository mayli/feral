#!/bin/bash
#
#
# wget -qO ~/community-troubleshooter.sh http://git.io/vewgm && bash ~/community-troubleshooter.sh
#
# Todo:
# check to see if normal folders are there, (rtorrent, rutorrent, deluge, transmission, mysql)
# 	maybe get a list of ALL default files/folders on a feral slot, and check for existance
#
#
mkdir -p ~/www/$(whoami).$(hostname -f)/public_html/tmp
log=$(openssl rand -hex 10).txt
logpath=~/www/$(whoami).$(hostname -f)/public_html/tmp/$log
if [ "$1" = "-c" ];then
        rm ~/www/$(whoami).$(hostname -f)/public_html/tmp/*.txt
	echo Old logs have been removed
	exit
fi
if [ -a ~/www/$(whoami).$(hostname -f)/public_html/tmp/index.html ];then
	:
else
	touch ~/www/$(whoami).$(hostname -f)/public_html/tmp/index.html
fi
#
echo "$(whoami)" on "$(hostname -f) on "$(date) > $logpath
echo >> $logpath
echo "You are using $(du -sB GB ~/| awk '{print $1}') of space on your slot." | tee -a $logpath
echo >> $logpath
echo "Your disk is $(df -h $(df -h ~/ | grep dev | awk '{print $1}') | grep dev | awk '{print $5}') used." | tee -a $logpath
echo >> $logpath
echo "For the next 30 seconds, your disk will be monitored to see how busy it is."
echo "Disk utilization over 30 seconds" >> $logpath
iostat -x 5 7 -d $(df -h ~ | grep dev | awk '{print $1}') | sed '/^$/d'| grep -v util | awk '{print $14}' | tail -n+3 | sed 's/^/%/' | tee -a $logpath
echo | tee -a $logpath
echo "Running proccesses:" | tee -a $logpath
ps x --sort=command | tee -a $logpath

echo
echo "Paste the following URL in chat, and someone may be able to help troubleshoot."
echo "https://$(hostname -f)/$(whoami)/tmp/$log"
