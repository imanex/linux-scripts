#!/bin/bash
function aptQuery () {
    if [[ ! $1 ]; then
        printf "`tput setaf 4`error:`tput op` first argument must be a package string.\n"
    else
        while read -r line; do
            test=$(echo $line | grep "ubuntu")
            if [[ $test ]]; then
                printf "Package \e[90m\"`tput setaf 4`${var2}`tput op`\e[90m\"\e[0m is already installed \e[90m[\e[37mVer\e[0m: ${var1}\e[90m]\e[0m.\n"
            else
                printf "$line\n"
            fi
        done < <(apt-cache search $@)
    fi
}
aptQuery $@
