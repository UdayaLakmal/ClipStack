# Changelog

All notable changes to ClipStack are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Semantic Versioning](https://semver.org/).

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

[1.0.0]: https://github.com/UdayaLakmal/ClipStack/releases/tag/v1.0.0
