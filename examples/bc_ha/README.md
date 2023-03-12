# Zscaler "bc_ha" deployment type

This deployment type is intended for fully functional Zscaler Branch Connector virtual appliance deployments in a vCenter ESXi environment. This template is intended to deploy 2 VMs simulataneously in an Active/Passive HA configuration.

## How to deploy:

### Option 1 (guided):
From the examples directory, run the zsec bash script that walks to all required inputs.
- ./zsec up
- enter "bc_ha"
- follow the remainder of the authentication and configuration input prompts.
- script will detect client operating system and download/run a specific version of terraform in a temporary bin directory
- inputs will be validated and terraform init/apply will automatically exectute.
- verify all resources that will be created/modified and enter "yes" to confirm

### Option 2 (manual):
Modify/populate any required variable input values in bc_ha/terraform.tfvars file and save.

From bc_ha directory execute:
- terraform init
- terraform apply

## How to destroy:

### Option 1 (guided):
From the examples directory, run the zsec bash script that walks to all required inputs.
- ./zsec destroy

### Option 2 (manual):
From bc_ha directory execute:
- terraform destroy

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.7, < 2.0.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.4.0 |
| <a name="requirement_vsphere"></a> [vsphere](#requirement\_vsphere) | ~>2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.3.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 3.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bc_vm"></a> [bc\_vm](#module\_bc\_vm) | ../../modules/terraform-zsbc-bcvm-esxi | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.testbed](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bc_api_key"></a> [bc\_api\_key](#input\_bc\_api\_key) | Branch Connector Portal API Key | `string` | `""` | no |
| <a name="input_bc_count"></a> [bc\_count](#input\_bc\_count) | Default number of Branch Connector appliances to create | `number` | `2` | no |
| <a name="input_bc_instance_size"></a> [bc\_instance\_size](#input\_bc\_instance\_size) | Branch Connector Instance size. Determined by and needs to match the Cloud Connector Portal provisioning template configuration | `string` | `"small"` | no |
| <a name="input_bc_password"></a> [bc\_password](#input\_bc\_password) | Admin Password for Branch Connector Portal authentication | `string` | `""` | no |
| <a name="input_bc_username"></a> [bc\_username](#input\_bc\_username) | Admin Username for Branch Connector Portal authentication | `string` | `""` | no |
| <a name="input_bc_vm_prov_url"></a> [bc\_vm\_prov\_url](#input\_bc\_vm\_prov\_url) | Zscaler Branch Connector Provisioning URL | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_byo_ssh_key"></a> [byo\_ssh\_key](#input\_byo\_ssh\_key) | user entered SSH Public Key | `string` | `""` | no |
| <a name="input_compute_cluster_enabled"></a> [compute\_cluster\_enabled](#input\_compute\_cluster\_enabled) | True/False to tell VM creation that the resource pool is or is not part of a compute cluster. Default is false | `bool` | `false` | no |
| <a name="input_compute_cluster_name"></a> [compute\_cluster\_name](#input\_compute\_cluster\_name) | Name of Compute Cluster in order to location the resource pool to deploy VM. All clusters and standalone hosts have a default root resource pool. This resource argument does not directly accept the cluster or standalone host resource. For more information, see the section on Specifying the Root Resource Pool in the vsphere\_resource\_pool data source documentation on using the root resource pool. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_datacenter"></a> [datacenter](#input\_datacenter) | The name of the vSphere datacenter you want to deploy the VM to | `string` | n/a | yes |
| <a name="input_datastore"></a> [datastore](#input\_datastore) | Datastore to deploy the VM. One of datastore\_id or datastore\_cluster\_id must be specified. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_datastore_cluster"></a> [datastore\_cluster](#input\_datastore\_cluster) | Datastore cluster to deploy the VM. Use of datastore\_cluster\_id requires vSphere Storage DRS to be enabled on the specified datastore cluster. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_datastore_cluster_enabled"></a> [datastore\_cluster\_enabled](#input\_datastore\_cluster\_enabled) | True/False to tell VM creation that the datastore is or is not part of a cluster. Default is false | `bool` | `false` | no |
| <a name="input_disk_provisioning"></a> [disk\_provisioning](#input\_disk\_provisioning) | The disk provisioning policy. If set, all the disks included in the OVF/OVA will have the same specified policy. One of thin, flat, thick, or sameAsSource | `string` | `"thin"` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | Primary/Secondary DNS servers for BC management interface if statically setting via provisioning url. Leave blank if using DHCP | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_dns_suffix"></a> [dns\_suffix](#input\_dns\_suffix) | Primary DNS suffix for BC management interface if statically setting via provisioning url. Leave blank if using DHCP | `string` | `""` | no |
| <a name="input_host_name"></a> [host\_name](#input\_host\_name) | (Optional) The managed object reference ID of a host on which to place the virtual machine. See the section on virtual machine migration for more information on modifying this value. When using a vSphere cluster, if a host\_system\_id is not supplied, vSphere will select a host in the cluster to place the virtual machine, according to any defaults or vSphere DRS placement policies | `list(string)` | n/a | yes |
| <a name="input_mgmt_gateway"></a> [mgmt\_gateway](#input\_mgmt\_gateway) | Default gateway for BC management interface if statically setting via provisioning url. Leave blank if using DHCP | `string` | `""` | no |
| <a name="input_mgmt_ip"></a> [mgmt\_ip](#input\_mgmt\_ip) | IP address for BC management interface if statically setting via provisioning url. Leave blank if using DHCP | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_mgmt_netmask"></a> [mgmt\_netmask](#input\_mgmt\_netmask) | Network mask for BC management interface if statically setting via provisioning url. Leave blank if using DHCP | `string` | `""` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The name prefix for all your resources | `string` | `"zs-bc"` | no |
| <a name="input_network_adapter_type"></a> [network\_adapter\_type](#input\_network\_adapter\_type) | The network interface type. Supported types are e1000 or vmxnet3. Default is vmxnet3 | `string` | `"e1000"` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Name of the vSphere network to deploy to | `string` | n/a | yes |
| <a name="input_ova_name"></a> [ova\_name](#input\_ova\_name) | Name of the Branch Connector OVA file | `string` | `"branchconnector.ova"` | no |
| <a name="input_resource_pool_name"></a> [resource\_pool\_name](#input\_resource\_pool\_name) | Name of ESXi host resource group. If one is not specified, the VMware default name of 'Resources' is used | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_tls_key_algorithm"></a> [tls\_key\_algorithm](#input\_tls\_key\_algorithm) | algorithm for tls\_private\_key resource | `string` | `"RSA"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_testbedconfig"></a> [testbedconfig](#output\_testbedconfig) | Output of of all exported attributes to be written to a local file |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
