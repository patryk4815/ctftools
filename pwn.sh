#!/bin/bash

docker build --platform linux/amd64 --build-arg frombuild=ubuntu -t pwn-amd64 -f ./Dockerfile.multi .
docker build --platform linux/arm/v7 --build-arg frombuild=ubuntu -t pwn-arm32v7 -f ./Dockerfile.multi .
docker build --platform linux/arm64 --build-arg frombuild=ubuntu -t pwn-arm64v8 -f ./Dockerfile.multi .

#docker run -v $(pwd):/work -w /work --rm --cap-add SYS_PTRACE -it pwn-amd64 bash
#docker run -v $(pwd):/work -w /work --rm --privileged -it pwn-amd64 bash
