import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing (docs/ci.md). key.properties is looked up in this order:
//   1. path in env ANDROID_KEY_PROPERTIES (CI writes one to $RUNNER_TEMP; locally point it at the file kept
//      outside the repo, e.g. C:/Users/Admin/keystores/A001-subnest/key.properties)
//   2. android/key.properties (git-ignored)
// Keys: storeFile, storePassword, keyAlias, keyPassword. Without it, release falls back to the debug key
// (fine for `flutter run --release`, NOT uploadable). Set REQUIRE_RELEASE_SIGNING=true to fail instead.
val keyPropertiesFile: File? =
    (System.getenv("ANDROID_KEY_PROPERTIES")?.takeIf { it.isNotBlank() }?.let { file(it) }
        ?: rootProject.file("key.properties")).takeIf { it.exists() }
val keyProperties = Properties().apply { keyPropertiesFile?.inputStream()?.use { load(it) } }
val requireReleaseSigning = System.getenv("REQUIRE_RELEASE_SIGNING") == "true"
if (keyPropertiesFile == null && requireReleaseSigning) {
    throw GradleException("REQUIRE_RELEASE_SIGNING=true but no key.properties found (ANDROID_KEY_PROPERTIES / android/key.properties)")
}

android {
    namespace = "com.phiotron.subnest"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Core library desugaring is required by flutter_local_notifications (zonedSchedule).
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Never change after the first store release.
        applicationId = "com.phiotron.subnest"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (keyPropertiesFile != null) {
            create("release") {
                storeFile = file(keyProperties.getProperty("storeFile"))
                storePassword = keyProperties.getProperty("storePassword")
                keyAlias = keyProperties.getProperty("keyAlias")
                keyPassword = keyProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig =
                if (keyPropertiesFile != null) {
                    signingConfigs.getByName("release")
                } else {
                    logger.warn("key.properties not found: release build is signed with the DEBUG key (not uploadable).")
                    signingConfigs.getByName("debug")
                }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
