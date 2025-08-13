{ pkgs, ... }: {
  programs = {
    thunderbird.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "simon" ];
    };
    light.enable = true;
  };

  xdg.portal = {
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
      kdePackages.xdg-desktop-portal-kde
    ];
    enable = true;
  };

  services.flatpak = {
    enable = true;
    packages = [
      "com.slack.Slack"
      "com.discordapp.Discord"
      "com.mongodb.Compass"
      "com.spotify.Client"
      "org.flameshot.Flameshot"
      "org.signal.Signal"
      "com.github.tchx84.Flatseal"
    ];
  };

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [ iosevka-bin nerd-fonts.iosevka-term ];

  environment.systemPackages = with pkgs; [
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
    waybar
    iosevka-bin
    nerd-fonts.iosevka-term
    firefox
    vscode
    wdisplays
    adwaita-icon-theme
    glib
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    kdePackages.xdg-desktop-portal-kde
    xdg-desktop-portal-wlr
    pulseaudio
    libnotify
  ];

  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment the following
    #jack.enable = true;
  };
}
