# Zscaler Branch Connector Cluster Infrastructure Setup

**Terraform configurations and modules for deploying Zscaler Branch Connector Cluster in VMware ESXi.**

## Prerequisites (You will be prompted for VMware vSphere credentials during deployment)

### vCenter requirements
1. vCenter Administrator credentials. For full list of Terraform Provider for VMware vSphere required privileges, refer to the documentation [here.](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs#notes-on-required-privileges)
- Admin username
- Admin password 
- vCenter server name (FQDN or IP)

Note: Profile-driver Storage access:<br>
The provider implementation requires the ability to read storage profiles from vSphere for some resource and data source operations. Ensure that the user account used for Terraform is provided the Profile-driven Storage > View (StorageProfile.View) privilege to be able to read the available storage policies.<br>

### Zscaler requirements
2. A valid Zscaler Branch Connector provisioning URL generated from the Branch Connector Portal
3. Zscaler Branch Connector Credentials (api key, username, password)
4. Download the Branch Connector OVA and save to the desired deployment type 'bootstrap' directory.

### Branch Connector + App Connector requirements
5. A valid Zscaler Private Access subscription and portal access
6. Zscaler ZPA API Keys. Details on how to find and generate ZPA API keys can be located [here:](https://help.zscaler.com/zpa/about-api-keys)
- Client ID
- Client Secret
- Customer ID
7. (Optional) An existing App Connector Group and Provisioning Key. Otherwise, you can follow the prompts in the examples terraform.tfvars to create a new Connector Group and Provisioning Key

See: [Zscaler Zero Trust SD-WAN Datasheet](https://www.zscaler.com/resources/data-sheets/zscaler-zero-trust-sd-wan.pdf) for more information.


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


## Deploying the cluster
(The automated tool can run only from MacOS and Linux. If required to run from a Windows workstation, the preferred method is executing within a Windows Subsystem Linux (WSL) environment).   

```
bash
cd examples
Optional: Edit the terraform.tfvars file under your desired deployment type (ie: bc) to setup your Branch Connector (Details are documented inside the file)
- ./zsec up
- enter <desired deployment type>
- follow prompts for any additional configuration inputs. *keep in mind, any modifications done to terraform.tfvars first will override any inputs from the zsec script*
- script will detect client operating system and download/run a specific version of terraform in a temporary bin directory
- inputs will be validated and terraform init/apply will automatically exectute.
- verify all resources that will be created/modified and enter "yes" to confirm
```

**Deployment Types**

```
Deployment Type: (bc|bc_ha|bc_ac|bc_ac_ha):
bc: Creates a fully autoprovisioned Branch Connector VM in vCenter.
bc_ha: Creates 2 Branch Connector VMs in active-passive HA configuration in vCenter.
bc_ac: Creates a fully autoprovisioned Branch Connector w/ integrated App Connector VM in vCenter
bc_ha_ac: Creates 2 Branch Connector w/ integrated App Connector VMs in active-passive HA configuration in vCenter

## Destroying the cluster
```
cd examples
- ./zsec destroy
- verify all resources that will be destroyed and enter "yes" to confirm
```

## Notes
```
1. For auto approval set environment variable **AUTO_APPROVE** or add `export AUTO_APPROVE=1`
2. For deployment type set environment variable **dtype** to the required deployment type or add `export dtype=bc`
3. To provide new credentials or region, delete the autogenerated .zsecrc file in your current working directory and re-run zsec.
```
