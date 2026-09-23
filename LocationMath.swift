//
//  LocationMath.swift
//  VTCompass
//
//  Phases 5, 6, 8 — all the math in one place, heavily commented because you
//  need to be able to explain this out loud.
//

import Foundation
import CoreLocation

enum LocationMath {

    // MARK: - Angle helpers

    /// Wraps any angle into 0..<360. Doing this in one place is what keeps the
    /// compass from misbehaving when it crosses north.
    static func normalizedDegrees(_ degrees: Double) -> Double {
        let remainder = degrees.truncatingRemainder(dividingBy: 360)
        return remainder < 0 ? remainder + 360 : remainder
    }

    /// Converts an angle into the equivalent value in -180...180.
    /// Example: 350° becomes -10°, which is what you want when asking
    /// "how far off am I, and which way?" rather than "what's the compass value?"
    static func signedDelta(_ degrees: Double) -> Double {
        let normalized = normalizedDegrees(degrees)
        return normalized > 180 ? normalized - 360 : normalized
    }

    // MARK: - Bearing

    /// Geographic ("forward azimuth") bearing from one coordinate to another,
    /// in degrees clockwise from true north. 0 = north, 90 = east, 180 = south.
    ///
    /// The formula, for the explanation you'll have to give:
    ///
    ///     θ = atan2( sin(Δλ)·cos(φ₂),
    ///                cos(φ₁)·sin(φ₂) − sin(φ₁)·cos(φ₂)·cos(Δλ) )
    ///
    /// where φ is latitude, λ is longitude, all in RADIANS.
    ///
    /// Why it isn't just `atan2(Δlat, Δlon)`: the Earth is a sphere, so a degree
    /// of longitude covers less ground the further you are from the equator.
    /// The cos(φ) terms are what correct for that convergence of the meridians.
    /// At Blacksburg's latitude the error from ignoring it would be large enough
    /// to visibly mis-aim the arrow, so we do it properly.
    ///
    /// atan2 returns -π...π, so we normalize to 0..<360 at the end.
    static func bearing(from origin: CLLocationCoordinate2D,
                        to destination: CLLocationCoordinate2D) -> Double {

        let lat1 = origin.latitude * .pi / 180
        let lon1 = origin.longitude * .pi / 180
        let lat2 = destination.latitude * .pi / 180
        let lon2 = destination.longitude * .pi / 180

        let deltaLon = lon2 - lon1

        let y = sin(deltaLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)

        let radians = atan2(y, x)
        let degrees = radians * 180 / .pi

        return normalizedDegrees(degrees)
    }

    /// How far to rotate the on-screen arrow.
    ///
    /// The bearing is relative to true north. The phone's heading is also
    /// relative to true north. The screen, however, is relative to *the phone*.
    /// So subtracting the heading converts a world-frame angle into a
    /// screen-frame angle:
    ///
    ///     arrowRotation = bearingToDestination − deviceHeading
    ///
    /// Result 0 means "dead ahead, top of the screen". If you spin the phone
    /// clockwise, heading increases, so the rotation decreases — the arrow
    /// swings counter-clockwise on screen and keeps aiming at the same real
    /// place on campus. That's exactly the behavior we want.
    ///
    /// Normalizing handles the wraparound: a bearing of 10° with a heading of
    /// 350° gives -340°, which normalizes to 20°, not a 340° spin the long way.
    static func arrowRotation(bearing: Double, heading: Double) -> Double {
        normalizedDegrees(bearing - heading)
    }

    // MARK: - Distance

    static let metersPerMile = 1609.344

    /// Straight-line ("as the crow flies") distance. Intentionally NOT a walking
    /// route — see WalkingTime below.
    static func distance(from userLocation: CLLocation, to building: Building) -> CLLocationDistance {
        userLocation.distance(from: building.location)
    }

    /// Human-readable distance.
    /// - Under ~0.1 mi we switch to feet, because "0.1 mi" is useless when
    ///   you're standing next to the building.
    /// - Otherwise one decimal place only, so the label doesn't flicker while
    ///   GPS jitters.
    static func distanceString(meters: CLLocationDistance) -> String {
        let miles = meters / metersPerMile
        if miles < 0.1 {
            let feet = (meters * 3.28084 / 10).rounded() * 10   // nearest 10 ft
            return "\(Int(feet)) ft"
        }
        return String(format: "%.1f mi", miles)
    }
}

// MARK: - Walking time

/// Phase 8 — deliberately isolated so it can be swapped for MapKit later.
///
/// To upgrade: keep this type's shape, replace the body of `minutes(forMeters:)`
/// with an async MKDirections request using `.transportType = .walking` and
/// read `route.expectedTravelTime`. Nothing else in the app needs to change,
/// because no other file does walking-time arithmetic.
enum WalkingTime {

    /// Average walking pace. 3 mph is the usual planning figure for an adult on
    /// flat ground. Campus has hills and crosswalks, so treat this as a floor.
    static let milesPerHour = 3.0

    static func minutes(forMeters meters: CLLocationDistance) -> Int {
        let metersPerMinute = milesPerHour * LocationMath.metersPerMile / 60
        let raw = meters / metersPerMinute
        return max(1, Int(raw.rounded()))   // never show "0 min"
    }

    static func string(forMeters meters: CLLocationDistance) -> String {
        "\(minutes(forMeters: meters)) min"
    }
}
