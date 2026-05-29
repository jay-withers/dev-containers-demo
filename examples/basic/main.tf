module "resource_group" {
  source = "../../"

  name     = "rg-example-dev"
  location = "uksouth"

  tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}
