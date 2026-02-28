import SwiftUI

struct IOSGroundingSheet: View {
    @Environment(\.dismiss) var dismiss

    @State private var isActive = false
    @State private var step = 0

    private let steps = [
        (sense: "See", count: 5, prompt: "Name 5 things you can see right now"),
        (sense: "Hear", count: 4, prompt: "Name 4 things you can hear"),
        (sense: "Feel", count: 3, prompt: "Name 3 things you can physically feel"),
        (sense: "Smell", count: 2, prompt: "Name 2 things you can smell"),
        (sense: "Taste", count: 1, prompt: "Name 1 thing you can taste"),
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                if !isActive {
                    VStack(spacing: 16) {
                        Image(systemName: "eye")
                            .font(.system(size: 48))
                            .foregroundColor(Theme.success)

                        Text("5-4-3-2-1 Grounding")
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)

                        Text("Anchor yourself in the present moment by engaging all five senses.")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)

                        Text("This takes about 2 minutes and helps with anxiety, dissociation, and overwhelm.")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(Theme.textMuted)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .padding(.top, 40)

                    Spacer()

                    Button(action: { isActive = true; step = 0 }) {
                        Text("Begin Exercise")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.success)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                } else {
                    // Active grounding
                    Spacer()

                    ZStack {
                        Circle()
                            .fill(Theme.bgSecondary)
                            .frame(width: 200, height: 200)
                        
                        Circle()
                            .fill(Theme.success.opacity(0.15))
                            .frame(width: 160, height: 160)
                        
                        VStack(spacing: 8) {
                            Text("\(steps[step].count)")
                                .font(.system(size: 64, weight: .ultraLight, design: .monospaced))
                                .foregroundColor(Theme.success)
                                .monospacedDigit()
                            
                            Text("things to notice")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                        }
                    }
                    .padding(.top, 20)

                    // Progress dots
                    HStack(spacing: 8) {
                        ForEach(0..<5, id: \.self) { i in
                            Circle()
                                .fill(i <= step ? Theme.success : Theme.textMuted.opacity(0.3))
                                .frame(width: 10, height: 10)
                        }
                    }
                    .padding(.top, 24)

                    Text(steps[step].prompt)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.top, 20)

                    Text("Take your time. There's no rush.")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(Theme.textMuted)

                    Spacer()

                    HStack(spacing: 16) {
                        if step > 0 {
                            Button(action: { step -= 1 }) {
                                Text("Back")
                                    .font(.system(size: 15, weight: .medium, design: .rounded))
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(Theme.textMuted.opacity(0.15))
                                    .foregroundColor(Theme.textSecondary)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(.plain)
                        }

                        Button(action: {
                            if step < 4 { step += 1 } else { isActive = false }
                        }) {
                            Text(step < 4 ? "Next" : "Complete")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .padding(.horizontal, 32)
                                .padding(.vertical, 12)
                                .background(Theme.success)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.bottom, 40)
                }
            }
            .background(Theme.bg)
            .navigationTitle("Grounding")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
