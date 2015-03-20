#!/bin/bash
# znc-install
scriptversion="0.5.0"
scriptname="znc-install"
# adamaze
#
# wget -qO ~/znc-install.sh http://git.io/hrKo && bash ~/znc-install.sh
#
############################
#### Script Notes Start ####
############################
#
# Todo:
#	add configuring help?
#
############################
##### Script Notes End #####
############################
#
############################
## Version History Starts ##
############################
#
# 0.5.0 - initial commit
#
############################
### Version History Ends ###
############################
#
############################
###### Variable Start ######
############################
#
updaterenabled="0"
#
scripturl="https://raw.githubusercontent.com/frankthetank7254/feral/master/znc-install.sh"
#
############################
####### Variable End #######
############################
#
############################
#### Self Updater Start ####
############################
#
if [[ "$updaterenabled" -eq 1 ]]
then
    [[ ! -d ~/bin ]] && mkdir -p ~/bin
    [[ ! -f ~/bin/"$scriptname" ]] && wget -qO ~/bin/"$scriptname" "$scripturl"
    #
    wget -qO ~/.000"$scriptname" "$scripturl"
    #
    if [[ $(sha256sum ~/.000"$scriptname" | awk '{print $1}') != $(sha256sum ~/bin/"$scriptname" | awk '{print $1}') ]]
    then
        echo -e "#!/bin/bash\nwget -qO ~/bin/$scriptname $scripturl\ncd && rm -f $scriptname{.sh,}\nbash ~/bin/$scriptname\nexit" > ~/.111"$scriptname"
        bash ~/.111"$scriptname"
        exit
    else
        if [[ -z $(ps x | fgrep "bash $HOME/bin/$scriptname" | grep -v grep | head -n 1 | awk '{print $1}') && $(ps x | fgrep "bash $HOME/bin/$scriptname" | grep -v grep | head -n 1 | awk '{print $1}') -ne "$$" ]]
        then
            echo -e "#!/bin/bash\ncd && rm -f $scriptname{.sh,}\nbash ~/bin/$scriptname\nexit" > ~/.222"$scriptname"
            bash ~/.222"$scriptname"
            exit
        fi
    fi
    cd && rm -f .{000,111,222}"$scriptname"
    chmod -f 700 ~/bin/"$scriptname"
else
    echo
    echo "The Updater has been disabled"
fi
#
############################
##### Self Updater End #####
############################
#
############################
#### Core Script Starts ####
############################
#
#echo
#echo -e "Hello $(whoami), you have the latest version of the" "\033[36m""$scriptname""\e[0m" "script. This script version is:" "\033[31m""$scriptversion""\e[0m"
#echo
#read -ep "The script has been updated, enter [y] to continue or [q] to exit: " -i "y" updatestatus
#echo
#if [[ "$updatestatus" =~ ^[Yy]$ ]]
#then
#
############################
#### User Script Starts ####
############################
#
mkdir -p ~/bin && bash
wget -qO ~/znc.tar.gz http://znc.in/releases/znc-latest.tar.gz
tar xf ~/znc.tar.gz && cd ~/znc-1.*
./configure --prefix=$HOME
make && make install
cd && rm -rf znc{-1.*,.tar.gz}
~/bin/znc --makeconf

# adding to cron
tmpnum=$(shuf -i 10001-20000 -n 1) 
if [ "$(crontab -l)" == "no crontab for $(whoami)" ]; then
        echo "crontab does not currently exist, so we are creating one"
        echo "@reboot ~/bin/znc" >> ~/crontab.$tmpnum.tmp
        crontab ~/crontab.$tmpnum.tmp
        rm ~/crontab.$tmpnum.tmp
else
        if [ $(crontab -l | grep -c znc) == "0" ]; then
                echo "crontab does exist, and znc is not in there, so we are appending it"
                crontab -l > ~/crontab.$tmpnum.tmp   
                echo "@reboot ~/bin/znc" >> ~/crontab.$tmpnum.tmp
                crontab ~/crontab.$tmpnum.tmp
                rm ~/crontab.$tmpnum.tmp
        else
                echo "znc is already in crontab"
        fi
fi

# give user the full URL
echo "Click on the URL below to do additional configuration if needed"
echo -e "\nhttps://$(hostname -f):$(grep Port ~/.znc/configs/znc.conf | awk '{print $3}')"


#
#
############################
##### User Script End  #####
############################
#
#else
#    echo -e "You chose to exit after updating the scripts."
#    echo
#    cd && bash
#    exit 1
#fi
#
############################
##### Core Script Ends #####
############################
#
