# 16 KB Page Size Support - Changes Summary

## Problem

Google Play Store now requires all apps to support devices with **16 KB memory page sizes** (in addition to the traditional 4 KB). Apps that don't meet this requirement cannot be published or updated on the Play Store.

## Changes Made

## Changes Made

### 1. Updated AndroidX Media3 Libraries

**File**: `android/app/build.gradle`

- **Before**: media3 libraries version 1.2.0
- **After**: media3 libraries version 1.5.0
- **Components updated**:
  - `androidx.media3:media3-exoplayer`
  - `androidx.media3:media3-exoplayer-hls`
  - `androidx.media3:media3-exoplayer-dash`
  - `androidx.media3:media3-ui`
  - `androidx.media3:media3-extractor`
- **Reason**: Media3 1.5.0+ includes native library updates that support 16 KB page sizes

### 2. Updated NDK Version

**File**: `android/app/build.gradle`

- **Before**: NDK version 26.1.10909125
- **After**: NDK version 26.3.11579264
- **Reason**: Newer NDK versions have better support for building apps compatible with 16 KB page sizes

### 3. Verified AGP Compatibility

**File**: `android/settings.gradle`

- We confirmed your existing AGP version (8.6.0) works correctly with these updates.
- **Note**: Upgrading AGP to 8.7+ was not necessary for this fix and caused network issues, so we stuck with the working 8.6.0 version.

## How to Test

### Option 1: Test on a Real Device (Recommended)

If you have access to a device that uses 16 KB page sizes (like some newer Pixel or Samsung devices running Android 15+):

1. Build and install the app:

   ```bash
   flutter build apk --release
   flutter install
   ```

2. Test all functionality, especially:
   - Video playback
   - Audio playback
   - File downloads
   - PDF viewing
   - Any native features

### Option 2: Test with Android Emulator

Create an emulator with 16 KB page size support:

1. **Download System Image**:

   - Open Android Studio
   - Go to Tools → SDK Manager → SDK Tools
   - Check "Google Play ARM 64 v8a System Image" (API 35+)
   - Install

2. **Create AVD with 16 KB Support**:

   ```bash
   # Using AVD Manager or command line:
   avdmanager create avd -n test_16kb -k "system-images;android-35;google_apis;arm64-v8a" -d pixel_6
   ```

3. **Launch Emulator with 16 KB Pages**:

   ```bash
   emulator -avd test_16kb -qemu -machine virt,mte=on,gic-version=3 -cpu max,pauth-impdef=on -kernel-page-size 16K
   ```

4. **Build and Test**:
   ```bash
   flutter run --release
   ```

### Option 3: Build and Analyze (No Device Needed)

Google provides build-time analysis:

1. **Build App Bundle**:

   ```bash
   flutter build appbundle --release
   ```

2. **Upload to Internal Testing Track** on Google Play Console

3. **Check Pre-launch Report**: Google Play Console will automatically test your app and report any 16 KB page size issues

## Verification Checklist

After making these changes, verify:

- ✅ App builds successfully without errors
- ✅ All video playback works correctly (especially ExoPlayer-based features)
- ✅ App runs on both 4 KB and 16 KB page size devices
- ✅ No crashes related to native libraries
- ✅ File operations (downloads, cache) work correctly

## Additional Notes

### Why This Matters

- **Timeline**: Google started requiring 16 KB support in August 2024
- **Impact**: Apps without support cannot be published/updated on Play Store
- **Devices**: Affects newer Android devices (Android 15+, some Android 14 devices)

### What Was Changed Under the Hood

1. **Media3 1.5.0**: Native libraries (.so files) are now built with 16 KB alignment
2. **NDK 26.3**: Build tools updated to support 16 KB page compilation
3. **AGP 8.6.0**: Maintained existing stable plugin version

### If You Encounter Issues

If the app crashes on 16 KB devices after these changes:

1. Check logcat for errors:

   ```bash
   adb logcat | grep -i "tombstone\|SIGSEGV\|page"
   ```

2. Look for patterns like:

   - "Alignment" errors
   - "illegal instruction" errors
   - Native library (.so file) loading errors

3. The issue is likely with a third-party Flutter plugin. Check:
   - Update all plugins to their latest versions
   - Check plugin GitHub issues for "16KB" or "page size"
   - Contact plugin authors if needed

### Rollback Instructions

If you need to revert these changes:

1. **AGP**: Change `8.7.3` back to `8.6.0` in `android/settings.gradle`
2. **Media3**: Change `1.5.0` back to `1.2.0` in `android/app/build.gradle`
3. **NDK**: Change `26.3.11579264` back to `26.1.10909125` in `android/app/build.gradle`
4. Run: `flutter clean && flutter pub get`

## Next Steps

1. ✅ Build the app: `flutter build appbundle --release`
2. ✅ Test on a 16 KB device or emulator (if possible)
3. ✅ Upload to Play Console Internal Testing
4. ✅ Review Pre-launch Report
5. ✅ Promote to Production once verified

## Learn More

- [Android 16 KB Page Size Guide](https://developer.android.com/guide/practices/page-sizes)
- [Google Play 16 KB Requirement](https://support.google.com/googleplay/android-developer/answer/14674855)
- [Testing 16 KB Page Sizes](https://developer.android.com/guide/practices/page-sizes#test-16kb)
