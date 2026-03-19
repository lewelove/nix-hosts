{ pkgs, ... }:

{
  services.fail2ban = {
    enable = true;
    bantime = "24h";
    maxretry = 5;

    ignoreIP = [
      "127.0.0.1/8"
      "192.168.1.0/24"
      "10.10.10.0/24"
    ];

    jails = {
      sshd.settings = {
        enabled = true;
        port = "ssh";
        filter = "sshd";
        maxretry = 3;
      };

      caddy-auth = {
        settings = {
          enabled = true;
          filter = "caddy-auth";
          logpath = "/var/log/caddy/access.log";
          port = "http,https";
          backend = "auto"; 
        };
      };
    };
  };

  environment.etc."fail2ban/filter.d/caddy-auth.conf".text = ''
    [Definition]
    failregex = ^.*"remote_ip":"<HOST>".*"status":(401|403|444).*$
    ignoreregex =
  '';
}
