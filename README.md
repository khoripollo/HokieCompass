# VT Compass

VT Compass is a SwiftUI iOS campus navigation application designed to help students, visitors, and members of the Virginia Tech community find their way around the Blacksburg campus.

Instead of requiring users to interpret a traditional campus map, VT Compass allows a user to select a campus destination and receive simple directional information based on their current location, including distance, estimated walking time, and a live compass pointing toward the destination.

## Team Members

| Team Member | Email |
|---|---|
| Sandhya Bontu | bsandhya17@vt.edu |
| Henry Doan | hdoan05@vt.edu |
| TyKhori Cabiness | khori@vt.edu |

## Project Overview

Virginia Tech's campus contains many academic buildings, residence halls, dining facilities, athletic facilities, student-life spaces, and landmarks. For students who are new to campus and visitors who are unfamiliar with the area, finding a specific destination can be difficult.

VT Compass addresses this problem by providing a simple campus-focused navigation experience. Users can search or filter campus destinations, select a location, and use their phone's current location and compass heading to determine which direction they should travel.

The application is built entirely with Swift and SwiftUI and uses Apple's CoreLocation framework for location and heading information.

## Features

- Search Virginia Tech campus destinations by name, category, descriptor, or supported aliases.
- Browse and filter campus destinations.
- View academic buildings, residence halls, dining locations, athletic facilities, and campus landmarks.
- View destination information and building images when available.
- Calculate the user's distance from a selected destination.
- Estimate walking time to the selected destination.
- Display a live compass arrow pointing toward the destination.
- Provide directional messages such as whether the destination is ahead or behind the user.
- Detect when the user has arrived near the selected destination.
- Save buildings as favorites.
- Persist favorites between app launches.
- Handle denied location permissions without crashing.
- Provide fallback icons when a building image is unavailable.
- Warn users when a destination's coordinate has not yet been verified.

## Technologies Used

- Swift
- SwiftUI
- CoreLocation
- UIKit
- Xcode
- UserDefaults


## Requirements

To build and run VT Compass, you will need:

- macOS
- Xcode
- iOS 16 or later
- An iPhone or iOS Simulator

A physical iPhone is strongly recommended for testing the live compass because the iOS Simulator does not provide the same magnetometer/heading functionality as a physical device.

## How to Run the Program

### 1. Open or Create the Xcode Project

Open the VT Compass Xcode project if the complete project repository is available.

If creating a new Xcode project from the source files:

1. Open Xcode.
2. Select **Create a new Xcode project**.
3. Choose **iOS → App**.
4. Set the interface to **SwiftUI**.
5. Set the language to **Swift**.
6. Add the VT Compass Swift source files to the project.
7. Make sure **Copy items if needed** is selected when importing the files.
8. Make sure there is only one Swift file containing the `@main` application entry point.

`VTCompassApp.swift` should be used as the application entry point.

### 2. Configure Location Permission

VT Compass requires access to the user's location.

In Xcode:

1. Select the project.
2. Select the application target.
3. Open the **Info** tab.
4. Add the following key:

`NSLocationWhenInUseUsageDescription`

Suggested value:

`VT Compass uses your location to point you toward the building you select.`

Without this permission description, iOS will not correctly request location access and the compass navigation functionality will not work.

### 3. Add Building Images

Building images should be stored in `Assets.xcassets`.

Each image asset should use the same name as the corresponding building's `imageName`/ID in the project data.

If an image cannot be found, VT Compass automatically displays a fallback building/category icon instead of crashing.

### 4. Build the Application

Select an iOS Simulator or connected iPhone from the Xcode device menu.

Then select:

**Product → Build**

or press:

**Command + B**

Resolve any signing configuration requested by Xcode if running the application on a physical device.

### 5. Run the Application

Select:

**Product → Run**

or press:

**Command + R**

When prompted, allow VT Compass to access your location while using the application.

### 6. Testing the Compass

For full compass testing, run VT Compass on a physical iPhone.

Select a destination and slowly rotate the phone. The compass arrow should continue pointing toward the selected destination as the phone changes direction.

The Simulator can still be used to test much of the interface, search functionality, filtering, favorites, and other application behavior, but live heading functionality should be verified on a physical device.

## How Navigation Works

VT Compass combines the user's current geographic position with the stored coordinate of the selected destination.

The application calculates:

1. The straight-line distance between the user and destination.
2. The geographic bearing from the user's position to the destination.
3. The difference between that bearing and the phone's current heading.
4. The rotation required for the on-screen compass arrow.

The application also handles compass-angle wraparound so that crossing north does not cause the arrow to unnecessarily rotate almost an entire circle in the opposite direction.

Walking time is currently estimated using distance and an average walking speed rather than an actual pedestrian route.

## Building Data

Most verified building coordinates are based on Virginia Tech's published building information.

Destinations that do not yet have an authoritative coordinate are explicitly marked as unverified by the application. This allows the app to distinguish verified destination data from approximate locations instead of presenting estimates as exact positions.

## Favorites

Users can tap the heart icon associated with a destination to add or remove it from their favorites.

Favorite building IDs are stored locally using `UserDefaults`, allowing the Favorites tab to persist between application launches.

## Known Limitations

- Some campus destinations do not yet have verified coordinates.
- Building photographs must be included manually in the application's asset catalog; missing photographs use fallback icons.
- Walking time is an estimate based on straight-line distance and average walking speed rather than an actual pedestrian route.
- Live compass heading functionality should be tested on a physical iPhone.
- The iOS 16 `onChange` implementation used by the project may produce a deprecation warning when building against newer iOS SDKs.

## Future Improvements

Given additional development time, we would like to:

- Add photographs for all supported campus destinations.
- Verify all remaining approximate destination coordinates.
- Integrate MapKit for actual pedestrian routes and more accurate walking-time estimates.
- Add an interactive Virginia Tech campus map.
- Expand destination categories and campus information.
- Add additional accessibility and appearance options.
- Add automated unit tests for bearing, distance, compass rotation, and navigation calculations.
- Update deprecated APIs for newer versions of iOS.
- Continue improving the user interface and destination data.

## Project Structure

The project is organized around several main responsibilities:

- `Building.swift` — campus destination model and categories.
- `BuildingData.swift` — campus destination data, coordinates, aliases, and search.
- `ExploreView.swift` — destination search, filtering, and browsing.
- `BuildingRow.swift` / `BuildingThumbnail.swift` — reusable destination list UI.
- `BuildingDetailView.swift` — destination details, distance, walking time, and compass navigation.
- `CompassView.swift` — visual compass interface.
- `LocationManager.swift` — CoreLocation authorization, user location, and device heading.
- `LocationMath.swift` — distance, bearing, angle normalization, and walking-time calculations.
- `FavoritesManager.swift` — persistent favorite destinations.
- `FavoritesView.swift` — saved destinations.
- `Theme.swift` — shared application colors and styling.
- `ContentView.swift` — main tab interface.
- `VTCompassApp.swift` — application entry point and shared environment objects.

## Authors

**Sandhya Bontu**  
bsandhya17@vt.edu

**Henry Doan**  
hdoan05@vt.edu

**TyKhori Cabiness**  
khori@vt.edu
