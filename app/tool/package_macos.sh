#!/bin/bash
# Packages the release app as Quarterdeck-macos.dmg (run from app/).
#
# With the signing secrets in the environment it signs the app with the
# Developer ID certificate (hardened runtime), notarizes and staples the app,
# then signs, notarizes and staples the dmg. Without them the dmg is unsigned.
#
#   tool/package_macos.sh [app] [dmg]
#
# Environment (the GitHub secrets of the release workflow):
#   MACOS_CERT_P12        base64 of the Developer ID Application .p12
#   MACOS_CERT_PASSWORD   its password
#   APPLE_API_KEY_P8      base64 of the App Store Connect API key (.p8)
#   APPLE_API_KEY_ID      its key ID
#   APPLE_API_ISSUER      the App Store Connect issuer ID
#
# On your Mac, with none of them set, they are read from ../.secure_files
# (git ignored): developer_id.p12, p12_password.txt, AuthKey_<key id>.p8 and
# api_issuer.txt.
set -euo pipefail

secure=../.secure_files
if [ -z "${MACOS_CERT_P12:-}" ] && [ -f "$secure/developer_id.p12" ]; then
  p8=$(find "$secure" -maxdepth 1 -name 'AuthKey_*.p8' | head -n 1)
  MACOS_CERT_P12=$(base64 -i "$secure/developer_id.p12")
  MACOS_CERT_PASSWORD=$(cat "$secure/p12_password.txt")
  APPLE_API_KEY_P8=$(base64 -i "$p8")
  APPLE_API_KEY_ID=$(basename "$p8" .p8 | sed 's/^AuthKey_//')
  APPLE_API_ISSUER=$(cat "$secure/api_issuer.txt")
  echo "Signing with the files in $secure"
fi

app="${1:-build/macos/Build/Products/Release/Quarterdeck.app}"
dmg="${2:-Quarterdeck-macos.dmg}"
entitlements=macos/Runner/Release.entitlements
work=$(mktemp -d)
keychain="$work/signing.keychain-db"
signed=
[ -n "${MACOS_CERT_P12:-}" ] && signed=1

cleanup() {
  [ -n "$signed" ] && security delete-keychain "$keychain" 2>/dev/null
  rm -rf "$work"
}
trap cleanup EXIT

if [ -n "$signed" ]; then
  # A throwaway keychain holds the certificate for this run only.
  pass=$(openssl rand -hex 16)
  echo "$MACOS_CERT_P12" | base64 --decode > "$work/cert.p12"
  echo "$APPLE_API_KEY_P8" | base64 --decode > "$work/key.p8"
  security create-keychain -p "$pass" "$keychain"
  security set-keychain-settings -lut 3600 "$keychain"
  security unlock-keychain -p "$pass" "$keychain"
  security import "$work/cert.p12" -k "$keychain" -P "$MACOS_CERT_PASSWORD" -T /usr/bin/codesign >/dev/null
  security set-key-partition-list -S apple-tool:,apple: -s -k "$pass" "$keychain" >/dev/null
  # shellcheck disable=SC2046
  security list-keychains -d user -s "$keychain" $(security list-keychains -d user | tr -d '"')
  identity=$(security find-identity -v -p codesigning "$keychain" | awk -F'"' '/Developer ID Application/ {print $2; exit}')
  [ -n "$identity" ] || { echo "No Developer ID Application identity in MACOS_CERT_P12" >&2; exit 1; }
  echo "Signing as $identity"

  notarize() {
    local out id status
    out=$(xcrun notarytool submit "$1" --key "$work/key.p8" --key-id "$APPLE_API_KEY_ID" \
      --issuer "$APPLE_API_ISSUER" --wait --timeout 30m --output-format json)
    id=$(python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])' <<<"$out")
    status=$(python3 -c 'import json,sys; print(json.load(sys.stdin)["status"])' <<<"$out")
    echo "Notarization of $(basename "$1"): $status ($id)"
    if [ "$status" != Accepted ]; then
      xcrun notarytool log "$id" --key "$work/key.p8" --key-id "$APPLE_API_KEY_ID" --issuer "$APPLE_API_ISSUER"
      exit 1
    fi
  }

  # Inside out: the embedded frameworks and libraries, then the app itself.
  find "$app/Contents/Frameworks" -depth \( -name '*.framework' -o -name '*.dylib' \) -print0 |
    xargs -0 -I{} codesign --force --timestamp --options runtime --sign "$identity" {}
  codesign --force --timestamp --options runtime --entitlements "$entitlements" --sign "$identity" "$app"
  codesign --verify --strict --deep "$app"
  ditto -c -k --keepParent "$app" "$work/app.zip"
  notarize "$work/app.zip"
  xcrun stapler staple "$app"
fi

rm -rf "$work/dmg" "$dmg"
mkdir "$work/dmg"
cp -R "$app" "$work/dmg/"
ln -s /Applications "$work/dmg/Applications"
hdiutil create -quiet -volname Quarterdeck -srcfolder "$work/dmg" -ov -format UDZO "$dmg"

if [ -n "$signed" ]; then
  codesign --force --timestamp --sign "$identity" "$dmg"
  notarize "$dmg"
  xcrun stapler staple "$dmg"
  spctl --assess --type execute -v "$app"
  spctl --assess --type open --context context:primary-signature -v "$dmg"
else
  echo "No MACOS_CERT_P12: $dmg is not signed"
fi
