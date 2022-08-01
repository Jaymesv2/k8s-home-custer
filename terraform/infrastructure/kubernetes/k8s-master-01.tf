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

  hostname = "k8s-controller-01"
  domain   = var.domain

  cloudinit_pool_name = data.terraform_remote_state.hypervisors.outputs.kvm1_pool_name
  disk_base_volume_id = data.terraform_remote_state.hypervisors.outputs.kvm1_os_images["debian_10"]

  network_ip_address     = "10.0.10.41"
  network_gateway_ip     = var.network_gateway_ip
  network_nameserver_ips = var.network_nameserver_ips

  host_root_password = random_password.k8s-controller-01.result
  host_admin_users   = local.host_admin_users
}



resource "aws_instance" "machine" {
    ami             = module.nixos_image.ami
    instance_type   = "t3.micro"
    security_groups = [ aws_security_group.ssh_and_egress.name ]
    key_name        = aws_key_pair.generated_key.key_name

    root_block_device {
        volume_size = 50 # GiB
    }
}

module "nixos_image" {
    source  = "git::https://github.com/tweag/terraform-nixos.git//aws_image_nixos?ref=5f5a0408b299874d6a29d1271e9bffeee4c9ca71"
    release = "20.09"
}

resource "aws_security_group" "ssh_and_egress" {
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
}

resource "tls_private_key" "state_ssh_key" {
    algorithm = "RSA"
}

resource "local_file" "machine_ssh_key" {
    sensitive_content = tls_private_key.state_ssh_key.private_key_pem
    filename          = "${path.module}/id_rsa.pem"
    file_permission   = "0600"
}

resource "aws_key_pair" "generated_key" {
    key_name   = "generated-key-${sha256(tls_private_key.state_ssh_key.public_key_openssh)}"
    public_key = tls_private_key.state_ssh_key.public_key_openssh
}


output "public_dns" {
    value = aws_instance.machine.public_dns
}

