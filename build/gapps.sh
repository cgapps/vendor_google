#!/bin/bash
# (c) Joey Rizzoli, 2015
# Released under GPL v2 License

##
# var
#
DATE=$(date +%F-%H-%M-%S)
TOP=$(realpath .)
ANDROIDV=5.1
BUILDZIP=gapps-$ANDROIDV-$DATE.zip
OUT=$TOP/out
TARGETZIP=$OUT/target-zip
METAINF=$TOP/build/meta
PREBUILTGAPPS=$TOP/prebuilt/gapps


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
    if [ -d $PREBUILTGAPPS ]; then
        if [ -d $OUT ]; then
            echo "Previous build found"
        else
            echo "No previous build found"
            mkdir $OUT
            mkdir $TARGETZIP
            mkdir $TARGETZIP/tmp
        fi
        echo "Getting prebuilts..."
        cp -r $PREBUILTGAPPS $TARGETZIP/gapps
        return 0
    else
        printerr "Couldn't find prebuilts, sync again"
        return 1
    fi
}

function zipit(){
    if [ "$LASTRETURN" == 0 ]; then
        echo "Importing installation scripts..."
        cp -r $TARGETZIP/gapps $TARGETZIP/tmp/system
        cp -r $METAINF $TARGETZIP/tmp/META-INF
        echo "Creating package..."
        cd $TARGETZIP/tmp
        zip -r /tmp/$BUILDZIP . &>/dev/null
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
