locals {

  testbedconfig = <<TB
SSH to BC-1 management
ssh -i ${try(trim(local_file.private_key[0].filename, "../"), "<user-ssh-key-pem-file>")} zsroot@${module.bc_vm.default_ip_address[0]}

SSH to BC-2 management
ssh -i ${try(trim(local_file.private_key[0].filename, "../"), "<user-ssh-key-pem-file>")} zsroot@${module.bc_vm.default_ip_address[1]}

All Branch Connector Instance names:
${join("\n", module.bc_vm.name)}

All Branch Connector Instance IDs:
${join("\n", module.bc_vm.id)}

BC-1 Primary/Mgmt IP
${module.bc_vm.default_ip_address[0]}

BC-2 Primary/Mgmt IP
${module.bc_vm.default_ip_address[1]}

BC-1 All IP Addresses
${jsonencode(module.bc_vm.guest_ip_addresses[0])}

BC-2 All IP Addresses
${jsonencode(module.bc_vm.guest_ip_addresses[1])}

TB
}

output "testbedconfig" {
  description = "Output of of all exported attributes to be written to a local file"
  value       = local.testbedconfig
}

resource "local_file" "testbed" {
  content  = local.testbedconfig
  filename = "../testbed.txt"
}
