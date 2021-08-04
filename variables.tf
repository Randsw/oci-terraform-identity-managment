variable "tenancy_id" {
    type = string
}

variable "exist_compartment_id" {
    type = string
    description = "Exist compartment that became root for newly created compartment."
}

variable "is_nested_compartment" {
    type = string
    default = false
}

variable "group_name" {
    type = string
    default = "DevOps-test"
    description = "Infrastructure deployers group"
}

variable "group_tags" {
    type = map(string)
    default = {
        func = "devops"
    }
}

variable "user_name" {
    type = string
    default = "Test"
}

variable "user_tags" {
    type = map(string)
    default = {
        app = "app"
    }
}

variable "user_email" {
    type = string
    default = "example@example.com"
}

variable "customer_secret_key_display_name" {
    type = string
    default = "s3-tfstate-key"
}

variable "user_api_key" {
    default     = "~/.oci/oci_dep_api_key_public.pem"
    description = "Path to the public key for accessing cloud API."
}

variable "policy_description" {
    type = string
    default = "Deploy user policy"
}

variable "policy_name" {
    type = string
    default = "deployer_policy"    
}

variable "compartment_name" {
    type = string
    default = "app_compartment"
}

variable "tags" {
    type = map(string)
    default = {
        app = "app"
    }
}

variable "compartment_description" {
    type = string
    default ="Compartment for application"
}

variable "exist_group_name" {
    type = string
    default = "DevOps"
}

variable "exist_user_name" {
    type = string
    default = "Deployer"
}

variable "create_group" {
    type = bool
    default = false
}

variable "create_user" {
    type = bool
    default = false
}

variable "add_user_to_group"{
    type = bool
    default = false
}
