//
//  LocationManager.swift
//  VTCompass
//
//  Phase 4 — one CLLocationManager for the whole app, published into SwiftUI.
//
//  Requires NSLocationWhenInUseUsageDescription in Info.plist. Without it,
//  iOS silently refuses to show the permission prompt and you'll waste an hour
//  wondering why nothing happens.
//

import Foundation
import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject {

    @Published private(set) var location: CLLocation?
    @Published private(set) var heading: CLHeading?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined

    /// Simulator and some iPads have no magnetometer.
    let headingIsAvailable: Bool = CLLocationManager.headingAvailable()

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 5          // meters; don't spam updates
        manager.headingFilter = 1           // degrees; smooth but responsive
        authorizationStatus = manager.authorizationStatus
    }

    var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }

    var isDenied: Bool {
        authorizationStatus == .denied || authorizationStatus == .restricted
    }

    /// Current heading in degrees clockwise from north, or nil if we don't have
    /// a usable one yet.
    ///
    /// `trueHeading` is geographic north and is what we want, because our
    /// bearing math is also geographic. But it's only valid once location
    /// services have a fix — until then CoreLocation reports it as -1. In that
    /// case we fall back to `magneticHeading`, which is off by the local
    /// magnetic declination (a few degrees in Virginia) but is better than
    /// showing nothing.
    var headingDegrees: Double? {
        guard let heading else { return nil }
        if heading.trueHeading >= 0 { return heading.trueHeading }
        if heading.magneticHeading >= 0 { return heading.magneticHeading }
        return nil
    }

    /// True when iOS thinks the compass needs a figure-8 wave to recalibrate.
    var headingNeedsCalibration: Bool {
        guard let heading else { return false }
        return heading.headingAccuracy < 0 || heading.headingAccuracy > 25
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    /// Safe to call repeatedly — CoreLocation ignores redundant starts.
    func start() {
        guard isAuthorized else {
            if authorizationStatus == .notDetermined { requestPermission() }
            return
        }
        manager.startUpdatingLocation()
        if headingIsAvailable { manager.startUpdatingHeading() }
    }

    /// Called when the compass screen goes away, to stop draining battery.
    func stop() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if isAuthorized { start() }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        // Ignore obviously bad fixes rather than letting them yank the arrow.
        guard latest.horizontalAccuracy >= 0 else { return }
        location = latest
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // Negative accuracy means the reading is invalid; drop it.
        guard newHeading.headingAccuracy >= 0 else { return }
        heading = newHeading
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Keep the last known good values on screen rather than blanking the UI.
        // A CLError of .denied is already reflected in authorizationStatus.
        print("LocationManager error: \(error.localizedDescription)")
    }
}
