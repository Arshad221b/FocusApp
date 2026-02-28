import SwiftUI

struct BreathingExerciseView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isActive = false
    @State private var phase: String = "Inhale"
    @State private var count = 4
    @State private var cycleCount = 0
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Breathing Exercise")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.textMuted)
                        .font(.system(size: 20))
                }
                .buttonStyle(.plain)
            }
            .padding(20)
            .background(Theme.sidebar)

            Spacer()

            VStack(spacing: 20) {
                Text("Box Breathing (4-4-4-4)")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(Theme.textSecondary)

                ZStack {
                    Circle()
                        .fill(Theme.accent.opacity(0.15))
                        .frame(width: 180, height: 180)

                    VStack(spacing: 6) {
                        Text(phase)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        Text("\(count)")
                            .font(.system(size: 44, weight: .bold, design: .monospaced))
                            .foregroundColor(Theme.accent)
                        if isActive {
                            Text("Cycle \(cycleCount + 1)")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                        }
                    }
                }

                if !isActive {
                    Button(action: startExercise) {
                        Text("Start")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 40).padding(.vertical, 12)
                            .background(Theme.accent.opacity(0.15))
                            .foregroundColor(Theme.accent)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                } else {
                    Button(action: stopExercise) {
                        Text("Stop")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 40).padding(.vertical, 12)
                            .background(Theme.danger.opacity(0.15))
                            .foregroundColor(Theme.danger)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()
        }
        .frame(width: 400, height: 420)
        .background(Theme.bg)
        .onDisappear { stopExercise() }
    }

    private func startExercise() {
        isActive = true; cycleCount = 0; phase = "Inhale"; count = 4
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                if count > 1 { count -= 1 }
                else { advancePhase() }
            }
        }
    }

    private func stopExercise() {
        isActive = false; timer?.invalidate(); timer = nil
    }

    private func advancePhase() {
        switch phase {
        case "Inhale": phase = "Hold"; count = 4
        case "Hold": phase = "Exhale"; count = 4
        case "Exhale": phase = "Rest"; count = 4
        default: cycleCount += 1; phase = "Inhale"; count = 4
        }
    }
}
