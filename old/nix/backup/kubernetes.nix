{ config, pkgs, ... }:
let 
  kubeMasterIp = "10.0.10.20";
  kubeMasterHostname = "api.kube";
  kubeMasterAPIServerPort = 6443;
in
{
  networking.extraHosts = "${kubeMasterIp} ${kubeMasterHostname}";

  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  #virtualisation.docker = {
    #enable = true;

    #enableNvidia = true;
    #extraOptions = "--default-runtime=nvidia";
  #};

  services.kubernetes = {
    roles = ["master" "node"];
    masterAddress = kubeMasterHostname;
    apiserverAddress = "https://${kubeMasterHostname}:$toString kubeMasterAPIServerPort}";
    easyCerts = true;
    clusterCidr = "172.20.0.0/16";
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kubeMasterIp;
    };
    flannel.enable = false;

    addons.dns.enable = true;

  };
}

