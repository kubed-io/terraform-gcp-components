# service-account

Creates a GCP service account (`google_service_account`) with an exported JSON key, optional project-level IAM role bindings, SA-level IAM bindings for workload identity impersonation, and an optional HMAC key for GCS S3-compatible access.

## Usage

### Basic service account with project roles

```hcl
module "service_account" {
  source = "github.com/kubed-io/terraform-gcp-components//modules/service-account?ref=main"

  name         = "my-app"
  display_name = "My App"
  description  = "Service account for my-app"

  roles = [
    "roles/storage.objectAdmin",
    "roles/secretmanager.secretAccessor",
  ]
}
```

### With workload identity impersonation

```hcl
module "service_account" {
  source = "github.com/kubed-io/terraform-gcp-components//modules/service-account?ref=main"

  name         = "github-deployer"
  display_name = "GitHub Deployer"

  roles = ["roles/run.admin"]

  bindings = {
    github = {
      role   = "roles/iam.workloadIdentityUser"
      member = "principalSet://iam.googleapis.com/projects/123456/locations/global/workloadIdentityPools/my-pool/attribute.repository_owner_id/102392839"
    }
  }
}
```

### With HMAC key for GCS S3-compatible access

```hcl
module "service_account" {
  source = "github.com/kubed-io/terraform-gcp-components//modules/service-account?ref=main"

  name         = "fission-storage"
  display_name = "Fission Storage"

  roles    = ["roles/storage.admin"]
  hmac_key = true
}
```

---

## Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | string | required | Account ID — the `@` part of the service account email |
| `display_name` | string | required | Display name shown in the GCP console |
| `description` | string | required | Free-form description |
| `roles` | list(string) | `[]` | Project-level IAM roles granted to the service account |
| `bindings` | map(object) | `{}` | SA-level IAM bindings granting other principals access — keyed by an arbitrary label |
| `hmac_key` | bool | `false` | Create an HMAC key for S3-compatible GCS access |

### `bindings` entries

| Field | Description |
|-------|-------------|
| `role` | IAM role to grant on the service account, e.g. `roles/iam.workloadIdentityUser` |
| `member` | Principal to bind, e.g. a `principalSet://` string for workload identity |

---

## Outputs

| Name | Sensitive | Description |
|------|-----------|-------------|
| `project_id` | no | GCP project ID |
| `email` | no | Full service account email |
| `credentials` | yes | Full JSON key file contents |
| `private_key` | yes | RSA private key from the JSON key |
| `token_uri` | yes | Token URI from the JSON key |
| `client_id` | yes | Client ID from the JSON key |
| `hmac_access_id` | yes | HMAC access ID (empty if `hmac_key = false`) |
| `hmac_secret` | yes | HMAC secret (empty if `hmac_key = false`) |

---

## Using the CRD

This module is also available as a Crossplane composite resource via the `ServiceAccount` kind in [`../../crd/service-account/`](../../crd/service-account/). The CRD writes the key and HMAC credentials to a Kubernetes Secret.

```yaml
apiVersion: gcp.kubed.io/v1alpha1
kind: ServiceAccount
metadata:
  name: my-app
spec:
  display_name: My App
  description: Service account for my-app
  roles:
  - roles/storage.objectAdmin
  writeSecretTo:
    namespace: my-namespace
    name: my-app-gcp-creds
```

---

## References

- [google_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account)
- [google_service_account_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key)
- [google_storage_hmac_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_hmac_key)
- [Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation)
