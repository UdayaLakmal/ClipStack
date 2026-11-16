# Contributing to ClipStack

Thanks for helping improve ClipStack! Bug reports, ideas and pull requests are all welcome.

- **Bugs and ideas:** [open an issue](https://github.com/UdayaLakmal/ClipStack/issues). For bugs, include your macOS version, Mac model, and steps to reproduce.
- **Pull requests:** keep changes focused, test them on a real Mac, and describe what you changed and why.

## Building

You need the Xcode Command Line Tools (`xcode-select --install`). Xcode itself is not required.

```bash
git clone https://github.com/UdayaLakmal/ClipStack.git
cd ClipStack
scripts/build.sh install
```

That builds a universal `ClipStack.app`, copies it to `~/Applications` and launches it.

| Command | Result |
|---|---|
| `scripts/build.sh` | Builds `build/ClipStack.app` (universal) |
| `scripts/build.sh install` | Builds, installs to `~/Applications`, launches |
| `scripts/build.sh release` | Builds and zips to `dist/ClipStack-<version>.zip` with a SHA-256 checksum |
| `scripts/build.sh screenshots` | Regenerates the images in `docs/images` from sample data |
| `scripts/build.sh icon` | Regenerates `Resources/AppIcon.icns` from `scripts/make-icon.swift` |

Builds are signed ad-hoc, so macOS asks for Accessibility permission again after every rebuild. To avoid that, create a code-signing certificate (Keychain Access → Certificate Assistant → Create a Certificate, type **Code Signing**) and build with `CODESIGN_IDENTITY="Your Certificate Name" scripts/build.sh install`.

## Customising

Everything lives in [`Sources/main.swift`](Sources/main.swift):

| Want to change | Where |
|---|---|
| Shortcut | `HotKey(keyCode: kVK_ANSI_V, modifiers: controlKey \| cmdKey)` in `AppDelegate` |
| Number of items kept | `static let maxItems = 300` in `HistoryStore` |
| Popup size | `width: 440, height: 480` in `PickerController` |
| Ignored clipboard types | `ignoredTypes` in `ClipboardMonitor` |

## How it works

```
 ┌──────────────────┐  every 0.4 s   ┌──────────────┐  save   ┌───────────────────┐
 │ ClipboardMonitor │ ─────────────▶ │ HistoryStore │ ──────▶ │ history.json      │
 └──────────────────┘ new text only  └──────────────┘         └───────────────────┘
                                            │
  ⌃⌘V ──▶ HotKey (Carbon) ──▶ PickerController (floating panel, search + list)
                                            │ ↩ / double-click
                                            ▼
          copy to NSPasteboard ──▶ refocus previous app ──▶ simulated ⌘V
```

- **Clipboard watching**: macOS has no "clipboard changed" notification, so ClipStack checks `NSPasteboard.changeCount` a few times a second, which is cheap.
- **Shortcut**: registered with Carbon's `RegisterEventHotKey`, which works system-wide and needs no permission.
- **Picker**: a non-activating `NSPanel`, so the app you were typing in stays in front.
- **Paste**: a synthetic <kbd>⌘</kbd><kbd>V</kbd> via `CGEvent`, which is why Accessibility access is needed.

## Diagnostics

ClipStack logs events (never clipboard contents) to the system log. Watch them with:

```bash
log stream --predicate 'subsystem == "io.github.udayalakmal.clipstack"'
```
