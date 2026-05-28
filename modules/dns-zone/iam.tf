resource "google_dns_managed_zone_iam_binding" "this" {
  for_each     = { for b in var.iam : b.role => b }
  project      = local.project
  managed_zone = google_dns_managed_zone.this.name
  role         = each.value.role
  members      = each.value.members

  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      title       = condition.value.title
      expression  = condition.value.expression
      description = condition.value.description
    }
  }
}
