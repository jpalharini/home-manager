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
      source = ./clojure.d/clojure;
      recursive = true;
    };

    ".lein" = {
      source = ./clojure.d/lein;
      recursive = true;
    };
  };
}
