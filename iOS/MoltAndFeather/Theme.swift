import SwiftUI

/// Unique visual identity for Molt & Feather.
enum Theme {
    static let background = Color(hex: "#1E1712")
    static let accent = Color(hex: "#D4A24E")
    static let secondary = Color(hex: "#8C6A4E")
    static let textPrimary = Color(hex: "#F3E9DA")

    static let titleFont: Font = .system(.largeTitle, design: .serif).weight(.bold)
    static let bodyFont: Font = .system(.body, design: .serif)

    static let cardCorner: CGFloat = 18
}

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
