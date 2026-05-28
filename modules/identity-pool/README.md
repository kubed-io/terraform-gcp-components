# identity-pool

Creates a GCP Workload Identity Pool (`google_iam_workload_identity_pool`). A pool is the top-level container for external identity providers — pair it with one or more `identity-pool-provider` modules to allow non-GCP workloads to authenticate as GCP service accounts without long-lived keys.

## Usage

```hcl
module "identity_pool" {
  source = "github.com/kubed-io/terraform-gcp-components//modules/identity-pool?ref=main"

  name         = "my-pool"
  display_name = "My Workload Identity Pool"
  description  = "Pool for GitHub Actions and CI workloads"
}
```

---

## Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | string | required | Pool ID — becomes `workload_identity_pool_id` (4–32 chars, lowercase, hyphens) |
| `display_name` | string | `""` | Human-friendly name shown in the GCP console |
| `description` | string | `""` | Free-form description of the pool |

---

## Outputs

| Name | Description |
|------|-------------|
| `pool_id` | The pool ID (matches `name`) |
| `pool_name` | Full resource name: `projects/<num>/locations/global/workloadIdentityPools/<id>` |
| `project_id` | GCP project ID |
| `project_number` | GCP project number — needed when building `principalSet://` member strings |

---

## Using the CRD

This module is also available as a Crossplane composite resource via the `IdentityPool` kind in [`../../crd/identity-pool/`](../../crd/identity-pool/).

```yaml
apiVersion: gcp.kubed.io/v1alpha1
kind: IdentityPool
metadata:
  name: my-pool
spec:
  display_name: My Workload Identity Pool
  description: Pool for GitHub Actions and CI workloads
```

---

## References

- [google_iam_workload_identity_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool)
- [Workload Identity Federation overview](https://cloud.google.com/iam/docs/workload-identity-federation)
