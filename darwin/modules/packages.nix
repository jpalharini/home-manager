{ config, pkgs, ... }:

{
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };
  
  environment.systemPackages = with pkgs; [
    ansible
    ansible-lint
    autoconf
    awscli2
    awslogs
    aws-iam-authenticator
    bat
    chezmoi
    clojure
    coreutils-prefixed
    diffutils
    discord
    docker
    ed
    espanso
    fd
    ffmpeg
    findutils
    gawk
    gimp
    git
    git-lfs
    gnupg
    gnused
    gnutar
    gnugrep
    go
    gzip
    htop
    inetutils # telnet netcat ...
    iperf
    jet # edn manipulation
    jq
    kafkactl
    kubectl
    kubectx
    kubernetes-helm
    lazygit
    leiningen
    less
    localsend
    minikube
    nano
    neovim
    openssh
    parallel
    qrencode
    rbenv
    redis
    ripgrep
    rsync
    shellcheck
    speedtest-cli
    telegraf
    tmux
    vim
    vscode
    watch
    wdiff
    wget
    yq # like jq, for yaml
    zip
  ];

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    taps = [
      "jimeh/emacs-builds"
      "homebrew/services"
    ];
    brews = [
      "fontconfig"
      "openssl@3"
      "pam-reattach"
      "pandoc"
    ];
    casks = [
      "ankerwork"
      "corretto@11"
      "corretto@17"
      "corretto@21"
      "font-jetbrains-mono-nerd-font"
      "font-roboto"
      "font-roboto-mono-nerd-font"
      "font-symbols-only-nerd-font"
      "intellij-idea"
      "jimeh/emacs-builds/emacs-app"
      "kdenlive"
      "meetingbar"
      "obs"
      "raycast"
      "stats"
      "syncthing"
      "xquartz"
    ];
  };
}
