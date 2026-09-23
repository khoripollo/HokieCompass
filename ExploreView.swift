//
//  ExploreView.swift
//  VTCompass
//
//  Changes in this pass:
//   • `.preferredColorScheme(.light)` removed. It would have overridden the
//     Settings theme picker coming in batch 2, and it forced light mode on the
//     whole app from one screen, which is not this view's decision to make.
//   • Hardcoded Color.white / .black replaced with semantic colors.
//   • Chips are now driven by BuildingCategory, so the six allowed filters
//     are the only ones that can ever appear.
//

import SwiftUI
import CoreLocation

// MARK: - Filter

/// All + the five BuildingCategory cases. Deriving the chips from the enum
/// means a new category can never quietly show up in the UI without being
/// added to the model on purpose.
enum BuildingFilter: Hashable, Identifiable {
    case all
    case category(BuildingCategory)

    static let allCases: [BuildingFilter] =
        [.all] + BuildingCategory.allCases.map(BuildingFilter.category)

    var id: String {
        switch self {
        case .all: return "All"
        case .category(let category): return category.rawValue
        }
    }

    var title: String { id }

    func matches(_ building: Building) -> Bool {
        switch self {
        case .all: return true
        case .category(let category): return building.belongs(to: category)
        }
    }
}

// MARK: - Explore

struct ExploreView: View {
    @EnvironmentObject private var locationManager: LocationManager

    @State private var searchText = ""
    @State private var selectedFilter: BuildingFilter = .all

    /// Search first, then narrow by chip, so the two compose.
    private var results: [Building] {
        BuildingData.search(searchText).filter { selectedFilter.matches($0) }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                header
                buildingList
            }
            .background(Color(.systemBackground))
            .toolbar(.hidden, for: .navigationBar)
        }
        .tint(VT.maroon)
        .onAppear {
            if locationManager.authorizationStatus == .notDetermined {
                locationManager.requestPermission()
            }
        }
    }

    // MARK: Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Explore Virginia Tech")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.primary)

            searchField
            filterChips

            Text("On Campus")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.primary)
                .padding(.top, 2)
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 8)
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Search for a building...", text: $searchText)
                .font(.system(size: 16))
                .foregroundStyle(Color.primary)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .submitLabel(.search)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 40)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(BuildingFilter.allCases) { filter in
                    let selected = filter == selectedFilter
                    Button {
                        selectedFilter = filter
                    } label: {
                        Text(filter.title)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(selected ? Color.white : Color.primary)
                            .padding(.horizontal, 13)
                            .padding(.vertical, 7)
                            .background(selected ? VT.maroon : Color(.systemGray6))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 1)
        }
    }

    // MARK: List

    private var buildingList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if results.isEmpty {
                    emptyState
                } else {
                    ForEach(Array(results.enumerated()), id: \.element.id) { index, building in
                        BuildingRow(building: building)

                        // Inset to line up under the text: 16 + 58 + 12.
                        if index < results.count - 1 {
                            Divider().padding(.leading, 86)
                        }
                    }
                }
            }
            .padding(.bottom, 24)
        }
        .scrollDismissesKeyboard(.immediately)
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 30))
                .foregroundStyle(.secondary)
            Text("No buildings found")
                .font(.headline)
                .foregroundStyle(Color.primary)
            Text("Try another building name or category.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
        .padding(.horizontal, 32)
    }
}
