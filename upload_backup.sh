#!/bin/bash

# FTP server details
ftp_server="serveraddress"
ftp_user="username"
ftp_pass="password"

# Local and remote file paths
remote_directory="dirname"

# Connect to the FTP server and perform file operations
{
ftp -n $ftp_server <<END_SCRIPT
user $ftp_user "$ftp_pass"
binary

cd $remote_directory

put "$1"

quit
END_SCRIPT
} > "upload_backup.log" 2>&1
