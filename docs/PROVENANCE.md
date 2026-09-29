# Provenance and ownership evidence

The provenance layer is designed to make origin easy to demonstrate and silent alteration easy to detect.

The protected-file hash manifest is generated from repository content and stored at `.well-known/provenance.json`. `make verify-origin` recomputes SHA-256 digests and reports mismatches. The compiled CLI also prints the same Origin ID.

Hash manifests alone are not independent proof of time or identity because anyone who can modify the repository can regenerate them. Stronger evidence comes from signing commits/tags/releases with a private cryptographic key and publishing those signatures through a durable identity. The included cosign helper is intentionally optional so no private key is embedded in the repository.
