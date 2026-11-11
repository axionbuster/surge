# Building Surge XT for iPad and iPhone

The iOS build contains the Surge XT standalone instrument and an embedded AUv3
instrument extension. The same arm64 app targets iPad and iPhone. It requires
Xcode, its iOS SDK, CMake 3.22 or newer, and the repository's recursive submodules.
The minimum iOS version is 16.0.

```sh
git submodule update --init --recursive
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
cmake -S . -B build/ios -G Xcode \
  -DCMAKE_SYSTEM_NAME=iOS \
  -DCMAKE_OSX_SYSROOT=iphoneos \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DSURGE_BUILD_TESTRUNNER=OFF
```

iOS selects the Standalone and AUv3 formats, omits desktop plug-in formats and the
desktop CLI, and uses the bundled PUC-Rio Lua interpreter for Formula Modulator
and Wavetable Script. Desktop MTS-ESP service discovery is disabled. The factory
patches, wavetables, skins, and other content are bundled with both executables;
the extension resolves its own bundle rather than the host app's resources.
User content and settings use each executable's sandbox.

For a device build, use an Apple development account configured in Xcode. Keep
the development team and any account-specific bundle identifier in local shell
variables or the ignored `CMakeUserPresets.json` file:

```sh
cmake -S . -B build/ios \
  -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGN_STYLE=Automatic \
  -DCMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY="Apple Development" \
  -DCMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM="$SURGE_DEVELOPMENT_TEAM" \
  -DSURGE_XT_BUNDLE_ID="$SURGE_BUNDLE_ID"
cmake --build build/ios --config Release --target surge-xt_Standalone -- \
  -allowProvisioningUpdates
```

The containing app is produced at
`build/ios/src/surge-xt/surge-xt_artefacts/Release/Standalone/Surge XT.app`.
Install the whole app so iOS can register its embedded AUv3. Do not install or
copy the extension separately. After installing, select Surge XT as an Audio Unit
instrument in the host's instrument browser. Hosting and audio playback must be
verified on each intended device and host app.

For an unsigned compile check, add
`-DCMAKE_XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED=NO` to configuration and omit
`-allowProvisioningUpdates` from the build. An unsigned app cannot be installed
on a physical device. Use a separate build directory with
`-DCMAKE_OSX_SYSROOT=iphonesimulator` for simulator builds.

The initial iOS interface uses the existing Surge XT editor and scales it to fit
the host's view. iPhone standalone uses landscape orientation. A compact touch
editor and shared app-group storage are separate follow-up work.
