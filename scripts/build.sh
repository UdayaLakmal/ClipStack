#!/bin/zsh
# Build MacClipHistory.app (universal: Apple Silicon + Intel).
#
#   scripts/build.sh            build into build/MacClipHistory.app
#   scripts/build.sh install    build, copy to ~/Applications and launch
#   scripts/build.sh release    build and package dist/MacClipHistory-<version>.zip
#   scripts/build.sh icon       regenerate Resources/AppIcon.icns
set -euo pipefail
cd "$(dirname "$0")/.."

VERSION=$(cat VERSION)
BUILD_NUMBER=$(git rev-list --count HEAD 2>/dev/null || echo 1)
APP=build/MacClipHistory.app
MIN_MACOS=13.0

make_icon() {
  local tmp; tmp=$(mktemp -d)
  swift scripts/make-icon.swift "$tmp/icon_1024.png"
  local set="$tmp/AppIcon.iconset"; mkdir -p "$set"
  for s in 16 32 128 256 512; do
    sips -z $s $s "$tmp/icon_1024.png" --out "$set/icon_${s}x${s}.png" >/dev/null
    sips -z $((s*2)) $((s*2)) "$tmp/icon_1024.png" --out "$set/icon_${s}x${s}@2x.png" >/dev/null
  done
  iconutil -c icns "$set" -o Resources/AppIcon.icns
  cp "$tmp/icon_1024.png" docs/images/icon.png
  rm -rf "$tmp"
  echo "Icon written to Resources/AppIcon.icns"
}

build() {
  [[ -f Resources/AppIcon.icns ]] || make_icon
  rm -rf "$APP"
  mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources" build/obj

  for arch in arm64 x86_64; do
    swiftc -O -swift-version 5 -target "$arch-apple-macos$MIN_MACOS" \
      Sources/main.swift -o "build/obj/MacClipHistory-$arch"
  done
  lipo -create build/obj/MacClipHistory-arm64 build/obj/MacClipHistory-x86_64 -output "$APP/Contents/MacOS/MacClipHistory"

  sed -e "s/__VERSION__/$VERSION/" -e "s/__BUILD__/$BUILD_NUMBER/" -e "s/__MIN_MACOS__/$MIN_MACOS/" \
    Resources/Info.plist > "$APP/Contents/Info.plist"
  cp Resources/AppIcon.icns "$APP/Contents/Resources/"

  # Ad-hoc signing by default. macOS ties Accessibility permission to the exact build, so it must be
  # re-granted after each rebuild. Set CODESIGN_IDENTITY to a certificate name to keep it across builds.
  codesign --force --sign "${CODESIGN_IDENTITY:--}" "$APP" >/dev/null
  echo "Built $APP (v$VERSION, build $BUILD_NUMBER)"
}

case "${1:-build}" in
  icon) make_icon ;;
  build) build ;;
  install)
    build
    pkill -x MacClipHistory || true
    mkdir -p ~/Applications
    rm -rf ~/Applications/MacClipHistory.app
    cp -R "$APP" ~/Applications/
    open ~/Applications/MacClipHistory.app
    echo "Installed to ~/Applications/MacClipHistory.app"
    ;;
  release)
    build
    mkdir -p dist
    ZIP="dist/MacClipHistory-$VERSION.zip"
    rm -f "$ZIP"
    ditto -c -k --sequesterRsrc --keepParent "$APP" "$ZIP"
    shasum -a 256 "$ZIP" | tee "$ZIP.sha256"
    ;;
  screenshots)
    build
    "$APP/Contents/MacOS/MacClipHistory" --screenshot docs/images
    ;;
  *) echo "usage: $0 [build|install|release|icon|screenshots]"; exit 1 ;;
esac
