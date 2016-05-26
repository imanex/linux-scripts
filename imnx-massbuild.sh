#!/bin/bash
#=================================================================================#

curDir="$PWD"
count="0"
CFLAGS="-march=haswell -mmmx -mno-3dnow -msse -msse2 -msse3 -mssse3 -mno-sse4a -mcx16 -msahf -mmovbe -maes -mno-sha -mpclmul -mpopcnt -mabm -mno-lwp -$
CXXFLAGS="-march=haswell -mmmx -mno-3dnow -msse -msse2 -msse3 -mssse3 -mno-sse4a -mcx16 -msahf -mmovbe -maes -mno-sha -mpclmul -mpopcnt -mabm -mno-lwp$
CC="gcc-5"
CXX="g++-5"
AR="ar"
LD="ld"

#=================================================================================#

function extractTars () {
    count="0"
    for thecount in `ls *.tar* -1 | sort -u`; do
        count=$((count+1))
    done
    for all in `ls *.tar* -1 | sort -u`; do
        printf "\ntotal files remaining to extract... : $count\n"
        printf "\n\e[96mExtracting \"$all\"...\e[0m\n"
        sleep 1
        tar xvf $all
        printf "\e[96mDone extracting \"$all\".\e[0m\n"
        sleep 1
        count=$((count-1))
    done
}

function configFolders () {
    count="0"
    for thecount in `find "${PWD}/" -maxdepth 1 -type d | sort -u`; do
        count=$((count+1))
    done
    skiptrigger="0"
    for all in `find "${PWD}/" -maxdepth 1 -type d | sort -u`; do
        if [[ $skiptrigger == "1" ]]; then
            printf "\nTotal configurations remaining: $count.\n"
            # skip the first listing, and continue.
            printf "\n\e[96mConfiguring \"$all\"...\e[0m\n"
            cd $all && sleep 1

        	# do this inside each folder.
            if [[ -e "./configure" ]]; then
    	    	./configure --prefix=/usr --enable-shared
    	    else
    	    	if [[ -e "./autogen.sh" ]]; then
		    	./autogen.sh --prefix=/usr
			    ./configure --prefix=/usr --enable-shared
		    fi
	    fi
        cd .. && sleep 1 && count=$((count-1))
        printf "\e[96mDone configuring \"$all\".\e[0m\n"
    else
        skiptrigger="1"
        count=$((count-1))
    fi
done
}

function makeFolders () {
    count="0"
    for thecount in `find "${PWD}/" -maxdepth 1 -type d | sort -u`; do
        count=$((count+1))
    done

    count=$((count-1))

    skiptrigger="0"
    for all in `find "${PWD}/" -maxdepth 1 -type d | sort -u`; do
        if [[ $skiptrigger == "1" ]]; then
            printf "\nTotal builds remaining: $count.\n"
            # skip the first listing, and continue.
            printf "\n\e[96mBuilding \"$all\"...\e[0m\n"
            cd $all && sleep 1
            make
            cd .. && sleep 1 && count=$((count-1))
            printf "\e[96mDone building \"$all\".\e[0m\n"
        else
            skiptrigger="1"
            count=$((count-1))
        fi
    done
}

function installFolders () {
    count="0"
    for thecount in `find "${PWD}/" -maxdepth 1 -type d | sort -u`; do
        count=$((count+1))
    done

    count=$((count-1))

    skiptrigger="0"
    for all in `find "${PWD}/" -maxdepth 1 -type d | sort -u`; do
        if [[ $skiptrigger == "1" ]]; then
            printf "\nTotal installations remaining: $count.\n"
            # skip the first listing, and continue.
            printf "\n\e[96mInstalling \"$all\"...\e[0m\n"
            cd $all && sleep 1
            make install
            cd .. && sleep 1 && count=$((count-1))
            printf "\e[96mDone installing \"$all\".\e[0m\n"
        else
            skiptrigger="1"
            count=$((count-1))
        fi
    done
}

printf "\n\e[96mDONE INSTALLING!\e[0m\n\n"
sleep 1
printf "\e[92m\n====================================================================================\n"
printf " first phase: extraction."
printf "\n====================================================================================\n\e[0m"
sleep 2
extractTars
printf "\e[92m\n====================================================================================\n"
printf " first phase: configuration."
printf "\n====================================================================================\n\e[0m"
sleep 2
configFolders
printf "\e[92m\n====================================================================================\n"
printf " first phase: building."
printf "\n====================================================================================\e[0m\n"
sleep 2
makeFolders
printf "\e[92m\n====================================================================================\n"
printf " first phase: installation."
printf "\n====================================================================================\n\e[0m"
sleep 2
installFolders
printf "\n\e[96mCLEANING UP...\e[0m\n"
sleep 1
for folder in `find * -maxdepth 0 -type d`; do rm "${folder}/" -r; done
printf "\n\e[96mDONE INSTALLING!\e[0m\n"
sleep 2
