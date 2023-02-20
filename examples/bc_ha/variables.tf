variable "ova_name" {
  type        = string
  description = "Name of the Branch Connector OVA file"
  default     = "branchconnector.ova"
}

variable "bc_count" {
  type        = number
  description = "Default number of Branch Connector appliances to create"
  default     = 2

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

variable "compute_cluster_name" {
  type        = list(string)
  description = "Name of Compute Cluster in order to location the resource pool to deploy VM. All clusters and standalone hosts have a default root resource pool. This resource argument does not directly accept the cluster or standalone host resource. For more information, see the section on Specifying the Root Resource Pool in the vsphere_resource_pool data source documentation on using the root resource pool."
  default     = [""]
}

variable "host_name" {
  type        = list(string)
  description = "(Optional) The managed object reference ID of a host on which to place the virtual machine. See the section on virtual machine migration for more information on modifying this value. When using a vSphere cluster, if a host_system_id is not supplied, vSphere will select a host in the cluster to place the virtual machine, according to any defaults or vSphere DRS placement policies"
}

variable "disk_size" {
  type        = string
  description = "size of disk 0"
  default     = "128"
}

variable "thin_provisioned_enabled" {
  type        = bool
  description = "Whether to thin provision the VM disk or not. Default is true"
  default     = true
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

variable "scsi_type" {
  type        = string
  description = "The SCSI controller type for the virtual machine"
  default     = "lsilogic"

  validation {
    condition = (
      var.scsi_type == "lsilogic" ||
      var.scsi_type == "lsilogic-sas" ||
      var.scsi_type == "pvscsi"
    )
    error_message = "Input scsi_type must be set to a supported value."
  }
}

variable "network_name" {
  type        = string
  description = "Name of the vSphere network to deploy to"
}

variable "network_adapter_type" {
  type        = string
  description = "The network interface type. Supported types are e1000 or vmxnet3. Default is vmxnet3"
  default     = "e1000"

  validation {
    condition = (
      var.network_adapter_type == "vmxnet3" ||
      var.network_adapter_type == "e1000"
    )
    error_message = "Input network_adapter_type must be set to either e1000 or vmxnet3."
  }
}

variable "bc_instance_size" {
  type        = string
  description = "Branch Connector Instance size. Determined by and needs to match the Cloud Connector Portal provisioning template configuration"
  default     = "small"
  validation {
    condition = (
      var.bc_instance_size == "small" ||
      var.bc_instance_size == "medium" ||
      var.bc_instance_size == "large"
    )
    error_message = "Input bc_instance_size must be set to an approved value."
  }
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

variable "resource_pool_name" {
  type        = list(string)
  description = "Name of ESXi host resource group. If one is not specified, the VMware default name of 'Resources' is used"
  default     = [""]
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

variable "tls_key_algorithm" {
  type        = string
  description = "algorithm for tls_private_key resource"
  default     = "RSA"
}
