terraform {
  required_providers {
    twingate = {
      source  = "Twingate/twingate"
      version = "1.1.0-rc1"
    }
  }
}
provider "twingate" {
}
