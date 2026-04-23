{ pkgs, lib, username, config, identity, ... }:

let
  wrapper = config.my.chromium.wrapper;
  name = "Vellum";
  icon = "vellum";
  domain = "vellum.localhost";
  port = 5173;

  vellum-cmd = pkgs.writeShellScriptBin "vellum" ''
    case "$1" in
      ui)
        cd "/home/${username}/dev/vellum/web-app" && exec ${pkgs.bun}/bin/bun run dev
        ;;
      *)
        exec "/home/${username}/dev/vellum/rust/target/release/vellum" "$@"
        ;;
    esac
  '';
in
{
  networking.hosts."127.0.0.1" = [ domain ];

  services.nginx.virtualHosts."${domain}" = {
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
    };
  };

  environment.systemPackages = [
    pkgs.bun
    vellum-cmd
  ];

  home-manager.users.${username} = { config, ... }: {
    home.file.".config/vellum".source = config.lib.file.mkOutOfStoreSymlink "${identity.repoPath}/dotfiles/.config/vellum";

    xdg.desktopEntries.${name} = {
      inherit name icon;
      genericName = "Vellum Project";
      exec = "${wrapper}/bin/chromium-browser --app=http://${domain}";
      terminal = false;
    };
  };
}
