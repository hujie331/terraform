# Terraform configuration
resource "docker_container" "web" {
    name = "hashicorp-learn"
    image = "sha256:b692a91e4e1582db97076184dae0b2f4a7a86b68c4fe6f91affa50ae06369bf5"

    env = []

    ports {
        external = 8080
        internal = 80
    }
}