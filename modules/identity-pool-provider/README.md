# identity-pool-provider

Creates a GCP Workload Identity Pool Provider (`google_iam_workload_identity_pool_provider`) under an existing pool. Defaults are shaped for GitHub Actions OIDC — swap `issuer_uri` and `attribute_mapping` for other providers.

Also grants `roles/iam.workloadIdentityUser` on specified service accounts via `google_service_account_iam_member`, allowing federated identities to impersonate them.

## Usage

### GitHub Actions (default)

```hcl
module "github_provider" {
  source = "github.com/kubed-io/terraform-gcp-components//modules/identity-pool-provider?ref=main"

  name    = "github"
  pool_id = "my-pool"

  display_name        = "GitHub Actions"
  attribute_condition = "assertion.repository_owner_id == '102392839'"

  members = [
    {
      serviceAccountName = "github-deployer"
      condition          = "attribute.repository_owner_id/102392839"
    },
  ]
}
```

### Custom OIDC provider

```hcl
module "custom_provider" {
  source = "github.com/kubed-io/terraform-gcp-components//modules/identity-pool-provider?ref=main"

  name       = "my-oidc"
  pool_id    = "my-pool"
  issuer_uri = "https://auth.example.com"

  attribute_mapping = {
    "google.subject" = "assertion.sub"
    "attribute.email" = "assertion.email"
  }

  members = [
    {
      serviceAccountName = "my-app"
      condition          = "attribute.email/deployer@example.com"
    },
  ]
}
```

---

## Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | string | required | Provider ID — becomes `workload_identity_pool_provider_id` (4–32 chars) |
| `pool_id` | string | required | Existing workload identity pool ID this provider belongs to |
| `display_name` | string | `""` | Human-friendly name shown in the GCP console |
| `description` | string | `""` | Free-form description |
| `disabled` | bool | `false` | Whether the provider is disabled |
| `issuer_uri` | string | GitHub Actions issuer | OIDC issuer URI |
| `allowed_audiences` | list(string) | `[]` | Allowed OIDC audiences — empty uses the pool provider resource name |
| `attribute_mapping` | map(string) | GitHub defaults | Maps external token claims to Google attributes; must include `google.subject` |
| `attribute_condition` | string | `null` | CEL expression restricting which tokens are accepted |
| `members` | list | `[]` | Service accounts to grant `workloadIdentityUser` — see below |

### `members` entries

| Field | Description |
|-------|-------------|
| `serviceAccountName` | GCP service account ID (not full email) |
| `condition` | `principalSet://` suffix, e.g. `attribute.repository_owner_id/102392839` |

---

## Outputs

| Name | Description |
|------|-------------|
| `provider_id` | The provider ID |
| `provider_name` | Full resource name: `projects/<num>/locations/global/workloadIdentityPools/<pool>/providers/<id>` |
| `audience` | Audience string to use in OIDC token requests (`//iam.googleapis.com/...`) |
| `project_id` | GCP project ID |
| `project_number` | GCP project number |

---

## Using the CRD

This module is also available as a Crossplane composite resource via the `IdentityPoolProvider` kind in [`../../crd/identity-pool-provider/`](../../crd/identity-pool-provider/).

```yaml
apiVersion: gcp.kubed.io/v1alpha1
kind: IdentityPoolProvider
metadata:
  name: github
spec:
  poolId: my-pool
  display_name: GitHub Actions
  attributeCondition: assertion.repository_owner_id == '102392839'
  members:
  - serviceAccountName: github-deployer
    condition: attribute.repository_owner_id/102392839
```

---

## References

- [google_iam_workload_identity_pool_provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider)
- [Workload Identity Federation for GitHub Actions](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions)
