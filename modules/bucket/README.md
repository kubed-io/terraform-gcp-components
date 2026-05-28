# bucket

Creates a GCS bucket (`google_storage_bucket`) with optional versioning, lifecycle rules, uniform bucket-level access, IAM bindings, and CORS.

## Usage

```hcl
module "bucket" {
  source = "github.com/kubed-io/terraform-gcp-components//modules/bucket?ref=main"

  name = "my-bucket"
}
```

### With versioning and lifecycle rules

```hcl
module "bucket" {
  source = "github.com/kubed-io/terraform-gcp-components//modules/bucket?ref=main"

  name          = "my-bucket"
  location      = "US"
  storage_class = "STANDARD"
  versioning    = true

  lifecycle_rules = [
    {
      action    = { type = "SetStorageClass", storage_class = "NEARLINE" }
      condition = { age = 90, matches_storage_class = ["STANDARD"] }
    },
    {
      action    = { type = "Delete" }
      condition = { age = 365, with_state = "ARCHIVED" }
    },
  ]
}
```

### With IAM bindings

```hcl
module "bucket" {
  source = "github.com/kubed-io/terraform-gcp-components//modules/bucket?ref=main"

  name = "my-bucket"

  iam = [
    {
      role    = "roles/storage.objectAdmin"
      members = ["serviceAccount:my-app@my-project.iam.gserviceaccount.com"]
    },
    {
      role    = "roles/storage.objectViewer"
      members = ["allUsers"]
    },
  ]
}
```

---

## Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | string | required | Name of the bucket — must be globally unique |
| `location` | string | `"US"` | GCS location: `US`, `EU`, `us-central1`, etc. |
| `storage_class` | string | `"STANDARD"` | `STANDARD`, `NEARLINE`, `COLDLINE`, or `ARCHIVE` |
| `versioning` | bool | `false` | Enable object versioning |
| `uniform_bucket_level_access` | bool | `true` | Enforce uniform IAM instead of per-object ACLs |
| `public_access_prevention` | string | `"enforced"` | `enforced` or `inherited` |
| `force_destroy` | bool | `false` | Delete all objects when destroying the bucket |
| `lifecycle_rules` | list | `[]` | Lifecycle rules — each with `action` and `condition` |
| `iam` | list | `[]` | IAM bindings — each with `role` and `members` |
| `cors` | list | `[]` | CORS rules — `origins`, `methods`, `response_headers`, `max_age_seconds` |
| `labels` | map(string) | `{}` | GCP labels |

---

## Outputs

| Name | Description |
|------|-------------|
| `name` | Bucket name |
| `url` | `gs://` URL of the bucket |
| `self_link` | Full resource self-link |
| `project` | GCP project ID |

---

## Using the CRD

This module is also available as a Crossplane composite resource via the `Bucket` kind in [`../../crd/bucket/`](../../crd/bucket/).

```yaml
apiVersion: gcp.kubed.io/v1alpha1
kind: Bucket
metadata:
  name: my-bucket
spec:
  location: US
  storage_class: STANDARD
  versioning: false
  iam:
  - role: roles/storage.objectAdmin
    members:
    - serviceAccount:my-app@my-project.iam.gserviceaccount.com
```

---

## References

- [google_storage_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)
- [Cloud Storage documentation](https://cloud.google.com/storage/docs)
