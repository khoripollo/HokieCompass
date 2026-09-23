//
//  BuildingDetailView.swift
//  VTCompass
//
//  Phases 3–8 — the screen that matters. Photo, distance, walking time, and a
//  live arrow.
//

import SwiftUI
import CoreLocation
import UIKit

struct BuildingDetailView: View {
    let building: Building

    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var favorites: FavoritesManager

    /// The angle actually handed to the arrow. It is NOT clamped to 0..<360.
    ///
    /// This is the fix for the north-crossing problem. If the true target goes
    /// 359° → 1°, feeding those raw numbers to rotationEffect makes SwiftUI
    /// animate 358° backwards — the arrow visibly whips around the dial. So we
    /// accumulate the *shortest signed step* each update instead. The angle may
    /// drift to 700° or -400° over a long session, which is fine: 700° and 340°
    /// draw identically.
    @State private var displayRotation: Double = 0

    // MARK: - Derived values

    private var userLocation: CLLocation? { locationManager.location }

    private var distanceMeters: CLLocationDistance? {
        userLocation.map { LocationMath.distance(from: $0, to: building) }
    }

    private var bearingDegrees: Double? {
        userLocation.map { LocationMath.bearing(from: $0.coordinate, to: building.coordinate) }
    }

    /// bearing − heading, normalized. nil until we have both a fix and a heading.
    private var targetRotation: Double? {
        guard let bearing = bearingDegrees,
              let heading = locationManager.headingDegrees else { return nil }
        return LocationMath.arrowRotation(bearing: bearing, heading: heading)
    }

    private var compassIsLive: Bool { targetRotation != nil }

    /// "Arrived" threshold. GPS on a phone is good to roughly 5–10 m in the
    /// open, so anything tighter than this would flicker.
    private var hasArrived: Bool {
        guard let meters = distanceMeters else { return false }
        return meters < 30
    }

    private var guidanceText: String {
        if hasArrived { return "You've arrived at \(building.name)" }
        guard let target = targetRotation else { return "Point your phone to start the compass" }
        let offset = abs(LocationMath.signedDelta(target))
        if offset < 20 { return "\(building.name) is straight ahead" }
        if offset > 150 { return "Turn around — \(building.name) is behind you" }
        return "Head toward \(building.name)"
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header
                if locationManager.isDenied {
                    permissionDeniedCard
                } else {
                    infoCards
                    compassSection
                }
                if !building.coordinatesVerified { approximateCoordinateNote }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(VT.background)
        .navigationTitle(building.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FavoriteButton(building: building)
            }
        }
        .onAppear {
            locationManager.start()
            if let target = targetRotation { displayRotation = target }
        }
        .onDisappear { locationManager.stop() }
        .onChange(of: targetRotation) { newValue in
            guard let newValue else { return }
            advanceRotation(toward: newValue)
        }
    }

    /// Steps `displayRotation` to the nearest representation of `target`.
    ///
    /// `signedDelta` turns "go to 5° when you're at 355°" into "+10°" rather
    /// than "−350°", so the arrow always takes the short way around.
    private func advanceRotation(toward target: Double) {
        let delta = LocationMath.signedDelta(target - displayRotation)
        displayRotation += delta
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: 12) {
            BuildingImage(imageName: building.imageName)
                .frame(height: 190)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)

            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(building.name)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(VT.primaryText)
                    Text(building.category)
                        .font(.subheadline)
                        .foregroundStyle(VT.secondaryText)
                }
                Spacer()
                FavoriteButton(building: building)
            }
        }
        .padding(.top, 8)
    }

    private var infoCards: some View {
        HStack(spacing: 12) {
            InfoCard(icon: "ruler",
                     title: "DISTANCE",
                     value: distanceMeters.map { LocationMath.distanceString(meters: $0) } ?? "—")
            InfoCard(icon: "figure.walk",
                     title: "WALKING TIME",
                     value: distanceMeters.map { WalkingTime.string(forMeters: $0) } ?? "—")
        }
    }

    private var compassSection: some View {
        VStack(spacing: 18) {
            CompassView(arrowRotation: displayRotation,
                        ringRotation: -(locationManager.headingDegrees ?? 0),
                        isActive: compassIsLive && !hasArrived)

            Text(guidanceText)
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(.center)
                .foregroundStyle(VT.primaryText)
                .padding(.horizontal, 12)

            statusLine
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .cardStyle(cornerRadius: 20)
    }

    /// Covers the remaining permission / hardware states without a wall of
    /// nested ifs in the main body.
    @ViewBuilder
    private var statusLine: some View {
        if locationManager.authorizationStatus == .notDetermined {
            VStack(spacing: 10) {
                Text("Location access is needed to point the compass.")
                    .font(.footnote)
                    .foregroundStyle(VT.secondaryText)
                Button("Enable Location") { locationManager.requestPermission() }
                    .buttonStyle(.borderedProminent)
                    .tint(VT.maroon)
            }
        } else if !locationManager.headingIsAvailable {
            statusText("Compass hardware isn't available on this device. Distance and walking time still work.")
        } else if userLocation == nil {
            HStack(spacing: 8) {
                ProgressView()
                Text("Finding your location...")
                    .font(.footnote)
                    .foregroundStyle(VT.secondaryText)
            }
        } else if locationManager.headingDegrees == nil {
            statusText("Waiting for compass...")
        } else if locationManager.headingNeedsCalibration {
            statusText("Compass accuracy is low — wave your phone in a figure 8.")
        }
    }

    private func statusText(_ text: String) -> some View {
        Text(text)
            .font(.footnote)
            .foregroundStyle(VT.secondaryText)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
    }

    private var permissionDeniedCard: some View {
        VStack(spacing: 14) {
            Image(systemName: "location.slash.fill")
                .font(.system(size: 40))
                .foregroundStyle(VT.orange)
            Text("Location access is off")
                .font(.title3.weight(.semibold))
            Text("The compass needs your location to know which way \(building.name) is. You can turn it on in Settings.")
                .font(.subheadline)
                .foregroundStyle(VT.secondaryText)
                .multilineTextAlignment(.center)
            Button("Open Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(VT.maroon)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .cardStyle(cornerRadius: 20)
    }

    private var approximateCoordinateNote: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(VT.orange)
            Text("Approximate location — coordinates for this building haven't been verified yet.")
                .font(.caption)
                .foregroundStyle(VT.secondaryText)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle(cornerRadius: 12)
    }
}

// MARK: - Info card

struct InfoCard: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption.weight(.semibold))
                Text(title)
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(VT.maroon)

            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(VT.primaryText)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}
