packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.4"
      source  = "github.com/hashicorp/qemu"
    }
  }
}


source "qemu" "ubuntu-2004" {
  iso_url          = "/path/to/ISO"
  iso_checksum     = "none"
  output_directory = "./builds-vm"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  disk_size        = "15G"
  format           = "qcow2"
  accelerator      = "kvm"
  ssh_username     = "vagrant"
  ssh_password     = "vagrant"
  ssh_timeout      = "60m"
  vm_name          = "ubuntu-20.04"
  net_device       = "virtio-net"
  disk_interface   = "virtio"
  boot_wait        = "10s"
  cpus             = "2"
  memory           = "2046"
  communicator     = "ssh"
  headless	   = "true"
  http_directory   = "/path/to/preseed.pkrtpl"
  boot_command	   = ["<tab> text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.pkrtpl<enter><wait>"]
}

build {
  sources = ["sources.qemu.ubuntu-2004"]

  post-processor "vagrant" {
    provider_override = "libvirt"
  }
}
