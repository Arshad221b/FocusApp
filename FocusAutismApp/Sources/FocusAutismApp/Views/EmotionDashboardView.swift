import SwiftUI

struct EmotionDashboardView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Emotions")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        Text("Track patterns and build emotional awareness")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                    }
                    Spacer()
                    Button(action: { appState.showEmotionLogger = true }) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus")
                            Text("Log Emotion")
                        }
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Theme.accent)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)

                HStack(alignment: .top, spacing: 20) {
                    quickLogCard
                        .frame(maxWidth: .infinity)
                    recentLogsCard
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 28)

                todayPatterns
                    .padding(.horizontal, 28)

                quickTools
                    .padding(.horizontal, 28)
                    .padding(.bottom, 24)
            }
        }
    }

    // MARK: - Quick Log
    private var quickLogCard: some View {
        QuickEmotionLogCard()
    }

    // MARK: - Recent Logs
    private var recentLogsCard: some View {
        let logs = Array(appState.emotionalLogs.sorted { $0.timestamp > $1.timestamp }.prefix(5))
        return VStack(alignment: .leading, spacing: 14) {
            Text("Recent")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textPrimary)

            if logs.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "heart.text.clipboard")
                        .font(.system(size: 28))
                        .foregroundColor(Theme.textMuted)
                    Text("No logs yet")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
            } else {
                VStack(spacing: 8) {
                    ForEach(logs) { log in
                        HStack(spacing: 10) {
                            Image(systemName: log.primaryEmotion.icon)
                                .foregroundColor(emotionColor(log.primaryEmotion))
                                .frame(width: 20)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(log.primaryEmotion.rawValue)
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                Text(timeAgo(log.timestamp))
                                    .font(.system(size: 11, design: .rounded))
                                    .foregroundColor(Theme.textMuted)
                            }

                            Spacer()

                            Text("\(log.intensity)/10")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(Theme.textSecondary)
                        }
                        .padding(10)
                        .background(Theme.bgSecondary)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding(18)
        .background(Theme.card)
        .cornerRadius(14)
    }

    // MARK: - Today Patterns
    private var todayPatterns: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Today's Patterns")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textPrimary)

            if appState.todayEmotionData.isEmpty {
                Text("Log emotions to see patterns emerge")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(Theme.textMuted)
                    .padding(.vertical, 8)
            } else {
                let sorted = appState.todayEmotionData.sorted { $0.value > $1.value }
                HStack(spacing: 12) {
                    ForEach(sorted.prefix(6), id: \.key) { emotion, count in
                        VStack(spacing: 6) {
                            Image(systemName: emotion.icon)
                                .font(.system(size: 20))
                                .foregroundColor(emotionColor(emotion))
                            Text("\(count)")
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                            Text(emotion.rawValue)
                                .font(.system(size: 10, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(emotionColor(emotion).opacity(0.08))
                        .cornerRadius(10)
                    }
                }
            }
        }
        .padding(18)
        .background(Theme.card)
        .cornerRadius(14)
    }

    // MARK: - Quick Tools
    private var quickTools: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Quick Access")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textPrimary)

            HStack(spacing: 12) {
                toolBtn(title: "Breathing", icon: "wind", color: Theme.accent) {
                    appState.showBreathingExercise = true
                }
                toolBtn(title: "Grounding", icon: "eye", color: Theme.success) {
                    appState.showGroundingExercise = true
                }
                toolBtn(title: "Full Log", icon: "heart.text.clipboard", color: Theme.warning) {
                    appState.showEmotionLogger = true
                }
            }
        }
        .padding(18)
        .background(Theme.card)
        .cornerRadius(14)
    }

    private func toolBtn(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(title)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(color.opacity(0.1))
            .foregroundColor(color)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(color.opacity(0.2), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private func emotionColor(_ e: Emotion) -> Color {
        switch e.category {
        case .positive:      return Theme.emotionPositive
        case .negative:      return Theme.emotionNegative
        case .neutral:       return Theme.emotionNeutral
        case .autismSpecific: return Theme.emotionAutism
        }
    }

    private func timeAgo(_ date: Date) -> String {
        let s = Date().timeIntervalSince(date)
        if s < 60 { return "Just now" }
        else if s < 3600 { return "\(Int(s / 60))m ago" }
        else if s < 86400 { return "\(Int(s / 3600))h ago" }
        else { return "\(Int(s / 86400))d ago" }
    }
}

// MARK: - Quick Emotion Log Card
struct QuickEmotionLogCard: View {
    @EnvironmentObject var appState: AppState
    @State private var selected: Emotion = .calm
    @State private var intensity: Int = 5
    @State private var notes: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("How are you feeling?")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textPrimary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 58))], spacing: 6) {
                ForEach(Emotion.allCases.filter { $0.category != .autismSpecific }, id: \.self) { emotion in
                    Button(action: { selected = emotion }) {
                        VStack(spacing: 3) {
                            Image(systemName: emotion.icon)
                                .font(.system(size: 16))
                            Text(emotion.rawValue)
                                .font(.system(size: 9, design: .rounded))
                        }
                        .frame(width: 52, height: 48)
                        .background(selected == emotion ? Theme.accent.opacity(0.2) : Theme.bgSecondary)
                        .foregroundColor(selected == emotion ? Theme.accent : Theme.textMuted)
                        .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }

            HStack {
                Text("Intensity: \(intensity)")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(Theme.textMuted)
                Spacer()
                Slider(value: Binding(get: { Double(intensity) }, set: { intensity = Int($0) }),
                       in: 1...10, step: 1)
                    .frame(width: 160)
                    .tint(Theme.accent)
            }

            TextField("Notes (optional)", text: $notes, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.system(size: 12, design: .rounded))
                .padding(10)
                .background(Theme.bgSecondary)
                .cornerRadius(8)
                .foregroundColor(Theme.textPrimary)

            Button(action: {
                let state = EmotionalState(primaryEmotion: selected, intensity: intensity, notes: notes, energyLevelBefore: appState.currentEnergyLevel)
                appState.logEmotion(state)
                notes = ""
            }) {
                HStack { Spacer(); Text("Log").font(.system(size: 14, weight: .semibold, design: .rounded)); Spacer() }
                    .padding(.vertical, 10)
                    .background(Theme.accent.opacity(0.15))
                    .foregroundColor(Theme.accent)
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
        .padding(18)
        .background(Theme.card)
        .cornerRadius(14)
    }
}
