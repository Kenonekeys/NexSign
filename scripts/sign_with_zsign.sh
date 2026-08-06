#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <input.ipa> <certificate.p12> <mobileprovision> [p12-password] [output.ipa]"
  exit 1
fi

INPUT="$1"
P12="$2"
MOBILE="$3"
P12_PASS="${4:-}"
OUT="${5:-signed.ipa}"

# Requires zsign: https://github.com/ngs/zsign
# Example: ./scripts/sign_with_zsign.sh MyApp.ipa cert.p12 mobile.provision password MyApp-signed.ipa

zsign -k "$P12" -p "$P12_PASS" -m "$MOBILE" -o "$OUT" "$INPUT"

echo "Signed output: $OUT"
