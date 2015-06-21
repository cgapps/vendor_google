#!/bin/bash
# (c) Joey Rizzoli, 2015
# Released under GPL v2 License

##
# var
#
DATE=$(date +%F-%H-%M)
TOP=$(realpath .)
ANDROIDV=5.1
OUT=$TOP/out
BUILD=$TOP/build
METAINF=$BUILD/meta
COMMON=$TOP/prebuilt/gapps/common

##
# functions
#
function printerr(){
  echo "$(tput setaf 1)$1$(tput sgr 0)"
}

function printdone(){
  echo "$(tput setaf 2)$1$(tput sgr 0)"
}

function create(){
    PREBUILT=$TOP/prebuilt/gapps/$GARCH
    if [ -d $OUT/$GARCH ]; then
        echo "Previous build found for $GARCH!"
        return 1
    else
        echo "No previous build found for $GARCH!"
        mkdir $OUT
        mkdir $OUT/$GARCH
    fi
    echo "Getting prebuilts..."
    cp -r $PREBUILT $OUT/$GARCH
    mv $OUT/$GARCH/$GARCH $OUT/$GARCH/arch
    cp -r $COMMON $OUT/$GARCH
    return 0
}

function zipit(){
    BUILDZIP=gapps-$ANDROIDV-$DATE.zip
    echo "Importing installation scripts..."
    cp -r $METAINF $OUT/$GARCH/META-INF
    echo "Creating package..."
    cd $OUT/$GARCH
    zip -r /tmp/$BUILDZIP . &>/dev/null
    rm -rf $OUT/tmp
    cd $TOP
    if [ -f /tmp/$BUILDZIP ]; then
        echo "Signing zip..."
        java -Xmx2048m -jar $TOP/build/sign/signapk.jar -w $TOP/build/sign/testkey.x509.pem $TOP/build/sign/testkey.pk8 /tmp/$BUILDZIP $OUT/$GARCH/$BUILDZIP
	if [ -x $(which md5sum) ]; then
            echo "Creating md5sum..."
            md5sum $OUT/$GARCH/$BUILDZIP >$OUT/$GARCH/$BUILDZIP.md5sum
        fi
    else
        printerr "Couldn't zip files!"
        return 1
    fi
    if [ "$?" == 0 ]; then
        return 0
    else
        return 1
    fi
}


##
# main
#
GARCH=$1
create
LASTRETURN=$?
if [ "$LASTRETURN" == 0 ]; then
    zipit
    LASTRETURN=$?
    if [ "$LASTRETURN" == 0 ]; then
        printdone "Build completed: $OUT/$GARCH/$BUILDZIP"
        exit 0
    else
        printerr "Build failed, check /tmp/gapps_log"
        exit 1
    fi
else
    exit 1
fi
