# Move Files
## Description
This is a simple script that does the following
1. Checks to ensure the server is not in a DR environment
2. Estabilshes an sftp connection to a host with a given username and password
3. Downloads the files in a specified directory to a specified local directory
4. Deletes the source files on the sftp server

## Installation
To install simply
1. download the script and make sure it has execute permissions
2. Open move_files.sh in vi or another text editor
3. Replace the constants at the top of the script with values appropriate to your environment, be sure to retain the double quotes 