{ pkgs, identity, ... }:

{

  programs.ssh.startAgent = true;

  programs.git = {
    enable = true;
    config = {
      user = {
        name = identity.username;
        email = identity.email;
      };
      init.defaultBranch = "main";
      safe.directory = "*";
    };
  };

  programs.dconf.enable = true;
  
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };
  
  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-hyprland
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    config = {
      common = {
        default = [ "gtk" ];
      };
    };
  };

  programs.fuse.userAllowOther = true;

  programs.fzf = {
    fuzzyCompletion = true;
    keybindings = true;
  };

}
