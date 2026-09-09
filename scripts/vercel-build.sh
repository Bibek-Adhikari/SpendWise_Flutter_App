#!/usr/bin/env bash
set -euo pipefail

FLUTTER_VERSION="3.24.5"
FLUTTER_DIR="${TMPDIR:-/tmp}/flutter-${FLUTTER_VERSION}"

if ! command -v flutter >/dev/null 2>&1; then
  archive="${TMPDIR:-/tmp}/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
  if [[ ! -x "${FLUTTER_DIR}/bin/flutter" ]]; then
    curl --fail --location --silent --show-error \
      "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" \
      --output "${archive}"
    mkdir -p "${FLUTTER_DIR}"
    tar -xJf "${archive}" --strip-components=1 -C "${FLUTTER_DIR}"
  fi
  export PATH="${FLUTTER_DIR}/bin:${PATH}"
fi

flutter config --no-analytics
flutter pub get
flutter build web --release