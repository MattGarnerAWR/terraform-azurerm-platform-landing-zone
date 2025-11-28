locals {
  tag_string = join(" ", [
    for k, v in var.tags : "\"${k}\"=\"${v}\""
  ])

}

# resource "terraform_data" "subscription_tagger" {
#   for_each = var.management_group_settings.subscription_placement

#   triggers_replace = {
#     tag_string      = local.tag_string
#     subscription_id = each.value.subscription_id
#     tags_hash       = md5(jsonencode(var.tags))
#   }

#   # Apply tags using local-exec provisioner
#   provisioner "local-exec" {
#     command = "az tag create --resource-id /subscriptions/${each.value.subscription_id} --tags ${local.tag_string}"
#   }
# }