#!/bin/bash -e
##SLCLI and Terraform Installation
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

echo "Now we will install Softlayer CLI. Please sit back and Relax!"
slcli --version &> /dev/null
check1=`echo $?`
if [ $check1 -eq 0 ]
        then
        echo "Softlayer CLI is already installed!"
else
        echo "Installing Softlayer CLI. Please sit back and Relax..!!!"
        curl -OL https://github.com/softlayer/softlayer-python/zipball/master
        unzip master
        con1=`echo $?`
        if [ $con1 -eq 0 ]
                then
                file=`ls | grep 'softlayer-python'`
                cd $file
                        python setup.py install
                        con2=`echo $?`
                        if [ $con2 -eq 0 ]
                        then
                                echo "Installation Complete"
						else	
							if [ $osname -eq 0 ]
							then 
								apt-get install python-setuptools -y
                                python setup.py install
							else
                                yum install python-setuptools -y
                                python setup.py install
							fi
						fi
		else
			if [ $osname -eq 0 ]
			then 
				apt-get update -y
                apt-get install unzip -y
			else
				yum update -y
				yum install unzip -y
			fi
            unzip master
			file=`ls | grep 'softlayer-python'`
                cd $file
				python setup.py install
				con3=`echo $?`
				if [ $con3 -eq 0 ]
				then
						echo "Installation Complete"
				else
					if [ $osname -eq 0 ]
					then
						apt-get install python-setuptools -y
                        python setup.py install
					else	
						yum install python-setuptools -y
						python setup.py install
                    fi
				fi	
        fi
fi
echo "Version details are as follows:"
slcli --version
echo
echo
echo "Installing Terraform"
echo
echo
terraform --version &> /dev/null
check1=`echo $?`
if [ $check1 -eq 0 ]
        then
        echo "Terraform is already installed!"
else
        echo "Installing Terraform... Sit back and relax!"
		cd /root
        mkdir terraform_dir
        cd terraform_dir
        wget https://releases.hashicorp.com/terraform/0.7.0/terraform_0.7.0_linux_amd64.zip
        unzip terraform_0.7.0_linux_amd64.zip
    if [ $osname -eq 0 ]
	then
		echo "export PATH=$PATH:/root/terraform_dir" >> /root/.bashrc
		source /root/.bashrc
	else
		echo "export PATH=$PATH:/root/terraform_dir" >> /root/.bash_profile
		source /root/.bash_profile		
    fi
fi
echo "Installation is complete!"
echo "Version details are as follows:"
terraform --version

echo "Please enter the Softlayer credentials for SLCLI Setup"
slcli setup