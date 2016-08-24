#!/bin/bash

echo "Installing GIT"

uname -a | grep ‘Ubuntu’ > /dev/null
osname=`echo $?`

git --version
git_check=`echo $?`

if [ $git_check -eq 0 ]
then 
                echo "GIT is already Installed...!!!"
else
                if [ $osname -eq 0 ]
                then
                                apt-get install git-core -y
                else
                                yum install git-core -y
                fi
fi

cd cfs-terraform
dir_chk=`ehco $?`

if [ $dir_chk -eq 0 ]
then
	rm -rf cfs-terraform
else
	echo "There is no directory named "cfs-terraform""
fi

echo "Downloading necessary scripts from GIT Repository"

git clone https://github.com/renaldrozario/Sprint1.git

cd cfs-terraform

source /var/lib/jenkins/.bashrc

terraform --version

exit