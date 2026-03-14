{ config, pkgs, ... }:

{
  services.authelia.instances.main = {
    enable = true;
    secrets = {
      storageEncryptionKeyFile = "/etc/authelia-storage-key";
      jwtSecretFile = "/etc/authelia-jwt-secret";
      sessionSecretFile = "/etc/authelia-session-secret";
    };
    
    settings = {
      theme = "dark";
      server = {
        address = "tcp://127.0.0.1:9091";
      };
      log.level = "info";

      authentication_backend = {
        file = {
          path = "/var/lib/authelia-main/users.yml";
        };
      };

      storage = {
        local = {
          path = "/var/lib/authelia-main/db.sqlite3";
        };
      };
      
      session = {
        name = "authelia_session";
        cookies = [
          {
            domain = "lewelaboratory.duckdns.org";
            authelia_url = "https://auth.lewelaboratory.duckdns.org";
            default_redirection_url = "https://auth.lewelaboratory.duckdns.org";
          }
        ];
      };

      access_control = {
        default_policy = "deny";
        rules = [
          {
            domain = [ "*.lewelaboratory.duckdns.org" ];
            policy = "one_factor";
          }
        ];
      };
      
      notifier = {
        filesystem = {
          filename = "/var/lib/authelia-main/emails.txt";
        };
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/authelia-main 0750 authelia-main authelia-main -"
  ];
}
