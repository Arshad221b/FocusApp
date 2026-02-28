import SwiftUI

struct IOSMuscleRelaxationSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isActive = false
    @State private var currentMuscle = 0
    @State private var isTensing = true
    
    private let muscles = [
        (name: "Right Hand", instruction: "Make a tight fist", relaxInstruction: "Release and let fingers relax"),
        (name: "Right Arm", instruction: "Tense your bicep", relaxInstruction: "Release and let arm go limp"),
        (name: "Left Hand", instruction: "Make a tight fist", relaxInstruction: "Release and let fingers relax"),
        (name: "Left Arm", instruction: "Tense your bicep", relaxInstruction: "Release and let arm go limp"),
        (name: "Face", instruction: "Scrunch eyes, grit teeth", relaxInstruction: "Release all facial tension"),
        (name: "Shoulders", instruction: "Raise shoulders to ears", relaxInstruction: "Drop shoulders down"),
        (name: "Chest", instruction: "Take deep breath, hold", relaxInstruction: "Exhale slowly and relax"),
        (name: "Stomach", instruction: "Tense belly muscles", relaxInstruction: "Release and relax belly"),
        (name: "Right Leg", instruction: "Tense thigh, point toes", relaxInstruction: "Release and let leg relax"),
        (name: "Left Leg", instruction: "Tense thigh, point toes", relaxInstruction: "Release and let leg relax"),
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                if !isActive {
                    // Start screen
                    VStack(spacing: 20) {
                        Image(systemName: "figure.flexibility")
                            .font(.system(size: 56))
                            .foregroundColor(Theme.info)
                        
                        Text("Muscle Relaxation")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        
                        Text("Progressive Muscle Relaxation (PMR): Tense each muscle group for 5 seconds, then relax for 30 seconds.")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "clock").foregroundColor(Theme.accent)
                                Text("Takes 10-15 minutes")
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            HStack(spacing: 12) {
                                Image(systemName: "heart.fill").foregroundColor(Theme.accent)
                                Text("Reduces physical tension")
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            HStack(spacing: 12) {
                                Image(systemName: "brain.head.profile").foregroundColor(Theme.accent)
                                Text("Calms the mind")
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }
                        .padding(16)
                        .background(Theme.card)
                        .cornerRadius(12)
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                    
                    Button(action: { startRelaxation() }) {
                        Text("Begin Exercise")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Theme.info)
                            .foregroundColor(.black)
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                } else {
                    // Active exercise
                    Spacer()
                    
                    // Progress
                    HStack(spacing: 4) {
                        ForEach(0..<muscles.count, id: \.self) { i in
                            Circle()
                                .fill(i < currentMuscle ? Theme.info : (i == currentMuscle ? Theme.info : Theme.textMuted.opacity(0.3)))
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Text("Muscle \(currentMuscle + 1) of \(muscles.count)")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(Theme.textMuted)
                        .padding(.top, 8)
                    
                    Text(muscles[currentMuscle].name)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                        .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        Text(isTensing ? "TENSE" : "RELEASE")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(isTensing ? Theme.danger : Theme.success)
                            .tracking(4)
                        
                        Text(isTensing ? muscles[currentMuscle].instruction : muscles[currentMuscle].relaxInstruction)
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .padding(24)
                    .background(Theme.card)
                    .cornerRadius(16)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(action: { stopRelaxation() }) {
                            Text("Stop")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(Theme.danger.opacity(0.2))
                                .foregroundColor(Theme.danger)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: { nextMuscle() }) {
                            Text(currentMuscle < muscles.count - 1 ? "Next" : "Complete")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(Theme.info)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.bottom, 40)
                }
            }
            .background(Theme.bg)
            .navigationTitle("Muscle Relaxation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
    
    private func startRelaxation() {
        isActive = true
        currentMuscle = 0
        isTensing = true
    }
    
    private func nextMuscle() {
        if isTensing {
            isTensing = false
        } else {
            isTensing = true
            if currentMuscle < muscles.count - 1 {
                currentMuscle += 1
            } else {
                isActive = false
            }
        }
    }
    
    private func stopRelaxation() {
        isActive = false
    }
}
