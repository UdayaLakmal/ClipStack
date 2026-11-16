// Draws the ClipStack app icon and writes a 1024×1024 PNG.
// Usage: swift scripts/make-icon.swift <output.png>
import Cocoa

let size: CGFloat = 1024
let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "icon_1024.png"

let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(size), pixelsHigh: Int(size),
                           bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                           colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)

// macOS icon grid: 824×824 rounded square centred in 1024, with a soft shadow.
let tile = NSRect(x: 100, y: 100, width: 824, height: 824)
let shape = NSBezierPath(roundedRect: tile, xRadius: 185, yRadius: 185)

NSGraphicsContext.saveGraphicsState()
let shadow = NSShadow()
shadow.shadowColor = NSColor.black.withAlphaComponent(0.35)
shadow.shadowBlurRadius = 28
shadow.shadowOffset = NSSize(width: 0, height: -12)
shadow.set()
NSColor.black.setFill()
shape.fill()
NSGraphicsContext.restoreGraphicsState()

NSGradient(colors: [NSColor(srgbRed: 0.38, green: 0.31, blue: 0.96, alpha: 1),
                    NSColor(srgbRed: 0.13, green: 0.62, blue: 0.98, alpha: 1)])!
    .draw(in: shape, angle: -60)

// Three stacked "clips" behind each other.
func card(_ r: NSRect, alpha: CGFloat) {
    let p = NSBezierPath(roundedRect: r, xRadius: 56, yRadius: 56)
    NSColor.white.withAlphaComponent(alpha).setFill()
    p.fill()
}
card(NSRect(x: 330, y: 610, width: 364, height: 150), alpha: 0.35)
card(NSRect(x: 290, y: 520, width: 444, height: 170), alpha: 0.55)
card(NSRect(x: 250, y: 230, width: 524, height: 380), alpha: 1.0)

// Text lines on the front card.
NSColor(srgbRed: 0.33, green: 0.36, blue: 0.95, alpha: 1).setFill()
for (i, w) in [380.0, 300.0, 340.0].enumerated() {
    NSBezierPath(roundedRect: NSRect(x: 322, y: 500 - CGFloat(i) * 90, width: w, height: 44),
                 xRadius: 22, yRadius: 22).fill()
}

NSGraphicsContext.restoreGraphicsState()
try! rep.representation(using: .png, properties: [:])!.write(to: URL(fileURLWithPath: out))
print("wrote \(out)")
