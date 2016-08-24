#!/bin/bsh -f
if [ "$2" = "apache-mysql" ]
then
	if [ "$1" = "development" ] || [ "$1" = "qa" ]
	then
                echo -n "Do you want to take backup before Destroy[y/n]:"
                read value
                if [ "$value" = "y" ]
                then
			cd $2/$1/web/
			id=$(cat terraform.tfstate | grep \"id\" | cut -d":" -f2 | cut -d"\"" -f2 | uniq)
			name=$(cat terraform.tfstate | grep \"name\" | cut -d":" -f2 | cut -d"\"" -f2 | uniq)
       		        slcli vs capture $id -n $name
       	        	imgid=$(slcli image list | grep $name | cut -d" " -f1)
	                echo "Backup in progress for the server" "$name"
	                for i in {1..600}
	                do
	                        sleep 1
	                        imgid1=$(slcli image detail $imgid | grep disk | tr -d ' '| cut -d"e" -f2)
	                        if [ "$imgid1" != "0" ]
	                        then
        	                        echo "Backup Completed successfully :" "$name"
	                                terraform destroy -force
	                                break
	                        fi
        	        done
			cd ../../../
			cd $2/$1/db
			id1=$(cat terraform.tfstate | grep \"id\" | cut -d":" -f2 | cut -d"\"" -f2 | uniq)
			dbname=$(cat terraform.tfstate | grep \"name\" | cut -d":" -f2 | cut -d"\"" -f2 | uniq)
        	        slcli vs capture $id1 -n $dbname
	                imgdbid=$(slcli image list | grep $dbname | cut -d" " -f1)
        	        echo "Backup in progress for the server" "$dbname"
	                for i in {1..600}
        	        do
                	        sleep 1
	                        imgdbid1=$(slcli image detail $imgdbid | grep disk | tr -d ' '| cut -d"e" -f2)
	                        if [ "$imgdbid1" != "0" ]
	                        then
	                                echo "Backup Completed successfully :" "$dbname"
        	                        terraform destroy -force
	                                break
        	                fi
	                done
			cd ../../
	                rm -rf $1
			cd ../
			rm -d $2
		elif [ "$value" = "n" ]
                then
			cd $2/$1/web/
                        terraform destroy -force
			cd ../../../
                        cd $2/$1/db
			terraform destroy -force
			cd ../../
			rm -rf $1
			cd ../
			rm -d $2
		else
                        echo "right selection is y/n"
                fi

	else
		echo "Current POC code supports only Development and QA environment, Please select Accordingly..."
	fi
elif [ "$2" = "wordpress" ] || [ "$2" = "websphere" ]
then
	if [ "$1" = "development" ] || [ "$1" = "qa" ]
        then
		echo -n "Do you want to take backup before Destroy[y/n]:"
		read value
		if [ "$value" = "y" ]
		then
			cd $2/$1/
        	      	id=$(cat terraform.tfstate | grep \"id\" | cut -d":" -f2 | cut -d"\"" -f2 | uniq)
			name=$(cat terraform.tfstate | grep \"name\" | cut -d":" -f2 | cut -d"\"" -f2 | uniq)
			slcli vs capture $id -n $name
			sleep 10
               		imgid=$(slcli image list | grep $name | cut -d" " -f1)
			sleep 5
	                echo "Backup in progress for the server" "$name"
			for i in {1..600}
	                do
        	                sleep 1
                	        imgid1=$(slcli image detail $imgid | grep disk | tr -d ' '| cut -d"e" -f2)
	                        if [ "$imgid1" != "0" ]
        	                then
					echo "Backup Completed successfully :" "$name"	
                        	        terraform destroy -force
	                                break
        	                fi
                	done
			cd ../
			rm -rf $1
			cd ../
			rm -d $2
		elif [ "$value" = "n" ]
		then
			cd $2/$1/
			terraform destroy -force
			cd ../
			rm -rf $1
			cd ../
                        rm -d $2
		else
			echo "right selection is y/n"
		fi
	else
                echo "Current POC code supports only Development and QA environment, Please select Accordingly..."
        fi
else
	echo "Current POC only supports apache-mysql, wordpress or websphere stack, Please select Accordingly..."
fi
