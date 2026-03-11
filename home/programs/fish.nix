{ pkgs, username, dot, ... }:

{
  programs.fish = {
    enable = true;
    loginShellInit = ''
      if test -z "$DISPLAY" -a (tty) = "/dev/tty1"
        exec start-hyprland
      end
    '';
  };

  home-manager.users.${username} = { config, ... }: {
    home.file.".config/fish".source = config.lib.file.mkOutOfStoreSymlink "${dot}/.config/fish";
  };
}
