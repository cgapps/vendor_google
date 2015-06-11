#!/sbin/sh
#
# /system/addon.d/70-gapps.sh
#
. /tmp/backuptool.functions

list_files() {
cat <<EOF
addon.d/30-gapps.sh
app/GoogleCalendarSyncAdapter/GoogleCalendarSyncAdapter.apk
app/GoogleContactsSyncAdapter/GoogleContactsSyncAdapter.apk
etc/permissions/com.google.android.camera2.xml
etc/permissions/com.google.android.maps.xml
etc/permissions/com.google.android.media.effects.xml
etc/permissions/com.google.widevine.software.drm.xml
etc/permissions/features.xml
framework/com.google.camera2.jar
framework/com.google.android.maps.jar
framework/com.google.android.media.effects.jar
framework/com.google.widevine.software.drm.jar
lib/libfilterpack_facedetect.so
lib/libgoogle_hotword_jni.so
lib/libgoogle_recognizer_jni_l.so
lib/libjni_latinimegoogle.so
priv-app/GoogleBackupTransport/GoogleBackupTransport.apk
priv-app/GoogleFeedback/GoogleFeedback.apk
priv-app/GoogleLoginService/GoogleLoginService.apk
priv-app/GoogleOneTimeInitializer/GoogleOneTimeInitializer.apk
priv-app/GooglePartnerSetup/GooglePartnerSetup.apk
priv-app/GoogleServicesFramework/GoogleServicesFramework.apk
priv-app/Phonesky/Phonesky.apk
priv-app/PrebuiltGmsCore/PrebuiltGmsCore.apk
priv-app/PrebuiltGmsCore/lib/x86/libAppDataSearch.so
priv-app/PrebuiltGmsCore/lib/x86/libconscrypt_gmscore_jni.so
priv-app/PrebuiltGmsCore/lib/x86/libgames_rtmp_jni.so
priv-app/PrebuiltGmsCore/lib/x86/libgcastv2_base.so
priv-app/PrebuiltGmsCore/lib/x86/libgcastv2_support.so
priv-app/PrebuiltGmsCore/lib/x86/libgmscore.so
priv-app/PrebuiltGmsCore/lib/x86/libgms-ocrclient.so
priv-app/PrebuiltGmsCore/lib/x86/libjgcastservice.so
priv-app/PrebuiltGmsCore/lib/x86/libsslwrapper_jni.so
priv-app/PrebuiltGmsCore/lib/x86/libWhisper.so
priv-app/SetupWizardSetupWizard.apk app/Provision/Provision.apk
priv-app/Velvet/Velvet.apk app/QuickSearchBox/QuickSearchBox.apk
priv-app/Velvet/lib/x86/libgoogle_hotword_jni.so
priv-app/Velvet/lib/x86/libgoogle_recognizer_jni_l.so
priv-app/Velvet/lib/x86/libvcdecoder_jni.so
EOF
}

case "$1" in
  backup)
    list_files | while read FILE DUMMY; do
      backup_file $S/$FILE
    done
  ;;
  restore)
    list_files | while read FILE REPLACEMENT; do
      R=""
      [ -n "$REPLACEMENT" ] && R="$S/$REPLACEMENT"
      [ -f "$C/$S/$FILE" ] && restore_file $S/$FILE $R
    done
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    # Stub
  ;;
esac
