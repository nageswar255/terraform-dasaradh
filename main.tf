terraform {
  backend "local" {}
}

provider "tls" {
  version = "~> 3.1.0"
}
module "ca" {
  source             = "../modules/ca"
  ca_common_name     = var.common_name
  organization_name  = var.organization_name
  ca_public_key_path = "gdp.crt"
}

module "api-cert" {
  source                = "../modules/certificate"
  common_name           = var.common_name
  organization_name     = var.organization_name
  # country               = "DE"
  # locality              = "Munich"
  cert_private_key_path = "gdp.pem"
  dns_names             = ["gdp.allianz", "server1.gdp.allianz", "server2.gdp.allianz"]
  ca_key_algorithm      = module.ca.ca_key_algorithm
  ca_private_key_pem    = module.ca.ca_private_key_pem
  ca_cert_pem           = module.ca.ca_cert_pem
  cert_public_key_path  = "api.gdp.crt"
}

