#!/usr/bin/env bash
# Upload Android signing secrets to this GitHub repo (values go through stdin, never argv/logs).
# Usage (Git Bash, from the app repo root, gh logged in):
#   bash .github/scripts/set-android-secrets.sh C:/Users/Admin/keystores/A001-subnest
# The folder must contain upload-keystore.jks + key.properties (storePassword/keyPassword/keyAlias).
set -euo pipefail

DIR="${1:?keystore folder required}"
JKS="$DIR/upload-keystore.jks"
PROPS="$DIR/key.properties"
[ -f "$JKS" ] || { echo "missing $JKS" >&2; exit 1; }
[ -f "$PROPS" ] || { echo "missing $PROPS" >&2; exit 1; }

prop() { grep "^$1=" "$PROPS" | head -n1 | cut -d= -f2- | tr -d '\r\n'; }

base64 -w0 "$JKS" | gh secret set ANDROID_KEYSTORE_BASE64
prop storePassword | gh secret set ANDROID_KEYSTORE_PASSWORD
prop keyPassword   | gh secret set ANDROID_KEY_PASSWORD
prop keyAlias      | gh secret set ANDROID_KEY_ALIAS

gh secret list
