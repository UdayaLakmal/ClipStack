# Changelog

All notable changes to MacClipHistory (formerly ClipStack) are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Semantic Versioning](https://semver.org/).

## [1.1.0] - 2026-11-16

### Changed
- **ClipStack is now MacClipHistory.** New app name, download name and GitHub address. Old links redirect automatically.

### Added
- Your ClipStack history and pins are imported automatically the first time MacClipHistory starts. The old data is left untouched.

### Upgrading from ClipStack
Quit ClipStack and turn off its Launch at Login, install MacClipHistory, then allow MacClipHistory in **Accessibility** and turn on **Launch at Login** again.

## [1.0.1] - 2026-11-16

### Fixed
- Double-clicking an item now pastes it. Previously it was only copied, because ⌘V was sent while the mouse button was still down and keyboard focus hadn't returned to your app.
- ClipStack no longer fails silently when it lacks Accessibility permission. It now explains what to do and opens the right settings page.
- The simulated ⌘V ignores modifier keys you may still be holding (for example ⌃ from ⌃⌘V).

### Added
- Opening ClipStack from Launchpad, Spotlight or Finder while it's running shows its menu at the mouse pointer. Useful when the menu bar icon is hidden behind the MacBook notch.
- Menu shows the paste permission status: **Auto-paste: On** or **Auto-paste: Off — Fix…**.
- Diagnostic logging (never logs clipboard contents). See the README's Troubleshooting section.
- `CODESIGN_IDENTITY` option in `scripts/build.sh` to keep Accessibility permission across your own rebuilds.

## [1.0.0] - 2026-11-16

First public release.

### Added
- Menu bar app with no Dock icon.
- Clipboard history of the last 300 text items, saved across restarts.
- Global shortcut <kbd>⌃⌘V</kbd> opens a floating, searchable history picker next to the mouse pointer.
- Keyboard navigation: type to filter, ↑/↓, ↩ to paste, Esc to close, ⌘1–⌘9 quick paste.
- Automatic paste into the frontmost app (requires Accessibility permission). Falls back to copy-only.
- Pin and delete items from the right-click menu. Pinned items stay at the top and survive Clear History.
- Skips items marked as concealed or transient by password managers.
- Launch at Login toggle, About window, and a link to the GitHub project.
- Universal binary for Apple Silicon and Intel, macOS 13 Ventura or later.

[1.1.0]: https://github.com/UdayaLakmal/MacClipHistory/releases/tag/v1.1.0
[1.0.1]: https://github.com/UdayaLakmal/ClipStack/releases/tag/v1.0.1
[1.0.0]: https://github.com/UdayaLakmal/ClipStack/releases/tag/v1.0.0
