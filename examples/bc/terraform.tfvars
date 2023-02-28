## This is only a sample terraform.tfvars file.
## Uncomment and change the below variables according to your specific environment

#####################################################################################################################
##### Variables 1-19 are populated automically if terraform is ran via ZSEC bash script.   ##### 
##### Modifying the variables in this file will override any inputs from ZSEC             #####
#####################################################################################################################

#####################################################################################################################
##### Cloud Init Userdata Provisioning variables for VAPP Properties  #####
#####################################################################################################################

## 1. Zscaler Branch Connector Provisioning URL E.g. connector.zscaler.net/api/v1/provUrl?name=vsphere_prov_url

#bc_vm_prov_url                         = ["connector.zscaler.net/api/v1/provUrl?name=vsphere_prov_url"]


## 2. Zscaler provisioning user account

#bc_username                            = "replace-with-bac-admin-name"


## 3. Zscaler provisioning user password

#bc_password                            = "replace-with-bac-admin-password"


## 4. Zscaler Branch Connector API Key

#bc_api_key                             = "replace-with-api-key"

#####################################################################################################################
##### Only required if statically setting network connectivity for Branch Connector VMs  #####
##### Skip if VMs/provisioning template is configured for DHCP                           #####
#####################################################################################################################

## 5. IP address for BC management interface if statically setting via provisioning url. Leave blank if using DHCP

#mgmt_ip                                = ["10.0.0.5"]

## 6. Network mask for BC management interface if statically setting via provisioning url. Leave blank if using DHCP

#mgmt_netmask                           = "255.255.255.0"

## 7. Default gateway for BC management interface if statically setting via provisioning url. Leave blank if using DHCP

#mgmt_gateway                           = "10.0.0.1"

## 8. Primary/Secondary DNS servers for BC management interface if statically setting via provisioning url. Leave blank if using DHCP

#dns_servers                            = ["10.0.0.100","10.0.0.101"]

## 9. Primary DNS suffix for BC management interface if statically setting via provisioning url. Leave blank if using DHCP

#dns_suffix                             = "internal.corp.com"


#####################################################################################################################
##### vCenter infrastructure variables  #####
#####################################################################################################################

## 10. Name of the vCenter datacenter

#datacenter                             = "replace-with-datacenter-name"

## 11. Name of the vCenter datastore(s) or datastore cluster(s). You must uncomment exactly 
##    either datastore or datastore_cluster_enabled AND datastore_cluster below depending on your environment

#datastore                              = ["replace-with-datastore-name"]
#datastore_cluster_enabled              = true
#datastore_cluster"                     = ["replace-with-datastore-cluster-name"]

## 12. Name or IP address of the ESXi host(s)

#host_name                              = ["replace-with-host-ip/name"]

## 13. Optional: vCenter Resource Pool details. This is only required if you are deploying to an explicitly defined resource pool 
##    and/or Compute Cluster.

##    Example-1: If deploying to a compute cluster with default resource pool, uncomment and populate only compute_cluster_name
##               and compute_cluster_enabled
##    Example-2: If deploying to a compute cluster with a custom resource pool, uncomment and populate both computer_cluster_name
##               and compute_cluster_enabled as well as resource_pool_name
##    Example-3: If deploying to a standalone host with default resource pool, do not uncomment/modify any variable below
##    Example-4: If deploying to a standalone host with a custom resource pool, uncomment and populate only resource_pool_name

#compute_cluster_enabled                = true
#compute_cluster_name                   = ["replace-with-compute-cluster-name"] 
#resource_pool_name                     = ["replace-with-resource-pool-name"]

## 14. Name of the vCenter Network to associate VM NICs to

#network_name                           = "replace-with-network-name"

## 15. vCenter network adapter type configuration for VM NIC. Available options are vmxnet3 or e1000. Default: e1000
##     Uncomment the desired network apapter type to configure.

#network_adapter_type                   = "e1000"
#network_adapter_type                   = "vmxnet3"


#####################################################################################################################
##### Custom variables. Only change if required for your environment  #####
#####################################################################################################################

## 16. Name of the Zscaler Branch Connector OVA file to be used for deployment. This file name must be located in
##     examples/bc/bootstrap directory.

#ova_name                               = "branchconnector.ova"

## 17. Branch Connector Instance size selection. Uncomment bc_instance_size line with desired vm size to change
##    (Default: "small") 
##    **** NOTE - This value is used by the vm module to determine how many network interfaces, CPU, and memory
##                are required for any VM. 

#bc_instance_size                       = "small"
#bc_instance_size                       = "medium"


#####################################################################################################################
##### Custom VM Resource Provisioning variables. Only change if required for your environment  #####
#####################################################################################################################

## 18. Disk Provisioning policy. The default is to enable thin provisioning at the disk and configure at the ovf template.
##     If you want something other than thin provisioned, uncomment thin_provisioning_enabled and one of either "thick"
##     or "flat" for disk_provisioning.

#thin_provisioned_enabled               = false

#disk_provisioning                      = "thick"
#disk_provisioning                      = "flat"


## 19. The SCSI controller type for the virtual machine. Default is lsilogic.
##     Uncomment to select the desired configuration for your environment.

#scsi_type                              = "lsilogic"
#scsi_type                              = "lsilogic-sas"
#scsi_type                              = "pvscsi"    
