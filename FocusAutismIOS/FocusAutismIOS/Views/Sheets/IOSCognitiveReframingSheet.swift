import SwiftUI

struct IOSCognitiveReframingSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var currentStep = 0
    @State private var situation = ""
    @State private var automaticThought = ""
    @State private var cognitiveDistortion = ""
    @State private var evidenceFor = ""
    @State private var evidenceAgainst = ""
    @State private var balancedThought = ""
    
    private let steps = [
        (title: "The Situation", description: "What happened? Describe the situation briefly.", placeholder: "e.g., My friend didn't text back"),
        (title: "Automatic Thought", description: "What went through your mind automatically?", placeholder: "e.g., They must hate me"),
        (title: "Cognitive Distortion", description: "What type of thinking pattern is this?", placeholder: "e.g., Mind reading, All-or-nothing"),
        (title: "Evidence For", description: "What facts support this thought?", placeholder: "e.g., They did ignore my message"),
        (title: "Evidence Against", description: "What facts don't support this?", placeholder: "e.g., They've been busy before"),
        (title: "Balanced Thought", description: "What's a more balanced way to see this?", placeholder: "e.g., They're busy, not avoiding me"),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Progress
                    HStack(spacing: 4) {
                        ForEach(0..<6, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(i <= currentStep ? Theme.accent2 : Theme.textMuted.opacity(0.3))
                                .frame(height: 4)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Step indicator
                    Text("Step \(currentStep + 1) of 6")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(Theme.textMuted)
                        .padding(.top, 8)
                    
                    // Title
                    Text(steps[currentStep].title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                        .padding(.top, 8)
                    
                    // Description
                    Text(steps[currentStep].description)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    // Input
                    VStack(alignment: .leading, spacing: 8) {
                        TextEditor(text: textForStep(currentStep))
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                            .scrollContentBackground(.hidden)
                            .padding(12)
                            .background(Theme.card)
                            .cornerRadius(12)
                            .frame(height: 120)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    // Tips for each step
                    if currentStep == 2 {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Common distortions:")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                            
                            ForEach(["Mind reading", "All-or-nothing", "Catastrophizing", "Should statements", "Emotional reasoning"], id: \.self) { tip in
                                HStack(spacing: 8) {
                                    Circle().fill(Theme.accent2).frame(width: 6, height: 6)
                                    Text(tip).font(.system(size: 12, design: .rounded)).foregroundColor(Theme.textSecondary)
                                }
                            }
                        }
                        .padding(14)
                        .background(Theme.bgSecondary)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    }
                    
                    // Show summary at end
                    if currentStep == 5 && !balancedThought.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Summary")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                            
                            summaryRow("Situation:", situation)
                            summaryRow("Old thought:", automaticThought)
                            summaryRow("New thought:", balancedThought)
                        }
                        .padding(16)
                        .background(Theme.success.opacity(0.15))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 20)
                }
            }
            .background(Theme.bg)
            .navigationTitle("Thought Reframing")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack(spacing: 16) {
                    if currentStep > 0 {
                        Button(action: { withAnimation { currentStep -= 1 } }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Theme.card)
                            .foregroundColor(Theme.textPrimary)
                            .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Button(action: {
                        withAnimation {
                            if currentStep < 5 {
                                currentStep += 1
                            } else {
                                dismiss()
                            }
                        }
                    }) {
                        HStack {
                            Text(currentStep < 5 ? "Next" : "Done")
                            if currentStep < 5 { Image(systemName: "chevron.right") }
                        }
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Theme.accent2)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
    }
    
    private func summaryRow(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textMuted)
            Text(value.isEmpty ? "—" : value)
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(Theme.textPrimary)
        }
    }
    
    private func textForStep(_ step: Int) -> Binding<String> {
        switch step {
        case 0: return $situation
        case 1: return $automaticThought
        case 2: return $cognitiveDistortion
        case 3: return $evidenceFor
        case 4: return $evidenceAgainst
        case 5: return $balancedThought
        default: return $situation
        }
    }
}
