import SwiftUI

struct IOSEmotionLoggerSheet: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    @State private var primaryEmotion: Emotion = .calm
    @State private var intensity: Int = 5
    @State private var triggers: [String] = []
    @State private var newTrigger: String = ""
    @State private var notes: String = ""
    @State private var physicalSymptoms: Set<PhysicalSymptom> = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Primary emotion
                    VStack(alignment: .leading, spacing: 10) {
                        Text("How are you feeling?")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 56))], spacing: 6) {
                            ForEach(Emotion.allCases, id: \.self) { emotion in
                                Button(action: { primaryEmotion = emotion }) {
                                    VStack(spacing: 2) {
                                        Image(systemName: emotion.icon)
                                            .font(.system(size: 18))
                                        Text(emotion.rawValue)
                                            .font(.system(size: 9, design: .rounded))
                                    }
                                    .frame(width: 50, height: 44)
                                    .background(primaryEmotion == emotion ? Theme.accent.opacity(0.2) : Theme.bgSecondary)
                                    .foregroundColor(primaryEmotion == emotion ? Theme.accent : Theme.textMuted)
                                    .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        HStack {
                            Text("Intensity: \(intensity)/10")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                            Spacer()
                            Slider(value: Binding(get: { Double(intensity) }, set: { intensity = Int($0) }),
                                   in: 1...10, step: 1)
                                .tint(Theme.accent)
                        }
                    }

                    // Physical symptoms
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Physical Symptoms")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)

                        FlowLayout(spacing: 6) {
                            ForEach(PhysicalSymptom.allCases, id: \.self) { symptom in
                                Button(action: {
                                    if physicalSymptoms.contains(symptom) { physicalSymptoms.remove(symptom) }
                                    else { physicalSymptoms.insert(symptom) }
                                }) {
                                    Text(symptom.rawValue)
                                        .font(.system(size: 11, design: .rounded))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(physicalSymptoms.contains(symptom) ? Theme.danger.opacity(0.2) : Theme.bgSecondary)
                                        .foregroundColor(physicalSymptoms.contains(symptom) ? Theme.danger : Theme.textMuted)
                                        .cornerRadius(10)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    // Triggers
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Triggers")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)

                        HStack {
                            TextField("What triggered this?", text: $newTrigger)
                                .textFieldStyle(.plain)
                                .font(.system(size: 13, design: .rounded))
                                .padding(10)
                                .background(Theme.bgSecondary)
                                .cornerRadius(8)
                                .foregroundColor(Theme.textPrimary)

                            Button(action: {
                                if !newTrigger.isEmpty { triggers.append(newTrigger); newTrigger = "" }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Theme.accent)
                            }
                            .buttonStyle(.plain)
                        }

                        if !triggers.isEmpty {
                            FlowLayout(spacing: 6) {
                                ForEach(triggers, id: \.self) { trigger in
                                    HStack(spacing: 4) {
                                        Text(trigger)
                                            .font(.system(size: 11, design: .rounded))
                                        Button(action: { triggers.removeAll { $0 == trigger } }) {
                                            Image(systemName: "xmark").font(.system(size: 9))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Theme.warning.opacity(0.2))
                                    .foregroundColor(Theme.warning)
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }

                    // Notes
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Notes")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)

                        TextEditor(text: $notes)
                            .frame(height: 80)
                            .padding(8)
                            .background(Theme.bgSecondary)
                            .cornerRadius(8)
                            .foregroundColor(Theme.textPrimary)
                            .scrollContentBackground(.hidden)
                            .font(.system(size: 13, design: .rounded))
                    }
                }
                .padding(20)
            }
            .background(Theme.bg)
            .navigationTitle("Log Emotion")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(primaryEmotion == .calm)
                }
            }
        }
    }

    private func save() {
        let state = EmotionalState(
            primaryEmotion: primaryEmotion,
            intensity: intensity,
            triggers: triggers,
            notes: notes,
            physicalSymptoms: Array(physicalSymptoms),
            energyLevelBefore: appState.currentEnergyLevel
        )
        appState.logEmotion(state)
        dismiss()
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.replacingUnspecifiedDimensions().width, subviews: subviews, spacing: spacing)
        return CGSize(width: proposal.width ?? 0, height: result.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            let pt = result.positions[index]
            subview.place(at: CGPoint(x: bounds.minX + pt.x, y: bounds.minY + pt.y), proposal: .unspecified)
        }
    }

    struct FlowResult {
        var positions: [CGPoint] = []
        var height: CGFloat = 0

        init(in width: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0; var y: CGFloat = 0; var rowH: CGFloat = 0
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                if x + size.width > width && x > 0 { x = 0; y += rowH + spacing; rowH = 0 }
                positions.append(CGPoint(x: x, y: y))
                rowH = max(rowH, size.height)
                x += size.width + spacing
            }
            height = y + rowH
        }
    }
}
