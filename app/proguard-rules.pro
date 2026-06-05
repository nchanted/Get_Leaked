# Keep the WebView + JS bridge surface intact if you later add @JavascriptInterface methods.
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
