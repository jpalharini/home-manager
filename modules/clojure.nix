{ pkgs, ... }:

{
  home.packages = with pkgs; [
    babashka
    clojure
    leiningen
  ];

  home.file = {
    ".clojure" = {
      source = ./clojure.d;
      recursive = true;
    };
  };
}
