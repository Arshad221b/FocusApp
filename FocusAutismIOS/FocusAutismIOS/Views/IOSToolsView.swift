import SwiftUI

struct IOSToolsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("Regulation Tools")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    Text("Evidence-based techniques to help you feel better")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 4)

                // Breathing - vibrant card
                toolCard(
                    icon: "wind",
                    title: "Breathing Exercises",
                    subtitle: "Box • Physiological Sigh • Deep",
                    color: Theme.accent,
                    gradient: [Theme.accent, Theme.accentDark],
                    action: { appState.showBreathingExercise = true }
                )

                // Grounding
                toolCard(
                    icon: "eye",
                    title: "5-4-3-2-1 Grounding",
                    subtitle: "Anchor to the present moment",
                    color: Theme.success,
                    gradient: [Theme.success, Theme.successLight],
                    action: { appState.showGroundingExercise = true }
                )

                // Body Scan
                toolCard(
                    icon: "figure.stand",
                    title: "Body Scan",
                    subtitle: "Release tension from each area",
                    color: Theme.warning,
                    gradient: [Theme.warning, Theme.warningLight],
                    action: { appState.showBodyScanExercise = true }
                )

                // PMR
                toolCard(
                    icon: "figure.flexibility",
                    title: "Muscle Relaxation",
                    subtitle: "Tense and release each muscle",
                    color: Theme.info,
                    gradient: [Theme.info, Theme.warning],
                    action: { appState.showMuscleRelaxationExercise = true }
                )

                // Cognitive Reframing
                toolCard(
                    icon: "brain.head.profile",
                    title: "Thought Reframing",
                    subtitle: "Challenge distorted thoughts",
                    color: Theme.accent2,
                    gradient: [Theme.accent2, Theme.accent2Light],
                    action: { appState.showCognitiveReframingExercise = true }
                )

                // Sensory Toolkit
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Theme.accent2.opacity(0.2))
                                .frame(width: 36, height: 36)
                            Image(systemName: "hand.raised.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Theme.accent2)
                        }
                        Text("Sensory Toolkit")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                    }

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        sensoryItem("snowflake", "Cold Water", "Splash face/wrists")
                        sensoryItem("hand.raised.fill", "Deep Pressure", "Hug/blanket")
                        sensoryItem("headphones", "Noise Block", "Headphones")
                        sensoryItem("sun.min", "Dim Lights", "Reduce visual")
                        sensoryItem("hand.draw", "Fidget", "Tactile object")
                        sensoryItem("figure.walk", "Movement", "Stretch/walk")
                        sensoryItem("cup.and.saucer", "Sip Water", "Cool drink")
                        sensoryItem("heart.fill", "Comfort Item", "Favorite object")
                    }
                }
                .padding(18)
                .background(Theme.card)
                .cornerRadius(16)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Theme.bg)
    }

    private func toolCard(icon: String, title: String, subtitle: String, color: Color, gradient: [Color], action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    Text(subtitle)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(Theme.textSecondary)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 36, height: 36)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(color)
                }
            }
            .padding(16)
            .background(Theme.card)
            .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }

    private func sensoryItem(_ icon: String, _ title: String, _ desc: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(Theme.accent2)
                Text(title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
            }
            Text(desc)
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(Theme.textSecondary)
                .lineLimit(2)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.bgSecondary)
        .cornerRadius(12)
    }
}
