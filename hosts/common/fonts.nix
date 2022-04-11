{ pkgs, ...}:
{
  fonts.fonts = with pkgs; [
    source-code-pro
    fira
    fira-code
    fira-code-symbols
    fira-mono
    font-awesome_5
    emacs-all-the-icons-fonts
  ];
}
