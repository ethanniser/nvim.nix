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
  patched-eyeliner-nvim = pkgs.vimPlugins.eyeliner-nvim.overrideAttrs {
    src = pkgs.fetchFromGitHub {
      owner = "jinh0";
      repo = "eyeliner.nvim";
      rev = "be71bd4";
      sha256 = "sPEsMP8FGiyzR54oZrybf5z8Zb+70UnpMPbrO9HVcps=";
    };
  }; # nixpkgs not yet updated see issue #51
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
    cmp-cmdline # cmp command line suggestions | https://github.com/hrsh7th/cmp-cmdline/
    cmp-cmdline-history # cmp command line history suggestions | https://github.com/dmitmel/cmp-cmdline-history/

    # debugging
    nvim-dap # https://github.com/mfussenegger/nvim-dap/
    nvim-dap-ui # https://github.com/rcarriga/nvim-dap-ui/
    nvim-dap-python # https://github.com/mfussenegger/nvim-dap-python

    # Git
    diffview-nvim # https://github.com/sindrets/diffview.nvim/
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    lazygit-nvim # https://github.com/kdheepak/lazygit.nvim

    # telescope and extensions
    telescope-nvim # https://github.com/nvim-telescope/telescope.nvim/
    telescope-fzy-native-nvim # https://github.com/nvim-telescope/telescope-fzy-native.nvim
    (mkNvimPlugin inputs.telescope-helpgrep-nvim "telescope-helpgrep-nvim") # https://github.com/catgoose/telescope-helpgrep.nvim
    telescope-zoxide # use zoxide with telescope | https://github.com/jvgrootveld/telescope-zoxide

    # UI
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    nvim-navic # Add LSP location to lualine | https://github.com/SmiteshP/nvim-navic
    nvim-treesitter-context # nvim-treesitter-context | https://github.com/nvim-treesitter/nvim-treesitter-context/
    which-key-nvim # https://github.com/folke/which-key.nvim
    nvim-notify # UI popup notifications | https://github.com/rcarriga/nvim-notify
    dressing-nvim # improves default vim.ui | https://github.com/stevearc/dressing.nvim
    nvim-scrollbar # scroll bar with git/diagnostics | https://github.com/petertriho/nvim-scrollbar
    alpha-nvim # Startup page | https://github.com/goolord/alpha-nvim?tab=readme-ov-file

    # Files
    oil-nvim # https://github.com/stevearc/oil.nvim
    neo-tree-nvim # https://github.com/nvim-neo-tree/neo-tree.nvim
    fzf-vim # https://github.com/junegunn/fzf.vim
    harpoon2 # File marking and quick navigation | https://github.com/ThePrimeagen/harpoon/tree/harpoon2

    # navigation/editing enhancement plugins

    patched-eyeliner-nvim # Highlights unique characters for f/F and t/T motions | https://github.com/jinh0/eyeliner.nvim
    nvim-surround # https://github.com/kylechui/nvim-surround/
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    indent-blankline-nvim # https://github.com/lukas-reineke/indent-blankline.nvim
    comment-nvim # https://github.com/numToStr/Comment.nvim
    nvim-autopairs # Automatically create matching pairs | https://github.com/windwp/nvim-autopairs
    nvim-ts-autotag # Automaticall close and rename html tags | https://github.com/windwp/nvim-ts-autotag
    (mkNvimPlugin inputs.gx-nvim "gx.nvim") # open links with `gx` | https://github.com/chrishrb/gx.nvim

    # Color Schemes
    tokyonight-nvim # https://github.com/folke/tokyonight.nvim/
    catppuccin-nvim # https://github.com/catppuccin/nvim/

    # LSP
    nvim-lspconfig # https://github.com/neovim/nvim-lspconfig/
    lsp_signature-nvim # https://github.com/ray-x/lsp_signature.nvim/
    aerial-nvim # Code outline | https://github.com/stevearc/aerial.nvim
    # rustaceanvim

    # Misc
    mini-nvim # assorted tools | https://github.com/echasnovski/mini.nvim
    todo-comments-nvim # highlights 'TODO' comments | https://github.com/folke/todo-comments.nvim
    vim-sleuth # Detect tabstop and shiftwidth automatically | https://github.com/tpope/vim-sleuth
    # ^ Useful utilities

    # General Dependencies
    sqlite-lua # https://github.com/kkharji/sqlite.lua/
    plenary-nvim # https://github.com/nvim-lua/plenary.nvim/
    nvim-web-devicons # https://github.com/nvim-tree/nvim-web-devicons/
    nvim-nio # https://github.com/nvim-neotest/nvim-nio/

    # Formatters
    conform-nvim # https://github.com/stevearc/conform.nvim/

    # Other
    hardtime-nvim # Establish good habits | https://github.com/m4xshen/hardtime.nvim
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
    rust-analyzer
    zls
    nodePackages.typescript-language-server
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
