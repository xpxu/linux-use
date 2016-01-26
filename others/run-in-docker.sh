#!/bin/bash

# 如果某个命令执行返回非0，那么退出.防止失败后继续执行。
set -e

# $BASH_SOURCE指当前脚本文件
cd "$(dirname $BASH_SOURCE)"

maven_cache_repo="$HOME/.m2/repository"
myname="$(basename $BASH_SOURCE)"

if [ "$1" = "mvn" ]; then
        cmd="$1"
        shift
        # $@指代shift之后的其他所有参数
        args="$@"
else
        jar="modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
        
        # Check if project is built
        if [ ! -f "$jar" ]; then
                echo "ERROR File not found: $jar"
                echo "ERROR Did you forget to './$myname mvn package'?"
                exit 1
        fi
        
        cmd="java -jar /gen/$jar"
        args="$@"
fi

mkdir -p "$maven_cache_repo"

# 让shell执行时打印所有执行的命令。非常有用的命令。
set -x

docker run -it \
        -w /gen \ # -w="": Working directory inside the container
        -v "${PWD}:/gen" \
        -v "${maven_cache_repo}:/root/.m2/repository" \
        maven:3-jdk-7 $cmd $args
