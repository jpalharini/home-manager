{ pkgs, ... }:

let
  scripts = {
    source-local-env = (pkgs.writeShellScriptBin "sourcef" ''
      while [ ! -f .env ] && [ "$(pwd)" != "/" ]; do
        find . -name ".env" -maxdepth 1 -type f
        pushd .. 1>/dev/null
      done

      if [ -f .env ]; then
        echo "Sourcing $(realpath .env)..."
        set -a; source .env; set +a
      else
        echo "No .env file found in parent dirs"
      fi
      ''
    );

    reload-config = (pkgs.writeScriptBin "reload-config" /*bash*/ ''
      #! /usr/bin/env zsh

      function reload_all_tmux() {
        for sess in $(tmux list-sessions -F "#{session_name}" 2>/dev/null); do
          curr_sess=$(tmux display -p '#S')
          if [ "$sess" != "$curr_sess" ]; then
            tmux run-shell -t "$sess" "reload-config && tmux display-message \"config reloaded\""
          fi
        done
      }

      source $HOME/.zshenv
      source $HOME/.zshrc

      if [ ! -z $TMUX ]; then
        tmux source $HOME/.config/tmux/tmux.conf
      fi

      # todo: figure out why this is problematic
      # reload_all_tmux
      ''
    );

    config = (pkgs.writeShellScriptBin "config" ''

      function _main_or_module () {
        main_file=$1
        module_file_fmt=$2
        module=$3
        
        if [ -z "$module" ]; then
          nvim "$main_file"
        else
          printf -v module_file "$module_file_fmt" "$module"
          nvim "$module_file"
        fi
      }

      function hm () {
        _main_or_module \
          "$HOME/.config/home-manager/home.nix" \
          "$HOME/.config/home-manager/modules/%s.nix" \
          "$1"
      }

      function darwin () {
        _main_or_module \
          "$HOME/.nixpkgs/darwin-configuration.nix"
          "$HOME/.nixpkgs/modules/%s.nix"
          "$1"
      }

      $@
    '');
  };

in {
  home.packages = [
    scripts.source-local-env
    scripts.reload-config
    scripts.config
    # todo: broken on linux
    #(import ./packages.d/bb/bb.nix)
    
    pkgs.lorri
    pkgs.maven
    pkgs.minio-client
    pkgs.mkcert
    pkgs.ripgrep
    pkgs.xmlstarlet
  ];
}
