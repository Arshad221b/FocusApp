import SwiftUI

// MARK: - High Contrast Warm Color Palette
// Black background with warm, high-contrast accents for visibility

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// High contrast warm theme on black
struct Theme {
    // Backgrounds: pure black for maximum contrast
    static let bg          = Color.black
    static let bgSecondary = Color(hex: "1A1A1A")  // near black
    static let card        = Color(hex: "2A2520")  // warm dark card
    static let cardHover   = Color(hex: "3A3530")  // lighter warm
    static let sidebar     = Color(hex: "0D0A08")  // deep warm black
    
    // Primary accents: bright warm orange - high visibility
    static let accent      = Color(hex: "FF9040")  // bright warm orange
    static let accentLight = Color(hex: "FFB070")  // lighter peach
    static let accentDark  = Color(hex: "E87020")  // deeper orange
    static let accentSoft  = Color(hex: "FF9040").opacity(0.2)
    
    // Secondary accents
    static let accent2     = Color(hex: "FFB830")  // bright gold
    static let accent2Light = Color(hex: "FFD060")  // light gold
    
    // Semantic colors - bright warm versions
    static let success     = Color(hex: "50D050")  // bright warm green
    static let successLight = Color(hex: "80E080")  // light green
    static let warning     = Color(hex: "FFB830")  // bright amber
    static let warningLight = Color(hex: "FFCF60")  // light amber
    static let danger      = Color(hex: "FF5040")  // bright coral red
    static let dangerLight = Color(hex: "FF8070")  // light coral
    static let info        = Color(hex: "E0A050")  // warm bronze
    
    // Text - high contrast on black
    static let textPrimary   = Color.white  // pure white
    static let textSecondary = Color(hex: "C8B8A0")  // warm off-white
    static let textMuted     = Color(hex: "807060")  // muted warm gray
    
    // Emotion colors - bright and distinct
    static let emotionPositive      = Color(hex: "50D050")  // bright green
    static let emotionNegative      = Color(hex: "FF5040")  // bright red
    static let emotionNeutral       = Color(hex: "C8B8A0")  // warm gray
    static let emotionAutism        = Color(hex: "FFB830")  // bright gold
    
    // Energy level colors - high contrast spectrum
    static let energyVeryLow  = Color(hex: "605040")  // dark warm
    static let energyLow      = Color(hex: "907060")  // medium warm
    static let energyMedium   = Color(hex: "FFB830")  // bright amber
    static let energyHigh     = Color(hex: "FF9040")  // bright orange
    static let energyVeryHigh = Color(hex: "FF5040")  // bright red
    
    // Priority colors - high contrast
    static let priorityUrgent = Color(hex: "FF5040")  // bright red
    static let priorityHigh   = Color(hex: "FF9040")  // bright orange
    static let priorityMedium = Color(hex: "FFB830")  // bright amber
    static let priorityLow    = Color(hex: "50D050")  // bright green
    
    // Timer ring - vibrant
    static let timerFocus = Color(hex: "FF9040")  // orange
    static let timerBreak = Color(hex: "50D050")  // green
    static let timerPause = Color(hex: "FFB830")  // amber
    
    // Breathing exercise - bright colors
    static let breatheIn   = Color(hex: "FF9040")  // orange
    static let breatheHold = Color(hex: "FFB830")  // amber
    static let breatheOut  = Color(hex: "50D050")  // green
    
    // Gradient helpers
    static var accentGradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: "FF9040"), Color(hex: "FFB830")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var cardGradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: "2A2520"), Color(hex: "1A1A1A")],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static var energyGradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: "50D050"), Color(hex: "FFB830"), Color(hex: "FF5040")],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
