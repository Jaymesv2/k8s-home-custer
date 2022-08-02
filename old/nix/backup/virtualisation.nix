{ config, pkgs, ... }:
{
  networking.bridges.br0.interfaces = [ "enp6s0" ];
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "br0" ];
  };
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];
}


