{ config, pkgs, ... }:
{
  environment.systemPackages = {
    enable = true;
    dataDir = "/zroot/db/postgres/root

  };
}

