provider "libvirt" {
  alias = "nas"
  uri   = "qemu+ssh://${data.sops_file.hypervisors.data["nas.user"]}@${data.sops_file.hypervisors.data["nas.ip"]}/system"
}

resource "libvirt_pool" "zroot" {
  provider = libvirt.nas

  name = "zroot"
  type = "dir"
  path = "/zroot/vms/images/store"
}

resource "libvirt_network" "nas" {
  provider = libvirt.nas

  name      = "lanbridge"
  mode      = "bridge"
  bridge    = "virbr0"
  #domain    = "lab.jaymes.xyz"
  addresses = ["0.0.0.0/0"]
  autostart = true
}

resource "libvirt_volume" "nas_os_images" {
  for_each = var.os_images

  provider = libvirt.nas

  name   = "${replace(each.key, "_", "-")}.${var.os_image_format}"
  pool   = libvirt_pool.zroot.name
  source = each.value
  format = var.os_image_format
}

output "nas_pool_name" {
  value = libvirt_pool.zroot.name
}

output "nas_os_images" {
  value = {
    for os, volume in libvirt_volume.nas_os_images : os => volume.id
  }
}
