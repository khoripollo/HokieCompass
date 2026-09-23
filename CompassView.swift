//
//  CompassView.swift
//  VTCompass
//
//  Phase 3 + 6 — pure presentation. It receives angles and draws them; it does
//  no math and knows nothing about CoreLocation. That separation is what makes
//  the compass easy to preview and easy to reason about.
//

import SwiftUI

struct CompassView: View {

    /// Degrees to rotate the arrow. May be outside 0..<360 on purpose — the
    /// caller accumulates it so SwiftUI animates the short way around north
    /// instead of unwinding 359° backwards. See BuildingDetailView.
    let arrowRotation: Double

    /// Degrees to rotate the N/E/S/W ring. This is `-heading`, so the ring
    /// stays locked to the real world while the phone turns underneath it.
    let ringRotation: Double

    /// False when we have no heading yet — the arrow is dimmed rather than
    /// pointing somewhere arbitrary and confident.
    let isActive: Bool

    var body: some View {
        ZStack {
            dial
            tickMarks.rotationEffect(.degrees(ringRotation))
            cardinalLetters.rotationEffect(.degrees(ringRotation))
            arrow
        }
        .frame(width: 260, height: 260)
        .accessibilityElement()
        .accessibilityLabel("Direction compass")
    }

    // MARK: - Pieces

    private var dial: some View {
        ZStack {
            Circle()
                .fill(VT.card)
                .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
            Circle()
                .strokeBorder(VT.maroon.opacity(0.18), lineWidth: 2)
            Circle()
                .strokeBorder(VT.maroon.opacity(0.08), lineWidth: 1)
                .padding(26)
        }
    }

    private var tickMarks: some View {
        ForEach(0..<36, id: \.self) { index in
            let isMajor = index % 9 == 0
            Capsule()
                .fill(isMajor ? VT.maroon.opacity(0.55) : VT.secondaryText.opacity(0.25))
                .frame(width: isMajor ? 3 : 1.5, height: isMajor ? 14 : 8)
                .offset(y: -116)
                .rotationEffect(.degrees(Double(index) * 10))
        }
    }

    private var cardinalLetters: some View {
        ForEach(Array(["N", "E", "S", "W"].enumerated()), id: \.offset) { index, letter in
            Text(letter)
                .font(.caption.weight(.bold))
                .foregroundStyle(letter == "N" ? VT.maroon : VT.secondaryText)
                .offset(y: -95)
                .rotationEffect(.degrees(Double(index) * 90))
                // Counter-rotate so letters stay upright as the ring turns.
                .rotationEffect(.degrees(-ringRotation - Double(index) * 90),
                                anchor: .center)
        }
    }

    private var arrow: some View {
        Image(systemName: "location.north.fill")
            .font(.system(size: 96, weight: .semibold))
            .foregroundStyle(isActive ? VT.maroon : VT.secondaryText.opacity(0.35))
            .shadow(color: VT.maroon.opacity(isActive ? 0.25 : 0), radius: 8, y: 3)
            .rotationEffect(.degrees(arrowRotation))
            // Short, linear, and only on the arrow. Anything springy here would
            // overshoot and make the compass look like it's lying.
            .animation(.linear(duration: 0.15), value: arrowRotation)
    }
}

#Preview {
    VStack(spacing: 30) {
        CompassView(arrowRotation: 45, ringRotation: -20, isActive: true)
        CompassView(arrowRotation: 0, ringRotation: 0, isActive: false)
    }
    .padding()
    .background(VT.background)
}
