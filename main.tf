# Configure VMware vSphere Provider
provider "vsphere" {
  user = var.vsphere_user
  password = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = true
}

# Build Virtual Machine
data "vsphere_datacenter" "dc" {
  name = "Nopnithi-DC"
}
data "vsphere_datastore" "datastore" {
  name = "datastore1"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_resource_pool" "pool" {
  name = "resource-pool1"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "network" {
  name = "vlan10-blue"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "template" {
  name = "ubuntu-18-04-terraform-template"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "ubuntu-server${count.index + 1}"
  num_cpus            = 2
  memory              = 4096
  resource_pool_id    = data.vsphere_resource_pool.pool.id
  datastore_id        = data.vsphere_datastore.datastore.id
  guest_id            = data.vsphere_virtual_machine.template.guest_id
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label = "ubuntu-18-04-terraform-template.vmdk"
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
    size  = 20
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "ubuntu-server${count.index + 1}"
        domain    = "nopnithi.lab"
      }
      network_interface {
        ipv4_address = "10.1.10.${count.index + 101}"
        ipv4_netmask = 24
      }
      ipv4_gateway = "10.1.10.254"
      dns_server_list = var.dns_servers
    }
  }
}