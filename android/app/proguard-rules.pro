# Flutter & embedding
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-keepattributes *Annotation*

# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }
# Nếu vẫn crash liên quan GMA nội bộ, nới rộng:
# -keep class com.google.android.gms.internal.ads.** { *; }

# (nếu dùng Gson trong plugin)
-keep class com.google.gson.** { *; }
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory

# (nếu plugin dùng OkHttp/Okio)
-dontwarn okhttp3.**
-dontwarn okio.**
