{ pkgs, ... }:

let 
  scripts = {
    move-node-or-workspace = (pkgs.writeShellScript "aerospace-move-node-or-workspace" /*bash*/ ''
      PATH="$PATH:/run/current-system/sw/bin"

      direction=$1

      # If it's the only window, move entire workspace to monitor in $direction
      if [[ $(aerospace list-windows --workspace focused | grep -c .) == 1 ]]; then
        aerospace move-workspace-to-monitor "$direction"
      else
        aerospace move-node-to-monitor "$direction"
      fi
    '');
  
  relative-resize = (pkgs.writeShellScript "aerospace-relative-resize" /*bash*/ ''
    PATH="$PATH:/run/current-system/sw/bin"

    current_monitor=$(aerospace list-windows --focused --format '%{monitor-name}')
    
    if [[ "$current_monitor" == "Built-in Retina Display" ]]; then
        current_monitor="Color LCD"
        resolution_field="Resolution"
    else
        resolution_field="UI Looks like"
    fi

    shopt -s lastpipe
    
    system_profiler SPDisplaysDataType \
      | grep -Pzo -a "(?<=$current_monitor:\n)(\s{10}.+){1,}" \
      | grep -Pao "(?<=$resolution_field: )(.+)(?= @)" \
      | read -r monitor_w _ monitor_h
    
    shopt -u lastpipe
    
    if [[ "$current_monitor" == "Built-in Retina Display" ]]; then
        monitor_w=$(( monitor_w / 2 ))
    fi
    
    if [[ $monitor_w > $monitor_h ]]; then
        size=$monitor_w
    else
        size=$monitor_h
    fi
    
    function one_third () {
        aerospace resize smart $(( size / 3 ))
    }
    
    function two_thirds () {
        aerospace resize smart $(( ( size / 3 ) * 2 ))
    }
    
    function half () {
        aerospace resize smart $(( size / 2 ))
    }
    
    $1

    '');
  };
in {
  services.aerospace = {
    enable = true;
    settings = {
      gaps = {
        inner.horizontal = 0;
        inner.vertical = 0;
        outer.top = 0;
        outer.left = 1;
        outer.bottom = 1;
        outer.right = 0;
      };
      mode.main.binding = {
        ctrl-l = "layout tiles horizontal vertical";
        ctrl-f = "layout floating tiling";
        ctrl-enter = "fullscreen";

        ctrl-up = "focus up";
        ctrl-left = "focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors left";
        ctrl-down = "focus down";
        ctrl-right = "focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors right";
        
        ctrl-shift-up = "move up";
        ctrl-shift-left = "move left";
        ctrl-shift-down = "move down";
        ctrl-shift-right = "move right";
        
        ctrl-cmd-up = "join-with up";
        ctrl-cmd-left = "join-with left";
        ctrl-cmd-down = "join-with down";
        ctrl-cmd-right = "join-with right";
        
        cmd-ctrl-minus = "resize smart -100";
        cmd-ctrl-equal = "resize smart +100";
        
        cmd-ctrl-0 = "exec-and-forget ${scripts.relative-resize} half";
        cmd-ctrl-1 = "exec-and-forget ${scripts.relative-resize} one_third";
        cmd-ctrl-2 = "exec-and-forget ${scripts.relative-resize} two_thirds";
        
        ctrl-leftSquareBracket = "workspace prev";
        ctrl-rightSquareBracket = "workspace next";
        
        cmd-ctrl-rightSquareBracket = "move-node-to-monitor next";
        cmd-ctrl-leftSquareBracket = "move-node-to-monitor prev";

        ctrl-shift-rightSquareBracket = "move-workspace-to-monitor next";
        ctrl-shift-leftSquareBracket = "move-workspace-to-monitor prev";

        cmd-ctrl-x = "mode service";
      };

      #mode.service.binding = {};

      on-window-detected = [
        {
          check-further-callbacks = true;
          run = [ "layout floating" ];
        }
        {
          "if".app-id = "com.vivaldi.Vivaldi";
          run = [ "layout tiling" ];
        }
        {
          "if".app-name-regex-substring = "alacritty";
          run = [ "layout tiling" ];
        }
        {
          "if".app-name-regex-substring = "Slack";
          run = [
            "layout tiling"
            "move-node-to-workspace slack"
          ];
        }
        {
          "if" = {
            app-id = "com.microsoft.rdc.macos";
            window-title-regex-substring = "Microsoft Remote Desktop|Preferences";
          };
          run = [ "layout floating" ];
        }
        {
          "if".app-id = "com.microsoft.rdc.macos";
          run = [
            "layout tiling"
            "move-node-to-workspace rdp"
          ];
        }
        {
          "if" = {
            app-id = "com.jetbrains.intellij";
            window-title-regex-substring = ".+ – .+";
          };
          run = [
            "layout tiling"
            "move-node-to-workspace idea"
          ];
        }
        {
          "if".window-title-regex-substring = "Zoom Meeting";
          run = [
            "layout tiling"
            "move-node-to-workspace zoom"
          ];
        }
      ];
      
      workspace-to-monitor-force-assignment = {
        "1-main" = [ "GP27-FUS" "^built-in*" ];
        "slack" = [ "ARZOPA" "^built-in*" ];
      };
    };
  };
}
