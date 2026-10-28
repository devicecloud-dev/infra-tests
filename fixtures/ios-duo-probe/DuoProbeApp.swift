import SwiftUI
import UIKit

// iPhone Duo probe fixture for infra-tests.
//
// Built against the iOS 27.1 SDK, so the iPhone Duo treats it as a Duo-aware
// app instead of running it in compatibility mode. The deployment target is
// 17.0, like ios-smoke, so it still installs on every other cell.
//
// It reports what a test needs to tell the Duo's displays and postures apart:
// - the window size in points: 466x678 on the cover screen, and 669x951 or
//   951x669 on the inner one;
// - the size classes;
// - the scene's screen;
// - the process start time, which changes if the system relaunches the app on
//   a fold instead of resizing it.
// The four corner buttons check that taps land where the view hierarchy says
// they are. That is what breaks on a foldable's inner screen in Maestro 2.11
// and earlier (mobile-dev-inc/Maestro#3623).
//
// Every string below is asserted by flows/ios-duo/*.yaml. Keep them in step.

private let processStart: String = {
  let formatter = DateFormatter()
  formatter.dateFormat = "HH:mm:ss"
  return formatter.string(from: Date())
}()

@main
struct DuoProbeApp: App {
  var body: some Scene {
    WindowGroup {
      ProbeView()
    }
  }
}

struct ProbeView: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @Environment(\.verticalSizeClass) private var verticalSizeClass
  @State private var lastTap = "none"
  @State private var text = ""
  @State private var resizes = 0

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        VStack(spacing: 12) {
          Text("DCD Duo Probe")
            .font(.title2).bold()
            .accessibilityIdentifier("duo_title")
          Text("Window \(Int(geometry.size.width.rounded()))x\(Int(geometry.size.height.rounded()))")
            .accessibilityIdentifier("duo_window")
          Text("Size H:\(name(horizontalSizeClass)) V:\(name(verticalSizeClass))")
            .accessibilityIdentifier("duo_size_classes")
          Text(screenDescription())
            .accessibilityIdentifier("duo_screen")
          Text("Started \(processStart) Resizes \(resizes)")
            .accessibilityIdentifier("duo_started")
          Text("Last tap: \(lastTap)")
            .accessibilityIdentifier("duo_last_tap")
          TextField("Type here", text: $text)
            .textFieldStyle(.roundedBorder)
            .frame(maxWidth: 240)
            .accessibilityIdentifier("duo_input")
          Text("Echo: \(text)")
            .accessibilityIdentifier("duo_echo")
        }
        .padding()
        corner("TL", .topLeading)
        corner("TR", .topTrailing)
        corner("BL", .bottomLeading)
        corner("BR", .bottomTrailing)
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
      .onChange(of: geometry.size) { resizes += 1 }
    }
  }

  private func corner(_ label: String, _ alignment: Alignment) -> some View {
    Button(label) { lastTap = label }
      .padding(8)
      .accessibilityIdentifier("corner_\(label.lowercased())")
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
      .padding(12)
  }

  private func name(_ sizeClass: UserInterfaceSizeClass?) -> String {
    switch sizeClass {
    case .compact: "compact"
    case .regular: "regular"
    default: "unknown"
    }
  }

  private func screenDescription() -> String {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    guard let scene = scenes.first else { return "Screen none Scenes 0" }
    let bounds = scene.screen.bounds
    return "Screen \(Int(bounds.width))x\(Int(bounds.height)) @\(Int(scene.screen.scale))x Scenes \(scenes.count)"
  }
}
