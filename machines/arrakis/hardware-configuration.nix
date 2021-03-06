# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [ "resume=/dev/disk/by-label/arrakisswap" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "arrakispool/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "arrakispool/home";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/114E-2DCB";
      fsType = "vfat";
    };

  swapDevices = [ { device = "/dev/disk/by-label/arrakisswap"; } ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
