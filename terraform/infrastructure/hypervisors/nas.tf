provider "libvirt" {
  alias = "nas"
  uri   = "qemu+ssh://${data.sops_file.hypervisors.data["nas.user"]}@${data.sops_file.hypervisors.data["nas.ip"]}/system"
}

resource "libvirt_pool" "nas" {
  provider = libvirt.nas

  name = "default"
  type = "dir"
  path = "/zroot/vms/images/store/"
}

resource "libvirt_network" "nas" {
  provider = libvirt.nas

  name      = "default"
  mode      = "nat"
  domain    = "default"
  addresses = ["0.0.0.0/0"]
  autostart = true
}

resource "libvirt_volume" "nas_os_images" {
  for_each = var.os_images

  provider = libvirt.nas

  name   = "${replace(each.key, "_", "-")}.${var.os_image_format}"
  pool   = libvirt_pool.nas.name
  source = each.value
  format = var.os_image_format
}

output "nas_pool_name" {
  value = libvirt_pool.nas.name
}

output "nas_os_images" {
  value = {
    for os, volume in libvirt_volume.nas_os_images : os => volume.id
  }
}
