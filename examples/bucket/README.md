# bucket example

Creates a GCS bucket with versioning, lifecycle rules, and IAM bindings.

## Terraform

Calls the `modules/bucket` module directly.

```sh
tofu init
tofu apply
```

## Kubernetes

Applies a `Bucket` composite resource. Crossplane reconciles it into an OpenTofu Workspace that calls the same module.

```sh
kubectl apply -k .
```

After the bucket is created, retrieve the bucket URL:

```sh
kubectl get bucket example-bucket -o jsonpath='{.status.details.url}'
```
