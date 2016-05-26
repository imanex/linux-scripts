#!/bin/bash
function aptInstall () {
    if [[ ! $1 ]]; then
        printf "`tput setaf 4`Error:`tput op` Package string not provided.\n"
    else
        while read -r line; do
            case $line in
                *...*) echo $line ;;
                *ubuntu*)
                    verStr=$(echo $line | sed "s/.*(\(.*\))./`tput setaf 4`\1`tput op`/g")
                    nameStr=$(echo -e $line | awk '{ print $1 }')
                    printf "Package \e[90m\"`tput setaf 4`${nameStr}`tput op`\e[90m\"\e[0m is already installed \e[90m[\e[37mVer\e[0m: ${verStr}\e[90m]\e[0m.\n" ;;
                *upgrade*) echo $line ;;
            esac
        done < <(apt-get install $@)
    fi
}
aptInstall $@
