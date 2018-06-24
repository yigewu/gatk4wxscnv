#!/bin/bash

mainRunDir=$1
bamDir=${mainRunDir}"bams/"
mkdir -p ${bamDir}

## format the disks
sudo mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb

### Use the mount tool to mount the disk to the instance with the discard option enabled:
sudo mount -o discard,defaults /dev/sdb ${bamDir}

### change permission of directory the disks are mounted on
sudo chmod 777 ${bamDir}

## add the persistent disk to the /etc/fstab file so that the device automatically mounts again when the instance restarts.
### Create a backup of your current /etc/fstab file
sudo cp /etc/fstab /etc/fstab.backup

### Use the blkid command to find the UUID for the persistent disk. The system generates this UUID when you format the disk. Use UUIDs to mount persistent disks because UUIDs do not change when you move disks between systems.
echo UUID=`sudo blkid -s UUID -o value /dev/sdb` ${bamDir} ext4 discard,defaults,nofail 0 2 | sudo tee -a /etc/fstab