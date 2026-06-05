# terraform-azurerm-resource-group

A simple Terraform module for managing an Azure Resource Group.

## Usage

```hcl
module "resource_group" {
  source = "../../"

  name     = "rg-example-dev"
  location = "uksouth"

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `name` | Name of the resource group | `string` | yes |
| `location` | Azure region (e.g. `uksouth`, `eastus`) | `string` | yes |
| `tags` | Map of tags to assign to the resource group | `map(string)` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Resource ID of the resource group |
| `name` | Name of the resource group |
| `location` | Azure region of the resource group |
| `subscription_id` | Subscription ID the resource group belongs to |

## Requirements

| Name | Version |
|------|---------|
| Terraform | `>= 1.5.0` |
| azurerm provider | `~> 4.0` |

## Example

See [examples/basic](examples/basic) for a working example.

```sh
cd examples/basic
az login
terraform init
terraform plan
```

---

## Dev Container

This repo includes a dev container with all required tooling pre-installed at pinned versions with SHA256 digest verification. No local tool installation is required beyond Docker.

### Getting started

Open the repo in VS Code and select **Reopen in Container**.

> **Prerequisite**: your host machine must have a git identity configured (`user.name` and `user.email`). The container reads these from the host at startup and fails with a clear message if they are missing.

### Mac — Colima (Docker Desktop alternative)

```sh
brew install docker colima
colima start
```

To start Colima automatically on login:

```sh
brew services start colima
```

### Tooling

All tools are installed from pinned URLs with SHA256 digest verification at build time.

| Tool | Version |
|------|---------|
| Azure CLI | 2.73.0 |
| Terraform | 1.15.5 |
| TFLint | 0.61.0 |
| Trivy | 0.69.3 |
| Checkov | 3.2.529 |
| terraform-docs | 0.24.0 |
| ShellCheck | 0.10.0 |
| pre-commit | 3.7.1 |
| PowerShell | 7.4.6 |
| Azure PowerShell (Az) | 16.0.0 |
| GitHub CLI | 2.93.0 |
| Node.js | 24.16.0 |

### VS Code extensions

| Extension | Purpose |
|-----------|---------|
| `hashicorp.terraform` | Terraform language support and formatting |
| `ms-azuretools.vscode-azureterraform` | Azure Terraform integration |
| `ms-azuretools.vscode-azureresourcegroups` | Browse Azure resources |
| `ms-azure-devops.azure-pipelines` | Azure Pipelines YAML support |
| `anthropic.claude-code` | Claude AI assistant |
| `ms-vscode.powershell` | PowerShell language support |
| `eamodio.gitlens` | Enhanced git tooling |
| `redhat.vscode-yaml` | YAML language support |
| `timonwong.shellcheck` | Shell script linting |
| `DavidAnson.vscode-markdownlint` | Markdown linting |

### Pre-commit hooks

Pre-commit is installed automatically when the container is created. The following hooks run on every commit:

| Hook | What it checks |
|------|---------------|
| `terraform fmt` | Terraform formatting |
| `tflint` | Terraform linting |
| `checkov` | Terraform security and compliance |
| `trivy` | HIGH/CRITICAL misconfigurations |
| `shellcheck` | Shell script issues |
| `terraform-standards` | Enforces Terraform file naming conventions (e.g. outputs only in `outputs*.tf`) |
| Standard hooks | Trailing whitespace, EOF newline, YAML/JSON validity, merge conflicts, large files |

To run hooks manually:

```sh
pre-commit run --all-files
```

### Claude Code MCP servers

The container configures two MCP servers for Claude Code automatically:

| Server | Purpose |
|--------|---------|
| Azure MCP (`@azure/mcp`) | Interact with Azure resources, query subscriptions, resource groups, and services |
| Microsoft Learn | Search and fetch official Microsoft and Azure documentation |

### Home directory mount

The host home directory is mounted at `/host-home` inside the container, giving access to host SSH keys, credentials, and other config without copying them into the image.
