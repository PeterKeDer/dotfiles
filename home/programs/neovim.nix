{
  config,
  unstable,
  hostInfo,
  ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (hostInfo) repoDirectory;
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = unstable.neovim-unwrapped;
  };

  xdg.configFile.nvim = {
    source = mkOutOfStoreSymlink "${repoDirectory}/.config/nvim";
  };
}
