# Writing code: GitHub tools, and what Neovim's language support runs.
{
  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # github
        gh
        ghgrab
        gh-dash

        # neovim: language servers enabled in ~/.config/nvim/init.lua (skipped there when missing)
        nixd
        bash-language-server
        ansible-language-server
        yaml-language-server
        dockerfile-language-server
        docker-compose-language-service
        helm-ls
        tofu-ls
        lua-language-server
        marksman
        taplo
        vscode-langservers-extracted # vscode-json-language-server
        systemd-lsp
        # nvim-treesitter (main) compiles parsers with these
        tree-sitter
        gcc

        # others
        jq
        yq-go
        entr
      ];
    };
}
