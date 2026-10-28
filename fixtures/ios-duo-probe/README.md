# ios-duo-probe fixture

`binaries/dcdduoprobe.zip`: the app that the iPhone Duo flows in
`flows/ios-duo/` run against. Like ios-smoke, it is native SwiftUI with no
dependencies.

## Why it exists

The iPhone Duo (Xcode 27.1+) has two displays:

| Display | Pixels | Points |
|---|---|---|
| cover (`primary`) | 1398×2034 | 466×678 |
| inner (`primary-1`) | 2007×2853 | 669×951 |

The app moves between them as the device folds. dcdsmoke only shows that an
app launches. This probe shows which display the app is on, and whether
Maestro can drive it there:

- the window size in points;
- the size classes;
- the scene's screen;
- the process start time, which changes if a fold relaunches the app rather
  than resizing it;
- four corner buttons and a text field, which check that taps land where the
  view hierarchy puts them.

On a foldable's inner screen, Maestro 2.11 and earlier shifts the hierarchy and
misses taps (mobile-dev-inc/Maestro#3623). So in that posture,
`flows/ios-duo/duo-probe.yaml` is expected to fail.

## Rebuilding

Build with **Xcode 27.1 or later**. Linking against an older SDK makes the Duo
run the app in compatibility mode, and then it no longer probes what a
Duo-aware customer app does.

```bash
cd fixtures/ios-duo-probe
mkdir -p dcdduoprobe.app
xcrun -sdk iphonesimulator swiftc \
  -target arm64-apple-ios17.0-simulator \
  -sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)" \
  -parse-as-library -O DuoProbeApp.swift -o dcdduoprobe.app/dcdduoprobe
cp Info.plist dcdduoprobe.app/
zip -qry ../../binaries/dcdduoprobe.zip dcdduoprobe.app
```

The deployment target is 17.0, the same as ios-smoke, so the app installs on
every cell, not only the Duo.
