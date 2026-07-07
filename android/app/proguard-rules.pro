# Add project specific ProGuard rules here.
# This ensures 16 KB page size compatibility

# Keep all native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Syncfusion PDF Viewer classes
-keep class com.syncfusion.** { *; }

# Keep all .so libraries
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Prevent obfuscation of native libraries
-keep class **.R$* {
    public static <fields>;
}

# For 16 KB page size support
-dontoptimize
-dontpreverify

# Keep flutter_local_notifications plugin classes from being obfuscated or stripped
-keep class com.dexterous.flutterlocalnotifications.** { *; }