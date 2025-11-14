import java.util.Properties
import java.io.FileInputStream
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")    
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
val keystoreProperties = Properties()
// Đổi path cho đúng file của bạn (ví dụ: "keys/keystore.properties" hoặc "key.properties")
val keystorePropertiesFile = file("src/keys/keystore.properties")
if (keystorePropertiesFile.exists()) {
    // ✅ Kotlin DSL: không dùng 'new'
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
android {
    namespace = "com.blazecore.apkblaze"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.blazecore.apkblaze"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders["ADMOB_APP_ID"] = "ca-app-pub-3940256099942544~3347511713"
    }
     signingConfigs {
        create("release") {
            // Ép về String? để tránh type mismatch khi thiếu key
            keyAlias = (keystoreProperties["keyAlias"] as String?) ?: ""
            keyPassword = (keystoreProperties["keyPassword"] as String?) ?: ""
            storeFile = file((keystoreProperties["storeFile"] as String?) ?: "")
            storePassword = (keystoreProperties["storePassword"] as String?) ?: ""
            enableV1Signing = true
            enableV2Signing = true
        }
    }

   
    buildTypes {
        // ⚠️ Kotlin DSL: dùng getByName thay vì debug { } / release { } kiểu Groovy
        getByName("debug") {
            isMinifyEnabled = false
            // Nếu muốn ký debug bằng keystore release (không bắt buộc):
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            }
            // DÙNG TEST APP ID CHO DEBUG
            manifestPlaceholders["ADMOB_APP_ID"] =
                "ca-app-pub-3940256099942544~3347511713" // TEST App ID
        }
        getByName("release") {
             isMinifyEnabled = false
             isShrinkResources = false
            // DÙNG APP ID THẬT CHO RELEASE
            manifestPlaceholders["ADMOB_APP_ID"] =
                "ca-app-pub-7943717185437931~4581298597" // PROD App ID của bạn

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
            signingConfig = signingConfigs.getByName("release")
        }
    }
    flavorDimensions += "default"

    productFlavors {
        create("development") {
            dimension = "default"
            // nên có suffix để phân biệt gói dev
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "[DEV] ApkBlaze")
        }

        create("production") {
            dimension = "default"
            // không cần suffix cho prod
            resValue("string", "app_name", "MODLEGEN")
        }
    }

    buildFeatures {
        dataBinding = true
    }
}

flutter {
    source = "../.."
}
dependencies {
    // Nếu bật desugaring ở trên, NHỚ thêm dependency:
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    // implementation(...) các thư viện khác của bạn
}