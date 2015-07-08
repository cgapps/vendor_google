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
GLOG=/tmp/gapps_log

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
    if [ -f $GLOG ]; then
        rm -f $GLOG
    fi
    echo "Starting GApps compilation" > $GLOG
    echo "ARCH= $GARCH" >> $GLOG
    echo "OS= $(uname -s -r)" >> $GLOG
    echo "NAME= $(whoami) at $(uname -n)" >> $GLOG
    PREBUILT=$TOP/prebuilt/gapps/$GARCH
    if [ -d $OUT/$GARCH ]; then
        echo "Previous build found for $GARCH!" >> $GLOG
    else
        echo "No previous build found for $GARCH!" >> $GLOG
        if [ -d $OUT ]; then
            echo "OUT directory detected at: $OUT" >> $GLOG
        else
            mkdir $OUT
        fi
        mkdir $OUT/$GARCH && echo "Created build directories" >> $GLOG
    fi
    echo "Getting prebuilts..."
    echo "Copying stuffs" >> $GLOG
    cp -r $PREBUILT $OUT/$GARCH >> $GLOG
    mv $OUT/$GARCH/$GARCH $OUT/$GARCH/arch >> $GLOG
    cp -r $COMMON $OUT/$GARCH >> $GLOG
}

function zipit(){
    BUILDZIP=gapps-$ANDROIDV-$GARCH-$DATE.zip
    echo "Importing installation scripts..."
    cp -r $METAINF $OUT/$GARCH/META-INF && echo "Meta copied" >> $GLOG
    echo "Creating package..."
    cd $OUT/$GARCH
    zip -r /tmp/$BUILDZIP . >> $GLOG
    rm -rf $OUT/tmp >> $GLOG
    cd $TOP
    if [ -f /tmp/$BUILDZIP ]; then
        echo "Signing zip..."
        java -Xmx2048m -jar $TOP/build/sign/signapk.jar -w $TOP/build/sign/testkey.x509.pem $TOP/build/sign/testkey.pk8 /tmp/$BUILDZIP $OUT/$GARCH/$BUILDZIP >> $GLOG
    else
        printerr "Couldn't zip files!"
        echo "Couldn't find unsigned zip file, aborting" >> $GLOG
        return 1
    fi
}

function getmd5(){
    if [ -x $(which md5sum) ]; then
        echo "md5sum is installed, getting md5..." >> $GLOG
        echo "Getting md5sum..."
        GMD5=$(md5sum $OUT/$GARCH/$BUILDZIP)
        return 0
    else
        echo "md5sum is not installed, aborting" >> $GLOG
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
        getmd5
        LASTRETURN=$?
        if [ "$LASTRETURN" == 0 ]; then
            echo "Done!" >> $GLOG
            printdone "Build completed: $OUT/$GARCH/$BUILDZIP"
            printdone "            md5: $GMD5"
            exit 0
        else
            printerr "Build failed, check $GLOG"
            exit 1
        fi
    else
        printerr "Build failed, check $GLOG"
        exit 1
    fi
else
    printerr "Build failed, check $GLOG"
    exit 1
fi
