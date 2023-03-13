################################################################################
# vSphere Data Sources populated from variable inputs to populate VM arguments
################################################################################
data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  count         = var.datastore_cluster_enabled == true ? length(var.datastore_cluster) : 0
  name          = element(var.datastore_cluster, count.index)
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  count         = var.datastore_cluster_enabled == false ? length(var.datastore) : 0
  name          = element(var.datastore, count.index)
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  count         = length(var.host_name)
  name          = element(var.host_name, count.index)
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  count         = length(var.host_name)
  name          = var.compute_cluster_enabled == false ? "/${var.datacenter}/host/${element(var.host_name, count.index)}/Resources/${element(var.resource_pool_name, count.index)}" : "/${var.datacenter}/host/${element(var.compute_cluster_name, count.index)}/Resources/${element(var.resource_pool_name, count.index)}"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


################################################################################
# Generate VM Template from Local OVF/OVA Source
################################################################################
data "vsphere_ovf_vm_template" "bc_ovf_local" {
  count             = var.bc_count
  name              = "${var.name_prefix}-bc-${count.index + 1}-ovf-template-${var.resource_tag}"
  disk_provisioning = var.disk_provisioning
  resource_pool_id  = element(data.vsphere_resource_pool.pool[*].id, count.index)
  datastore_id      = element(data.vsphere_datastore.datastore[*].id, count.index)
  host_system_id    = element(data.vsphere_host.host[*].id, count.index)
  local_ovf_path    = var.local_ovf_path
  deployment_option = local.deployment_option
  ovf_network_map = {
    "VM Network" : data.vsphere_network.network.id
  }
}

################################################################################
# Create Virtual Machine resources
################################################################################
resource "vsphere_virtual_machine" "bc_vm" {
  count                      = var.bc_count
  name                       = "${var.name_prefix}-bc-vm-${count.index + 1}-${var.resource_tag}"
  datastore_cluster_id       = var.datastore_cluster_enabled == true ? element(data.vsphere_datastore_cluster.datastore_cluster[*].id, count.index) : null
  datastore_id               = var.datastore_cluster_enabled == false ? element(data.vsphere_datastore.datastore[*].id, count.index) : null
  resource_pool_id           = element(data.vsphere_resource_pool.pool[*].id, count.index)
  num_cpus                   = element(data.vsphere_ovf_vm_template.bc_ovf_local[*].num_cpus, count.index)
  num_cores_per_socket       = element(data.vsphere_ovf_vm_template.bc_ovf_local[*].num_cores_per_socket, count.index)
  memory                     = element(data.vsphere_ovf_vm_template.bc_ovf_local[*].memory, count.index)
  datacenter_id              = data.vsphere_datacenter.datacenter.id
  host_system_id             = element(data.vsphere_host.host[*].id, count.index)
  guest_id                   = element(data.vsphere_ovf_vm_template.bc_ovf_local[*].guest_id, count.index)
  scsi_type                  = element(data.vsphere_ovf_vm_template.bc_ovf_local[*].scsi_type, count.index)
  nested_hv_enabled          = element(data.vsphere_ovf_vm_template.bc_ovf_local[*].nested_hv_enabled, count.index)
  wait_for_guest_net_timeout = var.wait_for_guest_net_timeout
  wait_for_guest_ip_timeout  = var.wait_for_guest_ip_timeout

  dynamic "network_interface" {
    for_each = local.vm_nic_count
    content {
      network_id   = data.vsphere_network.network.id
      adapter_type = var.network_adapter_type
    }
  }

  ovf_deploy {
    local_ovf_path    = element(data.vsphere_ovf_vm_template.bc_ovf_local[*].local_ovf_path, count.index)
    disk_provisioning = element(data.vsphere_ovf_vm_template.bc_ovf_local[*].disk_provisioning, count.index)
    ip_protocol       = "IPv4"
    deployment_option = local.deployment_option
    ovf_network_map   = element(data.vsphere_ovf_vm_template.bc_ovf_local[*].ovf_network_map, count.index)
  }

  dynamic "vapp" {
    for_each = var.ac_enabled ? ["1"] : []

    content {
      properties = {
        cc_url         = element(var.bc_vm_prov_url, count.index)
        api_key        = var.bc_api_key
        username       = var.bc_username
        password       = var.bc_password
        mgmt_ip        = element(var.mgmt_ip, count.index)
        mgmt_mask      = var.mgmt_netmask
        default_gw     = var.mgmt_gateway
        domain         = var.dns_suffix
        dns            = join(",", var.dns_servers)
        ssh_public_key = var.ssh_key
        provision_key  = var.ac_prov_key
        control_ip     = element(var.control_ip, count.index)
        control_mask   = var.control_netmask
        control_gw     = var.control_gateway
      }
    }
  }

  dynamic "vapp" {
    for_each = var.ac_enabled ? [] : ["1"]

    content {
      properties = {
        cc_url         = element(var.bc_vm_prov_url, count.index)
        api_key        = var.bc_api_key
        username       = var.bc_username
        password       = var.bc_password
        mgmt_ip        = element(var.mgmt_ip, count.index)
        mgmt_mask      = var.mgmt_netmask
        default_gw     = var.mgmt_gateway
        domain         = var.dns_suffix
        dns            = join(",", var.dns_servers)
        ssh_public_key = var.ssh_key
      }
    }
  }

  lifecycle {
    ignore_changes = [
      annotation,
      disk[0].io_share_count,
      vapp[0].properties,
    ]
  }
}
