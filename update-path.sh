#!/bin/bash

has_path()
{
    CHK_PATH=${1}
    CHK_PATH=${CHK_PATH%/}
    
    if [ x${CHK_PATH} != x ]; then
        count=1
        while :
        do
            dir=`echo "${PATH}" | cut -d ':' -f ${count}`
            if [ x${dir} = x ]; then
                break
            fi

            dir=${dir%/}

            echo "${dir} ?? ${CHK_PATH}"
            if [ x${dir} = x${CHK_PATH} ]; then
                echo "yes"
            fi
            
            count=$((${count} + 1))
        done
    fi

    echo "no"
}


update_path()
{
    CHK_PATH=${1}
    if [ x`has_path "${CHK_PATH}"` != xyes ]; then
        PATH="${CHK_PATH}:${PATH}"
    fi    
}

 
