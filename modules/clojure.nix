{ pkgs, ... }:

{
  home.packages = with pkgs; [
    babashka
    clojure
    corretto21
    leiningen
  ];

  home.file = {
    ".clojure" = {
      source = ./clojure.d;
      recursive = true;
    };
  };
}
