# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-wrapNeovim = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {inherit pkgs-wrapNeovim;};

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  #
  all-plugins = with pkgs.vimPlugins; [
    # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins
    # Can also add packages directly from flake inputs: `(mkNvimPlugin inputs.wf-nvim "wf.nvim")`

    # Probably not needed
    # hardtime-nvim # Establish good habits | https://github.com/m4xshen/hardtime.nvim
    # catppuccin-nvim # https://github.com/catppuccin/nvim/
    # lazygit-nvim # https://github.com/kdheepak/lazygit.nvim
    # nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/

    # I KNOW WTF THESE DO:

    # General Dependencies
    sqlite-lua # https://github.com/kkharji/sqlite.lua/
    plenary-nvim # https://github.com/nvim-lua/plenary.nvim/
    nvim-web-devicons # https://github.com/nvim-tree/nvim-web-devicons/
    nvim-nio # https://github.com/nvim-neotest/nvim-nio/
    nui-nvim # https://github.com/MunifTanjim/nui.nvim
    # End General Dep

    aerial-nvim # Code outline | https://github.com/stevearc/aerial.nvim
    (mkNvimPlugin inputs.stickybuf "stickybuf.nvim") # Locks a buffer to a window (for plugins with 'popup' buffers) | https://github.com/stevearc/stickybuf.nvim
    nvim-treesitter.withAllGrammars # https://github.com/nvim-treesitter/nvim-treesitter
    nvim-lspconfig # https://github.com/neovim/nvim-lspconfig/
    lsp_signature-nvim # https://github.com/ray-x/lsp_signature.nvim/
    conform-nvim # formatting | https://github.com/stevearc/conform.nvim/
    vim-sleuth # Detect tabstop and shiftwidth automatically | https://github.com/tpope/vim-sleuth
    todo-comments-nvim # highlights 'TODO' comments | https://github.com/folke/todo-comments.nvim
    gx-nvim # open links with `gx` | https://github.com/chrishrb/gx.nvim/
    tokyonight-nvim # https://github.com/folke/tokyonight.nvim/
    comment-nvim # https://github.com/numToStr/Comment.nvim
    alpha-nvim # Startup page | https://github.com/goolord/alpha-nvim?tab=readme-ov-file
    eyeliner-nvim # Highlights unique characters for f/F and t/T motions | https://github.com/jinh0/eyeliner.nvim
    nvim-autopairs # Automatically create matching pairs | https://github.com/windwp/nvim-autopairs
    luasnip # https://github.com/l3mon4d3/luasnip/
    nvim-cmp # https://github.com/hrsh7th/nvim-cmp
    cmp_luasnip # snippets autocompletion extension for nvim-cmp | https://github.com/saadparwaiz1/cmp_luasnip/
    lspkind-nvim # vscode-like LSP pictograms | https://github.com/onsails/lspkind.nvim/
    cmp-nvim-lsp # LSP as completion source | https://github.com/hrsh7th/cmp-nvim-lsp/
    cmp-buffer # current buffer as completion source | https://github.com/hrsh7th/cmp-buffer/
    cmp-path # file paths as completion source | https://github.com/hrsh7th/cmp-path/
    nvim-dap # https://github.com/mfussenegger/nvim-dap/
    nvim-dap-ui # https://github.com/rcarriga/nvim-dap-ui/
    gitsigns-nvim # Git line marking & blame | https://github.com/lewis6991/gitsigns.nvim/
    harpoon2 # File marking and quick navigation | https://github.com/ThePrimeagen/harpoon/tree/harpoon2
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    nvim-scrollbar # scroll bar with git/diagnostics | https://github.com/petertriho/nvim-scrollbar
    nvim-treesitter-context # context lines at top of screen | https://github.com/nvim-treesitter/nvim-treesitter-context/
    which-key-nvim # "context menu" at bottom of screen with available options | https://github.com/folke/which-key.nvim
    diffview-nvim # view git diff on entire file | https://github.com/sindrets/diffview.nvim/
    mini-nvim # collection | https://github.com/echasnovski/mini.nvim
    snacks-nvim # collection | https://github.com/folke/snacks.nvim
    nvim-highlight-colors # highlight hex and other color text | https://github.com/brenoprata10/nvim-highlight-colors
    oil-nvim # https://github.com/stevearc/oil.nvim
    nvim-ts-autotag # Automaticall close and rename html tags | https://github.com/windwp/nvim-ts-autotag
    nvim-spectre # global find and replace | https://github.com/nvim-pack/nvim-spectre/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
  ];

  extraPackages = with pkgs; [];

  expectedDeps = with pkgs; [
    # These are all of the dependencies that are expected to be installed by my configuration
    # You can use this part of the overlay if you want to make sure you have all of them
    # but its perfectly reasonable just to install them yourself globally or per project in a flake
    # This is more just to document it for me

    # Utils
    ripgrep
    fzf
    zoxide
    fd

    # Git
    git
    lazygit

    # Language Servers
    lua-language-server
    nil
    # rust-analyzer
    zls
    nodePackages.typescript-language-server
    vtsls
    vscode-langservers-extracted
    # biome
    astro-language-server
    pyright
    tailwindcss-language-server

    # Formatters
    stylua
    prettierd
    alejandra
    just
    ruff
  ];
in {
  # This is the neovim derivation
  # returned by the overlay
  configured-nvim = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  configured-nvim-deps = pkgs.buildEnv {
    name = "configured-nvim-deps";
    paths = expectedDeps;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}
