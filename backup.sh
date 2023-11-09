#!/bin/bash

backup_title="My Wordpress Website"

db_user=user
db_password="pass"
db_name=database

backup_sql="backup.sql"
current_date=$(date +"%Y%m%d")
backup_file="backup_${current_date}.tar.gz"

rm -f backup_*.tar.gz

echo "Start $backup_title backup"

echo "Creating database backup..."
mysqldump -u $db_user -p$db_password $db_name > "$backup_sql" > backu                                                                                                                                                             p_output.log 2>&1
echo "Done"

echo "Creating file backup..."
tar -czvf "$backup_file" "$backup_sql" /var/www/scienzenotizie.it >> backup_outp                                                                                                                                                             ut.log 2>&1
echo "Done"

echo "Split $backup_file for uploding in chunk"
split -b 2G -d - $backup_file.part < $backup_file

for part in ${backup_file}.part*; do
  echo "Uploading $part..."
  ./upload_backup.sh "$part"
  echo "Done"
  rm "$part"
  echo "Local file $par removed"
done

rm -f $backup_sql
rm -f $backup_file
echo "Local backup files is now removed"

./clean_backup.sh

echo "End $backup_title backup"
