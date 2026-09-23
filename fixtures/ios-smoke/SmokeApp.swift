import SwiftUI

// Minimal iOS coverage fixture for infra-tests.
//
// Deliberately native and dependency-free. The Expo fixture this replaces
// cannot run on iOS 27 at all: UIKit terminates any app that has not adopted
// the UIScene lifecycle, and Expo only wires that up from SDK 58. SwiftUI's
// App protocol is scene-based by construction, so this cannot regress the
// same way — and it has no JS dependency tree to rot.
//
// Every string below is asserted by flows/ios-smoke.yaml. Keep them in step.
@main
struct SmokeApp: App {
  var body: some Scene {
    WindowGroup {
      VStack(spacing: 24) {
        Text("DeviceCloud Smoke Test")
          .font(.title2).bold()
          .accessibilityIdentifier("smoke_title")
        Text("Device ready")
          .accessibilityIdentifier("smoke_status")
        Button("Tap Me") { }
          .accessibilityIdentifier("smoke_button")
      }
      .padding()
    }
  }
}
