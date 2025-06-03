{ config, pkgs, ... }: {
  nixpkgs.config = { android_sdk.accept_license = true; };

  home.packages = with pkgs; [
    expo-cli
    watchman
    jdk17

    android-studio
    androidsdk.cmdline-tools
    androidsdk.platform-tools
    androidsdk.build-tools

    androidsdk.emulator
    androidsdk.system-image
  ];

  home.sessionVariables = {
    ANDROID_HOME = "${pkgs.androidsdk}/libexec";
    ANDROID_SDK_ROOT = "${pkgs.androidsdk}/libexec";
    ANDROID_SDK_MANAGER = "${pkgs.androidsdk}/libexec/tools/bin/sdkmanager";

    PATH = ''
      ${pkgs.androidsdk.platform-tools}/bin
      :${pkgs.androidsdk.cmdline-tools}/bin
      :${config.home.sessionVariables.PATH}
    '';

    JAVA_HOME = "${pkgs.jdk17}";
  };
}
