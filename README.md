# vendor_google

**GApps for android devices**


Information
------------------

These are Google Apps for who want to install Google Packages on a custom rom.
Remember Apks and Jars files are prebuilt from Google.
All closed source files come from Nexuses' factory images.
This contains just the core files needed to setup a fully working Google account,
users will choose wich apps they want on their devices.
GApps contain a "quite old" universal Play Service, so the Play Store will download the proper one
for your device asap.
These GApps get monthly updates, fell free to fork and contribute to this, but remember,
**Opensource does not mean out-of-respect**. Also **NO MIRRORS ALLOWED**


Downloads
------------------

https://github.com/linuxxxxx/vendor_google/releases


Links
------------------
[Google +](https://google.com/+CgappsGithubIo0)
[Community](https://plus.google.com/u/0/b/104503298104020811639/communities/114625799842477562713)
[Website](cgapps.github.io)


Build
-------------------

You can compile your GApps package with GNU make

_make distclean_
- Remove output directory

_make gapps_
- compile signed flashable GApps for arm

_make gapps_arm64_
- compile signed flashable GApps for arm64

_make gapps_x86_
- compila signed flashable GApps for x86 (NOT supported atm)
