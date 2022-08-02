{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    vim_configurable
  ];
  # editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-fzf
      vim-gitgutter
      nerdtree
      vim-multiple-cursors
      #nvim-lint
      vim-fugitive
      onedarkpro-nvim
    ];
    configure = ''
      let mapleader = ","
      
      #let g:vimtex_view_method = 'zathura'

      set number relativenumber

      syntax on
      filetype plugin indent on
      map <leader>0 :setlocal spell! spelllang=en_us<CR>

      set wildmode=longest,list,full
      set splitbelow splitright

      map <leader>n :NERDTreeToggle<CR>

      noremap <leader>y "*y
      noremap <leader>p "*p
      noremap <leader>Y "+y
      noremap <leader>P "+p

      autocmd VimLeave \lc %
    '';
  };
}

