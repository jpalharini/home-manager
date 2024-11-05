{ config, ... }:

{
  programs.zsh = {
    initExtraFirst = /*bash*/ ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    initExtra = /*bash*/ ''
      export JAVA_HOME="$(/usr/libexec/java_home -v 21)";
    '';

    shellAliases = {
      drs = "darwin-rebuild switch";
      hms = "home-manager switch -f ~/.config/home-manager/macbook.nix";

      list-javas = "/usr/libexec/java_home -V";
      java11 = "export JAVA_HOME=$(/usr/libexec/java_home 11)";
      java17 = "export JAVA_HOME=$(/usr/libexec/java_home 17)";
      java21 = "export JAVA_HOME=$(/usr/libexec/java_home 21)";
    };
  };
}
