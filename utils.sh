#!/bin/bash

# initialize
# see p.14
init()
{
    set -u
    umask 0022
    PATH='/usr/bin:/bin'
    IFS=$(printf ' \t\n_'); IFS=${IFS%_}
    export IFS LC_ALL=C LANG=C PATH
}


get-num-of-cpu-cores()
{
    NUM_OF_CPUS="`grep processor /proc/cpuinfo | wc -l`"

    echo ${NUM_OF_CPUS}
}


# http://qiita.com/UmedaTakefumi/items/fe02d17264de6c78443d
get-os()
{
    if [ "$(uname)" == 'Darwin' ]; then
        OS='Mac'
    elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
        OS='Linux'
    elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
        OS='Cygwin'
    else
        echo "Your platform ($(uname -a)) is not supported."
        exit 1
    fi

    echo ${OS}
}


# see http://qiita.com/koara-local/items/1377ddb06796ec8c628a
# return DIST_NAME
get-linux-dist()
{
    if [ -e /etc/debian_version ] ||
       [ -e /etc/debian_release ]; then
       # Check Ubuntu or Debian
       if [ -e /etc/lsb-release ]; then
           # Ubuntu
           DIST_NAME="ubuntu"
       else
           # Debian
           DIST_NAME="debian"
       fi
    elif [ -e /etc/fedora-release ]; then
       # Fedra
       DIST_NAME="fedora"
    elif [ -e /etc/redhat-release ]; then
       # CentOS
       DIST_NAME="redhat"
    elif [ -e /etc/turbolinux-release ]; then
       # Turbolinux
       DIST_NAME="turbol"
    elif [ -e /etc/SuSE-release ]; then
       # SuSE Linux
       DIST_NAME="suse"
    elif [ -e /etc/mandriva-release ]; then
       # Mandriva Linux
       DIST_NAME="mandriva"
    elif [ -e /etc/vine-release ]; then
       # Vine Linux
       DIST_NAME="vine"
    elif [ -e /etc/gentoo-release ]; then
       # Gentoo Linux
       DIST_NAME="gentoo"
    else
       # Other
       echo "unkown distribution"
       DIST_NAME="unkown"
    fi

    echo ${DIST_NAME}
}


get-os-bits()
{
    OS_BITS=""
    if [ -x "`which uname`" ]; then
        OS_BITS=`uname -m`
    fi

    echo ${OS_BITS}
}


get-num-of-cpu-cores()
{
    OS=`get-os`
    if [ x${OS} = "xMac" ]; then
        NUM_OF_CPUS="sysctl hw.ncpu | awk '{print $2}'"
    else
        NUM_OF_CPUS="`grep processor /proc/cpuinfo | wc -l`"
    fi

    echo ${NUM_OF_CPUS}
}


os-info()
{
    OS_INFO=""

    OS=`get-os`
    OS_BITS=`get-os-bits`
    if [ x${OS} = xLinux ]; then
        LINUX_DIST_NAME=`get-linux-dist`
        OS_INFO="${LINUX_DIST_NAME} ${OS_BITS}"
    else
        OS_INFO="${LINUX_DIST_NAME} ${OS_BITS}"
    fi

    echo ${OS_INFO}
}


# MAIN
# init

