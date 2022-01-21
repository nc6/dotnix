{ pkgs, ...}:
{
  fonts.fonts = with pkgs; [
    source-code-pro
    fira
    fira-code
    fira-code-symbols
    fira-mono
    emacs-all-the-icons-fonts
  ];
}
