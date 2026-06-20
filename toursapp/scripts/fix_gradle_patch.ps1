param(
    [string]$ProjectRoot = "D:\Thanh\Projects\ToursApp\toursapp",
    [string]$AppId       = "com.example.stoneecho",
    [string]$KotlinVer   = "1.9.0",
    [string]$GradleVer   = "8.9"
)

$android = "$ProjectRoot\android"

# Backup
$backup = "$ProjectRoot\android_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Copy-Item $android $backup -Recurse -Force
Write-Host "Backup: $backup" -ForegroundColor Yellow

# Ensure dirs exist
New-Item -ItemType Directory -Force -Path "$android\gradle\wrapper" | Out-Null
New-Item -ItemType Directory -Force -Path "$android\app" | Out-Null

# -- settings.gradle --
$settingsContent = @'
pluginManagement {
    def flutterSdkPath = {
        def properties = new Properties()
        file("local.properties").withInputStream { properties.load(it) }
        def flutterSdkPath = properties.getProperty("flutter.sdk")
        assert flutterSdkPath != null, "flutter.sdk not set in local.properties"
        return flutterSdkPath
    }()

    includeBuild("${flutterSdkPath}/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.3.2" apply false
    id "org.jetbrains.kotlin.android" version "KOTLIN_VER" apply false
}

include ":app"
'@
$settingsContent = $settingsContent -replace 'KOTLIN_VER', $KotlinVer
Set-Content "$android\settings.gradle" $settingsContent -Encoding UTF8

# -- build.gradle (root) --
$buildRoot = @'
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = "../build"
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
'@
Set-Content "$android\build.gradle" $buildRoot -Encoding UTF8

# -- app/build.gradle --
$buildApp = @'
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}

android {
    namespace "APP_ID"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8
    }

    defaultConfig {
        applicationId "APP_ID"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.debug
            minifyEnabled false
            shrinkResources false
        }
    }
}

flutter {
    source "../.."
}
'@
$buildApp = $buildApp -replace 'APP_ID', $AppId
Set-Content "$android\app\build.gradle" $buildApp -Encoding UTF8

# -- gradle-wrapper.properties --
$wrapperContent = @'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-GRADLE_VER-all.zip
'@
$wrapperContent = $wrapperContent -replace 'GRADLE_VER', $GradleVer
Set-Content "$android\gradle\wrapper\gradle-wrapper.properties" $wrapperContent -Encoding UTF8

# -- gradle.properties --
$gradleProps = @'
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G -XX:+HeapDumpOnOutOfMemoryError
android.useAndroidX=true
android.enableJetifier=true
'@
Set-Content "$android\gradle.properties" $gradleProps -Encoding UTF8

Write-Host "Gradle files patched." -ForegroundColor Green
Write-Host "Now run: flutter build apk --debug" -ForegroundColor Green
