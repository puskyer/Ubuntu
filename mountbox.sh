#!/bin/bash
# -----------------------------------
# Author: Aaron Griffith
# Web: aarongriffith.net
# Purpose: To automatically mount Box.com on Ubuntu
# v1.0 - Wish me luck
#      - Modified some things in the script to make it prettier.
#      - Added Colors, spelling errors, prompts, etc.  
#-----------------------------------

# Color Stuff
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White
Color_Off='\033[0m'       # Color/Text Reset

#Check to see if root user is running script
if [ “$(id -u)” != “0” ]; then
echo -e “${Red}This script must be run as root${Color_Off}” 2>&1
exit 1
fi

# If statement to install davfs
DAVPKG="davfs2"
for pkg in $DAVPKG; do
    if dpkg --get-selections | grep -q "^$pkg[[:space:]]*install$" >/dev/null; 
    then        
        echo -e "\n${Green}Success: $pkg is already installed *****${Color_Off}"
    else
        echo -e "\n${Yellow}Notice: $pkg is NOT installed.\n Proceeding to install $pkg${Color_Off}\n"
	apt-get -qq install $pkg
        echo -e "\n${Green}Success: Successfully installed $pkg ${Color_Off}"
    fi
done

# Determine UBUNTU Username
echo -e "\n${White}Input your Ubuntu Username, followed by [Enter]${Color_Off}\n"
read nonrootusername

     if [ -z "$nonrootusername" ];     
     then
	echo -e "\n${Red}Error: Your UBUNTU USERNAME is not set.\nPlease rerun script and Input Username\n${Color_Off}";
	exit 0
     else
	echo -e "\n${Green}Success: Your UBUNTU USERNAME has been set to: ${Cyan} $nonrootusername ${Color_Off}\n";
     fi		

#Copy Contents to User's Home directory, change permissions.
cp -R /etc/davfs2/ /home/$nonrootusername/.davfs2
chown -R $nonrootusername /home/$nonrootusername/.davfs2

# Ask For Box.com Username/Password. Store in User's .davfs folder
echo -e "\nPlease Enter your Box.com USERNAME.\nThis will be used to automatically mount without prompting for Username/password."
read boxusername

     if [ -z "$boxusername" ];     
     then
	echo -e "\n${Red}Error: Your Box.com USERNAME has not been set.\nPlease rerun script and input your Box.com USERNAME.${Color_Off}\n";
	exit 0
     else
	echo -e "\n${Green}Success: Your Box.com username has been set.\nSee /home/$nonrootusername/.davfs2/secrets\n${Color_Off}";
     fi		

#BOX PASSWORD PROMPT
echo -e "\nWhat is your Box.com password?"
read boxpassword
     if [ -z "$boxpassword" ];     
     then
	echo -e "\n${Red}Error: Your Box.com PASSWORD has not been set.\nPlease rerun script and input your Box.com PASSWORD.${Color_Off}";
	exit 0
     else
	echo -e "\n${Green}Success: Your Box.com password have been set.\nSee /home/$nonrootusername/.davfs2/secrets ${Color_Off}";
     fi

# Create secrets file
echo -e "https://dav.box.com/dav $boxusername $boxpassword" >> /home/$nonrootusername/.davfs2/secrets

chmod 600 /home/$nonrootusername/.davfs2/secrets

#create box dir
mkdir /home/$nonrootusername/box

# fstab
echo -e "\n#Box.com Mount\nhttps://dav.box.com/dav /home/$nonrootusername/box  davfs  _netdev,rw,user 0 0" >> /etc/fstab

# Other box.com stuff
chmod u+s /sbin/mount.davfs
echo "secrets         ~/.davfs2/secrets" >> /home/$nonrootusername/.davfs2/davfs2.conf
#echo "secrets         ~/.davfs2/secrets" >> /etc/davfs2/davfs2.conf

# Automatically mount upon login or username switch
echo -e "\n#Automatically check if box is mounted\nmountpoint -q /home/$nonrootusername/box || mount /home/$nonrootusername/box" >> /home/$nonrootusername/.profile

#Mount it once and then finish!
su -c "mountpoint -q /home/$nonrootusername/box || mount /home/$nonrootusername/box" $nonrootusername

echo -e "\nCOMPLETE! Exit out of root user to have Box.com mounted!\n"
