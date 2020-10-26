# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "vfio-pci" ];
  boot.extraModulePackages = [ ];
  # modeset screws up Intel AMT Remote Contrl for some reason
  boot.kernelParams = [ "intel_iommu=on nomodeset" ];

  # handle case where too many hardlinks in nix store for ZFS.
  boot.loader.grub.copyKernels = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable ZFS for booting
  boot.supportedFilesystems = [ "zfs" ];

  # ZFS requires a networking hostID
  networking.hostId = "526b897e";

  # Manually configure networking, which I _think_ is cattle configuration
  networking.interfaces.eno1.ipv4 = {
    addresses = [ { address = "192.168.10.3"; prefixLength = 24; } ];
  };

  networking.nameservers = [ "192.168.10.1"];
  networking.defaultGateway = {
    address = "192.168.10.1";
    interface = "br-trunk";
  };
  
  networking.bridges = {
    br-trunk = {
      # Trunk
      interfaces = [ "enp5s0f2" ];
    };
  };

  networking.interfaces.br-trunk.routes = [
    { address = "192.168.10.1"; prefixLength = 32; }
  ];
  
  fileSystems."/" =
    { device = "rootpool/safe/ROOT/nixos";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/EFIBOOT0";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "rootpool/safe/home";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "rootpool/local/nix";
      fsType = "zfs";
    };

  fileSystems."/var" =
    { device = "rootpool/safe/var";
      fsType = "zfs";
    };

  boot.zfs.extraPools = [ "vmpool" ];

  swapDevices =
    [ { device = "/dev/disk/by-label/swappart"; }
    ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
