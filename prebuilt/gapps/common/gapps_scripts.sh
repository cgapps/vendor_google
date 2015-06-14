#!/sbin/sh

good_ffc_device() {
  if cat /proc/cpuinfo |grep -q Victory; then
    return 1
  fi
  if cat /proc/cpuinfo |grep -q herring; then
    return 1
  fi
  if cat /proc/cpuinfo |grep -q sun4i; then
    return 1
  fi
  return 0
}

chmod 755 /system/addon.d/30-gapps.sh
if [ -f "/system/addon.d/faceunlock.sh" ]; then
    chmod 755 /system/addon.d/31-faceunlock.sh
fi
if good_ffc_device && [ -e /system/etc/permissions/android.hardware.camera.front.xml ]; then
  chmod 755 /system/addon.d/31-faceunlock.sh
elif  [ -d /system/vendor/pittpatt/ ]; then
  rm -rf /system/vendor/pittpatt/
  rm -rf /system/app/FaceLock/
  rm  -f /system/lib/libfacelock_jni.so
  rm  -f /system/addon.d/31-faceunlock.sh
fi
rm -rf /tmp/face
