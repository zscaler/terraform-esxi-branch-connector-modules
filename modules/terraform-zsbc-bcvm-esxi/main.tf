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
  count         = local.vm_nic_count
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
# Create Virtual Machine resources
################################################################################
resource "vsphere_virtual_machine" "bc_vm" {
  count                      = var.bc_count
  name                       = "${var.name_prefix}-bc-vm-${count.index + 1}-${var.resource_tag}"
  datastore_cluster_id       = var.datastore_cluster_enabled == true ? element(data.vsphere_datastore_cluster.datastore_cluster[*].id, count.index) : null
  datastore_id               = var.datastore_cluster_enabled == false ? element(data.vsphere_datastore.datastore[*].id, count.index) : null
  resource_pool_id           = element(data.vsphere_resource_pool.pool[*].id, count.index)
  num_cpus                   = local.vm_cpus
  memory                     = local.vm_memory
  datacenter_id              = data.vsphere_datacenter.datacenter.id
  host_system_id             = element(data.vsphere_host.host[*].id, count.index)
  scsi_type                  = var.scsi_type
  wait_for_guest_net_timeout = var.wait_for_guest_net_timeout
  wait_for_guest_ip_timeout  = var.wait_for_guest_ip_timeout

  disk {
    label            = "disk0"
    size             = var.disk_size
    thin_provisioned = var.thin_provisioned_enabled

  }

  dynamic "network_interface" {
    for_each = data.vsphere_network.network[*].id
    content {
      network_id   = network_interface.value
      adapter_type = var.network_adapter_type
    }
  }

  ovf_deploy {
    local_ovf_path    = var.local_ovf_path
    disk_provisioning = var.disk_provisioning
    ip_protocol       = "IPv4"
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
