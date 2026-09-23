# VT Compass — setup and notes

A SwiftUI campus compass for Virginia Tech. No third-party packages, no backend,
no auth. iOS 16+, portrait, light mode first.

## 1. Add the files to Xcode

1. New project → iOS → App → Interface **SwiftUI**, Language **Swift**.
2. Delete the generated `ContentView.swift`.
3. Drag the `Models`, `Services`, `Views`, `Utilities` folders and
   `VTCompassApp.swift` into the project navigator.
   Check **Copy items if needed** and **Create groups**.
4. If your product name isn't `VTCompass`, Xcode already made its own `@main`
   App file. Keep one of the two, not both — see the note at the top of
   `VTCompassApp.swift`.

## 2. Required Info.plist entry

Target → **Info** tab → add:

| Key | Value |
|---|---|
| `NSLocationWhenInUseUsageDescription` | `VT Compass uses your location to point you toward the building you select.` |

Without this key iOS never shows the permission prompt and the compass silently
stays dead. This is the single most common reason CoreLocation "doesn't work."

Nothing else is needed — no entitlement, no background mode, no capability.

## 3. Images (optional)

Drop images into `Assets.xcassets` named exactly:

`squires`, `torgersen`, `newman`, `burruss`, `mcbryde`, `goodwin`, `lane`,
`cassell`, `moss`, `inn`, `drillfield`, `glc`

Any that are missing render a maroon placeholder tile. The app will not crash
and will not try to download anything.

## 4. Fix the coordinates before you demo

Every building is currently `coordinatesVerified: false`, and the detail screen
shows an orange "approximate location" note because of it. The values are my
approximations of where these buildings sit on campus — right neighborhood,
not surveyed. I did not have a way to verify them, so I flagged them rather
than presenting them as accurate.

To replace one (about 15 seconds each):

1. Open Apple Maps or Google Maps, find the building.
2. Long-press the roof → copy the coordinate.
3. Paste into `BuildingData.swift` and flip that building's flag to
   `coordinatesVerified: true`.

The note disappears per-building as you verify them.

## 5. Testing the compass

The Simulator has **no magnetometer**, so heading is always nil there — you'll
see distance and walking time but a dimmed arrow and "Waiting for compass...".
That is correct behavior, not a bug. Test on a physical iPhone.

On device, the checks worth doing:

- Stand still, spin slowly in a full circle. The arrow should stay locked on the
  same physical direction the whole way around, including as you pass north.
  No whipping, no backwards spin — that's what the accumulated
  `displayRotation` in `BuildingDetailView` prevents.
- Pick a building you can see. Confirm the arrow agrees with your eyes. If it's
  consistently off by the same amount for every building, that's a coordinate
  problem (step 4). If it's off for only one building, that one building's
  coordinate is wrong.
- Deny location in Settings, reopen → friendly card with an Open Settings
  button, no crash.

## 6. Known warning

`onChange(of:perform:)` in `BuildingDetailView` uses the iOS 16 signature, which
Xcode marks deprecated when building against iOS 17+. It still compiles and
works. If you want it clean and can require iOS 17, change it to:

```swift
.onChange(of: targetRotation) { _, newValue in
    guard let newValue else { return }
    advanceRotation(toward: newValue)
}
```

## 7. What I could not verify

This code was written in a Linux sandbox with no Swift toolchain and no Xcode,
so **it has never been compiled**. The logic is straightforward and I checked it
carefully, but expect the possibility of a typo or an API-signature nit on first
build. Paste any compiler errors back and I'll fix them.

## File map (matches the phase order in the spec)

| Phase | Files |
|---|---|
| 1 — model + data | `Models/Building.swift`, `Models/BuildingData.swift` |
| 2 — explore, search, nav | `Views/ExploreView.swift`, `Views/BuildingRow.swift` |
| 3 — static detail UI | `Views/BuildingDetailView.swift`, `Views/CompassView.swift` |
| 4 — location + permissions | `Services/LocationManager.swift` |
| 5, 6, 7, 8 — distance, bearing, wraparound, walk time | `Utilities/LocationMath.swift` |
| 9 — favorites | `Services/FavoritesManager.swift`, `Views/FavoritesView.swift` |
| 10 — polish | `Utilities/Theme.swift` |
