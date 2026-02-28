import SwiftUI

struct GroundingExerciseView: View {
    @Environment(\.dismiss) var dismiss
    @State private var step = 0
    @State private var countdown = 20
    @State private var timer: Timer?

    private let steps = [
        ("5 Things You See", "Look around slowly. Name 5 things you can see. Notice their color, shape, texture."),
        ("4 Things You Hear", "Close your eyes if comfortable. Name 4 sounds. Near and far."),
        ("3 Things You Feel", "Notice 3 physical sensations. Feet on ground, air on skin, fabric."),
        ("2 Things You Smell", "Notice 2 smells. If you can't, name 2 smells you enjoy."),
        ("1 Thing You Taste", "Notice the taste in your mouth. Or take a sip of water."),
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("5-4-3-2-1 Grounding")
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
                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self) { i in
                        Circle()
                            .fill(i <= step ? Theme.success : Theme.textMuted.opacity(0.3))
                            .frame(width: 10, height: 10)
                    }
                }

                Text("\(5 - step)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.success)

                Text(steps[step].0)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)

                Text(steps[step].1)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Text("Take your time. No rush.")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(Theme.textMuted)
                    .padding(.top, 8)

                HStack(spacing: 16) {
                    if step > 0 {
                        Button(action: { step -= 1; countdown = 20 }) {
                            Text("Back")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .padding(.horizontal, 20).padding(.vertical, 10)
                                .background(Theme.textMuted.opacity(0.15))
                                .foregroundColor(Theme.textSecondary)
                                .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }

                    Button(action: {
                        if step < 4 { step += 1; countdown = 20 }
                        else { dismiss() }
                    }) {
                        Text(step < 4 ? "Next" : "Done")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 20).padding(.vertical, 10)
                            .background(Theme.success.opacity(0.15))
                            .foregroundColor(Theme.success)
                            .cornerRadius(8)
                    }
                    .buttonStyle(.plain)
                }
            }

            Spacer()
        }
        .frame(width: 460, height: 480)
        .background(Theme.bg)
    }
}
