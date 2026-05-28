# dns-zone example

Creates a public GCP Cloud DNS managed zone with common records and IAM bindings.

## Terraform

Calls the `modules/dns-zone` module directly.

```sh
tofu init
tofu apply
```

## Kubernetes

Applies a `DnsZone` composite resource. Crossplane reconciles it into an OpenTofu Workspace that calls the same module.

```sh
kubectl apply -k .
```

After the zone is created, retrieve the delegated name servers:

```sh
kubectl get dnszone example-zone -o jsonpath='{.status.details.name_servers}'
```

Point your registrar's NS records at these to activate the zone.
