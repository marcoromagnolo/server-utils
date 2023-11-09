#!/bin/bash

# FTP server details
ftp_server="serveraddress"
ftp_user="username"
ftp_pass="password"

# Local and remote file paths
remote_directory="dirname"
local_file="remote_files.txt"

# Calculate the current date minus 1 week in seconds
one_week_ago=$(date -d "1 week ago" +%s)

# Connect to the FTP server and perform file operations
{
ftp -n $ftp_server <<END_SCRIPT
user $ftp_user "$ftp_pass"
binary

cd $remote_directory
nlist

quit
END_SCRIPT
} > $local_file

echo "Start cleaning remote backups"

cat $local_file | while IFS= read -r file
do
  if [[ $file =~ backup_[0-9]{8}\.tar\.gz\.part[0-9]+ ]]; then
    # Extract the date from the filename (assuming the date is in YYYYMMDD format)
    filename=$(basename "$file")
    date_in_filename=${filename:7:8}

    # Convert the date in the filename to seconds since epoch
    file_timestamp=$(date -d "$date_in_filename" +%s)

    # Check if the file is older than 1 week
    if [[ $file_timestamp -lt $one_week_ago ]]; then
      # Check if the date in the filename corresponds to the first or 15th of the month
      day_of_month=${date_in_filename:6:2}
      if [[ "$day_of_month" != "01" && "$day_of_month" != "15" ]]; then
        echo "Removing $file"
        {
        ftp -n $ftp_server <<END_SCRIPT
        user $ftp_user "$ftp_pass"
        binary
        cd $remote_directory
        rm $file
        quit
END_SCRIPT
        }
      fi
    fi
  fi
done

echo "Cleaning remote backups completed"
