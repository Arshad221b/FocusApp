import SwiftUI

struct IOSEmotionView: View {
    @EnvironmentObject var appState: AppState
    @State private var selected: Emotion = .calm
    @State private var intensity: Int = 5

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Quick log
                VStack(alignment: .leading, spacing: 16) {
                    Text("How are you feeling?")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    
                    // Emotion grid - bold colorful buttons
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 75))], spacing: 12) {
                        ForEach(Emotion.allCases.filter { $0.category != .autismSpecific }, id: \.self) { e in
                            Button(action: { selected = e }) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(colorFor(e).opacity(selected == e ? 0.3 : 0.15))
                                            .frame(width: 44, height: 44)
                                        Image(systemName: e.icon)
                                            .font(.system(size: 24, weight: .medium))
                                            .foregroundColor(selected == e ? colorFor(e) : colorFor(e).opacity(0.7))
                                    }
                                    Text(e.rawValue)
                                        .font(.system(size: 11, weight: selected == e ? .bold : .medium, design: .rounded))
                                        .foregroundColor(selected == e ? colorFor(e) : Theme.textSecondary)
                                }
                                .frame(width: 75, height: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(selected == e ? colorFor(e).opacity(0.15) : Theme.bgSecondary)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(selected == e ? colorFor(e) : Color.clear, lineWidth: 2)
                                )
                            }.buttonStyle(.plain)
                        }
                    }
                    
                    // Intensity - properly laid out
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Intensity")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                            Spacer()
                            Text("\(intensity)/10")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(colorFor(selected))
                        }
                        
                        Slider(value: Binding(get: { Double(intensity) }, set: { intensity = Int($0) }), in: 1...10, step: 1)
                            .tint(colorFor(selected))
                        
                        HStack {
                            Text("Calm")
                                .font(.system(size: 11, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                            Spacer()
                            Text("Intense")
                                .font(.system(size: 11, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                        }
                    }
                    .padding(14)
                    .background(Theme.bgSecondary)
                    .cornerRadius(12)
                    
                    // Log button
                    Button(action: {
                        appState.logEmotion(EmotionalState(primaryEmotion: selected, intensity: intensity, energyLevelBefore: appState.currentEnergyLevel))
                    }) {
                        HStack { 
                            Spacer()
                            Image(systemName: "plus.circle.fill")
                            Text("Log Emotion")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                            Spacer() 
                        }
                        .padding(.vertical, 14)
                        .background(Theme.accent)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }.buttonStyle(.plain)
                }
                .padding(20)
                .background(Theme.card)
                .cornerRadius(16)

                // Recent logs
                VStack(alignment: .leading, spacing: 14) {
                    Text("Recent Logs")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    
                    let logs = Array(appState.emotionalLogs.sorted { $0.timestamp > $1.timestamp }.prefix(5))
                    if logs.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "heart.slash")
                                .font(.system(size: 32))
                                .foregroundColor(Theme.textMuted)
                            Text("No emotion logs yet")
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                    } else {
                        ForEach(logs) { l in
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Theme.accent.opacity(0.15))
                                        .frame(width: 40, height: 40)
                                    Image(systemName: l.primaryEmotion.icon)
                                        .font(.system(size: 16))
                                        .foregroundColor(Theme.accent)
                                }
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(l.primaryEmotion.rawValue)
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(Theme.textPrimary)
                                    Text(l.timestamp, style: .relative)
                                        .font(.system(size: 12, design: .rounded))
                                        .foregroundColor(Theme.textMuted)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 2) {
                                    Text("\(l.intensity)/10")
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .foregroundColor(Theme.accent)
                                    Text("intensity")
                                        .font(.system(size: 10, design: .rounded))
                                        .foregroundColor(Theme.textMuted)
                                }
                            }
                            .padding(12)
                            .background(Theme.bgSecondary)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(20)
                .background(Theme.card)
                .cornerRadius(16)

                // Quick tools
                VStack(alignment: .leading, spacing: 14) {
                    Text("Quick Tools")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    
                    HStack(spacing: 12) {
                        qBtn("Breathing", icon: "wind", color: Theme.accent) { appState.showBreathingExercise = true }
                        qBtn("Grounding", icon: "eye", color: Theme.success) { appState.showGroundingExercise = true }
                        qBtn("Full Log", icon: "heart.text.clipboard", color: Theme.warning) { appState.showEmotionLogger = true }
                    }
                }
                .padding(20)
                .background(Theme.card)
                .cornerRadius(16)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Theme.bg)
    }

    private func qBtn(_ t: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(t)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(color.opacity(0.12))
            .foregroundColor(color)
            .cornerRadius(14)
        }.buttonStyle(.plain)
    }
    
    private func colorFor(_ emotion: Emotion) -> Color {
        switch emotion {
        case .joy, .excitement, .contentment, .gratitude, .pride, .calm, .interest, .hope:
            return Theme.success  // green - positive
        case .sadness, .fear, .anxiety, .anger, .frustration, .overwhelm, .shame, .guilt, .loneliness, .meltdown, .shutdown:
            return Theme.danger  // red - negative
        case .surprise, .confusion, .numbness, .dissociation:
            return Theme.warning  // amber - neutral
        case .hyperfocus:
            return Theme.accent  // orange - focused state
        }
    }
}
