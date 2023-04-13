<a href="https://terraform.io">
    <img src="https://raw.githubusercontent.com/hashicorp/terraform-website/master/public/img/logo-text.svg" alt="Terraform logo" title="Terraform" height="50" width="250" />
</a>
<a href="https://www.zscaler.com/">
    <img src="https://www.zscaler.com/themes/custom/zscaler/logo.svg" alt="Zscaler logo" title="Zscaler" height="50" width="250" />
</a>

Zscaler Branch Connector VMware ESXi/vSphere Terraform Modules
===========================================================================================================

# **README for VMware ESXi Terraform**
This README serves as a quick start guide to deploy Zscaler Branch Connector resources in a VMware ESXi vCenter environment using Terraform. To learn more about the resources created when deploying Branch Connector with Terraform, see [Deployment Templates for Zscaler Branch Connector](https://help.zscaler.com/cloud-branch-connector/deployment-templates-zscaler-branch-connector-app-connector). These deployment templates are intended to be fully functional and self service for production use. All modules may also be utilized as design recommendation based on the [Zscaler Zero Trust SD-WAN Datasheet](https://www.zscaler.com/resources/data-sheets/zscaler-zero-trust-sd-wan.pdf) .


## **ESXi Deployment Scripts for Terraform**

Use this repository to create the deployment resources required to deploy and operate Branch Connector in an existing VMware ESXi environment. The [examples](examples/) directory contains complete automation scripts for all deployment template solutions.

## Prerequisites

Our Deployment scripts are leveraging Terraform v1.1.9 that includes full binary and provider support for MacOS M1 chips, but any Terraform version 0.13.7 and higher should be generally supported.

- provider registry.terraform.io/hashicorp/vsphere v2.2.x
- provider registry.terraform.io/hashicorp/random v3.3.x
- provider registry.terraform.io/hashicorp/local v2.2.x
- provider registry.terraform.io/hashicorp/null v3.1.x
- provider registry.terraform.io/providers/zscaler/zpa v2.5.x

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

###  **Starter Deployment Template**

Use the [**Starter Deployment Template**](examples/bc/) to deploy your Branch Connector in an existing ESXi environment.

### **Starter Deployment Template with App Connector**

Use the [**Starter Deployment Template with App Connector**](examples/bc_ac) to deploy your combined Branch Connector + App Connector in an existing ESXi environment.

### **Starter Deployment Template with High-Availability**

Use the [**Starter Deployment Template with High-Availability**](examples/bc_ha) to deploy your Branch Connector in an existing ESXi environment. This template achieves high availability between two Branch Connectors.

### **Starter Deployment Template with App Connector and High-Availability**

Use the [**Starter Deployment Template with App Connector and High-Availability**](examples/bc_ha_ac) to deploy your combined Branch Connector + App Connector in an existing ESXi environment. This template achieves high availability between two Branch Connectors.
