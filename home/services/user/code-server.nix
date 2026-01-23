{ pkgs, username, ... }:

{
  home-manager.users.${username} = {
    systemd.user.services.code-server = {
      Unit = {
        Description = "VS Code Server (Local FOSS)";
        After = [ "network.target" ];
      };

      Service = {
        # 1. Run the binary directly
        # 2. Bind to localhost:4444
        # 3. Disable Auth (it's a local app)
        # 4. Disable Telemetry & Updates
        ExecStart = ''
          ${pkgs.code-server}/bin/code-server \
            --bind-addr 127.0.0.1:4444 \
            --auth none \
            --user-data-dir %h/.config/code-server \
            --extensions-dir %h/.config/code-server/extensions \
            --disable-telemetry \
            --disable-update-check \
            --ignore-last-opened
        '';

        # Force Open VSX Registry (Eclipse Foundation)
        # Environment = [ 
        #   "EXTENSIONS_GALLERY='{\"serviceUrl\": \"https://open-vsx.org/vscode/gallery\", \"itemUrl\": \"https://open-vsx.org/vscode/item\"}'"
        # ];

        Restart = "always";
        RestartSec = "5s";
      };

      Install.WantedBy = [ "default.target" ];
    };
  };
}
