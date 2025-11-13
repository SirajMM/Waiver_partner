# Keep Jackson-related classes
-keep class com.fasterxml.jackson.** { *; }
-dontwarn com.fasterxml.jackson.**

# Keep Java beans
-keep class java.beans.** { *; }
-dontwarn java.beans.**

# Keep DOM classes
-keep class org.w3c.dom.** { *; }
-dontwarn org.w3c.dom.**

-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}
-optimizations !method/inlining/
-keepclasseswithmembers class * {
  public void onPayment*(...);
}
-keep class * implements android.os.Parcelable { *; }
-keep class com.google.firebase.messaging.RemoteMessage { *; }
-keep class com.google.firebase.messaging.RemoteMessage$Notification { *; }
-keep class com.google.common.reflect.TypeToken
-keep class * extends com.google.common.reflect.TypeToken
# Keep background service classes
-keep class id.flutter.flutter_background_service.** { *; }
-keep class androidx.work.impl.background.systemjob.SystemJobService { *; }