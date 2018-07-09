#!/bin/bash

imageName=$1
docker rm $(docker ps -a | grep '\sExited' | grep ${imageName})
