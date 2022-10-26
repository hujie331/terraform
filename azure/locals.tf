locals {
  subnets = {
    subnet1 = {
        name = "subnet-1"
        address_prefix = ["10.0.1.0/24"]
    }
    subnet3 = {
        name = "subnet-3"
        address_prefix = ["10.0.3.0/24"]
        service_delegation = "true"
    }
    subnet4 = {
        name = "subnet-4"
        address_prefix = ["10.0.4.0/24"]
        
    }
  }
}