# dns-zone

Manages a Google Cloud DNS managed zone (`google_dns_managed_zone`) with IAM bindings and DNS record sets.

## Usage

```hcl
module "dns_zone" {
  source = "github.com/kubed-io/terraform-gcp-components//modules/dns-zone?ref=main"

  name        = "kellydomain"
  dns_name    = "kellydomain.com."
  description = "Public zone for kellydomain.com"
  labels      = { env = "homelab" }

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
      rrdatas = ["kellydomain.com."]
    },
    {
      name    = "@"
      type    = "MX"
      ttl     = 3600
      rrdatas = [
        "1 aspmx.l.google.com.",
        "5 alt1.aspmx.l.google.com.",
        "10 alt3.aspmx.l.google.com.",
      ]
    },
  ]

  iam = [
    {
      role    = "roles/dns.admin"
      members = ["serviceAccount:ci-deployer@my-project.iam.gserviceaccount.com"]
    },
  ]
}
```

### Private zone

```hcl
module "dns_zone" {
  source = "github.com/kubed-io/terraform-gcp-components//modules/dns-zone?ref=main"

  name       = "homelab-internal"
  dns_name   = "homelab.internal."
  visibility = "private"

  private_visibility_config = {
    networks = [
      { network_url = "projects/my-project/global/networks/default" }
    ]
  }
}
```

### Zone with DNSSEC

```hcl
module "dns_zone" {
  source = "github.com/kubed-io/terraform-gcp-components//modules/dns-zone?ref=main"

  name     = "secure-zone"
  dns_name = "secure.example.com."

  dnssec_config = {
    state = "on"
  }
}
```

### Record with weighted round-robin routing

```hcl
module "dns_zone" {
  source = "github.com/kubed-io/terraform-gcp-components//modules/dns-zone?ref=main"

  name     = "kellydomain"
  dns_name = "kellydomain.com."

  records = [
    {
      name = "api"
      type = "A"
      ttl  = 300
      routing_policy = {
        wrr = [
          { weight = 0.8, rrdatas = ["10.128.1.1"] },
          { weight = 0.2, rrdatas = ["10.130.1.1"] },
        ]
      }
    },
  ]
}
```

---

## Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | string | required | Resource name for the zone, unique within the project |
| `dns_name` | string | required | DNS name ending with a dot, e.g. `example.com.` |
| `description` | string | `"Managed by Terraform"` | Free-text description |
| `visibility` | string | `"public"` | `public` or `private` |
| `force_destroy` | bool | `false` | Delete all records in the zone when destroying |
| `deletion_policy` | string | `"DELETE"` | `DELETE`, `ABANDON`, or `PREVENT` |
| `dnssec_config` | object | `null` | DNSSEC config — `state`, `non_existence`, `default_key_specs` |
| `private_visibility_config` | object | `null` | VPC networks that can see this zone |
| `cloud_logging_config` | object | `null` | Cloud DNS query logging — `{ enabled = bool }` |
| `iam` | list | `[]` | IAM bindings — `role`, `members`, optional `condition` |
| `records` | list | `[]` | DNS record sets — see Records below |
| `labels` | map(string) | `{}` | GCP labels |

### Records

Each entry in `records` supports:

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | string | required | Relative name (`www`, `api`) or `@` for the zone apex |
| `type` | string | required | `A`, `AAAA`, `CNAME`, `MX`, `TXT`, `NS`, `SRV`, etc. |
| `ttl` | number | `300` | Time-to-live in seconds |
| `rrdatas` | list(string) | `[]` | Record data; mutually exclusive with `routing_policy` |
| `routing_policy` | object | `null` | WRR, geo, or primary/backup routing |
| `deletion_policy` | string | `"DELETE"` | `DELETE`, `ABANDON`, or `PREVENT` |

`routing_policy` supports three mutually exclusive strategies: `wrr` (weighted round-robin), `geo` (geolocation), and `primary_backup` (failover).

---

## Outputs

| Name | Description |
|------|-------------|
| `name` | Resource name of the managed zone |
| `dns_name` | DNS name of the zone |
| `managed_zone_id` | Unique GCP-assigned zone ID |
| `name_servers` | Authoritative name servers — use these to set up NS delegation at your registrar |
| `project` | GCP project ID |

---

## Using the CRD

This module is also available as a Crossplane composite resource via the `DnsZone` kind in the [`../../crd/dns-zone/`](../../crd/dns-zone/) directory. The CRD is the preferred way to manage DNS zones from within the cluster.

```yaml
apiVersion: gcp.kubed.io/v1alpha1
kind: DnsZone
metadata:
  name: kellydomain
spec:
  dnsName: kellydomain.com.
  records:
  - name: "@"
    type: A
    ttl: 300
    rrdatas:
    - 1.2.3.4
  iam:
  - role: roles/dns.admin
    members:
    - serviceAccount:ci-deployer@my-project.iam.gserviceaccount.com
```

---

## References

- [google_dns_managed_zone](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone)
- [google_dns_record_set](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set)
- [google_dns_managed_zone_iam_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_managed_zone_iam)
- [Cloud DNS documentation](https://cloud.google.com/dns/docs)
