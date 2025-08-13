{ lib, pkgs, input, ... }:
let
  ssh_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHyg+0co/X0fxa7diT1nG76SLX55Kk3QKJMMHmLgT2LO jens.nomtak@work_laptop"
  ];
in with lib; {
  users = {
    users.root = {
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = ssh_keys;
    };
    users.jensnomtak = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
        "audio"
        "plugdb"
        "libvirtd"
        "dialout"
        "networkmanager"
      ]; # Enable `sudo` for the user.
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = ssh_keys;
    };
  };

  security.sudo.extraRules = [{
    users = [ "jensnomtak" ];
    commands = [{
      command = "ALL";
      options = [ "NOPASSWD" ];
    }];
  }];

  programs = {
    ssh.startAgent = true;
    zsh = {
      enable = true;
      setOptions = [
        "NO_BG_NICE" # don't nice background tasks
        "NO_HUP"
        "NO_LIST_BEEP"
        "LOCAL_OPTIONS" # allow functions to have local options
        "LOCAL_TRAPS" # allow functions to have local traps
        "HIST_VERIFY"
        "EXTENDED_HISTORY" # add timestamps to history
        "PROMPT_SUBST"
        "COMPLETE_IN_WORD"
        "IGNORE_EOF"

        # Share history between sessions
        "APPEND_HISTORY" # adds history
        "INC_APPEND_HISTORY"
        "SHARE_HISTORY" # adds history incrementally and share it across sessions
        "HIST_REDUCE_BLANKS"
      ];
    };
  };

  nix = {
    settings = {
      allowed-users = [ "jensnomtak" ];
      trusted-users = [ "jensnomtak" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
    optimise = {
      automatic = true;
      dates = [ "01:32" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  time.timeZone = "Europe/Stockholm";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "sv_SE.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
    };
  };

  environment.systemPackages = with pkgs; [
    coreutils-prefixed
    asn
    _1password-cli
    bash
    btop
    # rocmPackages.rocm-smi # amd gpu status
    bat
    curl
    charm-freeze
    delta
    difftastic
    dfc
    dig
    dive
    eva
    fd
    file
    fzf
    gcc
    gdb
    gitAndTools.gitFull
    git-lfs
    go
    gotools
    gnumake
    gum
    htop
    iftop
    inetutils
    inotify-tools
    iotop
    jq
    killall
    libgcc
    lsof
    lz4
    moreutils
    mosh
    neovim
    nodejs_22
    perl
    pv
    pwgen
    python3
    ripgrep
    rsync
    # ruby
    rustc
    cargo
    siege
    strace
    silver-searcher
    tcpdump
    tig
    tmux
    tree
    unzip
    vim
    wget
    whois
    yq
    zip
    zsh
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "1password-cli" "terraform" ];

}
