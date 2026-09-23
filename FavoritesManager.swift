//
//  FavoritesManager.swift
//  VTCompass
//
//  Phase 9 — favorites, persisted in UserDefaults.
//
//  Why not @AppStorage: @AppStorage can't store a Set directly. A tiny
//  ObservableObject holding a Set in memory and an Array on disk is simpler
//  than encoding a Set into a String just to satisfy a property wrapper.
//

import Foundation
import Combine

final class FavoritesManager: ObservableObject {

    private let storageKey = "favoriteBuildingIDs"

    @Published private(set) var favoriteIDs: Set<String>

    init() {
        let saved = UserDefaults.standard.stringArray(forKey: storageKey) ?? []
        favoriteIDs = Set(saved)
    }

    func isFavorite(_ building: Building) -> Bool {
        favoriteIDs.contains(building.id)
    }

    func toggle(_ building: Building) {
        if favoriteIDs.contains(building.id) {
            favoriteIDs.remove(building.id)
        } else {
            favoriteIDs.insert(building.id)
        }
        save()
    }

    /// Favorites in the same order as the master list, so the Favorites tab
    /// doesn't reshuffle itself on every launch.
    var favoriteBuildings: [Building] {
        BuildingData.all.filter { favoriteIDs.contains($0.id) }
    }

    private func save() {
        UserDefaults.standard.set(Array(favoriteIDs), forKey: storageKey)
    }
}
