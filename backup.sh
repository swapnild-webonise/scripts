#!/bin/bash
export AWS_ACCESS_KEY=
export AWS_SECRET_KEY=

db=`s3cmd ls -r s3://usa-football-db-backups/Db1-24-watch/backup/backup/usaf2008_impl_live/ | sort -r -k 4 | head -1 | awk '{print $4}'`
echo $db

#s3cmd get $db 
s3cmd get s3://usa-football-db-backups/Db1-24-watch/backup/backup/usaf2008_impl_live/site.yml /tmp/
