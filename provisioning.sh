#!/bin/bsh -f
if [ "$2" = "apache-mysql" ]
then
	if [ "$1" = "development" ] || [ "$1" = "qa" ]
	then
		webcpu=$( cat json/"$1"-"$2".json | grep webcpu | cut -d":" -f2)
		webmemory=$( cat json/"$1"-"$2".json | grep webmemory | cut -d":" -f2 )
		webimage=$( cat json/"$1"-"$2".json | grep webimage | cut -d":" -f2)
		webhostname=$( cat json/"$1"-"$2".json | grep webhostname | cut -d":" -f2 )
		dbcpu=$( cat json/"$1"-"$2".json | grep dbcpu | cut -d":" -f2)
		dbmemory=$( cat json/"$1"-"$2".json | grep dbmemory | cut -d":" -f2 )
		dbimage=$( cat json/"$1"-"$2".json | grep dbimage | cut -d":" -f2)
		dbhostname=$( cat json/"$1"-"$2".json | grep dbhostname | cut -d":" -f2 )
		cp sl.tf sl1.tf
		sed -i s/hostname/"$webhostname"/g sl1.tf
		sed -i s/cpucount/"$webcpu"/g sl1.tf
		sed -i s/ramsize/"$webmemory"/g sl1.tf
		sed -i s/imagename/"$webimage"/g sl1.tf
		mkdir -p $2/$1/web
		mkdir -p $2/$1/db
		mv sl1.tf $2/$1/web/
		cd $2/$1/web
		terraform plan
		terraform apply
		cd ../../../
		cp sl.tf sl1.tf
		sed -i s/hostname/"$dbhostname"/g sl1.tf
		sed -i s/cpucount/"$dbcpu"/g sl1.tf
		sed -i s/ramsize/"$dbmemory"/g sl1.tf
		sed -i s/imagename/"$dbimage"/g sl1.tf
		mv sl1.tf $2/$1/db/
		cd $2/$1/db
		terraform plan
		terraform apply
	else
		echo "Current POC code supports only Development and QA environment, Please select Accordingly..."
	fi
elif [ "$2" = "wordpress" ] || [ "$2" = "websphere" ]
then
	if [ "$1" = "development" ] || [ "$1" = "qa" ]
        then
                cpu=$( cat json/"$1"-"$2".json | grep cpu | cut -d":" -f2)
                memory=$( cat json/"$1"-"$2".json | grep memory | cut -d":" -f2 )
                image=$( cat json/"$1"-"$2".json | grep image | cut -d":" -f2)
                hostname=$( cat json/"$1"-"$2".json | grep hostname | cut -d":" -f2 )
                cp sl.tf sl1.tf
                sed -i s/hostname/"$hostname"/g sl1.tf
                sed -i s/cpucount/"$cpu"/g sl1.tf
                sed -i s/ramsize/"$memory"/g sl1.tf
                sed -i s/imagename/"$image"/g sl1.tf
                mkdir -p $2/$1/
                mv sl1.tf $2/$1/
                cd $2/$1/
                terraform plan
                terraform apply
	else
                echo "Current POC code supports only Development and QA environment, Please select Accordingly..."
        fi
else
	echo "Current POC only supports apache-mysql, wordpress or websphere stack, Please select Accordingly..."
fi
