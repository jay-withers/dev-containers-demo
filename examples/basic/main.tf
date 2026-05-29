module "resource_group" {
  source = "../../"

  name     = "rg-example-dev"
  location = "uksouth"

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

output "resource_group_id" {
  value = module.resource_group.id
}
