{
  username = "peterkeder";
  homeDirectory = "/home/peterkeder";
  repoDirectory = "/home/peterkeder/dotfiles";
  system = "x86_64-linux";

  configuration = {
    # To override default home modules, add more
    modules = [
      ../home.nix
      # TODO: maybe depedent on sys?
      ../systems/wsl.nix
    ];
  };
}
