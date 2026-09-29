#!/usr/bin/env bash
set -euo pipefail
# Optional: cryptographically sign a release after installing cosign.
# Usage: COSIGN_KEY=cosign.key ./scripts/sign_release.sh dist/AURORA_FX.tar.gz
artifact=${1:?artifact path required}
command -v cosign >/dev/null || { echo 'cosign not installed'; exit 3; }
: "${COSIGN_KEY:?set COSIGN_KEY to your private key path}"
cosign sign-blob --key "$COSIGN_KEY" --output-signature "$artifact.sig" "$artifact"
echo "Signature written to $artifact.sig"
