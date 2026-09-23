//
//  Building.swift
//  VTCompass
//
//  The model separates two things that were previously collapsed into one:
//
//    `categories`  — which filter chips a building appears under. Internal.
//                    A building can be in several (GLC is Academic + Residential).
//    `descriptor`  — the gray line shown under the name in the UI.
//                    "Student Life", "Campus Landmark", "Library".
//
//  They are NOT the same thing. Squires filters as Academic but displays as
//  "Student Life", which is exactly what the reference screenshots show.
//

import Foundation
import CoreLocation

/// The only filter categories that appear in the UI.
enum BuildingCategory: String, CaseIterable, Hashable, Identifiable {
    case academic = "Academic"
    case residential = "Residential"
    case dining = "Dining"
    case athletics = "Athletics"
    case landmark = "Landmark"

    var id: String { rawValue }
}

struct Building: Identifiable, Hashable {
    let id: String
    let name: String

    /// Gray subtitle under the name in every row.
    let descriptor: String

    /// Filter membership. Never shown directly.
    let categories: Set<BuildingCategory>

    let latitude: Double
    let longitude: Double
    let imageName: String

    /// true  = coordinate came from Virginia Tech's official building feed
    ///         (vt.edu/about/locations/buildings).
    /// false = still an estimate; the detail screen shows a warning badge.
    let coordinatesVerified: Bool

    /// Kept so BuildingDetailView keeps compiling unchanged — it reads
    /// `building.category` for the subtitle under the header photo.
    var category: String { descriptor }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }

    func belongs(to category: BuildingCategory) -> Bool {
        categories.contains(category)
    }

    /// Everything search should match: the name, the visible descriptor, and
    /// the filter category names. Typing "residential" or "student life" both
    /// work now; previously neither did.
    var searchableText: String {
        ([name, descriptor] + categories.map(\.rawValue)).joined(separator: " ")
    }
}
