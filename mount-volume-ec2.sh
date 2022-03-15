#!/bin/sh

INSTANCE=$1
FILE_SYSTEM=$2
MOUNT_DIR=$3

echo "Mounting file system $FILE_SYSTEM to instance $INSTANCE at mount point $MOUNT_DIR"

sudo apt update
sudo apt install nfs-common

sudo mkdir $MOUNT_DIR

sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $FILE_SYSTEM:/ $MOUNT_DIR

cd $MOUNT_DIR

sudo chmod go+rw .

rm mount-test.txt
echo "Successfully mounted" > mount-test.txt
cat mount-test.txt

