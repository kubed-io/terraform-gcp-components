# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!--
  These ARE the release notes. One short line per entry, written for a user of the
  modules. CI-only, test-only and docs-only PRs take the `no changelog` label.
-->


## [Unreleased]

## [0.0.2] - 2026-10-12

### Added

- `service-account` module: a GCP service account with a JSON key, project and SA-level IAM bindings, and an optional HMAC key.
- `bucket` module: a GCS bucket with versioning, lifecycle rules, IAM bindings, CORS and labels.
- `identity-pool` module: a Workload Identity Pool.
- `identity-pool-provider` module: an OIDC Workload Identity Pool Provider, with defaults for GitHub Actions.
- `dns-zone` module: a Cloud DNS managed zone with record sets, IAM bindings, DNSSEC and query logging.
- Crossplane CRDs for each module (`*.gcp.kubed.io`), pinned to the release's own modules and pulled once per release.
