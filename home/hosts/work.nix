{
  username = "peter.ke";
  homeDirectory = "/Users/peter.ke/";
  repoDirectory = "/Users/peter.ke/dotfiles";
  system = "aarch64-darwin";

  configuration = {
    # To override default home modules, add more
    modules = [
      ../home.nix
      # ../systems/wsl.nix
    ];
  };
}
