#!/bin/sh

usage() {
  printf "Usage: %s: -f <file_system> -p <mount_path>\n" $0
}

while getopts 'f:p:' flag; do
  case "${flag}" in
    f) FILE_SYSTEM=${OPTARG};;
    p) MOUNT_PATH=${OPTARG};;
    ?) usage && exit 2;;
  esac
done

if [ -z "$FILE_SYSTEM" ]; then usage && exit 2; fi
if [ -z "$MOUNT_PATH" ]; then usage && exit 2; fi

mount 1> /dev/null || exit 1

echo "Mounting file system $FILE_SYSTEM at mount point $MOUNT_PATH"

sudo mkdir $MOUNT_PATH
sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $FILE_SYSTEM:/ $MOUNT_PATH || exit 1
cd $MOUNT_PATH
sudo chmod go+rw .

rm mount-test.txt
echo "Successfully mounted" > mount-test.txt
cat mount-test.txt
