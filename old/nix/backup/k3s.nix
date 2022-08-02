{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    k3s
    kubectl
  ];

  services.k3s = {
    role = "server";
    enable = true;
    extraFlags = "--cluster-cidr 172.20.0.0/16";
  };
}

