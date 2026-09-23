//
//  BuildingRow.swift
//  VTCompass
//
//  Only change in this pass: the hardcoded `.foregroundStyle(.black)` and
//  `.background(Color.white)` are gone. They made the row unreadable in dark
//  mode and would have fought the Settings theme picker in batch 2.
//
//  BuildingImage and FavoriteButton are defined here and used by
//  BuildingDetailView — do not remove them.
//

import SwiftUI
import UIKit

struct BuildingImage: View {
    let imageName: String

    var body: some View {
        if let uiImage = UIImage(named: imageName) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                Color(.systemGray6)
                Image(systemName: "building.2.fill")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(VT.maroon)
            }
        }
    }
}

struct FavoriteButton: View {
    let building: Building
    @EnvironmentObject private var favorites: FavoritesManager
    var iconSize: CGFloat = 19
    var tapTarget: CGFloat = 40

    private var isFavorite: Bool { favorites.isFavorite(building) }

    var body: some View {
        Button {
            favorites.toggle(building)
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: iconSize, weight: .semibold))
                .foregroundStyle(isFavorite ? VT.maroon : Color.secondary)
                .frame(width: tapTarget, height: tapTarget)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isFavorite ? "Remove \(building.name) from favorites"
                                       : "Add \(building.name) to favorites")
    }
}

struct BuildingRow: View {
    let building: Building

    var body: some View {
        HStack(spacing: 10) {
            // The link and the heart are siblings. A Button nested inside a
            // NavigationLink's label never receives taps.
            NavigationLink {
                BuildingDetailView(building: building)
            } label: {
                HStack(spacing: 12) {
                    BuildingThumbnail(building: building)

                    VStack(alignment: .leading, spacing: 3) {
                        Text(building.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.primary)
                            .lineLimit(1)

                        Text(building.descriptor)
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Spacer(minLength: 0)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            FavoriteButton(building: building, iconSize: 17, tapTarget: 36)

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.secondary.opacity(0.7))
        }
        .padding(.horizontal, 16)
        .frame(height: 64)
    }
}
