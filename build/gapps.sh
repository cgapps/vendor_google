#!/bin/bash
# (c) Joey Rizzoli, 2015
# Released under GPL v2 License

##
# var
#
DATE=$(date +%F-%H-%M-%S)
TOP=$(realpath .)
ANDROIDV=5.1
OUT=$TOP/out
BUILD=$TOP/build
METAINF=$BUILD/meta

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
        echo "Previous build found for $GARCH"
    else
        echo "No previous build found for $GARCH"
        mkdir $OUT
        TARGET=$OUT/$GARCH
        mkdir $TARGET
        mkdir $TARGET/tmp
    fi
    echo "Getting prebuilts..."
    cp -r $PREBUILT $TARGET/gapps
    return $?
}

function zipit(){
    if [ "$LASTRETURN" == 0 ]; then
        BUILDZIP=gapps-$ANDROIDV-$GARCH-$DATE.zip
        echo "Importing installation scripts..."
        cp -r $TARGET/gapps $TARGET/tmp/system
        cp -r $METAINF $TARGET/tmp/META-INF
        echo "Creating package..."
        cd $TARGET/tmp
        zip -r /tmp/$BUILDZIP . &>/dev/null
        rm -rf $TARGET/tmp
        cd $TOP
        if [ -f /tmp/$BUILDZIP ]; then
            echo "Signing zip..."
            java -Xmx2048m -jar $TOP/build/sign/signapk.jar -w $TOP/build/sign/testkey.x509.pem $TOP/build/sign/testkey.pk8 /tmp/$BUILDZIP $OUT/$BUILDZIP
        else
            printerr "Couldn't zip files!"
            return 1
        fi
        if [ "$?" == 0 ]; then
            return 0
        else
            return 1
        fi
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
zipit
LASTRETURN=$?
if [ "$LASTRETURN" == 0 ]; then
    printdone "Build completed: $OUT/$BUILDZIP"
    exit 0
else
    printerr "Build failed, check /tmp/gapps_log"
    exit 1
fi
