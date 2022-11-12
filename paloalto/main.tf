terraform {
  required_providers {
    panos = {
        source = "PaloAltoNetworks/panos"
    }
  }
}

resource "panos_general_settings" "main" {
    hostname = "mainfirewall"
    domain   = "letmetechyou.com"


    lifecycle {
        create_before_destroy = true
    }
}


resource "panos_ethernet_interface" "port1" {
    name = "ethernet1/1"
    vsys = "vsys1"
    mode = "layer3"
    static_ips = ["9.9.9.2/24"]
    comment = "Configured for outbound traffic"

    lifecycle {
        create_before_destroy = true
    }
}

resource "panos_ethernet_interface" "port2" {
    name = "ethernet1/2"
    vsys = "vsys1"
    mode = "layer3"
    static_ips = ["10.1.1.1/24"]
    comment = "Configured for internal traffic"

    lifecycle {
        create_before_destroy = true
    }
}




provider "panos" {
    hostname = "192.168.1.131"
    username = "admin"
    password = var.password
}

resource "panos_address_object" "ao1" {
    name = "ntp1"
    value = "10.0.0.1"

    lifecycle {
        create_before_destroy = true
    }
}