locals {
  user_id = var.create_user ? oci_identity_user.deploy_user[0].id : data.oci_identity_users.exist_user.users[0].id
  group_id = var.create_group ? oci_identity_group.deploy_group[0].id : data.oci_identity_groups.exist_group.groups[0].id
  root_compartment_id = try(var.is_nested_compartment ? var.exist_compartment_id : var.tenancy_id)
}

resource "oci_identity_compartment" "app-compartment" {
    compartment_id = local.root_compartment_id
    description = var.compartment_description
    name = var.compartment_name
    freeform_tags = var.tags
}

data "oci_identity_groups" "exist_group" {
    compartment_id = var.tenancy_id
    name = var.exist_group_name
    state = "ACTIVE"
}

data "oci_identity_users" "exist_user" {
    compartment_id = var.tenancy_id
    name = var.exist_user_name
    state = "ACTIVE"
}

resource "oci_identity_group" "deploy_group" {
    count = var.create_group ? 1 : 0 #Create new group if bool is true
    compartment_id = var.tenancy_id
    description = "Deploy group"
    name = var.group_name
    freeform_tags = var.group_tags
}

resource "oci_identity_user" "deploy_user" {
    count = var.create_user ? 1 : 0 # Create user ?
    compartment_id = var.tenancy_id
    description = "Deploy user"
    name = var.user_name
    email = var.user_email
    freeform_tags = var.user_tags
}

resource "oci_identity_user_group_membership" "deploy_user_to_deploy_group" {
    count = var.add_user_to_group ? 1 : 0
    group_id = local.group_id
    user_id = local.user_id
}

resource "oci_identity_customer_secret_key" "deploy_user_customer_secret_key" {
    count = var.create_user ? 1 : 0 # Create user ?
    display_name = var.customer_secret_key_display_name
    user_id = local.user_id
}

resource "oci_identity_api_key" "user_api_key" {
    count = var.create_user ? 1 : 0 # Create user ?
    key_value = "${file(var.user_api_key)}"
    user_id = local.user_id
}

resource "oci_identity_policy" "Deploy_policy" {
    #count = var.create_group ? 1 : 0 #Create new group if bool is true
    compartment_id = oci_identity_compartment.app-compartment.id
    description = var.policy_description
    name = var.policy_name
    statements = ["Allow group %{ if var.create_group }${oci_identity_group.deploy_group[0].name}%{ else }${data.oci_identity_groups.exist_group.groups[0].name}%{ endif } to manage all-resources in compartment ${oci_identity_compartment.app-compartment.name}",
                  "Allow group %{ if var.create_group }${oci_identity_group.deploy_group[0].name}%{ else }${data.oci_identity_groups.exist_group.groups[0].name}%{ endif } to manage dns in compartment ${oci_identity_compartment.app-compartment.name}",
                  "Allow group %{ if var.create_group }${oci_identity_group.deploy_group[0].name}%{ else }${data.oci_identity_groups.exist_group.groups[0].name}%{ endif } to manage objects in compartment ${oci_identity_compartment.app-compartment.name}",
                  "Allow group %{ if var.create_group }${oci_identity_group.deploy_group[0].name}%{ else }${data.oci_identity_groups.exist_group.groups[0].name}%{ endif } to manage buckets in compartment ${oci_identity_compartment.app-compartment.name}",]
    freeform_tags = var.tags
}