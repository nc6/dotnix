{ pkgs,...}:
{
  config = {
    programs.starship = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
