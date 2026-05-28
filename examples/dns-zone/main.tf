module "dns_zone" {
  source = "../../modules/dns-zone"

  name        = "example-zone"
  dns_name    = "example.com."
  description = "Public zone for example.com"

  deletion_policy = "PREVENT"

  iam = [
    {
      role    = "roles/dns.admin"
      members = ["serviceAccount:external-dns@my-project.iam.gserviceaccount.com"]
    },
  ]

  records = [
    {
      name    = "@"
      type    = "A"
      ttl     = 300
      rrdatas = ["1.2.3.4"]
    },
    {
      name    = "www"
      type    = "CNAME"
      ttl     = 300
      rrdatas = ["example.com."]
    },
    {
      name  = "@"
      type  = "MX"
      ttl   = 3600
      rrdatas = [
        "1 aspmx.l.google.com.",
        "5 alt1.aspmx.l.google.com.",
        "5 alt2.aspmx.l.google.com.",
        "10 alt3.aspmx.l.google.com.",
        "10 alt4.aspmx.l.google.com.",
      ]
    },
    {
      name    = "@"
      type    = "TXT"
      ttl     = 300
      rrdatas = ["\"v=spf1 include:_spf.google.com ~all\""]
    },
    {
      name    = "_dmarc"
      type    = "TXT"
      ttl     = 300
      rrdatas = ["\"v=DMARC1; p=reject; rua=mailto:dmarc@example.com\""]
    },
  ]

  labels = {
    managed-by = "crossplane"
  }
}
