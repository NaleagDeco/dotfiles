{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    awscli
    chefdk
    emacs
    fasd
    fd
    fzf
    git
    google-cloud-sdk
    python3
    ripgrep
    tree
    vim
    vscode
    zsh
  ];
  environment.shells = [ pkgs.zsh ];
  environment.pathsToLink = [ "/share/zsh" ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  #programs.bash.enable = true;
  programs.zsh.enable = true;
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 1;
  nix.buildCores = 1;

  imports = [ <home-manager/nix-darwin> ];
  home-manager.useUserPackages = true;

  users.users.gaelan = {
    home = "/Users/gaelan";
    description = "Gaelan D'costa";

    shell = pkgs.zsh;
  };

  home-manager.users.gaelan = {config, pkgs, ... }:
    {
      # Let Home Manager install and manage itself.
      # programs.home-manager.enable = true;
      
      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      home.stateVersion = "20.03";

      programs.emacs.enable = true;

      programs.fzf.enable = true;
      programs.fzf.enableZshIntegration = true;
      
      programs.git.enable = true;      
      programs.git.extraConfig = {
        core = {
          autocrlf = "input";
          editor = "emacsclient";
        };
        hub = {
          protocol = "https";
        };
      };
      programs.git.userEmail = "gaelan@tulip.com";
      programs.git.userName = "Gaelan D'costa";

      programs.ssh.enable = true;
      programs.ssh.compression = true;
      programs.ssh.controlMaster = "auto";
      programs.ssh.forwardAgent = false;

      programs.ssh.matchBlocks = {
        "bastion pfsense cisco" = {
          hostname = "192.168.20.2";
          localForwards = [
            {
              bind.port = 4200;
              host.address = "192.168.10.1";
              host.port = 80;
            }
            {
              bind.port = 4201;
              host.address = "192.168.10.2";
              host.port = 80;
            }
          ];
        };
        jails = {
          hostname = "192.168.10.4";
          proxyJump = "bastion";
        };
        docker = {
          hostname = "192.168.10.50";
          proxyJump = "bastion";
        };
        "bastion01-tulip-prod" = {
          hostname = "34.192.243.137";
          user = "welladmin";
        };
        tulip-servers = {
          host = "*.dev *.staging *.demo *.prod *.internal";
          proxyCommand = "ssh -q bastion01-tulip-prod -- /usr/local/bin/central_ssh.sh %h";
          user = "welladmin";
        };
      };

      programs.zsh.enable = true;
      programs.zsh.enableAutosuggestions = true;
      programs.zsh.enableCompletion = true;
      programs.zsh.autocd = true;
      programs.zsh.defaultKeymap = "emacs";
      programs.zsh.dotDir = ".config/zsh";
      programs.zsh.history = {
        extended = true;
        path = "${config.xdg.dataHome}/zsh/.zsh_history";
      };
      programs.zsh.initExtra = ''
      # initialize fasd, configures completion, hooks, aliases
      command -v fasd >/dev/null 2>&1 && eval "$(fasd --init auto)"

      # If input isn't a command but a directory, switch to it
      setopt auto_cd

      # Treat '#', '~', and '^' as part of patteerns for filename geeneration.
      setopt extended_glob

      # If a glob pattern has no matches, error instead of retaining pattern string
      setopt nomatch

      # cd will implicitly push old directory into directory stack
      setopt auto_pushd
      # Don't push multiple copies of the same directory onto directory stack.
      setopt pushd_ignore_dups

      ## Just use a stock pre-supplied prompt for now.
      autoload -Uz promptinit && promptinit && prompt redhat
n
      ## Include tdocker dir into PATH
      if [[ -d ~/workspace/dev_scripts/docker/bin ]]; then
          export PATH=$PATH:$HOME/workspace/dev_scripts/docker/bin
      fi

      ### Tulip workflow
      function tclone () {
          mkdir -p ~/workspace/$1 && git clone git@git.internal.tulip.io:$1.git ~/workspace/$1
      }

      ## If vim doesn't exist, invoke vi instead
      command -v vim --help >/dev/null 2>&1 || alias vim=vi
      '';
      
      programs.zsh.shellAliases = {
        tdl = "tdocker login";
        e = "$VISUAL";
        killemacs="emacsclient -e '(kill-emacs)'";
        pgrep="pgrep -a";
        ls="ls -FGh";
        grep="grep --colour=auto";
      };
    };
}
