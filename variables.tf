variable "vsphere_user" {
  description = "vSphere user"
  default = "administrator@vsphere.local"
}
variable "vsphere_password" {
  description = "Password for vSphere user"
  default = "G@me1234"
}
variable "vsphere_server" {
  description = "vSphere host name"
  default = "vcenter.nopnithi.lab"
}
variable "dns_servers" {
  description = "DNS Server IPs"
  default = ["8.8.8.8", "8.8.4.4"]
}
variable "vm_count" {
  description = "Number of VMs we want to spin up"
  default = 3
}