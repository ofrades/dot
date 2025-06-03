{ config, pkgs, ... }:

let
  ############################################################
  # 1) Android SDK settings (same as before, except naming) #
  ############################################################
  buildToolsVersion = "33.0.2";
  cmdLineToolsVersion = "8.0";
  toolsVersion = "26.1.1";
  platformToolsVersion = "33.0.3";
  platformVersions = [ "33" "34" ];
  abiVersions = [ "x86_64" ];
  cmakeVersions = [ "3.10.2" "3.18.1" ];
  ndkVersions = [ "24.0.8215888" ];
  extraLicensesList = [
    "android-sdk-preview-license"
    "android-googletv-license"
    "android-sdk-arm-dbt-license"
    "google-gdk-license"
    "intel-android-extra-license"
    "intel-android-sysimage-license"
    "mips-android-sysimage-license"
  ];

  android = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = cmdLineToolsVersion;
    toolsVersion = toolsVersion;
    platformToolsVersion = platformToolsVersion;
    buildToolsVersions = [ buildToolsVersion "30.0.3" ];
    includeEmulator = false;
    emulatorVersion = "31.3.14";
    platformVersions = platformVersions;
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = abiVersions;
    cmakeVersions = cmakeVersions;
    includeNDK = true;
    ndkVersions = ndkVersions;
    useGoogleAPIs = false;
    useGoogleTVAddOns = false;
    includeExtras = [ "extras;google;gcm" ];
    extraLicenses = extraLicensesList; # <— fixed name here
  };

  # Path to the Nix-installed aapt2:
  aapt2Path =
    "${android.androidsdk}/libexec/android-sdk/build-tools/${buildToolsVersion}/aapt2";
in {
  #####################################################
  # 2) Accept Android SDK licenses automatically      #
  #####################################################
  nixpkgs.config = { android_sdk.accept_license = true; };

  #################################################################
  # 3) Install android-studio, gradle, and jdk21 into your $HOME #
  #################################################################
  home.packages = with pkgs; [ android-studio gradle jdk21 ];

  ##########################################################
  # 4) Export all the usual ANDROID_* and JAVA_HOME vars   #
  ##########################################################
  home.sessionVariables = rec {
    JAVA_HOME = pkgs.jdk17.home;
    ANDROID_HOME = "${android.androidsdk}/libexec/android-sdk";
    ANDROID_SDK_ROOT = ANDROID_HOME;
    NDK_HOME = "${ANDROID_HOME}/ndk/";
    ANDROID_NDK_ROOT = "${ANDROID_HOME}/ndk/";
    ANDROID_NDK_HOME = "${ANDROID_HOME}/ndk/";

    # 5) FORCE Gradle to pick up Nix’s aapt2 rather than downloading one
    GRADLE_OPTS =
      "-Dorg.gradle.project.android.aapt2FromMavenOverride=${aapt2Path}";
  };

  #################################################################################
  # 6) (Optional) Activation check: warn if aapt2Path isn’t executable           #
  #################################################################################
  home.activation = {
    patchAapt2 = ''
      echo "ⓘ Verifying that AAPT2 is executable → ${aapt2Path}"
      if [ ! -x "${aapt2Path}" ]; then
        echo "⚠️  Warning: ${aapt2Path} is not executable! Check your composeAndroidPackages config."
      fi
    '';
  };
}
