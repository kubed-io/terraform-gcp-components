# Kubed GCP Terraform Components

A collection of OpenTofu/Terraform modules and matching Crossplane composite resource definitions for managing GCP resources from Kubernetes. Each module under `modules/` is paired with a CRD under `crd/` that wraps it as a `*.gcp.kubed.io` resource via the Crossplane OpenTofu provider.

## Modules

### [Service Account](modules/service-account/README.md)

`kind: ServiceAccount` — creates a GCP service account, an exported JSON key, optional project-level IAM role bindings, SA-level IAM bindings for workload identity impersonation, and an optional HMAC key for GCS S3-compatible access.

### [Bucket](modules/bucket/README.md)

`kind: Bucket` — creates a GCS bucket with versioning, lifecycle rules, uniform bucket-level access, IAM bindings, CORS, and labels.

### [Identity Pool](modules/identity-pool/README.md)

`kind: IdentityPool` — creates a Workload Identity Pool. Pool ID is taken from `metadata.name`. Pair with one or more Identity Pool Providers to allow external workloads to authenticate as GCP service accounts without long-lived keys.

### [Identity Pool Provider](modules/identity-pool-provider/README.md)

`kind: IdentityPoolProvider` — creates an OIDC Workload Identity Pool Provider under an existing pool. Defaults shaped for GitHub Actions OIDC (issuer `https://token.actions.githubusercontent.com`, standard attribute mapping). Use `attributeCondition` to restrict which tokens the provider accepts (e.g. limit to a specific GitHub org or repo).

### [DNS Zone](modules/dns-zone/README.md)

`kind: DnsZone` — creates a Cloud DNS managed zone with DNS record sets and IAM bindings. Supports public and private zones, DNSSEC, geolocation and weighted routing policies, and Cloud DNS query logging.

## Usage

The CRDs in `crd/` are consumed by the parent cluster repo. Each composition references its module via a `source: Remote` workspace pointing at `github.com/kubed-io/terraform-gcp-components//modules/<name>?ref=main`.

## References

- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [OpenTofu Google Provider](https://search.opentofu.org/provider/hashicorp/google/latest)
- [Workload Identity Federation for GitHub Actions](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions)
- [GitHub OIDC in GCP](https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-google-cloud-platform)
