## This is only a sample terraform.tfvars file.
## Uncomment and change the below variables according to your specific environment

#####################################################################################################################
##### Variables 5-26 are populated automically if terraform is ran via ZSEC bash script.   ##### 
##### Modifying the variables in this file will override any inputs from ZSEC             #####
#####################################################################################################################

#####################################################################################################################
##### Optional: ZPA Provider Resources. Skip to step 3. if you already have an  #####
##### App Connector Group + Provisioning Key.                                   #####
#####################################################################################################################

## 1. ZPA App Connector Provisioning Key variables. Uncomment and replace default values as desired for your deployment.
##    For any questions populating the below values, please reference: 
##    https://registry.terraform.io/providers/zscaler/zpa/latest/docs/resources/zpa_provisioning_key

#enrollment_cert                                = "Connector"
#provisioning_key_name                          = "new_key_name"
#provisioning_key_enabled                       = true
#provisioning_key_max_usage                     = 10

## 2. ZPA App Connector Group variables. Uncomment and replace default values as desired for your deployment. 
##    For any questions populating the below values, please reference: 
##    https://registry.terraform.io/providers/zscaler/zpa/latest/docs/resources/zpa_app_connector_group

#app_connector_group_name                       = "new_group_name"
#app_connector_group_description                = "group_description"
#app_connector_group_enabled                    = true
#app_connector_group_country_code               = "US"
#app_connector_group_latitude                   = "37.3382082"
#app_connector_group_longitude                  = "-121.8863286"
#app_connector_group_location                   = "San Jose, CA, USA"
#app_connector_group_upgrade_day                = "SUNDAY"
#app_connector_group_upgrade_time_in_secs       = "66600"
#app_connector_group_override_version_profile   = true
#app_connector_group_version_profile_id         = "2"
#app_connector_group_dns_query_type             = "IPV4_IPV6"


#####################################################################################################################
##### Optional: ZPA Provider Resources. Skip to step 5. if you added values for steps 1. and 2. #####
##### meaning you do NOT have a provisioning key already.                                       #####
#####################################################################################################################

## 3. By default, this script will create a new App Connector Group Provisioning Key.
##     Uncomment if you want to use an existing provisioning key (true or false. Default: false)

#byo_provisioning_key                           = true

## 4. Provide your existing provisioning key name. Only uncomment and modify if you set byo_provisioning_key to true

#byo_provisioning_key_name                      = "key-name-from-zpa-portal"


#####################################################################################################################
##### Cloud Init Userdata Provisioning variables for VAPP Properties  #####
#####################################################################################################################

## 5. Zscaler Branch Connector Provisioning URL E.g. connector.zscaler.net/api/v1/provUrl?name=vsphere_prov_url

#bc_vm_prov_url                         = ["connector.zscaler.net/api/v1/provUrl?name=vsphere_prov_url"]

## 6. Zscaler provisioning user account

#bc_username                            = "replace-with-bc-deployment-user"

## 7. Zscaler provisioning user password

#bc_password                            = "replace-with-bc-deployment-password"

## 8. Zscaler Branch Connector API Key

#bc_api_key                             = "replace-with-api-key"

#####################################################################################################################
##### Only required if statically setting network connectivity for Branch Connector VMs  #####
##### Skip if VMs/provisioning template is configured for DHCP                           #####
#####################################################################################################################

## 9. IP address for BC management interface if statically setting via provisioning url. Leave blank if using DHCP

#mgmt_ip                                = ["10.0.0.5"]

## 10. Network mask for BC management interface if statically setting via provisioning url. Leave blank if using DHCP

#mgmt_netmask                           = "255.255.255.0"

## 11. Default gateway for BC management interface if statically setting via provisioning url. Leave blank if using DHCP

#mgmt_gateway                           = "10.0.0.1"

## 12. Primary/Secondary DNS servers for BC management interface if statically setting via provisioning url. Leave blank if using DHCP

#dns_servers                            = ["10.0.0.100","10.0.0.101"]

## 13. Primary DNS suffix for BC management interface if statically setting via provisioning url. Leave blank if using DHCP

#dns_suffix                             = "internal.corp.com"

## 14. IP address for BC management interface if statically setting via provisioning url. Leave blank if using DHCP

#control_ip                             = ["10.0.0.6"]

## 15. Network mask for BC management interface if statically setting via provisioning url. Leave blank if using DHCP

#control_netmask                        = "255.255.255.0"

## 16. Default gateway for BC management interface if statically setting via provisioning url. Leave blank if using DHCP

#control_gateway                        = "10.0.0.1"

#####################################################################################################################
##### vCenter infrastructure variables  #####
#####################################################################################################################

## 17. Name of the vCenter datacenter

#datacenter                             = "replace-with-datacenter-name"

## 18. Name of the vCenter datastore(s) or datastore cluster(s). You must uncomment exactly 
##    either datastore or datastore_cluster_enabled AND datastore_cluster below depending on your environment

#datastore                              = ["replace-with-datastore-name"]
#datastore_cluster_enabled              = true
#datastore_cluster"                     = ["replace-with-datastore-cluster-name"]

## 19. Name or IP address of the ESXi host(s)

#host_name                              = ["replace-with-host-ip/name"]

## 20. Optional: vCenter Resource Pool details. This is only required if you are deploying to an explicitly defined resource pool 
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

## 21. Name of the vCenter Network to associate VM NICs to

#network_name                           = "replace-with-network-name"

## 22. vCenter network adapter type configuration for VM NIC. Available options are vmxnet3 or e1000. Default: e1000
##     Uncomment the desired network apapter type to configure.

#network_adapter_type                   = "e1000"
#network_adapter_type                   = "vmxnet3"


#####################################################################################################################
##### Custom variables. Only change if required for your environment  #####
#####################################################################################################################

## 23. Name of the Zscaler Branch Connector OVA file to be used for deployment. This file name must be located in
##     examples/bc/bootstrap directory.

#ova_name                               = "branchconnector.ova"

## 24. Branch Connector Instance size selection. Uncomment bc_instance_size line with desired vm size to change
##    (Default: "small") 
##    **** NOTE - This value is used by the vm module to determine how many network interfaces, CPU, and memory
##                are required for any VM. 

#bc_instance_size                       = "small"
#bc_instance_size                       = "medium"


#####################################################################################################################
##### Custom VM Resource Provisioning variables. Only change if required for your environment  #####
#####################################################################################################################

## 25. Disk Provisioning policy. The default is to enable thin provisioning at the disk and configure at the ovf template.
##     Default: "thin"

#disk_provisioning                      = "thin"
#disk_provisioning                      = "thick"
#disk_provisioning                      = "flat"

## 26. By default, Terraform will generate a new SSH Private/Public Key Pair that can be used to access the Branch Connector VM.
##     Uncomment and enter an SSH Public Key if you would rather use your own and not create a new one.

#byo_ssh_key                            = "ssh-rsa AAAA etc"
