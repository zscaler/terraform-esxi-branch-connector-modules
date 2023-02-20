output "id" {
  description = "The UUID of the virtual machine"
  value       = vsphere_virtual_machine.bc_vm[*].id
}

output "name" {
  description = "The name of the virtual machine"
  value       = vsphere_virtual_machine.bc_vm[*].name
}

output "default_ip_address" {
  description = "The first IPv4 address that is reachable through the default gateway configured on the machine, then the first reachable IPv6 address, and then the first general discovered address if neither exists"
  value       = vsphere_virtual_machine.bc_vm[*].default_ip_address
}

output "guest_ip_addresses" {
  description = "The current list of IP addresses on this machine, including the value of default_ip_address"
  value       = vsphere_virtual_machine.bc_vm[*].guest_ip_addresses
}
