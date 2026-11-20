{...}:
{
  programs.nushell = {
    enable = true;

    loadSessionVariables = true;

    configFile.source = ./config.nu;
  };
}
