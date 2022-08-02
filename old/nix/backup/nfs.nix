{ config, pkgs, ... }:
{
  services.nfs.server.enable = true;
  services.samba = {
    enable = true;
    shares = {
      media = {
        path = "/tank/media/";
	"read only" = false;
	browseable = "yes";
	comment = "media share";
      };

    };

  };
}

