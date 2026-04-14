{ pkgs, username, ... }:

{
  home-manager.users.${username} = {
    programs.btop = {
      enable = true;
      settings = {
        theme_background = false; 
        truecolor = true;
        vim_keys = true;
        presets = "cpu:0:default,proc:0:default,mem:0:default,net:0:default";
        graph_symbol = "braille";
        update_ms = 1500;
      };
    };

    xdg.desktopEntries.btop = {
      name = "btop";
      genericName = "System Monitor";
      comment = "Monitor system resources";
      exec = "${pkgs.alacritty}/bin/alacritty --class btop -e btop";
      icon = "btop";
      terminal = false;
      categories = [ "System" "Monitor" ];
    };
  };
}
