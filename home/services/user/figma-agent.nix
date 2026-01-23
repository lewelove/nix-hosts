{ pkgs, username, lib, ... }:

let
  # Build the 0.4.3 version which supports the /figma/ prefix
  figma-agent-v0_4_3 = pkgs.rustPlatform.buildRustPackage rec {
    pname = "figma-agent";
    version = "0.4.3";

    src = pkgs.fetchFromGitHub {
      owner = "neetly";
      repo = "figma-agent-linux";
      rev = "${version}";
      hash = "sha256-eP2C/u4CWdf7ABHdxapFcrmI1Un405wIHE0kpvz7y7A=";
    };

    cargoHash = "sha256-KmoTsriLnYvEI+yOOV9sLQ6qPRKqYRDzaYj7Kp72sP0=";

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [ pkgs.fontconfig ];

    doCheck = false;
  };
in
{
  home-manager.users.${username} = {
    systemd.user.services.figma-agent = {
      Unit = {
        Description = "Figma Agent for Linux (v0.4.3 API)";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${figma-agent-v0_4_3}/bin/figma-agent";
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = [ "BIND=127.0.0.1:44950" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
