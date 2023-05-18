#--------------------------------------------------------------
# A Remote Network represents a single private network in Twingate that can have one or more Connectors and Resources assigned to it. You must create a Remote Network before creating Resources and Connectors that belong to it. For more information, see Twingate's documentation.
#--------------------------------------------------------------
resource "twingate_remote_network" "this" {
  name = var.twingate.remote_network.name
}
#--------------------------------------------------------------
# Connectors provide connectivity to Remote Networks. This resource type will create the Connector in the Twingate Admin Console, but in order to successfully deploy it, you must also generate Connector tokens that authenticate the Connector with Twingate. For more information, see Twingate's documentation.
#--------------------------------------------------------------
resource "twingate_connector" "this" {
  remote_network_id = twingate_remote_network.this.id
  name              = var.twingate.connector.name
}
#--------------------------------------------------------------
# This resource type will generate tokens for a Connector, which are needed to successfully provision one on your network. The Connector itself has its own resource type and must be created before you can provision tokens.
#--------------------------------------------------------------
resource "twingate_connector_tokens" "this" {
  connector_id = twingate_connector.this.id
}
# resource "twingate_group" "this" {
#   name = var.twingate.group.name
# }
#--------------------------------------------------------------
# Users provides different levels of write capabilities across the Twingate Admin Console. For more information, see Twingate's documentation.
#--------------------------------------------------------------
resource "twingate_user" "this" {
  for_each    = var.twingate.user
  email       = each.value.email
  first_name  = each.value.first_name
  last_name   = each.value.last_name
  role        = each.value.role
  send_invite = lookup(each.value, "send_invite", true)
}
#--------------------------------------------------------------
# Resources in Twingate represent servers on the private network that clients can connect to. Resources can be defined by IP, CIDR range, FQDN, or DNS zone. For more information, see the Twingate documentation.
#--------------------------------------------------------------
resource "twingate_resource" "this" {
  for_each          = var.twingate.resource
  name              = each.value.name
  address           = each.value.address
  alias = each.value.alias
  remote_network_id = twingate_remote_network.this.id

  dynamic "protocols" {
    for_each = lookup(var.twingate.resource, "protocols", [])
    content {
      allow_icmp = lookup(protocols.value, "allow_icmp", true)
      dynamic "tcp" {
        for_each = length(lookup(protocols.value, "tcp", [])) > 0 ? [lookup(protocols.value, "tcp", {})] : []
        content {
          policy = lookup(tcp.value, "policy", "ALLOW_ALL")
          ports  = lookup(tcp.value, "ports", null)
        }
      }
      dynamic "udp" {
        for_each = length(lookup(protocols.value, "udp", [])) > 0 ? [lookup(protocols.value, "udp", {})] : []
        content {
          policy = lookup(udp.value, "policy", "ALLOW_ALL")
          ports  = lookup(udp.value, "ports", null)
        }
      }
    }
  }
}

#--------------------------------------------------------------
# Output
#--------------------------------------------------------------
output "twingate_connector_tokens" {
  sensitive = true
  value     = twingate_connector_tokens.this
}
