# service-account example

Creates a GCP service account with project-level IAM roles and writes the JSON key to a Kubernetes Secret.

## Terraform

Calls the `modules/service-account` module directly.

```sh
tofu init
tofu apply
```

## Kubernetes

Applies a `ServiceAccount` composite resource. Crossplane reconciles it into an OpenTofu Workspace that calls the same module and writes credentials to the secret named in `writeSecretTo`.

```sh
kubectl apply -k .
```

After the account is created, retrieve the service account email:

```sh
kubectl get serviceaccount example-app -o jsonpath='{.status.details.email}'
```

The JSON key is written to the secret specified in `writeSecretTo`:

```sh
kubectl get secret example-app-gcp-creds -n default -o jsonpath='{.data.credentials\.json}' | base64 -d
```
