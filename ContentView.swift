//
//  ContentView.swift
//  VTCompass
//
//  Created by Sandhya Bontu on 9/21/26.
//

import SwiftUI

    struct ContentView: View {
        var body: some View {
            TabView {
                ExploreView()
                    .tabItem {
                        Label("Explore", systemImage: "map.fill")
                    }

                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
            }
            .tint(VT.maroon)
        }
    }


#Preview {
    ContentView()
        .environmentObject(LocationManager())
        .environmentObject(FavoritesManager())
}
