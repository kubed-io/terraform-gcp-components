# identity-pool-provider example

Creates a GitHub Actions OIDC provider under an existing Workload Identity Pool and grants `roles/iam.workloadIdentityUser` on a service account, allowing GitHub Actions workflows to authenticate as GCP service accounts without long-lived keys.

## Prerequisites

The pool referenced by `poolId` must already exist — create it with the `identity-pool` module or CRD first.

## Terraform

Calls the `modules/identity-pool-provider` module directly.

```sh
tofu init
tofu apply
```

## Kubernetes

Applies an `IdentityPoolProvider` composite resource. Crossplane reconciles it into an OpenTofu Workspace that calls the same module.

```sh
kubectl apply -k .
```

After the provider is created, retrieve the audience string to use in GitHub Actions workflows:

```sh
kubectl get identitypoolprovider github -o jsonpath='{.status.details.audience}'
```

Use the audience in your GitHub Actions workflow:

```yaml
- uses: google-github-actions/auth@v2
  with:
    workload_identity_provider: ${{ steps.provider.outputs.audience }}
    service_account: example-app@my-project.iam.gserviceaccount.com
```
