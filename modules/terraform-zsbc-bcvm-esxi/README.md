# Zscaler Branch Connector / VMware ESXi VM Module

This module can be used to deploy a customized Zscaler Branch Connector VM from a local OVA/OVF template. It includes predefined vapp properties for a complete, zero-touch provisioning process.

The OVF configuration maintains a configuration mapping to automatically create the required resource allocation for the BC VM. vSphere refers to this as a "DeploymentOption". Terraform maps to this based on three user defined variables (bc_instance_size, ac_enabled, and network_adapater_type). Please refer to the table below to understand which OVF Deployment Option (column one) will get utilized based on the variable inputs (columns 2,3,4).

| (ovf) deployment option | (tf var) bc_instance_size | (tf var) ac_enabled | (tf var) network_adapter_type | CPU | Memory (GB) | Disk (GB) | NICs |
|:-----------------------:|:-------------------------:|:-------------------:|:-----------------------------:|:---:|:-----------:|:---------:|:----:|
| small-e1000             | small                     | false               | e1000                         | 2   | 4           | 128       | 2    |
| small-vmxnet3           | small                     | false               | vmxnet3                       | 2   | 4           | 128       | 2    |
| small-e1000-appc        | small                     | true                | e1000                         | 4   | 16          | 128       | 3    |
| small-vmxnet3-appc      | small                     | true                | vmxnet3                       | 4   | 16          | 128       | 3    |
| medium-e1000            | medium                    | false               | e1000                         | 4   | 8           | 128       | 4    |
| medium-vmxnet3          | medium                    | false               | vmxnet3                       | 4   | 8           | 128       | 4    |
| medium-e1000-appc       | medium                    | true                | e1000                         | 6   | 32          | 128       | 5    |
| medium-vmxnet3-appc     | medium                    | true                | vmxnet3                       | 6   | 32          | 128       | 5    |


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.7, < 2.0.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.2.0 |
| <a name="requirement_vsphere"></a> [vsphere](#requirement\_vsphere) | ~>2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vsphere"></a> [vsphere](#provider\_vsphere) | ~>2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vsphere_virtual_machine.bc_vm](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine) | resource |
| [vsphere_datacenter.datacenter](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datacenter) | data source |
| [vsphere_datastore.datastore](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datastore) | data source |
| [vsphere_datastore_cluster.datastore_cluster](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datastore_cluster) | data source |
| [vsphere_host.host](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/host) | data source |
| [vsphere_network.network](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/network) | data source |
| [vsphere_ovf_vm_template.bc_ovf_local](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/ovf_vm_template) | data source |
| [vsphere_resource_pool.pool](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/resource_pool) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ac_enabled"></a> [ac\_enabled](#input\_ac\_enabled) | True/False to determine how many VM network interfaces should be provisioned | `bool` | `false` | no |
| <a name="input_ac_prov_key"></a> [ac\_prov\_key](#input\_ac\_prov\_key) | App Connector Provisioning Key. Only required for BC + AC deployments | `string` | `""` | no |
| <a name="input_bc_api_key"></a> [bc\_api\_key](#input\_bc\_api\_key) | Branch Connector Portal API Key | `string` | `""` | no |
| <a name="input_bc_count"></a> [bc\_count](#input\_bc\_count) | Default number of Branch Connector appliances to create | `number` | `1` | no |
| <a name="input_bc_instance_size"></a> [bc\_instance\_size](#input\_bc\_instance\_size) | Branch Connector Instance size. Determined by and needs to match the Cloud Connector Portal provisioning template configuration | `string` | `"small"` | no |
| <a name="input_bc_password"></a> [bc\_password](#input\_bc\_password) | Admin Password for Branch Connector Portal authentication | `string` | `""` | no |
| <a name="input_bc_username"></a> [bc\_username](#input\_bc\_username) | Admin Username for Branch Connector Portal authentication | `string` | `""` | no |
| <a name="input_bc_vm_prov_url"></a> [bc\_vm\_prov\_url](#input\_bc\_vm\_prov\_url) | Zscaler Branch Connector Provisioning URL | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_compute_cluster_enabled"></a> [compute\_cluster\_enabled](#input\_compute\_cluster\_enabled) | True/False to tell VM creation that the resource pool is or is not part of a compute cluster. Default is false | `bool` | `false` | no |
| <a name="input_compute_cluster_name"></a> [compute\_cluster\_name](#input\_compute\_cluster\_name) | Name of Compute Cluster in order to location the resource pool to deploy VM. All clusters and standalone hosts have a default root resource pool. This resource argument does not directly accept the cluster or standalone host resource. For more information, see the section on Specifying the Root Resource Pool in the vsphere\_resource\_pool data source documentation on using the root resource pool. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_control_gateway"></a> [control\_gateway](#input\_control\_gateway) | Default gateway for BC/AC control interface if statically setting via provisioning url. Leave blank if using DHCP | `string` | `""` | no |
| <a name="input_control_ip"></a> [control\_ip](#input\_control\_ip) | IP address for BC/AC control interface if statically setting via provisioning url. Leave blank if using DHCP | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_control_netmask"></a> [control\_netmask](#input\_control\_netmask) | Network mask for BC/AC control interface if statically setting via provisioning url. Leave blank if using DHCP | `string` | `""` | no |
| <a name="input_datacenter"></a> [datacenter](#input\_datacenter) | The name of the vSphere datacenter you want to deploy the VM to | `string` | n/a | yes |
| <a name="input_datastore"></a> [datastore](#input\_datastore) | Datastore to deploy the VM. One of datastore\_id or datastore\_cluster\_id must be specified. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_datastore_cluster"></a> [datastore\_cluster](#input\_datastore\_cluster) | Datastore cluster to deploy the VM. Use of datastore\_cluster\_id requires vSphere Storage DRS to be enabled on the specified datastore cluster. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_datastore_cluster_enabled"></a> [datastore\_cluster\_enabled](#input\_datastore\_cluster\_enabled) | True/False to tell VM creation that the datastore is or is not part of a cluster. Default is false | `bool` | `false` | no |
| <a name="input_disk_provisioning"></a> [disk\_provisioning](#input\_disk\_provisioning) | The disk provisioning policy. If set, all the disks included in the OVF/OVA will have the same specified policy. One of thin, flat, thick, or sameAsSource | `string` | `"thin"` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | Primary/Secondary DNS servers for BC management interface if statically setting via provisioning url. Leave blank if using DHCP | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_dns_suffix"></a> [dns\_suffix](#input\_dns\_suffix) | Primary DNS suffix for BC management interface if statically setting via provisioning url. Leave blank if using DHCP | `string` | `""` | no |
| <a name="input_host_name"></a> [host\_name](#input\_host\_name) | (Optional) The managed object reference ID of a host on which to place the virtual machine. See the section on virtual machine migration for more information on modifying this value. When using a vSphere cluster, if a host\_system\_id is not supplied, vSphere will select a host in the cluster to place the virtual machine, according to any defaults or vSphere DRS placement policies | `list(string)` | n/a | yes |
| <a name="input_local_ovf_path"></a> [local\_ovf\_path](#input\_local\_ovf\_path) | Complete path from local file system to the Branch Connector OVA file | `string` | `"../../examples/branchconnector.ova"` | no |
| <a name="input_mgmt_gateway"></a> [mgmt\_gateway](#input\_mgmt\_gateway) | Default gateway for BC management interface if statically setting via provisioning url. Leave blank if using DHCP | `string` | `""` | no |
| <a name="input_mgmt_ip"></a> [mgmt\_ip](#input\_mgmt\_ip) | IP address for BC management interface if statically setting via provisioning url. Leave blank if using DHCP | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_mgmt_netmask"></a> [mgmt\_netmask](#input\_mgmt\_netmask) | Network mask for BC management interface if statically setting via provisioning url. Leave blank if using DHCP | `string` | `""` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The name prefix for all your resources | `string` | `"zs-bc"` | no |
| <a name="input_network_adapter_type"></a> [network\_adapter\_type](#input\_network\_adapter\_type) | The network interface type. Supported types are e1000 or vmxnet3. Default is vmxnet3 | `string` | `"vmxnet3"` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | Name of the vSphere network to deploy to | `string` | n/a | yes |
| <a name="input_resource_pool_name"></a> [resource\_pool\_name](#input\_resource\_pool\_name) | Name of ESXi host resource group. If one is not specified, the VMware default name of 'Resources' is used | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_resource_tag"></a> [resource\_tag](#input\_resource\_tag) | A tag to associate to all the Branch Connector module resources | `string` | `""` | no |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | SSH Key for instances | `string` | `""` | no |
| <a name="input_wait_for_guest_ip_timeout"></a> [wait\_for\_guest\_ip\_timeout](#input\_wait\_for\_guest\_ip\_timeout) | The amount of time, in minutes, to wait for an available guest IP address on the virtual machine. This should only be used if the version VMware Tools does not allow the wait\_for\_guest\_net\_timeout waiter to be used. A value less than 1 disables the waiter | `number` | `5` | no |
| <a name="input_wait_for_guest_net_timeout"></a> [wait\_for\_guest\_net\_timeout](#input\_wait\_for\_guest\_net\_timeout) | The amount of time, in minutes, to wait for an available guest IP address on the virtual machine. Older versions of VMware Tools do not populate this property. In those cases, this waiter can be disabled and the wait\_for\_guest\_ip\_timeout waiter can be used instead | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_ip_address"></a> [default\_ip\_address](#output\_default\_ip\_address) | The first IPv4 address that is reachable through the default gateway configured on the machine, then the first reachable IPv6 address, and then the first general discovered address if neither exists |
| <a name="output_guest_ip_addresses"></a> [guest\_ip\_addresses](#output\_guest\_ip\_addresses) | The current list of IP addresses on this machine, including the value of default\_ip\_address |
| <a name="output_id"></a> [id](#output\_id) | The UUID of the virtual machine |
| <a name="output_name"></a> [name](#output\_name) | The name of the virtual machine |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
