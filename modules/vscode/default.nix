{ pkgs,...}:
{
	programs.vscode = let
    localPkgs = pkgs.vscode-utils.extensionsFromVscodeMarketplace (import ./exts.nix);
  in {
    enable = true;
    extensions = localPkgs;
		keybindings = pkgs.lib.importJSON ./keybindings.json;
		userSettings = pkgs.lib.importJSON ./settings.json;
	};
}
