import SwiftUI

struct IOSBreathingSheet: View {
    @Environment(\.dismiss) var dismiss

    @State private var technique: BreathTechnique = .boxBreathing
    @State private var phase: BreathPhase = .inhale
    @State private var count: Int = 4
    @State private var cycles: Int = 0
    @State private var isActive = false
    @State private var timer: Timer?

    enum BreathTechnique: String, CaseIterable {
        case boxBreathing = "Box Breathing"
        case physiologicalSigh = "Physiological Sigh"
        case deepBreathing = "4-6 Deep"

        var inhale: Int {
            switch self { case .boxBreathing: return 4; case .physiologicalSigh: return 3; case .deepBreathing: return 4 }
        }
        var hold1: Int {
            switch self { case .boxBreathing: return 4; default: return 0 }
        }
        var inhale2: Int {
            switch self { case .physiologicalSigh: return 2; default: return 0 }
        }
        var exhale: Int {
            switch self { case .boxBreathing: return 4; case .physiologicalSigh: return 7; case .deepBreathing: return 6 }
        }
        var hold2: Int {
            switch self { case .boxBreathing: return 4; default: return 0 }
        }
    }

    enum BreathPhase: String {
        case inhale = "Breathe In"
        case hold1 = "Hold"
        case inhale2 = "Breathe In Again"
        case exhale = "Breathe Out"
        case hold2 = "Hold After Exhale"
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if !isActive {
                    // Technique picker
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Choose a technique")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)

                        ForEach(BreathTechnique.allCases, id: \.self) { tech in
                            Button(action: { technique = tech }) {
                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(technique == tech ? Theme.accent : Theme.textMuted.opacity(0.3))
                                        .frame(width: 10, height: 10)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(tech.rawValue)
                                            .font(.system(size: 14, weight: .medium, design: .rounded))
                                            .foregroundColor(Theme.textPrimary)
                                        Text(techDescription(tech))
                                            .font(.system(size: 11, design: .rounded))
                                            .foregroundColor(Theme.textMuted)
                                    }
                                    Spacer()
                                }
                                .padding(12)
                                .background(technique == tech ? Theme.accent.opacity(0.1) : Theme.bgSecondary)
                                .cornerRadius(10)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    Spacer()

                    Button(action: startBreathing) {
                        Text("Begin Exercise")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.accent)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                } else {
                    // Active breathing
                    Spacer()

                    ZStack {
                        // Black outer ring
                        Circle()
                            .fill(Theme.bgSecondary)
                            .frame(width: 240, height: 240)
                        
                        // Color ring
                        Circle()
                            .fill(phaseColor.opacity(0.2))
                            .frame(width: 200, height: 200)
                        
                        // Inner pulsing circle
                        Circle()
                            .fill(phaseColor.opacity(0.3))
                            .frame(width: breathSize, height: breathSize)
                            .animation(.easeInOut(duration: 0.8), value: breathSize)
                        
                        VStack(spacing: 8) {
                            Text(phase.rawValue)
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(phaseColor)
                                .textCase(.uppercase)
                                .tracking(2)
                            Text("\(count)")
                                .font(.system(size: 64, weight: .ultraLight, design: .monospaced))
                                .foregroundColor(Theme.textPrimary)
                                .monospacedDigit()
                        }
                    }

                    Text("Cycle \(cycles + 1)")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(Theme.textMuted)
                        .padding(.top, 16)

                    Spacer()

                    Button(action: stopBreathing) {
                        Text("Stop")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(Theme.danger.opacity(0.15))
                            .foregroundColor(Theme.danger)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 40)
                }
            }
            .background(Theme.bg)
            .navigationTitle("Breathing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .onDisappear { stopBreathing() }
    }

    private func techDescription(_ tech: BreathTechnique) -> String {
        switch tech {
        case .boxBreathing: return "4-4-4-4 pattern, activates calm"
        case .physiologicalSigh: return "Double inhale + long exhale"
        case .deepBreathing: return "4s inhale, 6s exhale"
        }
    }

    private var phaseColor: Color {
        switch phase {
        case .inhale, .inhale2: return Theme.breatheIn
        case .hold1, .hold2:   return Theme.breatheHold
        case .exhale:          return Theme.breatheOut
        }
    }

    private var breathSize: CGFloat {
        switch phase {
        case .inhale, .inhale2: return 160
        case .hold1, .hold2:   return 180
        case .exhale:          return 100
        }
    }

    private func startBreathing() {
        isActive = true
        cycles = 0
        phase = .inhale
        count = technique.inhale
        startTimer()
    }

    private func stopBreathing() {
        isActive = false
        timer?.invalidate()
        timer = nil
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                if count > 1 {
                    count -= 1
                } else {
                    advancePhase()
                }
            }
        }
    }

    private func advancePhase() {
        switch phase {
        case .inhale:
            if technique.inhale2 > 0 { phase = .inhale2; count = technique.inhale2 }
            else if technique.hold1 > 0 { phase = .hold1; count = technique.hold1 }
            else { phase = .exhale; count = technique.exhale }
        case .inhale2:
            if technique.hold1 > 0 { phase = .hold1; count = technique.hold1 }
            else { phase = .exhale; count = technique.exhale }
        case .hold1:
            phase = .exhale; count = technique.exhale
        case .exhale:
            if technique.hold2 > 0 { phase = .hold2; count = technique.hold2 }
            else { cycles += 1; phase = .inhale; count = technique.inhale }
        case .hold2:
            cycles += 1; phase = .inhale; count = technique.inhale
        }
    }
}
