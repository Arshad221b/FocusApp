import SwiftUI

// MARK: - Tools View (Fully Interactive)
// Each tool section has a "Start" button that expands into a guided, step-by-step exercise inline.

struct ToolsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Regulation Tools")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        Text("Evidence-based techniques to help you regulate")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                    }
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)

                // Interactive tool cards
                BreathingToolCard()
                    .padding(.horizontal, 28)

                GroundingToolCard()
                    .padding(.horizontal, 28)

                BodyScanToolCard()
                    .padding(.horizontal, 28)

                PMRToolCard()
                    .padding(.horizontal, 28)

                CognitiveReframingToolCard()
                    .padding(.horizontal, 28)

                SensoryToolkitCard()
                    .padding(.horizontal, 28)
                    .padding(.bottom, 24)
            }
        }
    }
}

// MARK: - Breathing Tool (inline guided exercise)
struct BreathingToolCard: View {
    @State private var isActive = false
    @State private var technique: BreathTechnique = .boxBreathing
    @State private var phase: BreathPhase = .inhale
    @State private var count: Int = 4
    @State private var cycles: Int = 0
    @State private var timer: Timer?

    enum BreathTechnique: String, CaseIterable {
        case boxBreathing = "Box Breathing"
        case physiologicalSigh = "Physiological Sigh"
        case deepBreathing = "4-6 Deep Breathing"

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
        var description: String {
            switch self {
            case .boxBreathing: return "4-4-4-4 pattern. Used by Navy SEALs. Activates parasympathetic nervous system."
            case .physiologicalSigh: return "Double inhale + long exhale. Fastest known way to reduce real-time stress (Huberman Lab, Stanford)."
            case .deepBreathing: return "4s inhale, 6s exhale. Extended exhale activates vagus nerve for calm."
            }
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
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Image(systemName: "wind")
                    .font(.system(size: 16))
                    .foregroundColor(Theme.accent)
                Text("Breathing Exercises")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                if !isActive {
                    Text("~1-3 min")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(Theme.textMuted)
                }
            }

            if !isActive {
                // Technique picker
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(BreathTechnique.allCases, id: \.self) { tech in
                        Button(action: { technique = tech }) {
                            HStack(spacing: 10) {
                                Circle()
                                    .fill(technique == tech ? Theme.accent : Theme.textMuted.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(tech.rawValue)
                                        .font(.system(size: 13, weight: .medium, design: .rounded))
                                        .foregroundColor(technique == tech ? Theme.textPrimary : Theme.textSecondary)
                                    Text(tech.description)
                                        .font(.system(size: 11, design: .rounded))
                                        .foregroundColor(Theme.textMuted)
                                        .lineLimit(2)
                                }
                                Spacer()
                            }
                            .padding(10)
                            .background(technique == tech ? Theme.accent.opacity(0.08) : Color.clear)
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Button(action: startBreathing) {
                    HStack {
                        Spacer()
                        Text("Begin Exercise")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(Theme.accent.opacity(0.15))
                    .foregroundColor(Theme.accent)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.accent.opacity(0.3), lineWidth: 1))
                }
                .buttonStyle(.plain)
            } else {
                // Active breathing guide
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(phaseColor.opacity(0.1))
                            .frame(width: 160, height: 160)
                        Circle()
                            .fill(phaseColor.opacity(0.25))
                            .frame(width: breathSize, height: breathSize)
                            .animation(.easeInOut(duration: 0.8), value: breathSize)
                        VStack(spacing: 4) {
                            Text(phase.rawValue)
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                            Text("\(count)")
                                .font(.system(size: 36, weight: .bold, design: .monospaced))
                                .foregroundColor(Theme.textPrimary)
                        }
                    }

                    Text("Cycle \(cycles + 1)")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(Theme.textMuted)

                    Button(action: stopBreathing) {
                        Text("Stop")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                            .background(Theme.danger.opacity(0.15))
                            .foregroundColor(Theme.danger)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(Theme.card)
        .cornerRadius(14)
        .onDisappear { stopBreathing() }
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
        case .inhale, .inhale2: return 120
        case .hold1, .hold2:   return 140
        case .exhale:          return 80
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
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
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

// MARK: - 5-4-3-2-1 Grounding (inline guided)
struct GroundingToolCard: View {
    @State private var isActive = false
    @State private var step = 0
    @State private var userInputs: [String] = ["", "", "", "", ""]

    private let steps = [
        (sense: "See", count: 5, prompt: "Name 5 things you can see right now"),
        (sense: "Hear", count: 4, prompt: "Name 4 things you can hear"),
        (sense: "Feel", count: 3, prompt: "Name 3 things you can physically feel"),
        (sense: "Smell", count: 2, prompt: "Name 2 things you can smell"),
        (sense: "Taste", count: 1, prompt: "Name 1 thing you can taste"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "eye")
                    .font(.system(size: 16))
                    .foregroundColor(Theme.success)
                Text("5-4-3-2-1 Grounding")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text("~2 min")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(Theme.textMuted)
            }

            Text("Activates your senses to anchor you in the present moment. Proven effective for anxiety, dissociation, and overwhelm.")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Theme.textSecondary)

            if !isActive {
                Button(action: { isActive = true; step = 0 }) {
                    HStack {
                        Spacer()
                        Text("Begin Exercise")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(Theme.success.opacity(0.15))
                    .foregroundColor(Theme.success)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.success.opacity(0.3), lineWidth: 1))
                }
                .buttonStyle(.plain)
            } else {
                VStack(spacing: 16) {
                    // Progress dots
                    HStack(spacing: 8) {
                        ForEach(0..<5, id: \.self) { i in
                            Circle()
                                .fill(i <= step ? Theme.success : Theme.textMuted.opacity(0.3))
                                .frame(width: 10, height: 10)
                        }
                    }

                    Text("\(steps[step].count)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.success)

                    Text(steps[step].prompt)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                        .multilineTextAlignment(.center)

                    Text("Take your time. There's no rush.")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(Theme.textMuted)

                    HStack(spacing: 12) {
                        if step > 0 {
                            Button(action: { step -= 1 }) {
                                Text("Back")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .background(Theme.textMuted.opacity(0.15))
                                    .foregroundColor(Theme.textSecondary)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }

                        Button(action: {
                            if step < 4 { step += 1 } else { isActive = false }
                        }) {
                            Text(step < 4 ? "Next" : "Complete")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(Theme.success.opacity(0.15))
                                .foregroundColor(Theme.success)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
        .padding(20)
        .background(Theme.card)
        .cornerRadius(14)
    }
}

// MARK: - Body Scan (inline guided)
struct BodyScanToolCard: View {
    @State private var isActive = false
    @State private var step = 0
    @State private var timer: Timer?
    @State private var countdown = 10

    private let bodyParts = [
        ("Feet", "Notice the soles of your feet. Are they warm or cool? Any tingling?"),
        ("Legs", "Scan up through your calves and thighs. Notice any tension."),
        ("Stomach", "Notice your belly rising and falling. Any tightness or butterflies?"),
        ("Chest", "Feel your heartbeat. Notice the rhythm of your breath here."),
        ("Shoulders", "Are they raised? Gently let them drop. Release any holding."),
        ("Hands", "Notice your fingers. Open and close them slowly."),
        ("Face", "Relax your jaw. Soften your forehead. Let your eyes be soft."),
        ("Whole Body", "Take a full breath. Feel your entire body as one."),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "figure.stand")
                    .font(.system(size: 16))
                    .foregroundColor(Theme.warning)
                Text("Body Scan")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text("~2 min")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(Theme.textMuted)
            }

            Text("Systematically notice sensations in each body part. Helps identify where you hold stress and builds interoception (body awareness).")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Theme.textSecondary)

            if !isActive {
                Button(action: startScan) {
                    HStack { Spacer(); Text("Begin Body Scan").font(.system(size: 14, weight: .semibold, design: .rounded)); Spacer() }
                        .padding(.vertical, 12)
                        .background(Theme.warning.opacity(0.15))
                        .foregroundColor(Theme.warning)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.warning.opacity(0.3), lineWidth: 1))
                }
                .buttonStyle(.plain)
            } else {
                VStack(spacing: 16) {
                    // Progress
                    HStack(spacing: 4) {
                        ForEach(0..<bodyParts.count, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(i <= step ? Theme.warning : Theme.textMuted.opacity(0.3))
                                .frame(height: 4)
                        }
                    }

                    Text(bodyParts[step].0)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.warning)

                    Text(bodyParts[step].1)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                        .multilineTextAlignment(.center)

                    Text("\(countdown)s")
                        .font(.system(size: 20, weight: .bold, design: .monospaced))
                        .foregroundColor(Theme.textSecondary)

                    HStack(spacing: 12) {
                        Button(action: stopScan) {
                            Text("Stop")
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .padding(.horizontal, 20).padding(.vertical, 8)
                                .background(Theme.danger.opacity(0.15))
                                .foregroundColor(Theme.danger)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)

                        Button(action: nextBodyPart) {
                            Text(step < bodyParts.count - 1 ? "Next" : "Complete")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .padding(.horizontal, 20).padding(.vertical, 8)
                                .background(Theme.warning.opacity(0.15))
                                .foregroundColor(Theme.warning)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
        .padding(20)
        .background(Theme.card)
        .cornerRadius(14)
        .onDisappear { stopScan() }
    }

    private func startScan() {
        isActive = true; step = 0; countdown = 10
        startTimer()
    }

    private func stopScan() {
        isActive = false; timer?.invalidate(); timer = nil
    }

    private func nextBodyPart() {
        if step < bodyParts.count - 1 { step += 1; countdown = 10 }
        else { stopScan() }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                if countdown > 1 { countdown -= 1 }
                else { nextBodyPart() }
            }
        }
    }
}

// MARK: - Progressive Muscle Relaxation
struct PMRToolCard: View {
    @State private var isActive = false
    @State private var step = 0
    @State private var phase: PMRPhase = .tense
    @State private var countdown = 5
    @State private var timer: Timer?

    enum PMRPhase: String {
        case tense = "Tense"
        case release = "Release & Feel"
    }

    private let muscles = [
        ("Hands", "Make tight fists with both hands"),
        ("Arms", "Bend your elbows and flex your biceps"),
        ("Shoulders", "Raise your shoulders up to your ears"),
        ("Face", "Scrunch your face tightly"),
        ("Stomach", "Tighten your abdominal muscles"),
        ("Legs", "Press your thighs together and point your toes"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "figure.flexibility")
                    .font(.system(size: 16))
                    .foregroundColor(Theme.info)
                Text("Progressive Muscle Relaxation")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text("~3 min")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(Theme.textMuted)
            }

            Text("Tense each muscle group for 5 seconds, then release. The contrast helps your body learn what relaxation feels like.")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Theme.textSecondary)

            if !isActive {
                Button(action: startPMR) {
                    HStack { Spacer(); Text("Begin Exercise").font(.system(size: 14, weight: .semibold, design: .rounded)); Spacer() }
                        .padding(.vertical, 12)
                        .background(Theme.info.opacity(0.15))
                        .foregroundColor(Theme.info)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.info.opacity(0.3), lineWidth: 1))
                }
                .buttonStyle(.plain)
            } else {
                VStack(spacing: 16) {
                    HStack(spacing: 4) {
                        ForEach(0..<muscles.count, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(i <= step ? Theme.info : Theme.textMuted.opacity(0.3))
                                .frame(height: 4)
                        }
                    }

                    Text(muscles[step].0)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.info)

                    Text(phase == .tense ? muscles[step].1 : "Let go... feel the difference")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                        .multilineTextAlignment(.center)

                    Text(phase.rawValue)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(phase == .tense ? Theme.danger : Theme.success)
                        .textCase(.uppercase)

                    Text("\(countdown)s")
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .foregroundColor(Theme.textSecondary)

                    Button(action: stopPMR) {
                        Text("Stop")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .padding(.horizontal, 24).padding(.vertical, 8)
                            .background(Theme.danger.opacity(0.15))
                            .foregroundColor(Theme.danger)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
        .padding(20)
        .background(Theme.card)
        .cornerRadius(14)
        .onDisappear { stopPMR() }
    }

    private func startPMR() {
        isActive = true; step = 0; phase = .tense; countdown = 5
        startTimer()
    }

    private func stopPMR() {
        isActive = false; timer?.invalidate(); timer = nil
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                if countdown > 1 { countdown -= 1 }
                else {
                    if phase == .tense { phase = .release; countdown = 5 }
                    else {
                        if step < muscles.count - 1 { step += 1; phase = .tense; countdown = 5 }
                        else { stopPMR() }
                    }
                }
            }
        }
    }
}

// MARK: - Cognitive Reframing
struct CognitiveReframingToolCard: View {
    @State private var isActive = false
    @State private var step = 0
    @State private var thought = ""
    @State private var emotion = ""
    @State private var evidence = ""
    @State private var reframe = ""

    private let steps = [
        ("Capture the Thought", "What thought is causing distress? Write it exactly as it appears in your mind."),
        ("Name the Emotion", "What emotion does this thought trigger? How intense is it (1-10)?"),
        ("Examine the Evidence", "What facts support this thought? What facts contradict it?"),
        ("Reframe", "Write a more balanced version of this thought. It doesn't have to be positive, just more accurate."),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 16))
                    .foregroundColor(Theme.accentLight)
                Text("Cognitive Reframing")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text("~5 min")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(Theme.textMuted)
            }

            Text("From CBT: Challenge distorted thoughts by examining evidence. Particularly helpful for rigid thinking patterns common in autism.")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Theme.textSecondary)

            if !isActive {
                Button(action: { isActive = true; step = 0 }) {
                    HStack { Spacer(); Text("Start Reframing").font(.system(size: 14, weight: .semibold, design: .rounded)); Spacer() }
                        .padding(.vertical, 12)
                        .background(Theme.accentLight.opacity(0.15))
                        .foregroundColor(Theme.accentLight)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Theme.accentLight.opacity(0.3), lineWidth: 1))
                }
                .buttonStyle(.plain)
            } else {
                VStack(spacing: 16) {
                    HStack(spacing: 4) {
                        ForEach(0..<4, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(i <= step ? Theme.accentLight : Theme.textMuted.opacity(0.3))
                                .frame(height: 4)
                        }
                    }

                    Text("Step \(step + 1): \(steps[step].0)")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.accentLight)

                    Text(steps[step].1)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(Theme.textSecondary)

                    TextEditor(text: currentBinding)
                        .frame(height: 80)
                        .padding(8)
                        .background(Theme.bgSecondary)
                        .cornerRadius(8)
                        .foregroundColor(Theme.textPrimary)
                        .scrollContentBackground(.hidden)
                        .font(.system(size: 13, design: .rounded))

                    HStack(spacing: 12) {
                        if step > 0 {
                            Button(action: { step -= 1 }) {
                                Text("Back")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .padding(.horizontal, 20).padding(.vertical, 8)
                                    .background(Theme.textMuted.opacity(0.15))
                                    .foregroundColor(Theme.textSecondary)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }

                        Button(action: {
                            if step < 3 { step += 1 } else { isActive = false }
                        }) {
                            Text(step < 3 ? "Next" : "Finish")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .padding(.horizontal, 20).padding(.vertical, 8)
                                .background(Theme.accentLight.opacity(0.15))
                                .foregroundColor(Theme.accentLight)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
        .padding(20)
        .background(Theme.card)
        .cornerRadius(14)
    }

    private var currentBinding: Binding<String> {
        switch step {
        case 0: return $thought
        case 1: return $emotion
        case 2: return $evidence
        default: return $reframe
        }
    }
}

// MARK: - Sensory Toolkit (quick reference)
struct SensoryToolkitCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "hand.raised")
                    .font(.system(size: 16))
                    .foregroundColor(Theme.emotionAutism)
                Text("Sensory Toolkit")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
            }

            Text("Quick reminders for sensory regulation. These are physical actions you can do right now.")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Theme.textSecondary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                sensoryTip(icon: "snowflake", title: "Cold Water", desc: "Splash cold water on face/wrists. Activates dive reflex, slows heart rate.")
                sensoryTip(icon: "hand.point.down", title: "Deep Pressure", desc: "Wrap yourself tightly in a blanket or press palms together hard for 10s.")
                sensoryTip(icon: "ear.badge.waveform", title: "Noise Cancel", desc: "Put on noise-cancelling headphones or earplugs. Reduce auditory input.")
                sensoryTip(icon: "light.min", title: "Dim Lights", desc: "Reduce visual input. Close eyes or go to a darker room.")
                sensoryTip(icon: "hand.draw", title: "Fidget Object", desc: "Use a familiar tactile object. Focus on its texture and weight.")
                sensoryTip(icon: "figure.walk", title: "Movement", desc: "Stand up and stretch, walk, or do 10 jumping jacks to discharge energy.")
            }
        }
        .padding(20)
        .background(Theme.card)
        .cornerRadius(14)
    }

    private func sensoryTip(icon: String, title: String, desc: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(Theme.emotionAutism)
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
            }
            Text(desc)
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(Theme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.bgSecondary)
        .cornerRadius(8)
    }
}
