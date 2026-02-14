# Quick Test Guide - iOS Background Download Notifications

## 🚀 Quick Start

### 1. Build and Run on iOS
```bash
cd /Users/mazen/Desktop/daliluna_altaalimi
flutter run -d <ios-device-or-simulator>
```

### 2. Grant Notification Permissions
- When the app launches, a permission dialog will appear
- **Tap "Allow"** to enable notifications

### 3. Test Download with Notifications
1. Open the app
2. Navigate to any video lecture
3. **Start downloading a video**
4. **Press Home button** to minimize the app
5. **Watch for notifications:**
   - Progress notifications during download
   - Completion notification with sound when finished

## ✅ What to Expect

### During Download (App in Background)
- Silent progress notifications every few seconds
- Shows percentage: "جاري التحميل... 45%"
- No sound (to avoid disturbance)

### On Completion
- Notification with sound and alert
- Shows: "اكتمل التحميل ✓"
- Message: "تم تحميل الفيديو بنجاح"

### On Failure
- Notification with alert
- Shows: "فشل التحميل ✗"
- Message: "حدث خطأ أثناء التحميل"

## 🔍 Verify Notifications

### Check iOS Settings
1. **Settings** > **Notifications** > **دليلنا التعليمي**
2. Verify settings:
   - ✅ Allow Notifications: **ON**
   - ✅ Sounds: **ON**
   - ✅ Badges: **ON**
   - ✅ Banner Style: **Temporary** or **Persistent**

### Check Notification Center
- Swipe down from top of screen
- Look for download progress/completion notifications

## 🐛 Troubleshooting

### Problem: No notifications appear

**Solution 1: Check Permissions**
```dart
// Add to main.dart temporarily for debugging:
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final plugin = FlutterLocalNotificationsPlugin();
final settings = await plugin
    .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
    ?.getNotificationSettings();
print("📱 iOS Notification Settings: $settings");
```

**Solution 2: Reset App**
1. Delete app from device
2. Clean build: `flutter clean`
3. Rebuild: `flutter run`
4. Grant permissions when asked

**Solution 3: Check iOS Settings**
- Ensure "Allow Notifications" is ON in iOS Settings

### Problem: Notifications appear but no sound

**Check:**
1. Device is not in Silent Mode (check side switch)
2. Notification sounds are enabled in Settings
3. App notification sound permission is granted

### Problem: Download completes but app doesn't show it

**This is normal for background service:**
- Notification will appear in Notification Center
- Tap notification to open app and see downloaded video

## 📊 Debug Logs

Monitor these logs in Xcode or terminal:

```
✅ Good Signs:
- "iOS notification permissions granted: true"
- "جاري التحميل... 25%"
- "جاري التحميل... 50%"
- "اكتمل التحميل!"

❌ Problem Signs:
- "iOS notification permissions granted: false"
- No progress logs
- Any error messages
```

## 🎯 Test Checklist

- [ ] App requests notification permissions on first launch
- [ ] Permissions granted in iOS Settings
- [ ] Download starts successfully
- [ ] App can be minimized during download
- [ ] Progress notifications appear in Notification Center
- [ ] Completion notification appears with sound
- [ ] Can tap notification to return to app
- [ ] Downloaded video is playable

## 📝 Notes

- **Small videos** (< 50MB): Download completes quickly
- **Large videos** (> 100MB): May take several minutes
- **Background limits**: iOS limits background tasks to ~30 seconds at a time
- **For very large files**: Download in foreground or use native URLSession

## 🎉 Success Criteria

✅ **Notifications are working if you see:**
1. Permission dialog on first launch
2. Progress updates in Notification Center
3. Completion notification with sound
4. Downloaded video available in app
