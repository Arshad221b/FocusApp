import SwiftUI

// MARK: - Warm Autism-Friendly Color Palette
// Research basis: Warm, muted earth tones reduce sensory overwhelm.
// High contrast text on soft backgrounds aids readability.
// Consistent, predictable color usage reduces cognitive load.

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

// Centralized warm theme so every view pulls from one place
struct Theme {
    // Backgrounds: warm dark tones (no cold blue)
    static let bg          = Color(hex: "1C1714")  // deep warm brown-black
    static let bgSecondary = Color(hex: "2A2118")  // slightly lighter warm brown
    static let card        = Color(hex: "362B22")  // card surfaces
    static let cardHover   = Color(hex: "443828")  // hover / selected state
    static let sidebar     = Color(hex: "231C16")  // sidebar darker

    // Accents: warm amber / terra cotta
    static let accent      = Color(hex: "D4915C")  // warm amber-orange (primary accent)
    static let accentLight = Color(hex: "E8B87D")  // lighter amber for highlights
    static let accentSoft  = Color(hex: "D4915C").opacity(0.15)  // subtle tint
    
    // Semantic warm colors
    static let success     = Color(hex: "8DB580")  // sage green (soft, warm)
    static let warning     = Color(hex: "D4A84B")  // goldenrod
    static let danger      = Color(hex: "C4694A")  // terra cotta red
    static let info        = Color(hex: "B8976A")  // warm tan

    // Text
    static let textPrimary   = Color(hex: "F0E6D8")  // warm cream white
    static let textSecondary = Color(hex: "A89580")  // warm muted tan
    static let textMuted     = Color(hex: "7A6B5D")  // muted brown-gray

    // Emotion colors (warm-shifted)
    static let emotionPositive      = Color(hex: "8DB580")  // sage
    static let emotionNegative      = Color(hex: "C4694A")  // terra cotta
    static let emotionNeutral       = Color(hex: "A89580")  // warm gray
    static let emotionAutism        = Color(hex: "B8874B")  // warm gold

    // Energy level colors (warm spectrum)
    static let energyVeryLow  = Color(hex: "7A6B5D")
    static let energyLow      = Color(hex: "A89580")
    static let energyMedium   = Color(hex: "D4A84B")
    static let energyHigh     = Color(hex: "D4915C")
    static let energyVeryHigh = Color(hex: "C4694A")
    
    // Priority colors
    static let priorityUrgent = Color(hex: "C4694A")
    static let priorityHigh   = Color(hex: "D4915C")
    static let priorityMedium = Color(hex: "D4A84B")
    static let priorityLow    = Color(hex: "8DB580")
    
    // Timer ring
    static let timerFocus = Color(hex: "D4915C")
    static let timerBreak = Color(hex: "8DB580")
    static let timerPause = Color(hex: "D4A84B")
    
    // Breathing exercise
    static let breatheIn   = Color(hex: "D4915C")
    static let breatheHold = Color(hex: "D4A84B")
    static let breatheOut  = Color(hex: "8DB580")
}
