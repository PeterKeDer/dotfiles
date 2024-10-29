{
  config,
  hostInfo,
  pkgs,
  ...
}:
let
  inherit (hostInfo) username homeDirectory;
in
{
  imports = [
    ./programs/neovim.nix
    ./programs/wezterm.nix
    ./programs/zsh
  ];

  home = {
    inherit username homeDirectory;

    packages = with pkgs; [ nixfmt-rfc-style ];

    stateVersion = "24.05";
  };

  # TODO: lmao you still need it in conf because in order for this to work,
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  programs.home-manager.enable = true;
}
