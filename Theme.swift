//
//  Theme.swift
//  VTCompass
//
//  Colors and one shared card style. Keeping these in a single file means
//  "make it less maroon" is a one-line change.
//

import SwiftUI

enum VT {
    /// Virginia Tech maroon, approx #861F41
    static let maroon = Color(red: 134 / 255, green: 31 / 255, blue: 65 / 255)

    /// Burnt orange accent, approx #E87722
    static let orange = Color(red: 232 / 255, green: 119 / 255, blue: 34 / 255)

    static let background = Color(.systemGroupedBackground)
    static let card = Color(.secondarySystemGroupedBackground)
    static let primaryText = Color(.label)
    static let secondaryText = Color(.secondaryLabel)
}

/// Rounded card with a subtle shadow, used by building rows and info cards.
struct CardBackground: ViewModifier {
    var cornerRadius: CGFloat = 16

    func body(content: Content) -> some View {
        content
            .background(VT.card)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}

extension View {
    func cardStyle(cornerRadius: CGFloat = 16) -> some View {
        modifier(CardBackground(cornerRadius: cornerRadius))
    }
}
