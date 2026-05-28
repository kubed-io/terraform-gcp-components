module "bucket" {
  source = "../../modules/bucket"

  name          = "example-bucket"
  location      = "US"
  storage_class = "STANDARD"
  versioning    = true
  force_destroy = false

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

  iam = [
    {
      role    = "roles/storage.objectAdmin"
      members = ["serviceAccount:my-app@my-project.iam.gserviceaccount.com"]
    },
  ]

  labels = {
    managed-by = "crossplane"
  }
}
