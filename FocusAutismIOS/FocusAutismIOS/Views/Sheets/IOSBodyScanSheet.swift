import SwiftUI

struct IOSBodyScanSheet: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isActive = false
    @State private var currentRegion = 0
    @State private var phase: String = "Relax"
    @State private var timer: Timer?
    
    private let regions = [
        (name: "Feet", instruction: "Wiggle your toes. Feel the sensation."),
        (name: "Legs", instruction: "Tense your legs for 3 seconds, then release."),
        (name: "Stomach", instruction: "Notice your breathing. Rise and fall."),
        (name: "Hands", instruction: "Make a fist. Squeeze tight, then let go."),
        (name: "Arms", instruction: "Tense your arms. Feel the tension, then relax."),
        (name: "Shoulders", instruction: "Raise shoulders to ears. Release and drop."),
        (name: "Face", instruction: "Scrunch your face. Release all tension."),
        (name: "Whole Body", instruction: "Feel completely relaxed from head to toe.")
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                if !isActive {
                    // Start screen
                    VStack(spacing: 20) {
                        Image(systemName: "figure.stand")
                            .font(.system(size: 56))
                            .foregroundColor(Theme.warning)
                        
                        Text("Body Scan")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        
                        Text("A gentle guided relaxation through 8 body regions. Great for releasing physical tension.")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image(systemName: "clock").foregroundColor(Theme.accent)
                                Text("Takes 5-8 minutes")
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundColor(Theme.textSecondary)
                            }
                            HStack(spacing: 12) {
                                Image(systemName: "moon.fill").foregroundColor(Theme.accent)
                                Text("Reduces anxiety & stress")
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }
                        .padding(16)
                        .background(Theme.card)
                        .cornerRadius(12)
                    }
                    .padding(.top, 40)
                    
                    Spacer()
                    
                    Button(action: { startBodyScan() }) {
                        Text("Begin Body Scan")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Theme.warning)
                            .foregroundColor(.black)
                            .cornerRadius(14)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                } else {
                    // Active body scan
                    Spacer()
                    
                    // Progress
                    HStack(spacing: 6) {
                        ForEach(0..<regions.count, id: \.self) { i in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(i <= currentRegion ? Theme.warning : Theme.textMuted.opacity(0.3))
                                .frame(height: 4)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Text("\(currentRegion + 1) of \(regions.count)")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(Theme.textMuted)
                        .padding(.top, 8)
                    
                    Text(regions[currentRegion].name)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                        .padding(.top, 20)
                    
                    Text(regions[currentRegion].instruction)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 12)
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(action: { stopBodyScan() }) {
                            Text("Stop")
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(Theme.danger.opacity(0.2))
                                .foregroundColor(Theme.danger)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: { nextRegion() }) {
                            Text(currentRegion < regions.count - 1 ? "Next" : "Complete")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(Theme.warning)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.bottom, 40)
                }
            }
            .background(Theme.bg)
            .navigationTitle("Body Scan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .onDisappear { stopBodyScan() }
    }
    
    private func startBodyScan() {
        isActive = true
        currentRegion = 0
    }
    
    private func nextRegion() {
        if currentRegion < regions.count - 1 {
            currentRegion += 1
        } else {
            isActive = false
        }
    }
    
    private func stopBodyScan() {
        isActive = false
    }
}
