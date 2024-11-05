with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "bb-scripts";

  HOME = "/tmp/homedir";
  M2_REPO = "/tmp/homedir/.m2/repository";
  CLJ_JVM_OPTS = "-Duser.home=/tmp/homedir";

  src = ./.;

  buildInputs = [
    pkgs.clojure
    pkgs.jdk
  ];

  buildPhase = ''
    runHook preBuild
    clojure -J-Dmaven.repo.local=/tmp/homedir/.m2/repository -Srepro -X:build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp out/* $out/bin
    chmod u+x $out/bin/*
    rm out/*
    runHook postInstall
  '';
}
