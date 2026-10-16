#!/bin/sh
set -eu
cd "$(git rev-parse --show-toplevel)"

# Preferir el SDK instalado normalmente; usar el SDK de AppsMobiles como apoyo.
if command -v flutter >/dev/null 2>&1 && command -v dart >/dev/null 2>&1; then
  dart format .
  flutter analyze
  flutter test
elif [ -x ../tools/flutter/bin/flutter ]; then
  ../tools/flutter/bin/dart format .
  ../tools/flutter/bin/flutter analyze
  ../tools/flutter/bin/flutter test
else
  echo 'Agrega Flutter y Dart al PATH antes de verificar el proyecto.' >&2
  exit 1
fi
