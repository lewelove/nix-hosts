{ identity, ... }:

{
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
}
