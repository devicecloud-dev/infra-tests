# ios-smoke fixture

`binaries/dcdsmoke.zip` — the app the iOS matrices run against. 9KB, native
SwiftUI, no dependencies.

## Why it exists

It replaced `wikipedia-pre26.zip` / `sample.zip` on 2026-09-23. Those are the
same x86_64-only build, and iOS 26.5 and 27.0 refuse to install an Intel-only
simulator app — `Failed to find matching arch`, surfaced to the user as "This
app needs to be updated by the developer". Every iOS cell on a current runtime
failed.

A native SwiftUI app also sidesteps a second trap. From iOS 27, UIKit
terminates any app that has not adopted the UIScene lifecycle, before the first
frame. That kills Expo apps built with SDK 57 or earlier, and it does not look
like a crash — the run reports a failed `assertVisible`, and a flow with no
assertion passes. SwiftUI's `App` protocol is scene-based by construction.

## Rebuilding

Needs a Mac with Xcode only — no node, no CocoaPods, no project file:

```bash
cd fixtures/ios-smoke
mkdir -p dcdsmoke.app
xcrun -sdk iphonesimulator swiftc \
  -target arm64-apple-ios17.0-simulator \
  -sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)" \
  -parse-as-library -O SmokeApp.swift -o dcdsmoke.app/dcdsmoke
cp Info.plist dcdsmoke.app/
zip -qry ../../binaries/dcdsmoke.zip dcdsmoke.app
```

`-parse-as-library` is required: a lone `.swift` file is treated as script mode
and `@main` is then rejected.

The deployment target is 17.0, the oldest runtime we hold. Raise it only when
that floor moves, or the fixture stops installing on the oldest cell.

Verified on iPhone 15/17, iPhone 14/18, iPhone 16/26, iPhone 18 Pro/27 and
iPad Pro 13-inch M5/27 — all passing, 3-6s each.
