# Keep Flutter plugins
-keep class io.flutter.** { *; }

# Regula Face SDK
-keep class com.regula.** { *; }
-dontwarn com.regula.**
-keep class io.flutter.plugins.flutter_face_api.** { *; }
-dontwarn io.flutter.plugins.flutter_face_api.**

# MLKit related
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.** { *; }

# Camera plugin
-keep class io.flutter.plugins.camera.** { *; }

# Untuk JSON serialization/deserialization
-keepattributes *Annotation*

# Optional: Gson & kotlinx.serialization (jika digunakan)
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**
-keep class kotlinx.serialization.** { *; }
-dontwarn kotlinx.serialization.**

# For reflection & native code (umum)
-keepclassmembers class * {
    *;
}
