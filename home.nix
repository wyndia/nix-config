{ config, pkgs, ... }:

{
  # 必须保留的状态版本号，不要轻易修改
  home.stateVersion = "25.11"; 

  home.username = "root";
  home.homeDirectory = "/root";

  # 启用 Home Manager
  programs.home-manager.enable = true;

  # --- 1. 安装 Devbox 和其他核心工具 ---
  home.packages = with pkgs; [
    nh devbox
    git tig curl wget jq htop lazygit mosh neofetch ripgrep diff-so-fancy silver-searcher bat
    cloudflared
    gemini-cli-bin
    duckdb
  ];

  # --- 2. 配置 Fish Shell ---
  programs.fish = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      grep = "rgrep";
    };
    # 可以在这里写 config.fish 的内容
    interactiveShellInit = ''
      # set -gx FLAKE /root/nix-config
      set -gx NH_FLAKE /root/nix-config
    '';
  };
  # programs.starship.enable = true;

  # --- 3. 配置 Neovim ---
  programs.neovim = {
    enable = true;
    defaultEditor = true; # 设置为默认编辑器 ($EDITOR)
    viAlias = true;
    vimAlias = true;

    # 安装插件 (这是重点！)
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars # 语法高亮核心
      telescope-nvim    # 文件搜索神器
      gruvbox-nvim      # 主题
      vim-nix           # 写 Nix 文件的高亮
      supertab
    ];

    # 你的 init.lua 或 init.vim 配置内容
    initLua = ''
      -- 基础设置
      vim.opt.number = true
      vim.opt.relativenumber = false
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.expandtab = true
      
      -- 设置主题
      vim.cmd("colorscheme gruvbox")

      -- 这里可以写更多 Lua 配置...
    '';
  };

  # home.sessionVariables = {
  #   FLAKE = "/root/nix-config";
  #   NH_FLAKE = "/root/nix-config";
  # };
}
