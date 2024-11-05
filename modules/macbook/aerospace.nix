{ config, pkgs, ... }:

let 
  scripts = {
    move-node-or-workspace = (pkgs.writeShellScriptBin "_aerospace-move-node-or-workspace" ''
      direction=$1

      # If it's the only window, move entire workspace to monitor in $direction
      if [[ $(aerospace list-windows --workspace focused | grep -c .) == 1 ]]; then
        aerospace move-workspace-to-monitor "$direction"
      else
        aerospace move-node-to-monitor "$direction"
      fi
    '');
  
  relative-resize = (pkgs.writeShellScriptBin "_aerospace-relative-resize" ''
    current_monitor=$(aerospace list-windows --focused --format '%{monitor-name}')
    
    if [[ "$current_monitor" == "Built-in Retina Display" ]]; then
        current_monitor="Color LCD"
        resolution_field="Resolution"
    else
        resolution_field="UI Looks like"
    fi
    
    system_profiler SPDisplaysDataType \
      | grep -Pzo -a "(?<=$current_monitor:\n)(\s{10}.+){1,}" \
      | grep -Pao "(?<=$resolution_field: )(.+)(?= @)" \
      | read -r monitor_w _ monitor_h
    
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
  home.packages = [
    scripts.move-node-or-workspace
    scripts.relative-resize
  ];

  home.file = {
    ".config/aerospace/aerospace.toml" = {
      source = aerospace.d/aerospace.toml;
      onChange = "/opt/homebrew/bin/aerospace reload";
    };
  };
}
