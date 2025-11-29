# Keep Flutter engine
-keep class io.flutter.** { *; }

# Keep Firebase / Play Services
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Firestore serialization
-keep class com.google.protobuf.** { *; }
-keep class com.google.firestore.** { *; }

# Keep annotations used by reflection
-keepattributes *Annotation*

# Keep Play Core SplitInstall / SplitCompat classes used by Flutter
-keep class com.google.android.play.core.** { *; }

# Prevent removing constructors used by JSON frameworks
-keepclassmembers class * {
    public <init>(...);
}
