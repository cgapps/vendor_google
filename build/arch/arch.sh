#!/sbin/sh
ARCH=$(grep ro.product.cpu.abi= /system/build.prop | cut -d "=" -f 2)
CGAPPS=/tmp/cgapps
GARM=$CGAPPS/arm
GARM64=$CGAPPS/arm64
GX86=$CGAPPS/x86

if [ $ARCH == armeabi-v7a ]; then # arm
    cp -r $GARM/app/FaceLock /system/app/FaceLock
    cp -r $GARM/priv-app/PrebuiltGmsCore /system/priv-app/PrebuiltGmsCore
    cp -r $GARM/priv-app/Velvet /system/priv-app/Velvet
    cp -r $GARM/lib /system/lib
elif [ $ARCH == arm64-v8a ]; then # arm64
    cp -r $GARM64/app/FaceLock /system/app/FaceLock
    cp -r $GARM64/priv-app/PrebuiltGmsCore /system/priv-app/PrebuiltGmsCore
    cp -r $GARM64/priv-app/Velvet /system/priv-app/Velvet
    if [ $(grep ro.product.device= /system/build.prop | cut -d "=" -f 2) == "flounder" ]; then
        cp -r $GARM64/priv-app/HotWord /system/priv-app/HotWord
    fi
    cp -r $GARM64/lib /system/lib
    cp -r $GARM64/lib64 /system/lib64
    cp -r $GARM64/addon.d /system/addon.d
elif [ $ARCH == x86 ]; then # x86
    cp -r $X86/priv-app/PrebuiltGmsCore /system/priv-app/PrebuiltGmsCore
    cp -r $x86/priv-app/Velvet /system/priv-app/Velvet
else # flashing on microwave
    echo "Couldn't get info, empty system??"
fi
