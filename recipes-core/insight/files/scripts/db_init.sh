#!/bin/bash

# *****************************************************************************
# *                     Proprietary Information of
# *                       Ingersoll-Rand Company
# *
# *                   Copyright 2020 Ingersoll-Rand
# *                         All Rights Reserved
# *
# * This document is the property of Ingersoll-Rand Company and contains
# * contains proprietary and confidential information of Ingersoll-Rand
# * Company.  Neither this document nor said proprietary information
# * shall be published, reproduced, copied, disclosed, or communicated to
# * any third party, nor be used for any purpose other than that stated
# * in the particular enquiry or order for which it is issued. The
# * reservation of copyright in this document extends from each date
# * appearing thereon and in respect of the subject matter as it appeared
# * at the relevant date.
# *
# *****************************************************************************

#create and mount the database and temp folders if they do not exist
DB_FILE=/mnt/ssd/database/data/db_init

FR_FILE=/temp_data/FR_status
FACTORY_RESET_FILE=/scripts/Factory_Reset.sql

#db migration related files
DB_SCHEMA_FILE_NEW=/scripts/DB_Creation_Schema.sql
DB_SCHEMA_FILE_OLD=/scripts/db_schema_old.sql
DB_SCHEMA_FILE_DIFF=/scripts/db_schema_changes.sql
DEFAULT_RECORDS_FILE=/scripts/Insert_Default_Records.sql

#this function is used to manage the postgres user's privilege
setPostgresPrivilege()
{
    if [ "$1" = "trusted" ]
    then
        #stop the postgresql service
        echo "`date` : Stop the database" >> /var/log/diskcheck.log
        echo "`date` : Stop the database" >> /dev/console
		service postgresql stop
		ps auxw | grep postgresql  | grep -v grep > /dev/null
        while [ $? == 0 ] 
		do
		  echo "yyyyyyyyyyyyyyyyyyyyyyyyy" >> /var/log/diskcheck.log
		  
		  service postgresql stop
		  sleep 2
		  ps auxw | grep postgresql  | grep -v grep > /dev/null
		done

        echo "`date` : Copy the temporary settings for postgresql" >> /var/log/diskcheck.log
        echo "`date` : Copy the temporary settings for postgresql" >> /dev/console
        cp /settings/postgresql.conf /etc/postgresql/11/main
        cp /settings/temp/pg_hba.conf /etc/postgresql/11/main

        #start the postgresql service
        echo "`date` : Start the database" >> /var/log/diskcheck.log
        echo "`date` : Start the database" >> /dev/console
        service postgresql start
		ps auxw | grep postgresql  | grep -v grep > /dev/null
		while [ $? != 0 ] 
		do
			echo "weeeeeeeeeeeeeeeeeeeeee" >> /var/log/diskcheck.log			
			service postgresql start
			sleep 2
			ps auxw | grep postgresql  | grep -v grep > /dev/null
		done
   
    elif [ "$1" = "peer" ]
    then
        echo "`date` : Copy the final settings for postgresql to require password for postgres user" >> /var/log/diskcheck.log
        echo "`date` : Copy the final settings for postgresql to require password for postgres user" >> /dev/console
        cp /settings/pg_hba.conf /etc/postgresql/11/main
    else
      echo "`date` : Invalid privilege" >> /var/log/diskcheck.log
      echo "`date` : Invalid privilege" >> /dev/console 
    fi      
}

if [ ! -f "$DB_FILE" ]
then
	echo "`date` : DB Not Initialized" >> /var/log/diskcheck.log
	echo "`date` : DB Not Initialized" >> /dev/console

	# remove any files in the folder - may be old CouchDB files
	echo "`date` : Remove any old files" >> /var/log/diskcheck.log
	echo "`date` : Remove any old files" >> /dev/console
	rm -rf /mnt/ssd/database/data/* 

	# copy the initial files from the install folder 
	echo "`date` : Copy DB data from install folder to SATA" >> /var/log/diskcheck.log
	echo "`date` : Copy DB data from install folder to SATA" >> /dev/console
	rsync -av /var/lib/postgresql/11/main/ /mnt/ssd/database/data >> /var/log/diskcheck.log
    
    setPostgresPrivilege trusted
    
	#change to the postgres user and create the database, user, and assign rights
	echo "`date` : Create the insight user and database" >> /var/log/diskcheck.log
	echo "`date` : Create the insight user and database" >> /var/log/diskcheck.log
	echo "1111111111111111" >> /var/log/diskcheck.log
	psql -U postgres -c "create user insight with password 'B80F01';" >> /var/log/diskcheck.log
	echo "222222222222222222" >> /var/log/diskcheck.log
	psql -U postgres -c "create database db_insight;" >> /var/log/diskcheck.log
	echo "333333333333333333333" >> /var/log/diskcheck.log
	psql -U postgres -c "grant all privileges on database db_insight to insight;"  >> /var/log/diskcheck.log
	echo "4444444444444444444444" >> /var/log/diskcheck.log
	psql -U postgres -c "alter user postgres with password 'ghw2SIO4';" >> /var/log/diskcheck.log
	
	echo "5555555555555555555" >> /var/log/diskcheck.log
	psql -U postgres db_insight < $DB_SCHEMA_FILE_NEW >> /var/log/diskcheck.log 2>&1
	echo "66666666666666666666666666666666" >> /var/log/diskcheck.log
    psql -U postgres db_insight < $DEFAULT_RECORDS_FILE >> /var/log/diskcheck.log 2>&1
    #rm -f $DEFAULT_RECORDS_FILE $DB_SCHEMA_FILE_NEW

    setPostgresPrivilege peer
    
	#create the db_init file
	echo "`date` : Create the db_init file to show DB was initialized" >> /var/log/diskcheck.log 
	echo "`date` : Create the db_init file to show DB was initialized" >> /dev/console
	touch $DB_FILE
    #Factory Reset goes here..
elif [ -f "$FR_FILE" ]
then
	echo F > $FR_FILE
	touch $FR_FILE
	
    echo "`date` : Schema Reset started..." >> /var/log/diskcheck.log
    echo "`date` : Schema Reset started..." >> /dev/console
    
    setPostgresPrivilege trusted

    #Reset schema
    psql -U postgres db_insight < $FACTORY_RESET_FILE >> /var/log/diskcheck.log 2>&1

    #empty sessions table so that user is not inhibited from re login after a reboot(within session timeout time)
    psql -d db_insight -U postgres -c "TRUNCATE public.tbl_session;"  >> /var/log/diskcheck.log 2>&1
    
    setPostgresPrivilege peer
     
    echo "`date` : Schema Reset done" >> /var/log/diskcheck.log
    echo "`date` : Schema Reset done" >> /dev/console
	
    # delete all the logs
    echo "`date` : Delete All Logs" >> /var/log/diskcheck.log
    echo "`date` : Delete All Logs" >> /dev/console	
    rm -rf /temp_data/download/*
    rm -rf /var/logs/*
    rm -rf /temp_data/Firmware_logs/*
    rm -rf /temp_data/logs/*

	echo S > $FR_FILE
	touch $FR_FILE

    #db migration goes here..
elif [ -f "$DB_SCHEMA_FILE_NEW" ]
then
    echo "`date` : Schema migration started..." >> /var/log/diskcheck.log
	echo "`date` : Schema migration started..." >> /dev/console
    
    setPostgresPrivilege trusted
    
    echo "`date` : Backup old schema" >> /var/log/diskcheck.log
	echo "`date` : Backup old schema" >> /dev/console

    #create schema dump of current database (old schema)
    pg_dump -U postgres -s db_insight > $DB_SCHEMA_FILE_OLD 2>> /var/log/diskcheck.log

	echo "`date` : Create schema diff" >> /var/log/diskcheck.log
	echo "`date` : Create schema diff" >> /dev/console
    
    #create schema diff
    java -jar /usr/share/java/apgdiff-2.6.0.jar $DB_SCHEMA_FILE_OLD $DB_SCHEMA_FILE_NEW > $DB_SCHEMA_FILE_DIFF 2>> /var/log/diskcheck.log

	echo "`date` : Apply schema diff" >> /var/log/diskcheck.log
	echo "`date` : Apply schema diff" >> /dev/console
    
    #restore schema
    psql -U postgres db_insight < $DB_SCHEMA_FILE_DIFF >> /var/log/diskcheck.log 2>&1

	echo "`date` : Insert default records" >> /var/log/diskcheck.log
	echo "`date` : Insert default records" >> /dev/console
    
    #insert default records
    psql -U postgres db_insight < $DEFAULT_RECORDS_FILE >> /var/log/diskcheck.log 2>&1

    #empty sessions table so that user is not inhibited from re login after a reboot(within session timeout time)
    psql -d db_insight -U postgres -c "TRUNCATE public.tbl_session;"  >> /var/log/diskcheck.log 2>&1
    
    setPostgresPrivilege peer
    
    #delete all .sql files   $DB_SCHEMA_FILE_NEW $DEFAULT_RECORDS_FILE
    rm -f $DB_SCHEMA_FILE_OLD $DB_SCHEMA_FILE_DIFF 
     
    echo "`date` : Schema migration done" >> /var/log/diskcheck.log
    echo "`date` : Schema migration done" >> /dev/console
else
    echo "`date` : DB schema is already upto date" >> /var/log/diskcheck.log
    echo "`date` : DB schema is already upto date" >> /dev/console

    setPostgresPrivilege trusted

    echo "`date` : Truncating sessions table..." >> /var/log/diskcheck.log
    echo "`date` : Truncating sessions table..." >> /dev/console

    #empty sessions table so that user is not inhibited from re login after a reboot(within session timeout time)
    psql -d db_insight -U postgres -c "TRUNCATE public.tbl_session;"  >> /var/log/diskcheck.log 2>&1

    setPostgresPrivilege peer
fi

 
#restart the server
echo "`date` : Restart the database" >> /var/log/diskcheck.log
echo "`date` : Restart the database" >> /dev/console
service postgresql restart
ps auxw | grep postgresql  | grep -v grep > /dev/null
while [ $? != 0 ] 
do
  echo "`date` : Database not up.  Wait..." >> /var/log/diskcheck.log
  echo "`date` : Database not up.  Wait..." >> /dev/console 
  service postgresql restart
  sleep 2
  ps auxw | grep postgresql  | grep -v grep > /dev/null
done

echo "`date` : Database is UP" >> /var/log/diskcheck.log  
echo "`date` : Database is UP" >> /dev/console

