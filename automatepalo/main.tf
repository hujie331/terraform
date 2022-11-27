terraform {
  required_providers {
    panos = {
        source = "PaloAltoNetworks/panos"
    }
  }
}

provider "panos" {
    hostname = "192.168.1.145"
    username = "admin"
    password = var.password
}

resource "panos_virtual_router" "main" {
    name = "default"
    interfaces = [
        panos_ethernet_interface.ethernet1.name,
        panos_ethernet_interface.ethernet2.name,
    ]

    lifecycle {
        create_before_destroy = true
    }
}

resource "panos_static_route_ipv4" "main" {
    name = "default route"
    virtual_router = panos_virtual_router.main.name
    destination = "0.0.0.0/0"
    next_hop = "1.1.1.1"

    lifecycle {
        create_before_destroy = true
    }
}



resource "panos_zone" "trustedzone" {
    name = "trusted-inside-zone"
    mode = "layer3"
    interfaces = [
        panos_ethernet_interface.ethernet2.name
    ]
    lifecycle {
        create_before_destroy = true
    }
}

resource "panos_zone" "untrustedzone" {
    name = "untrusted-outside-zone"
    mode = "layer3"
    interfaces = [
        panos_ethernet_interface.ethernet1.name
    ]
    lifecycle {
        create_before_destroy = true
    }
}



resource "panos_ethernet_interface" "ethernet1" {
    name = "ethernet1/1"
    vsys = "vsys1"
    mode = "layer3"
    static_ips = ["outside-ip"]
    comment = "outside-interface"

    lifecycle {
        create_before_destroy = true
    }
}

resource "panos_ethernet_interface" "ethernet2" {
    name = "ethernet1/2"
    vsys = "vsys1"
    mode = "layer3"
    static_ips = ["inside-ip"]
    comment = "inside-ip"

    lifecycle {
        create_before_destroy = true
    }
}

resource "panos_address_object" "outsideip" {
    name = "outside-ip"
    value = "1.1.1.2/24"
    description = "outside ip address"
    lifecycle {
        create_before_destroy = true
    }
}

resource "panos_address_object" "insideip" {
    name = "inside-ip"
    value = "192.168.1.2/24"
    description = "inside ip address"
    lifecycle {
        create_before_destroy = true
    }
}

resource "panos_security_policy" "example" {
    rule {
        name = "allow internet traffic"
        audit_comment = "Initial config"
        source_zones = ["trusted-inside-zone"]
        source_addresses = ["any"]
        source_users = ["any"]
        hip_profiles = ["any"]
        destination_zones = ["untrusted-outside-zone"]
        destination_addresses = ["any"]
        applications = ["any"]
        services = ["application-default"]
        categories = ["any"]
        action = "allow"
    }

    lifecycle {
        create_before_destroy = true
    }
}