# Keep Flutter plugins
-keep class io.flutter.** { *; }

# MLKit related
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.** { *; }

# Camera plugin
-keep class io.flutter.plugins.camera.** { *; }

# For reflection
-keepclassmembers class * {
    *;
}