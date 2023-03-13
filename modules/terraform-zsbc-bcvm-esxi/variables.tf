variable "bc_count" {
  type        = number
  description = "Default number of Branch Connector appliances to create"
  default     = 1

  validation {
    condition = (
      var.bc_count >= 1 && var.bc_count <= 2
    )
    error_message = "Input bc_count must be set to a single value between 1 and 2."
  }
}

variable "name_prefix" {
  type        = string
  description = "The name prefix for all your resources"
  default     = "zs-bc"
}

variable "resource_tag" {
  type        = string
  description = "A tag to associate to all the Branch Connector module resources"
  default     = ""
}

variable "datacenter" {
  type        = string
  description = "The name of the vSphere datacenter you want to deploy the VM to"
}

variable "datastore" {
  type        = list(string)
  description = "Datastore to deploy the VM. One of datastore_id or datastore_cluster_id must be specified."
  default     = [""]
}

variable "datastore_cluster" {
  type        = list(string)
  description = "Datastore cluster to deploy the VM. Use of datastore_cluster_id requires vSphere Storage DRS to be enabled on the specified datastore cluster."
  default     = [""]
}

variable "compute_cluster_name" {
  type        = list(string)
  description = "Name of Compute Cluster in order to location the resource pool to deploy VM. All clusters and standalone hosts have a default root resource pool. This resource argument does not directly accept the cluster or standalone host resource. For more information, see the section on Specifying the Root Resource Pool in the vsphere_resource_pool data source documentation on using the root resource pool."
  default     = [""]
}

variable "host_name" {
  type        = list(string)
  description = "(Optional) The managed object reference ID of a host on which to place the virtual machine. See the section on virtual machine migration for more information on modifying this value. When using a vSphere cluster, if a host_system_id is not supplied, vSphere will select a host in the cluster to place the virtual machine, according to any defaults or vSphere DRS placement policies"
}

variable "disk_provisioning" {
  type        = string
  description = "The disk provisioning policy. If set, all the disks included in the OVF/OVA will have the same specified policy. One of thin, flat, thick, or sameAsSource"
  default     = "thin"

  validation {
    condition = (
      var.disk_provisioning == "thin" ||
      var.disk_provisioning == "flat" ||
      var.disk_provisioning == "thick"
    )
    error_message = "Input disk_provisioning must be set to an appropriate value. See variables.tf."
  }
}

variable "network_name" {
  type        = string
  description = "Name of the vSphere network to deploy to"
}

variable "network_adapter_type" {
  type        = string
  description = "The network interface type. Supported types are e1000 or vmxnet3. Default is vmxnet3"
  default     = "vmxnet3"
  validation {
    condition = (
      var.network_adapter_type == "e1000" ||
      var.network_adapter_type == "vmxnet3"
    )
    error_message = "Input network_adapter_type must be set to an approved value."
  }
}

variable "bc_instance_size" {
  type        = string
  description = "Branch Connector Instance size. Determined by and needs to match the Cloud Connector Portal provisioning template configuration"
  default     = "small"
  validation {
    condition = (
      var.bc_instance_size == "small" ||
      var.bc_instance_size == "medium"
    )
    error_message = "Input bc_instance_size must be set to an approved value."
  }
}

variable "ac_enabled" {
  type        = bool
  description = "True/False to determine how many VM network interfaces should be provisioned"
  default     = false
}

#Locals matrix to define the number of vNICs to assign to a VM given any combination of size/features
locals {
  small_bc_nic     = var.bc_instance_size == "small" && var.ac_enabled == false ? ["1", "2"] : []
  small_bc_ac_nic  = var.bc_instance_size == "small" && var.ac_enabled == true ? ["1", "2", "3"] : []
  medium_bc_nic    = var.bc_instance_size == "medium" && var.ac_enabled == false ? ["1", "2", "3", "4"] : []
  medium_bc_ac_nic = var.bc_instance_size == "medium" && var.ac_enabled == true ? ["1", "2", "3", "4", "5"] : []

  vm_nic_count = coalescelist(local.small_bc_nic, local.small_bc_ac_nic, local.medium_bc_nic, local.medium_bc_ac_nic)
}

#Locals matrix to define the deployment type based on bc_instance_size, network_adapter_type and ac_enabled configuration
locals {
  small_e1000         = var.bc_instance_size == "small" && var.ac_enabled == false && var.network_adapter_type == "e1000" ? "small-e1000" : ""
  small_vmxnet3       = var.bc_instance_size == "small" && var.ac_enabled == false && var.network_adapter_type == "vmxnet3" ? "small-vmxnet3" : ""
  small_e1000_appc    = var.bc_instance_size == "small" && var.ac_enabled == true && var.network_adapter_type == "e1000" ? "small-e1000-appc" : ""
  small_vmxnet3_appc  = var.bc_instance_size == "small" && var.ac_enabled == true && var.network_adapter_type == "vmxnet3" ? "small-vmxnet3-appc" : ""
  medium_e1000        = var.bc_instance_size == "medium" && var.ac_enabled == false && var.network_adapter_type == "e1000" ? "medium-e1000" : ""
  medium_vmxnet3      = var.bc_instance_size == "medium" && var.ac_enabled == false && var.network_adapter_type == "vmxnet3" ? "medium-vmxnet3" : ""
  medium_e1000_appc   = var.bc_instance_size == "medium" && var.ac_enabled == true && var.network_adapter_type == "e1000" ? "medium-e1000-appc" : ""
  medium_vmxnet3_appc = var.bc_instance_size == "medium" && var.ac_enabled == true && var.network_adapter_type == "vmxnet3" ? "medium-vmxnet3-appc" : ""

  deployment_option = coalesce(local.small_e1000, local.small_vmxnet3, local.small_e1000_appc, local.small_vmxnet3_appc, local.medium_e1000, local.medium_vmxnet3, local.medium_e1000_appc, local.medium_vmxnet3_appc)
}

variable "local_ovf_path" {
  type        = string
  description = "Complete path from local file system to the Branch Connector OVA file"
  default     = "../../examples/branchconnector.ova"
}

variable "wait_for_guest_net_timeout" {
  type        = number
  description = "The amount of time, in minutes, to wait for an available guest IP address on the virtual machine. Older versions of VMware Tools do not populate this property. In those cases, this waiter can be disabled and the wait_for_guest_ip_timeout waiter can be used instead"
  default     = 0
}

variable "wait_for_guest_ip_timeout" {
  type        = number
  description = "The amount of time, in minutes, to wait for an available guest IP address on the virtual machine. This should only be used if the version VMware Tools does not allow the wait_for_guest_net_timeout waiter to be used. A value less than 1 disables the waiter"
  default     = 5
}

variable "resource_pool_name" {
  type        = list(string)
  description = "Name of ESXi host resource group. If one is not specified, the VMware default name of 'Resources' is used"
  default     = [""]
}

variable "datastore_cluster_enabled" {
  type        = bool
  description = "True/False to tell VM creation that the datastore is or is not part of a cluster. Default is false"
  default     = false
}

variable "compute_cluster_enabled" {
  type        = bool
  description = "True/False to tell VM creation that the resource pool is or is not part of a compute cluster. Default is false"
  default     = false
}

variable "bc_vm_prov_url" {
  description = "Zscaler Branch Connector Provisioning URL"
  type        = list(string)
  default     = [""]
}

variable "bc_username" {
  type        = string
  description = "Admin Username for Branch Connector Portal authentication"
  default     = ""
}

variable "bc_password" {
  type        = string
  description = "Admin Password for Branch Connector Portal authentication"
  default     = ""
  sensitive   = true
}

variable "bc_api_key" {
  type        = string
  description = "Branch Connector Portal API Key"
  default     = ""
}

variable "mgmt_ip" {
  type        = list(string)
  description = "IP address for BC management interface if statically setting via provisioning url. Leave blank if using DHCP"
  default     = [""]
}

variable "mgmt_netmask" {
  type        = string
  description = "Network mask for BC management interface if statically setting via provisioning url. Leave blank if using DHCP"
  default     = ""
}

variable "mgmt_gateway" {
  type        = string
  description = "Default gateway for BC management interface if statically setting via provisioning url. Leave blank if using DHCP"
  default     = ""
}

variable "dns_servers" {
  type        = list(string)
  description = "Primary/Secondary DNS servers for BC management interface if statically setting via provisioning url. Leave blank if using DHCP"
  default     = [""]
}

variable "dns_suffix" {
  type        = string
  description = "Primary DNS suffix for BC management interface if statically setting via provisioning url. Leave blank if using DHCP"
  default     = ""
}

variable "ssh_key" {
  type        = string
  description = "SSH Key for instances"
  default     = ""
}

variable "ac_prov_key" {
  type        = string
  description = "App Connector Provisioning Key. Only required for BC + AC deployments"
  default     = ""
}

variable "control_ip" {
  type        = list(string)
  description = "IP address for BC/AC control interface if statically setting via provisioning url. Leave blank if using DHCP"
  default     = [""]
}

variable "control_netmask" {
  type        = string
  description = "Network mask for BC/AC control interface if statically setting via provisioning url. Leave blank if using DHCP"
  default     = ""
}

variable "control_gateway" {
  type        = string
  description = "Default gateway for BC/AC control interface if statically setting via provisioning url. Leave blank if using DHCP"
  default     = ""
}
