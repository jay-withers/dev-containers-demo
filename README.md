# terraform-azurerm-resource-group

A simple Terraform module for managing an Azure Resource Group.

## Dev Container

This repo includes a dev container with all required tooling pre-installed at pinned versions. No local tool installation is required beyond Docker.

### Getting started

Open the repo in VS Code and select **Reopen in Container**.

### Mac prerequisite — Colima

Docker Desktop is not required. The Docker CLI plus Colima is a lightweight alternative:

```sh
brew install docker colima
colima start
```

To start Colima automatically on login:

```sh
brew services start colima
```

## Terraform Example

See [examples/basic](examples/basic) for a working example.

```sh
cd examples/basic
az login
terraform init
terraform plan
```
