{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    prometheus
    prometheus-node-exporter
  ];

  services.prometheus = {
    enable = true;
    exporters = {
      node = {
        enable = true;
	enabledCollectors = [ 
	  "systemd" 
	];
      };
    };
  };
}

