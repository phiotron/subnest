# ML Kit text recognition bundles only the Latin script by default; the plugin references the optional
# Chinese / Japanese / Korean / Devanagari recognizers. R8 full mode fails on those missing classes.
-dontwarn com.google.mlkit.vision.text.**
