#!/bin/bash 
#set -x
# Source: theme.fm/2011/06/a-shell-script-for-a-complete-wordpress-backup-4/
NOW=$(date +"%Y-%m-%d-%H%M")
FILE="example.com.$NOW.tar"
BACKUP_DIR="/path/to/backups"
WWW_DIR="/path/to/httpdocs/"
 
DB_USER="user"
DB_PASS="password"
DB_NAME="dbname"
DB_FILE="dumpfilename.sql"
 
WWW_TRANSFORM='s,^path/to/httpdocs,www,' #note absence of leading and trailing slash
DB_TRANSFORM='s,^path/to/httpdocs,database,' #note absence of leading and trailing slash
 
# tar files & dump database
tar -cvf $BACKUP_DIR/$FILE --exclude='.git' --transform $WWW_TRANSFORM $WWW_DIR
mysqldump -u$DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/$DB_FILE
 
# Restrict permissions on db backup
chmod 600 $BACKUP_DIR/$DB_FILE
 
# Append db backup into tar file
tar --append --file=$BACKUP_DIR/$FILE --transform $DB_TRANSFORM $BACKUP_DIR/$DB_FILE
rm $BACKUP_DIR/$DB_FILE
gzip -9 $BACKUP_DIR/$FILE
 
# Remove old backup
find $BACKUP_DIR -type f -mtime +100 -exec rm {} \;
 
# Sync to Remote host
rsync -avz --delete --max-delete=1 $BACKUP_DIR/ user@remotehost:/path/to/backup