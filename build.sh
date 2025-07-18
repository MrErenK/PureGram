#!/usr/bin/env bash

set -e

CMAKE_OSX_ARCHITECTURES="arm64e;arm64"
CMAKE_OSX_SYSROOT="iphoneos"

# Building modes
if [ "$1" == "sideload" ];
then

    # Clean build artifacts
    make clean
    rm -rf .theos

    # Check for decrypted instagram ipa
    ipaFile="$(find ./packages/*com.burbn.instagram*.ipa -type f -exec basename {} \;)"
    if [ -z "${ipaFile}" ]; then
        echo -e '\033[1m\033[0;31m./packages/com.burbn.instagram.ipa not found.\nPlease put a decrypted Instagram IPA in its path.\033[0m'
        exit 1
    fi

    echo -e '\033[1m\033[32mBuilding PureGram tweak for sideloading (as IPA)\033[0m'
    make "SIDELOAD=1"

    # Create IPA File
    echo -e '\033[1m\033[32mCreating the IPA file...\033[0m'
    rm -f packages/PureGram-sideloaded.ipa
    cyan -i "packages/${ipaFile}" -o packages/PureGram-sideloaded.ipa -f .theos/obj/debug/PureGram.dylib .theos/obj/debug/sideloadfix.dylib -c 0 -m 15.0 -du

    echo -e "\033[1m\033[32mDone, we hope you enjoy PureGram!\033[0m\n\nYou can find the ipa file at: $(pwd)/packages"

elif [ "$1" == "rootless" ];
then

    # Clean build artifacts
    make clean
    rm -rf .theos

    echo -e '\033[1m\033[32mBuilding PureGram tweak for rootless\033[0m'

    export THEOS_PACKAGE_SCHEME=rootless
    make package

    echo -e "\033[1m\033[32mDone, we hope you enjoy PureGram!\033[0m\n\nYou can find the deb file at: $(pwd)/packages"

elif [ "$1" == "rootful" ];
then

    # Clean build artifacts
    make clean
    rm -rf .theos

    echo -e '\033[1m\033[32mBuilding PureGram tweak for rootful\033[0m'

    unset THEOS_PACKAGE_SCHEME
    make package

    echo -e "\033[1m\033[32mDone, we hope you enjoy PureGram!\033[0m\n\nYou can find the deb file at: $(pwd)/packages"

else
    echo '+--------------------+'
    echo '|PureGram Build Script|'
    echo '+--------------------+'
    echo
    echo 'Usage: ./build.sh <sideload/rootless/rootful>'
    exit 1
fi
