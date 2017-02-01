## azure-templates

This directory contains [ARM templates](https://azure.microsoft.com/en-gb/resources/templates/) that provision XAP data grid on Azure VMs

### Pre-requirements

You need to generate [Azure service principal](https://github.com/Azure/acs-engine/blob/master/docs/serviceprincipal.md) 

### Deploying notes

You can deploy the following templates through [Azure Portal](https://portal.azure.com) or [Azure XPlat CLI 0.10.0](https://github.com/Azure/azure-xplat-cli/releases/tag/v0.10.0-May2016):

- xap-docker-ubuntu-azure.json
- xap-k8s-ubuntu-azure.json

To deploy them using the portal you need to create a [custom deployment](https://portal.azure.com/#create/Microsoft.Template), copy XAP azure template content to the editor and save it.

To deploy them using the CLI you need to:

- Install the Azure CLI 0.10.0
- Configure the Azure CLI to use your Azure account and subscription

```bash
azure login
azure account set "<SUBSCRIPTION NAME OR ID>"
azure config mode arm
```

#### Run XAP components with Docker on Azure

With `xap-docker-ubuntu-azure.json` template you will be able to deploy an Ubuntu VM with an XAP docker container, such as:

- XAP management node (1 LUS, 1 GSM and n GSCs)
- XAP compute node (n GSCs)
- GS web management console

If you use the Azure CLI you can:

- Edit parameters placeholders and default values in `xap-docker-ubuntu-azure-parameters.json`. Ensure that 'xapLicense' parameter points to your XAP license key.
You might want to change value for 'xapNodeType' parameter to be set to either 'xap-compute-node' or 'gs-webui'. In case of 'xap-compute-node' deployment you will have to edit 'xapLookupLocators' and 'gscCount' parameters values as well.

- Run the following commands:

```bash
azure group create --name="<RESOURCE_GROUP_NAME>" --location="<LOCATION>"

azure group deployment create --name="<DEPLOYMENT NAME>" --resource-group="<RESOURCE_GROUP_NAME>" --template-file="azure-templates/xap-docker-ubuntu-azure.json" --parameters-file="azure-templates/xap-docker-ubuntu-azure-parameters.json"
```

#### Run XAP data-grid with Kubernetes on Azure

`xap-k8s-ubuntu-azure.json` template allows deploying an [Azure Container Service cluster with Kubernetes orchestrator](https://azure.microsoft.com/en-us/services/container-service/) and XAP deployments.

- You will need to have an SSH RSA public key. You may follow instructions in acs-engine documentation (https://github.com/Azure/azure-quickstart-templates/blob/master/101-acs-dcos/docs/SSHKeyManagement.md#ssh-key-generation) in order to create a key pair.
- You will need to build XAP docker image using the Dockerfile and push the image to some [private docker registry server](https://docs.docker.com/registry/deploying/). 

In case you are using the Azure CLI:

- You will need to provide correct paramaters values in `xap-k8s-ubuntu-azure-parameters.json` 
- Run the following commands:

```bash
azure group create --name="<RESOURCE_GROUP_NAME>" --location="<LOCATION>"

azure group deployment create --name="<DEPLOYMENT NAME>" --resource-group="<RESOURCE_GROUP_NAME>" --template-file="azure-templates/xap-k8s-ubuntu-azure.json" --parameters-file="azure-templates/xap-k8s-ubuntu-azure-parameters.json"
```
    
    
  