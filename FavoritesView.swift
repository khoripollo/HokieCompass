//
//  FavoritesView.swift
//  VTCompass
//
//  Phase 9 — same card, filtered list.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favorites: FavoritesManager

    var body: some View {
        NavigationStack {
            Group {
                if favorites.favoriteBuildings.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(favorites.favoriteBuildings) { building in
                                BuildingRow(building: building)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                    }
                }
            }
            .background(VT.background)
            .navigationTitle("Favorites")
        }
        .tint(VT.maroon)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart")
                .font(.system(size: 44))
                .foregroundStyle(VT.orange)
            Text("No favorites yet")
                .font(.title3.weight(.semibold))
            Text("Tap the heart on any building in Explore and it will show up here.")
                .font(.subheadline)
                .foregroundStyle(VT.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(VT.background)
    }
}
