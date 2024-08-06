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
  # }
  all-plugins = with pkgs.vimPlugins; [
    # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins
    # Can also add packages directly from flake inputs: `(mkNvimPlugin inputs.wf-nvim "wf.nvim")`

    # Treesitter
    nvim-treesitter.withAllGrammars # https://github.com/nvim-treesitter/nvim-treesitter

    # Snippets
    luasnip # https://github.com/l3mon4d3/luasnip/

    # Completions
    nvim-cmp # https://github.com/hrsh7th/nvim-cmp
    cmp_luasnip # snippets autocompletion extension for nvim-cmp | https://github.com/saadparwaiz1/cmp_luasnip/
    lspkind-nvim # vscode-like LSP pictograms | https://github.com/onsails/lspkind.nvim/
    cmp-nvim-lsp # LSP as completion source | https://github.com/hrsh7th/cmp-nvim-lsp/
    cmp-nvim-lsp-signature-help # https://github.com/hrsh7th/cmp-nvim-lsp-signature-help/
    cmp-buffer # current buffer as completion source | https://github.com/hrsh7th/cmp-buffer/
    cmp-path # file paths as completion source | https://github.com/hrsh7th/cmp-path/
    cmp-nvim-lua # neovim lua API as completion source | https://github.com/hrsh7th/cmp-nvim-lua/
    cmp-cmdline # cmp command line suggestions
    cmp-cmdline-history # cmp command line history suggestions

    # Git
    diffview-nvim # https://github.com/sindrets/diffview.nvim/
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/

    # telescope and extensions
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim
    (mkNvimPlugin inputs.telescope-helpgrep-nvim "telescope-helpgrep-nvim")

    # UI
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    nvim-navic # Add LSP location to lualine | https://github.com/SmiteshP/nvim-navic
    nvim-treesitter-context # nvim-treesitter-context
    which-key-nvim

    # Files
    oil-nvim # https://github.com/stevearc/oil.nvim
    neo-tree-nvim # https://github.com/nvim-neo-tree/neo-tree.nvim
    fzf-vim

    # navigation/editing enhancement plugins
    eyeliner-nvim # Highlights unique characters for f/F and t/T motions | https://github.com/jinh0/eyeliner.nvim
    nvim-surround # https://github.com/kylechui/nvim-surround/
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    # ^ navigation/editing enhancement plugins

    # Color Schemes
    tokyonight-nvim

    # LSP
    nvim-lspconfig
    lsp_signature-nvim
    # rustaceanvim

    # Misc
    mini-nvim
    nvim-unception # Prevent nested neovim sessions | nvim-unception
    # ^ Useful utilities

    # General Dependencies
    sqlite-lua
    plenary-nvim
    nvim-web-devicons

    # Formatters
    conform-nvim
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

    # Language Servers
    lua-language-server
    nil
    rust-analyzer
    zls

    # Formatters
    stylua
    prettierd
    alejandra
    just
  ];
in {
  # This is the neovim derivation
  # returned by the overlay
  configured-nvim = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  configured-nvim-deps = pkgs.buildEnv {
    name = "nvim-expected-deps";
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
