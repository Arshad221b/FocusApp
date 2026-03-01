import SwiftUI

struct IOSRegulationCheckInSheet: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    @State private var emotionAfter: Emotion = .calm
    @State private var intensityAfter: Int = 3
    @State private var rating: Int = 3
    @State private var notes: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 48))
                            .foregroundColor(Theme.success)
                        
                        Text("How did that help?")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        
                        if let strategy = appState.pendingCheckInStrategy {
                            Text("You used: \(strategy.rawValue)")
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(Theme.textSecondary)
                        }
                        
                        // Before state
                        HStack(spacing: 8) {
                            Text("Before:")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                            Image(systemName: appState.checkInEmotionBefore.icon)
                                .font(.system(size: 14))
                                .foregroundColor(Theme.accent)
                            Text("\(appState.checkInEmotionBefore.rawValue) (\(appState.checkInIntensityBefore)/10)")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                        }
                        .padding(10)
                        .background(Theme.bgSecondary)
                        .cornerRadius(8)
                    }
                    .padding(.top, 12)
                    
                    // How do you feel now?
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How do you feel now?")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 8) {
                            ForEach(Emotion.allCases.prefix(15), id: \.self) { emotion in
                                Button(action: { emotionAfter = emotion }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: emotion.icon)
                                            .font(.system(size: 18))
                                        Text(emotion.rawValue)
                                            .font(.system(size: 9, design: .rounded))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(emotionAfter == emotion ? Theme.accent.opacity(0.2) : Theme.bgSecondary)
                                    .foregroundColor(emotionAfter == emotion ? Theme.accent : Theme.textMuted)
                                    .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        
                        HStack {
                            Text("Intensity: \(intensityAfter)/10")
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(Theme.textSecondary)
                            Spacer()
                        }
                        Slider(value: Binding(get: { Double(intensityAfter) }, set: { intensityAfter = Int($0) }),
                               in: 1...10, step: 1)
                            .tint(Theme.accent)
                    }
                    .padding(18)
                    .background(Theme.card)
                    .cornerRadius(16)
                    
                    // Effectiveness rating
                    VStack(spacing: 12) {
                        Text("How effective was this?")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        
                        HStack(spacing: 16) {
                            ForEach(1...5, id: \.self) { star in
                                Button(action: { rating = star }) {
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .font(.system(size: 32))
                                        .foregroundColor(star <= rating ? Theme.warning : Theme.textMuted)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        
                        HStack {
                            Text("Not helpful")
                                .font(.system(size: 11, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                            Spacer()
                            Text("Very helpful")
                                .font(.system(size: 11, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                        }
                    }
                    .padding(18)
                    .background(Theme.card)
                    .cornerRadius(16)
                    
                    // Optional notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes (optional)")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                        TextField("What worked? What didn't?", text: $notes)
                            .textFieldStyle(.plain)
                            .font(.system(size: 13, design: .rounded))
                            .padding(10)
                            .background(Theme.bgSecondary)
                            .cornerRadius(8)
                            .foregroundColor(Theme.textPrimary)
                    }
                    .padding(.horizontal, 4)
                    
                    // Save button
                    Button(action: {
                        appState.completeRegulationCheckIn(
                            emotionAfter: emotionAfter,
                            intensityAfter: intensityAfter,
                            rating: rating,
                            notes: notes
                        )
                        dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                            Text("Save Check-In")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                            Spacer()
                        }
                        .padding(.vertical, 14)
                        .background(Theme.success)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                }
                .padding(20)
            }
            .background(Theme.bg)
            .navigationTitle("Check-In")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Skip") {
                        appState.cancelRegulationTracking()
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            emotionAfter = appState.checkInEmotionBefore
            intensityAfter = max(1, appState.checkInIntensityBefore - 2)
        }
    }
}
