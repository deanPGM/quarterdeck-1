import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    // Start at 1440x900, smaller if the screen is.
    let screen = (self.screen ?? NSScreen.main)?.visibleFrame.size ?? NSSize(width: 1440, height: 900)
    let windowFrame = NSRect(x: 0, y: 0, width: min(1440, screen.width), height: min(900, screen.height))
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    self.center()
    // Size and place as you left them: macOS saves the frame under this name
    // and puts it back here when there is one.
    self.setFrameAutosaveName("Quarterdeck")

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
