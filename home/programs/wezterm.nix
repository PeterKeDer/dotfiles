{ config, hostInfo, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (hostInfo) repoDirectory;
in
{
  # TODO: consider if we can install on windows
  xdg.configFile.wezterm = {
    source = mkOutOfStoreSymlink "${repoDirectory}/.config/wezterm";
  };
}
