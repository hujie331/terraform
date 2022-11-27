variable "password" {
    description = "password for the palo alto login"
    type = string
    default = "admin"
    sensitive = true
}