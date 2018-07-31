#!.bin/bash

imageName=$1
batchName=$2

docker rm $(docker ps -a | grep ${imageName} | grep 'Exited' | awk '{print $1}' )
