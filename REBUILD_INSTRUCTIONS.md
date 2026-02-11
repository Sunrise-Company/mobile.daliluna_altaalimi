# Rebuild Instructions - After MUX Error Fixes

## Quick Rebuild Steps

### Option 1: Clean Build (Recommended)
```bash
# Navigate to project root
cd /Users/mazen/Desktop/daliluna_altaalimi

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Rebuild iOS pods
cd ios
pod install --repo-update
cd ..

# Build for Android
flutter build apk

# Run on device (choose one)
flutter run -d android                    # Any connected device
flutter run                               # Auto-select device
```

### Option 2: Quick Rebuild (if no dependency changes)
```bash
cd /Users/mazen/Desktop/daliluna_altaalimi

# Rebuild the app
flutter build apk

# Or for iOS
flutter build ios
```

### Option 3: Hot Reload During Development
```bash
# Run the app in debug mode
flutter run

# Then press 'r' to hot reload (won't work for native code changes)
# Press 'R' for full restart
# Press 'q' to quit
```

## What Changed

### Dart Changes
- **File**: `lib/download_service.dart`
- **Changes**: 
  - Enhanced `_muxMp4()` method with file validation
  - Added try-catch-finally for proper error handling
  - Added fallback to single-stream download on mux failure
  - Detailed error messages and file size logging

### Kotlin Changes
- **File**: `android/app/src/main/kotlin/com/sunrise/daliluna_altaalimi/MainActivity.kt`
- **Changes**:
  - Added input file validation in `muxMp4()` method
  - Enhanced error handling with try-catch-finally
  - Added proper resource cleanup
  - Added detailed logging (Log.d, Log.e, Log.w)
  - Added sample count tracking

## Verification

After rebuilding, test the following:

### Test 1: Download with Separate Streams
1. Find a video with separate video+audio options
2. Start download
3. Check Android logcat for these messages:
```
D/MediaMuxer: Video: XX.XXMB, Audio: X.XXMB
D/MediaMuxer: Wrote XXXX samples to track 0
D/MediaMuxer: Wrote XXX samples to track 1
D/MediaMuxer: Muxing completed successfully
```

### Test 2: Simulate Mux Failure (Optional)
The fallback mechanism automatically tries muxed format if separate streams fail.

### Test 3: Check Error Logs
If muxing fails:
- Error logs will show specific reason (file not found, too small, etc.)
- Temporary files will be automatically cleaned up
- App will retry with different format

## Logcat Commands

```bash
# View all logs related to muxing
adb logcat | grep -i muxer

# View all app logs
adb logcat com.sunrise.daliluna_altaalimi:V

# Save logs to file for analysis
adb logcat > logcat_output.txt

# Clear logs
adb logcat -c
```

## Troubleshooting Build Issues

### Issue: Pod install fails
```bash
cd ios
rm -rf Pods
rm -rf Podfile.lock
pod install --repo-update
```

### Issue: Gradle build fails
```bash
cd android
./gradlew clean
./gradlew build --info
```

### Issue: Version mismatch
```bash
flutter upgrade
flutter pub get
cd ios && pod install && cd ..
```

## Performance Notes

The fixes include:
- ✅ File validation (prevents corrupted uploads)
- ✅ Better error messages (easier debugging)
- ✅ Automatic fallback (better UX)
- ✅ Proper resource cleanup (prevents memory leaks)
- ✅ Detailed logging (helps troubleshooting)

No performance degradation - validation is minimal compared to file I/O.
