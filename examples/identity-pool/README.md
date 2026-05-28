# identity-pool example

Creates a GCP Workload Identity Pool. Pair with an `identity-pool-provider` to allow external workloads (e.g. GitHub Actions) to authenticate as GCP service accounts without long-lived keys.

## Terraform

Calls the `modules/identity-pool` module directly.

```sh
tofu init
tofu apply
```

## Kubernetes

Applies an `IdentityPool` composite resource. Crossplane reconciles it into an OpenTofu Workspace that calls the same module.

```sh
kubectl apply -k .
```

After the pool is created, retrieve the full pool name needed for provider configuration:

```sh
kubectl get identitypool example-pool -o jsonpath='{.status.details.pool_name}'
```
