resource "random_password" "k8s-controller-01" {
  length  = 32
  special = false
}

module "k8s-controller-01" {
  source  = "eyulf/libvirt-virtual-machine/module"
  version = "1.0.0"

  providers = {
    libvirt = libvirt.nas
  }

  vcpus = 2
  memory = 2048

  hostname = "k8s-controller-01"
  domain   = var.domain

  cloudinit_pool_name = data.terraform_remote_state.hypervisors.outputs.nas_pool_name
  disk_base_volume_id = data.terraform_remote_state.hypervisors.outputs.nas_os_images["debian_11"]

  network_ip_address     = "10.0.10.24"
  network_gateway_ip     = var.network_gateway_ip
  network_nameserver_ips = var.network_nameserver_ips

  host_root_password = random_password.k8s-controller-01.result
  host_admin_users   = {
    "admin" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLWizAeAAB/LkAVCIzlw94ullQvJIeP3UZEL1fD1Os4SF8E+fhA/4/wgaw+z2hFdqR3QkcSTVCmYzoRd9xV4q16hFqmohMhtvWNf+6JsU7w/jd5vBg9/testAwxdoPy8aUdp1kyi7rA1Ahed2tVIXd5cxJ+nbXxPslcOtUK6+buIdFlJeI6+cBo/YKckY2NDO76ftJhPocSQBy2xPqG5yQfcAojnTY7pk1zrDzcn1gNbbcrB1tXj3qhRMyZe4Fqe86RxLQxADEyCFKMaE2n07CRxLKTLuWQpm2HkrPsf63a5G+s7L1y4mHIQOy2Sra0YtBIKxdbyghSIFJiAEEA6qSBsDcWEWMcHPhPR0s1XHFw3f08gQVruXLkVIoAeX3jX73w+RDMS32/hP2ZMNJsmS5Q2LtS3yfAX8PfHKHeXiaCyY6hwY6UoHJHd8YfsAQbiva4q+gxBVDCHpQ283xNK/hXPuyN0bIYt1YYT95yHFQnCgEh6egB2j2G13QsX7tTPalzP4VL/F2p4vOTe5gTcS93mgtcnp/s4zYzBSVmw3//Lb4EE10/VC/Zk8WnEK9jDG5odqjngFdWYQilyC8JxN0nEvInJQeQsY+YlT+PEDABm8BKq7rvMPG2Qq3nYoKE3qGi7N5lepK8ZnZ+Mrl5glXDneOFxau0OVU5qKeR8vEnw== trent@arch"
  }
}