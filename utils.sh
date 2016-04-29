#!/bin/bash

# initialize
# see p.14
set -u
umask 0022
PATH='/usr/bin:/bin'
IFS=$(printf ' \t\n_'); IFS=${IFS%_}
export IFS LC_ALL=C LANG=C PATH

# HOW TO USE
# 
# 1. source utils.sh
# 2. followinf variables are set:
#    OS_INFO, OS, OS_BITS, DIST_NAME


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
}


get-os-bits()
{
    OS_BITS=""
    if [ -x "`which uname`" ]; then
        OS_BITS=`uname -m`
    fi
}


os-info()
{
    OS_INFO=""

    get-os
    get-os-bits
    if [ ${OS} = "Linux" ]; then
        get-linux-dist
        OS_INFO="${DIST_NAME} ${OS_BITS}"
    else
        OS_INFO="${OS} ${OS_BITS}"
    fi
}


# MAIN
os-info


