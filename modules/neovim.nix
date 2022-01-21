{ pkgs, ... }:
{
  config = {

    home.packages = [
      # Needed for neovim coc
      pkgs.nodejs
    ];

    programs.neovim = {
      enable = true;

      extraConfig = ''
        set number
        set expandtab
        set tabstop=2
        set softtabstop=2
        set shiftwidth=2
        set mouse=a
        set clipboard=unnamed
        set incsearch

        imap fd <Esc>
      '';

      plugins = with pkgs.vimPlugins; [
        coc-nvim
      ];
    };
  };
}
