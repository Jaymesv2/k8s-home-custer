# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    users = {
      admin = {
        uid = 1000;
	home = "/home/admin";
        group = "admin";
        isNormalUser = true;
        extraGroups = [ "wheel" "libvirtd" ];
        packages = with pkgs; [

        ];
	createHome = true;
	openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLWizAeAAB/LkAVCIzlw94ullQvJIeP3UZEL1fD1Os4SF8E+fhA/4/wgaw+z2hFdqR3QkcSTVCmYzoRd9xV4q16hFqmohMhtvWNf+6JsU7w/jd5vBg9/testAwxdoPy8aUdp1kyi7rA1Ahed2tVIXd5cxJ+nbXxPslcOtUK6+buIdFlJeI6+cBo/YKckY2NDO76ftJhPocSQBy2xPqG5yQfcAojnTY7pk1zrDzcn1gNbbcrB1tXj3qhRMyZe4Fqe86RxLQxADEyCFKMaE2n07CRxLKTLuWQpm2HkrPsf63a5G+s7L1y4mHIQOy2Sra0YtBIKxdbyghSIFJiAEEA6qSBsDcWEWMcHPhPR0s1XHFw3f08gQVruXLkVIoAeX3jX73w+RDMS32/hP2ZMNJsmS5Q2LtS3yfAX8PfHKHeXiaCyY6hwY6UoHJHd8YfsAQbiva4q+gxBVDCHpQ283xNK/hXPuyN0bIYt1YYT95yHFQnCgEh6egB2j2G13QsX7tTPalzP4VL/F2p4vOTe5gTcS93mgtcnp/s4zYzBSVmw3//Lb4EE10/VC/Zk8WnEK9jDG5odqjngFdWYQilyC8JxN0nEvInJQeQsY+YlT+PEDABm8BKq7rvMPG2Qq3nYoKE3qGi7N5lepK8ZnZ+Mrl5glXDneOFxau0OVU5qKeR8vEnw== trent@arch"];
      };
    };
    groups = {
      admin = {
        gid = 1000;
      };
    };
  };
}

