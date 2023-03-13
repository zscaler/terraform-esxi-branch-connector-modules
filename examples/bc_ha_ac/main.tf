################################################################################
# 1. Generate a unique random string for resource name assignment
################################################################################
resource "random_string" "suffix" {
  length  = 8
  upper   = false
  special = false
}

################################################################################
# The following lines generates a new SSH key pair and stores the PEM file 
# locally. The public key output is used as the instance_key passed variable 
# to the vm modules for admin_ssh_key public_key authentication.
# This is not recommended for production deployments. Please consider modifying 
# to pass your own custom public key file located in a secure location.   
################################################################################
# private key for login
resource "tls_private_key" "key" {
  count     = var.byo_ssh_key == "" ? 1 : 0
  algorithm = var.tls_key_algorithm
}

# write private key to local pem file
resource "local_file" "private_key" {
  count           = var.byo_ssh_key == "" ? 1 : 0
  content         = tls_private_key.key[0].private_key_pem
  filename        = "../${var.name_prefix}-key-${random_string.suffix.result}.pem"
  file_permission = "0600"
}


################################################################################
# 2. Create specified number of Branch Connector VMs from OVA template.
#    Also, referenced userdata ISO file is used from CD-ROM mounting via
#    automatic upload to datastore(s) or from existing path/name directly. 
################################################################################
module "bc_vm" {
  source                    = "../../modules/terraform-zsbc-bcvm-esxi"
  bc_count                  = var.bc_count
  name_prefix               = var.name_prefix
  resource_tag              = random_string.suffix.result
  datastore_cluster_enabled = var.datastore_cluster_enabled
  datacenter                = var.datacenter
  datastore                 = var.datastore
  datastore_cluster         = var.datastore_cluster
  compute_cluster_enabled   = var.compute_cluster_enabled
  compute_cluster_name      = var.compute_cluster_name
  host_name                 = var.host_name
  local_ovf_path            = fileexists("bootstrap/${var.ova_name}") ? "${abspath(path.root)}/bootstrap/${var.ova_name}" : "OVA file name and/or path is wrong. Please fix and re-run terraform"
  network_adapter_type      = var.network_adapter_type
  bc_instance_size          = var.bc_instance_size
  network_name              = var.network_name
  resource_pool_name        = var.resource_pool_name
  bc_vm_prov_url            = var.bc_vm_prov_url
  bc_api_key                = var.bc_api_key
  bc_username               = var.bc_username
  bc_password               = var.bc_password
  mgmt_ip                   = var.mgmt_ip
  mgmt_netmask              = var.mgmt_netmask
  mgmt_gateway              = var.mgmt_gateway
  dns_servers               = var.dns_servers
  dns_suffix                = var.dns_suffix
  ssh_key                   = try(tls_private_key.key[0].public_key_openssh, var.byo_ssh_key)
  ac_enabled                = var.ac_enabled
  ac_prov_key               = module.zpa_provisioning_key.provisioning_key
  control_ip                = var.control_ip
  control_netmask           = var.control_netmask
  control_gateway           = var.control_gateway
}



################################################################################
# 3. Create ZPA App Connector Group
################################################################################
module "zpa_app_connector_group" {
  count                                        = var.byo_provisioning_key == true ? 0 : 1 # Only use this module if a new provisioning key is needed
  source                                       = "../../modules/terraform-zpa-app-connector-group"
  app_connector_group_name                     = coalesce(var.app_connector_group_name, "zs-bc-esxi-${var.datacenter}")
  app_connector_group_description              = "${var.app_connector_group_description}-${var.datacenter}"
  app_connector_group_enabled                  = var.app_connector_group_enabled
  app_connector_group_country_code             = var.app_connector_group_country_code
  app_connector_group_latitude                 = var.app_connector_group_latitude
  app_connector_group_longitude                = var.app_connector_group_longitude
  app_connector_group_location                 = var.app_connector_group_location
  app_connector_group_upgrade_day              = var.app_connector_group_upgrade_day
  app_connector_group_upgrade_time_in_secs     = var.app_connector_group_upgrade_time_in_secs
  app_connector_group_override_version_profile = var.app_connector_group_override_version_profile
  app_connector_group_version_profile_id       = var.app_connector_group_version_profile_id
  app_connector_group_dns_query_type           = var.app_connector_group_dns_query_type
}


################################################################################
# 4. Create ZPA Provisioning Key (or reference existing if byo set)
################################################################################
module "zpa_provisioning_key" {
  source                            = "../../modules/terraform-zpa-provisioning-key"
  enrollment_cert                   = var.enrollment_cert
  provisioning_key_name             = coalesce(var.provisioning_key_name, "zs-bc-esxi-${var.datacenter}")
  provisioning_key_enabled          = var.provisioning_key_enabled
  provisioning_key_association_type = var.provisioning_key_association_type
  provisioning_key_max_usage        = var.provisioning_key_max_usage
  app_connector_group_id            = try(module.zpa_app_connector_group[0].app_connector_group_id, "")
  byo_provisioning_key              = var.byo_provisioning_key
  byo_provisioning_key_name         = var.byo_provisioning_key_name
}
