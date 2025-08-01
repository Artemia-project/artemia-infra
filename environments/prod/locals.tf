locals {
  tags = {
    Terraform   = "true"
    Environment = "prod"
    Project     = "artemia"
  }
  
  location            = "koreacentral"
  resource_group_name = "artemia-rg"
}