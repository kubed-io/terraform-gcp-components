# One record set per name + type, keyed by both, so adding or removing an entry only
# touches that record set. Records this module does not declare are never read or changed,
# so another writer (external-dns, the console) can share the zone on different names.
resource "google_dns_record_set" "this" {
  for_each = {
    for r in var.records :
    "${r.name} ${r.type}" => r
  }
  project      = local.project
  managed_zone = google_dns_managed_zone.this.name
  name = (
    each.value.name == "@"
    ? google_dns_managed_zone.this.dns_name
    : "${each.value.name}.${google_dns_managed_zone.this.dns_name}"
  )
  type    = each.value.type
  ttl     = each.value.ttl
  rrdatas = each.value.rrdatas

  dynamic "routing_policy" {
    for_each = each.value.routing_policy != null ? [each.value.routing_policy] : []
    content {
      health_check = routing_policy.value.health_check

      dynamic "wrr" {
        for_each = routing_policy.value.wrr
        content {
          weight  = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }

      dynamic "geo" {
        for_each = routing_policy.value.geo
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }

      dynamic "primary_backup" {
        for_each = routing_policy.value.primary_backup != null ? [routing_policy.value.primary_backup] : []
        content {
          trickle_ratio = primary_backup.value.trickle_ratio

          primary {
            external_endpoints = primary_backup.value.primary.external_endpoints
          }

          dynamic "backup_geo" {
            for_each = primary_backup.value.backup_geo
            content {
              location = backup_geo.value.location
              rrdatas  = backup_geo.value.rrdatas
            }
          }
        }
      }
    }
  }
}

# Ownership markers in external-dns's TXT registry format, written for every record so the
# zone says who owns what with or without an external-dns beside it. Same name and value
# format as external-dns's own: the
# record type is prefixed to the first label (www A → a-www). The apex and wildcards get no
# marker — a-<zone> falls outside the zone, and external-dns cannot own them either.
resource "google_dns_record_set" "owner" {
  for_each = {
    for r in var.records :
    "${r.name} ${r.type}" => r
    if r.name != "@" && !startswith(r.name, "*")
  }
  project      = local.project
  managed_zone = google_dns_managed_zone.this.name
  name         = "${lower(each.value.type)}-${each.value.name}.${google_dns_managed_zone.this.dns_name}"
  type         = "TXT"
  ttl          = 300
  rrdatas      = ["\"heritage=external-dns,external-dns/owner=${local.owner_id},external-dns/resource=dnszone/${var.name}\""]
}
