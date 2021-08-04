output "access_key" {
    value = var.create_user ? oci_identity_customer_secret_key.deploy_user_customer_secret_key[0].id : null
}

output "secret_key" {
    value = var.create_user ? oci_identity_customer_secret_key.deploy_user_customer_secret_key[0].key : null
}

output "compartm_id" {
    value = oci_identity_compartment.app-compartment.compartment_id
    sensitive = true
}

output "deploy_user_id" {
    value = local.user_id
}