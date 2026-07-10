#!/usr/bin/env bash
set -euo pipefail

REPOSITORY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIRECTORY="$REPOSITORY_ROOT/apps/staff_mobile"

if [[ -d "$APP_DIRECTORY/android" && -d "$APP_DIRECTORY/ios" && -f "$APP_DIRECTORY/.metadata" ]]; then
  echo "Flutter native scaffolding already exists."
  exit 0
fi

TEMP_DIRECTORY="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIRECTORY"' EXIT

flutter create \
  --empty \
  --platforms=android,ios \
  --org=com.visitflow \
  --project-name=visitflow_staff \
  "$TEMP_DIRECTORY/visitflow_staff"

rm -rf "$APP_DIRECTORY/android" "$APP_DIRECTORY/ios"
cp -R "$TEMP_DIRECTORY/visitflow_staff/android" "$APP_DIRECTORY/android"
cp -R "$TEMP_DIRECTORY/visitflow_staff/ios" "$APP_DIRECTORY/ios"
cp "$TEMP_DIRECTORY/visitflow_staff/.metadata" "$APP_DIRECTORY/.metadata"

echo "Generated Android and iOS Flutter scaffolding in apps/staff_mobile."
