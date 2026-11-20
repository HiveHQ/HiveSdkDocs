#!/usr/bin/env bash
# Checks a content image the way the sdk-docs pods use it (HiveHQ/aws-infra,
# kubernetes/apps/base/sdk-docs/deployment.yaml): an init container runs
# `cp -Rp /site/. /srv/site/` as root, with no capabilities and a read-only
# root filesystem, and stock nginx serves the copy.
#
# Usage: .github/scripts/check-image.sh IMAGE
set -euo pipefail

image=${1:?usage: $0 IMAGE}
vol="sdk-docs-check-$$"
trap 'docker volume rm -f "$vol" >/dev/null 2>&1 || true' EXIT

fail() {
  echo "::error::$1" >&2
  exit 1
}

# No entrypoint: the pod gives the command
entrypoint=$(docker image inspect --format '{{json .Config.Entrypoint}}' "$image")
[ "$entrypoint" = "null" ] || [ "$entrypoint" = "[]" ] || fail "image has an entrypoint: $entrypoint"

# The files index.html links to, at fixed paths. aws-infra's
# tests/nginx_conf.sh compares the same list with what's live. A hashed name
# (screen-1a2b3c4d.css) means config.rb's asset_hash got switched on.
files=(
  index.html
  stylesheets/screen.css stylesheets/print.css
  javascripts/all.js
  images/hive.ico images/logo.png images/navbar.png images/tracked-events.png
  fonts/slate.eot fonts/slate.svg fonts/slate.ttf fonts/slate.woff fonts/slate.woff2
)
docker run --rm "$image" sh -c 'for f; do [ -s "/site/$f" ] || { echo "missing or empty: /site/$f"; exit 1; }; done' sh "${files[@]}" ||
  fail "the site is missing files"

# Owned by root, 644 files and 755 directories
bad=$(docker run --rm "$image" find /site ! -user 0 -o ! -group 0 -o -type f ! -perm 644 -o -type d ! -perm 755)
[ -z "$bad" ] || fail "unexpected owner or mode: $(echo "$bad" | tr '\n' ' ')"

# The init container, with the pod's restrictions
docker volume create "$vol" >/dev/null
docker run --rm --read-only --cap-drop ALL --security-opt no-new-privileges \
  -v "$vol:/srv/site" "$image" cp -Rp /site/. /srv/site/ ||
  fail "cp -Rp /site/. /srv/site/ failed with the pod's restrictions"
docker run --rm -v "$vol:/srv/site:ro" "$image" diff -r /site /srv/site >/dev/null ||
  fail "the copy differs from /site"

echo "$image: OK"
