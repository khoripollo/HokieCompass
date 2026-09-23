import SwiftUI
import UIKit

struct BuildingThumbnail: View {
    let building: Building
    var width: CGFloat = 58
    var height: CGFloat = 44
    var cornerRadius: CGFloat = 7

    var body: some View {
        Group {
            if let uiImage = UIImage(named: building.imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color(.systemGray6)
                    Image(systemName: symbolName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(VT.maroon)
                }
            }
        }
        .frame(width: width, height: height)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    private var symbolName: String {
        if building.categories.contains(.dining) { return "fork.knife" }
        if building.categories.contains(.residential) { return "bed.double.fill" }
        if building.categories.contains(.athletics) { return "sportscourt.fill" }
        if building.categories.contains(.landmark) { return "mappin.and.ellipse" }
        return "book.closed.fill"
    }
}
