# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" "aes_x86_64" "aesni_intel" "cryptd" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "v4l2loopback" ];
  boot.extraModulePackages = [ pkgs.linuxPackages_latest.v4l2loopback ];
  boot.extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 video_nr=9 card_label="OBS Virtual Output"
    '';
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/3624849c-d896-49c1-8089-a5ec19d607df";
      fsType = "btrfs";
      options = [ "subvol=nixos" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/64905e66-de9d-4269-862d-2560465bb487";
  boot.initrd.luks.devices."swap".device = "/dev/disk/by-uuid/0ac23874-84fb-4e47-b270-221c0c8f672e";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9CC3-5E76";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/f62aa82a-a8a1-4c88-9749-210efdbd2144"; }
    ];

  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  hardware.ckb-next.enable = true;

  # My usb sound card is 44100Hz
  # This fixes crackling when adjusting playback volume on youtube
  hardware.pulseaudio.daemon.config = {
    default-sample-rate = "44100";
    avoid-resampling = "true";
  };

  # Make steam detect my DualShock 4 "Slim" controller (and others for reference)
  services.udev.extraRules = ''
    # DualShock 4 over USB hidraw
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
    # DualShock 4 wireless adapter over USB hidraw
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0666"
    # DualShock 4 Slim over USB hidraw
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
    # DualShock 4 over bluetooth hidraw
    KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0666"
    # DualShock 4 Slim over bluetooth hidraw
    KERNEL=="hidraw*", KERNELS=="*054C:09CC*", MODE="0666"
  '';
}
