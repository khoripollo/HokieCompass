//
//  VTCompassApp.swift
//  VTCompass
//
//  CRASH FIX
//  ---------
//  The previous version created ContentView with no environment objects:
//
//      WindowGroup { ContentView() }
//
//  ExploreView, FavoritesView, BuildingDetailView and FavoriteButton all
//  declare @EnvironmentObject. SwiftUI traps at runtime the instant one of
//  them appears if the object was never injected, so the app died on launch.
//  The #Preview in ContentView.swift *did* inject them, which is why previews
//  kept working and hid the problem.
//
//  Both managers are owned here with @StateObject so there is exactly one of
//  each for the whole app's lifetime.
//

import SwiftUI

@main
struct VTCompassApp: App {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var favorites = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(favorites)
        }
    }
}
