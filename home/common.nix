{ secrets, config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.

  home = {
    username = "chris";
    homeDirectory = "/home/${config.home.username}";
    sessionVariables.EDITOR = "nvim";
    packages = with pkgs; [ 
      (python311.withPackages (ps: with ps; [
      matplotlib
      numpy
      h5py
      pandas
      openpyxl
      ]))
      ripgrep
      nodejs
      texlive.combined.scheme-full
      pkgs.texlivePackages.latexmk
      pandoc
      zathura
      pyright
      btop
    ];
    file.".config/nixpkgs/config.nix" = {
      enable = true;
      text = ''
{ allowUnfree = true; }
      '';
    };
  };

  
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  xdg = {
    enable = true;
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;

    fzf.enable = true;
    fzf.enableZshIntegration = true;

    direnv.enable = true;
    direnv.enableZshIntegration = true;
    direnv.nix-direnv.enable = true;

    neovim = {
        enable = true;
        viAlias = true;  # Use `vi` as an alias for `nvim`
        vimAlias = true; # Use `vim` as an alias for `nvim`
       plugins = with pkgs.vimPlugins; [
          telescope-nvim
          plenary-nvim
          nvim-lspconfig
          nvim-treesitter.withAllGrammars
          gruvbox
          nvim-cmp
          cmp-nvim-lsp
          luasnip
          cmp_luasnip
          coc-nvim
	  vimtex
        ];

        # Extra Neovim configuration
        extraConfig = ''
" General settings
set number                      " Show line numbers
set relativenumber              " Show relative line numbers
set tabstop=4                   " Number of spaces for a tab
set shiftwidth=4                " Number of spaces for autoindent
set expandtab                   " Use spaces instead of tabs
set smartindent                 " Enable smart indentation
set clipboard=unnamedplus       " Use system clipboard
set mouse=a                     " Enable mouse support
set wrap                        " Enable line wrapping
set cursorline                  " Highlight the current line
set termguicolors               " Enable true color support
set scrolloff=8                 " Keep 8 lines visible when scrolling
set signcolumn=yes              " Always show the sign column
let mapleader = " "             " Set the leader
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_method = 'latexmk'

colorscheme gruvbox

lua << EOF

require('nvim-treesitter.configs').setup {
    ensure_installed = {}, -- or "all"
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    playground = {
        enable = true,
        updatetime = 25,
        persist_queries = false,
    },
}

local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}

-- Autocompletion
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
    }),
})

-- Enable LSP capabilities for autocompletion
local capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.pyright.setup({
    capabilities = capabilities,
})
EOF

      '';
    };
    zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        v = "nvim";
        ll = "ls -l";
        g = "git";
        c = "clear";
        gc = "nix-collect-garbage --delete-old";	
      };
      history = {
        ignoreDups = true;
        save = 10000;
    	size = 10000;
    	expireDuplicatesFirst = true;
	    ignoreSpace = true;
    	share = true;
	    path = "/home/${config.home.username}/.config/zsh/.zsh_history";
      };
      historySubstringSearch.enable = true;
      defaultKeymap = "viins";
      dotDir = "/.config/zsh";
      oh-my-zsh = {
        enable = true;
    	plugins = [
	        "git"
	        "man"
	        "sudo"
	        "tmux"
	        "vi-mode"
	    ];
      };
    };

    tmux = {
      enable = true;
      keyMode = "vi";
      extraConfig = ''
unbind C-b

set-option -g prefix C-space

bind C-space send-prefix

unbind-key i
bind-key i next-window
bind-key u previous-window
unbind-key j
bind-key j select-pane -D
unbind-key k
bind-key k select-pane -U
unbind-key l
bind-key l select-pane -R
unbind-key h
bind-key h select-pane -L

bind-key y set-window-option synchronize-panes

bind % split-window -h -c "#{pane_current_path}"
bind '"' split-window -v -c "#{pane_current_path}"
      '';
    };
    git = {
      enable = true;
      userName = "stofe95";
      userEmail = "cdedek@gmail.com";
    };
    taskwarrior = {
      enable = true;
    };
  };
  home.file.".latexmkrc".text = ''
    $pdf_mode = 1;
    $pdflatex = 'pdflatex -interation=nonstopmode -synctex=1 %O %S';
    $biber = 'biber %O %S';
    $preview_continuous_mode = 1;
    '';
}
