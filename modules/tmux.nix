{ config, pkgs, ... }:

let
  scripts = {
    aws-info = (pkgs.writeShellScript "tmux-aws-info" ''
      metadata_url="http://169.254.169.254/latest/meta-data"

      function save_token () {
        echo "INFO: Refreshing token..." &>/dev/null
        curl -s --connect-timeout 1 -o /tmp/.aws-meta-token \
          -X PUT "http://169.254.169.254/latest/api/token" \
          -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"
      }
      
      function is_token_valid () {
        local token_age=$(expr `date +%s` - `stat -c %Y /tmp/.aws-meta-token`)
        return $(( token_age > 21600 ))
      }
      
      function getf () {
        { test -f /tmp/.aws-meta-token && token=$(\cat /tmp/.aws-meta-token) && is_token_valid; } || save_token
        curl -X GET -sf --connect-timeout 1 -H "X-aws-ec2-metadata-token: $token" "$metadata_url/$1"
      }
      
      function is_aws () {
        { getf "" 1>/dev/null && return 0; } || return 1
      }
      
      function status () {
        local inst_id=$(getf instance-id)
        local inst_name=$(getf tags/instance/Name)
      
        printf '%s %s' "$(getf instance-id)" "($(getf tags/instance/Name))"
      }
      
      $1 "$2"
    '');

    host-info = (pkgs.writeShellScriptBin "tmux-host-info" ''
      declare -A host_map

      host_map["joaopalharini"]="nu-mac"

      is_aws=$(${scripts.aws-info} is_aws)

      function _print_icon () {
        bash -c "printf \"$1\""
      }

      function icon() {
        # If it's a Mac, use system_profiler to identify if it's portable
        if system_profiler SPHardwareDataType | grep "Model Identifier" | grep -q "Book"; then
          _print_icon "\uf109"
        else
          # If Linux, check for battery presence to identify if portable
          if eval test -d /sys/module/battery; then
            _print_icon "\uf109"
          elif [ $is_aws ]; then
            _print_icon "\uf0c2"
          else
            _print_icon "\uf233"
          fi
        fi
      }

      function host() {
        if [ $is_aws ]; then
          ${scripts.aws-info} status
        else
          hostname_key=$(hostname | tr -d '.')
          custom=''${host_map[$hostname_key]}
          if [ -z "$custom" ]; then
            echo -n "$(hostname)"
          else
            echo -n "$custom"
          fi
        fi
      }

      $1
    '');

    toggle-status = (pkgs.writeShellScriptBin "tmux-toggle-status" ''
      state=$(tmux display -p '#{status}')

      if [ -n "$SSH_CLIENT" ]; then
        if [ "$STATE" == "off" ]; then
          tmux set -u status
        else
          tmux set status off
        fi
      fi
    '');
  };

in {
  home.packages = [
    scripts.toggle-status
    scripts.host-info
  ];

  programs.tmux = {
    enable = true;
    
    baseIndex = 1;
    disableConfirmationPrompt = true;
    escapeTime = 10;
    keyMode = "vi";
    mouse = true;
    prefix = "C-q";
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";

    extraConfig = (builtins.readFile ./tmux.d/tmux.conf);

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = (builtins.readFile ./tmux.d/catppuccin.tmux.conf);
      }
    ];
  };
}
