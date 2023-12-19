# AKS Multi-Stage Deployment with Terraform, Helm, and GitHub Actions

## Overview
This project demonstrates a multi-stage (development and staging) deployment of a Dockerized application on Azure Kubernetes Service (AKS) using Terraform, Helm Charts, Helmfile, and GitHub Actions. The application used is `nginxdemos/hello`, deployed with specific configurations for each environment.

## Prerequisites
- Azure account and Azure CLI
- Kubernetes CLI (kubectl)
- Helm and Helmfile
- Terraform

## Setup and Configuration

### 1. Infrastructure Setup with Terraform
- AKS cluster is created using Terraform.
- Two Kubernetes namespaces (`dev-namespace` and `stage-namespace`) are defined for separate environments.

### 2. Application Deployment with Helm and Helmfile
- Helm charts are used for packaging the `nginxdemos/hello` application.
- Helmfile is utilized to manage the deployment of Helm charts to different environments.
- Environment-specific values and secrets are managed through separate files for development and staging environments.

### 3. Continuous Deployment with GitHub Actions
- GitHub Actions workflows are set up for continuous deployment.
- Separate jobs are defined for deploying to development and staging environments upon code pushes to the main branch.

## GitHub Repository Secrets

For the GitHub Actions workflows to function correctly, the following secrets must be set up in the GitHub repository:

- `ARM_CLIENT_ID`: The Azure Service Principal's Client ID.
- `ARM_CLIENT_SECRET`: The Secret associated with the Azure Service Principal.
- `ARM_SUBSCRIPTION_ID`: Your Azure Subscription ID.
- `ARM_TENANT_ID`: Your Azure Tenant ID.
- `AZURE_CREDENTIALS`: A JSON object containing Azure service principal credentials. This is used for Azure CLI authentication in GitHub Actions.

### Setting Up GitHub Secrets

1. **Create an Azure Service Principal** (if you haven't already):
   
   `az ad sp create-for-rbac --name "myAKSClusterSP" --role contributor --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} --sdk-auth`

    - Replace {subscription-id} and {resource-group} with your actual subscription ID and resource group name. This command will output the credentials needed.

2. **Add Secrets to GitHub Repository**:
    - Go to your GitHub repository.
    - Navigate to 'Settings' > 'Secrets'.
    - Click 'New repository secret' and add each of the above secrets.

### Managing Encrypted Secrets with SOPS
## Overview
This project uses SOPS (Secrets OPerationS) for secure secret management. SOPS encrypts secrets using a 4096-bit RSA key. The encrypted secrets are then manually updated in the Kubernetes environment using kubectl.

## Prerequisites
- SOPS installed on your local machine.
- Access to a 4096-bit RSA private/public key pair for encryption and decryption.

## Creating and Updating Secrets
Encrypting Secrets:

- Note: The current encrypted files are `secrets/dev-secrets.yaml` and `secrets/stage-secrets.yaml` the secret files to create in first place are unencrypted, after following these steps, you will end with the encrypted files similar to the actual ones.
- Create a YAML file containing the secrets you wish to encrypt.
- Use SOPS with your RSA public key to encrypt the file:
`sops --encrypt --pgp [RSA public key ID] [plain secrets file] > [encrypted secrets file]`

## Updating Secrets in Kubernetes:

- After encrypting the secrets, you need to update them manually in the Kubernetes environment.
- Use kubectl to apply the secrets to your Kubernetes cluster:
`kubectl create secret generic [secret-name] --from-file=[encrypted secrets file] -n [namespace]`

- Note: Replace [secret-name], [encrypted secrets file], and [namespace] with your specific secret name, file name, and Kubernetes namespace.

## Usage
### Deploying to AKS
- Ensure Azure CLI is logged in to your Azure account.
- Run Terraform scripts to set up the AKS cluster and namespaces.
- Use Helmfile to deploy the application:
    - For development environment: helmfile -e dev apply
    - For staging environment: helmfile -e stage apply

## Continuous Deployment
- Push changes to the main branch.
- GitHub Actions will automatically deploy changes to the respective environments.

### Repository Structure
- `.github/workflows`: Contains GitHub Actions workflow definitions.
- `helmfile.yaml`: Helmfile configuration for managing deployments across environments.
- `hello-chart/`: Helm chart for the nginxdemos/hello application.
- `envValues/`: Directory containing environment-specific values.
- `secrets/`: Directory containing encrypted secrets for each environment.

### Additional Information
- Make sure to set the necessary secrets in GitHub repository settings for Azure and Helm secrets.
- Terraform state should be managed securely, preferably using remote backends like Azure Blob Storage.