import SwiftUI

struct IOSFocusView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Focus")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    Text(motivationalSubtitle)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 4)

                // Timer - stunning design
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(timerColor.opacity(0.1))
                        .frame(width: 300, height: 300)
                    
                    // Main background
                    Circle()
                        .fill(Theme.card)
                        .frame(width: 260, height: 260)
                    
                    // Progress ring - gradient
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [timerColor, timerColor.opacity(0.5)]),
                                center: .center,
                                startAngle: .degrees(0),
                                endAngle: .degrees(360 * progress)
                            ),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .frame(width: 260, height: 260)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.4), value: appState.timeRemaining)
                    
                    // Inner circle
                    Circle()
                        .stroke(Theme.bgSecondary, lineWidth: 2)
                        .frame(width: 220, height: 220)
                    
                    // Time content
                    VStack(spacing: 8) {
                        // State badge
                        HStack(spacing: 6) {
                            Circle()
                                .fill(timerColor)
                                .frame(width: 8, height: 8)
                            Text(stateLabel)
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(timerColor)
                                .textCase(.uppercase)
                                .tracking(2)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(timerColor.opacity(0.15))
                        .cornerRadius(20)
                        
                        // Time display
                        Text(timeString)
                            .font(.system(size: 56, weight: .thin, design: .monospaced))
                            .foregroundColor(Theme.textPrimary)
                            .monospacedDigit()
                        
                        // Session indicator
                        if appState.timerState == .focusing || appState.timerState == .paused {
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 10))
                                Text("Session \(appState.completedSessionsToday + 1)")
                                    .font(.system(size: 11, weight: .medium, design: .rounded))
                            }
                            .foregroundColor(timerColor)
                        }
                    }
                }
                .padding(.vertical, 10)

                // Current task
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "target")
                            .foregroundColor(Theme.accent)
                        Text("Focusing On")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        Spacer()
                    }
                    
                    if let task = appState.currentTask {
                        HStack(spacing: 14) {
                            // Priority stripe
                            RoundedRectangle(cornerRadius: 3)
                                .fill(priorityColor(for: task.priority))
                                .frame(width: 5)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text(task.title)
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                    .lineLimit(2)
                                
                                if !task.detailedDescription.isEmpty {
                                    Text(task.detailedDescription)
                                        .font(.system(size: 13, design: .rounded))
                                        .foregroundColor(Theme.textSecondary)
                                        .lineLimit(1)
                                }
                                
                                HStack(spacing: 16) {
                                    Label("\(Int(task.estimatedDuration/60)) min", systemImage: "clock")
                                    Label(task.priority.rawValue, systemImage: "flag")
                                }
                                .font(.system(size: 11, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                            }
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(Theme.accent.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                Image(systemName: task.category.icon)
                                    .font(.system(size: 18))
                                    .foregroundColor(Theme.accent)
                            }
                        }
                        .padding(16)
                        .background(Theme.bgSecondary)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Theme.accent.opacity(0.3), lineWidth: 1)
                        )
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "clipboard")
                                .font(.system(size: 36))
                                .foregroundColor(Theme.textMuted)
                            
                            Text("No task selected")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                            
                            Text("Select a task from the Tasks tab to focus on")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(24)
                        .background(Theme.bgSecondary)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 4)

                // Control buttons
                VStack(spacing: 12) {
                    if appState.timerState == .idle || appState.timerState == .completed {
                        mainButton(
                            "Start Focus",
                            icon: "play.fill",
                            color: Theme.accent
                        ) {
                            appState.startFocusSession()
                        }
                        .disabled(appState.currentTask == nil)
                        .opacity(appState.currentTask == nil ? 0.5 : 1)
                        
                    } else if appState.timerState == .focusing {
                        HStack(spacing: 12) {
                            secondaryButton("Pause", icon: "pause.fill", color: Theme.warning) {
                                appState.pauseTimer()
                            }
                            secondaryButton("Stop", icon: "stop.fill", color: Theme.danger) {
                                appState.stopSession()
                            }
                        }
                    } else if appState.timerState == .paused {
                        HStack(spacing: 12) {
                            mainButton("Resume", icon: "play.fill", color: Theme.success) {
                                appState.resumeTimer()
                            }
                            secondaryButton("Stop", icon: "stop.fill", color: Theme.danger) {
                                appState.stopSession()
                            }
                        }
                    } else if appState.timerState == .onBreak {
                        mainButton("Take Break", icon: "cup.and.saucer.fill", color: Theme.success) {
                            appState.startBreak()
                        }
                    } else if appState.timerState == .onLongBreak {
                        mainButton("Long Break", icon: "moon.fill", color: Theme.success) {
                            appState.startLongBreak()
                        }
                    }
                }
                .padding(.horizontal, 4)

                // Stats row
                VStack(spacing: 10) {
                    Text("Today's Progress")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 12) {
                        miniStat(
                            value: "\(appState.completedSessionsToday)",
                            label: "Sessions",
                            icon: "flame.fill",
                            color: Theme.accent
                        )
                        miniStat(
                            value: "\(appState.todaysFocusMinutes)",
                            label: "Minutes",
                            icon: "clock.fill",
                            color: Theme.success
                        )
                        miniStat(
                            value: "\(Int(goalProgress * 100))%",
                            label: "Goal",
                            icon: "target",
                            color: goalProgress >= 1.0 ? Theme.success : Theme.warning
                        )
                    }
                    
                    // Goal progress bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Theme.bgSecondary)
                                .frame(height: 10)
                            RoundedRectangle(cornerRadius: 6)
                                .fill(
                                    LinearGradient(
                                        colors: goalProgress >= 1.0 ? [Theme.success, Theme.success.opacity(0.7)] : [Theme.accent, Theme.accentLight],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geo.size.width * goalProgress, height: 10)
                        }
                    }
                    .frame(height: 10)
                    
                    if goalProgress >= 1.0 {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .foregroundColor(Theme.warning)
                            Text("Daily goal achieved!")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.success)
                        }
                    } else {
                        Text("\(appState.dailyGoal - appState.completedSessionsToday) more session\(appState.dailyGoal - appState.completedSessionsToday == 1 ? "" : "s") to reach goal")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(Theme.textMuted)
                    }
                }
                .padding(16)
                .background(Theme.card)
                .cornerRadius(16)
                .padding(.horizontal, 4)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Theme.bg)
    }

    private func mainButton(_ title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                Text(title)
                    .font(.system(size: 17, weight: .bold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [color, color.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(14)
            .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }

    private func secondaryButton(_ title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }

    private func miniStat(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
            Text(label)
                .font(.system(size: 10, design: .rounded))
                .foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.bgSecondary)
        .cornerRadius(12)
    }

    private var goalProgress: Double {
        min(Double(appState.completedSessionsToday) / max(1, Double(appState.dailyGoal)), 1.0)
    }
    
    private func priorityColor(for priority: TaskPriority) -> Color {
        switch priority {
        case .urgent: return Theme.danger
        case .high: return Theme.accent
        case .medium: return Theme.warning
        case .low: return Theme.success
        }
    }

    private var progress: Double {
        guard appState.timeRemaining > 0 else { return 0 }
        let total = totalTime
        return total > 0 ? appState.timeRemaining / total : 0
    }

    private var totalTime: TimeInterval {
        switch appState.timerState {
        case .focusing: return TimeInterval(appState.settings.focusDuration * 60)
        case .onBreak: return TimeInterval(appState.settings.shortBreakDuration * 60)
        case .onLongBreak: return TimeInterval(appState.settings.longBreakDuration * 60)
        default: return TimeInterval(appState.settings.focusDuration * 60)
        }
    }

    private var timeString: String {
        let minutes = Int(appState.timeRemaining) / 60
        let seconds = Int(appState.timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private var stateLabel: String {
        switch appState.timerState {
        case .idle: return "Ready"
        case .focusing: return "Focus"
        case .paused: return "Paused"
        case .onBreak: return "Break"
        case .onLongBreak: return "Long Break"
        case .completed: return "Done"
        }
    }

    private var motivationalSubtitle: String {
        switch appState.timerState {
        case .idle:
            return appState.currentTask != nil ? "Ready to focus? You've got this!" : "Select a task to begin your focus session"
        case .focusing:
            return "Stay in the zone. Great things happen when you focus!"
        case .paused:
            return "Take a breath. Resume when you're ready."
        case .onBreak, .onLongBreak:
            return "Excellent work! Recharge your energy."
        case .completed:
            return "Amazing session! Take a well-deserved break."
        }
    }

    private var timerColor: Color {
        switch appState.timerState {
        case .idle: return Theme.textMuted
        case .focusing: return Theme.accent
        case .paused: return Theme.warning
        case .onBreak, .onLongBreak, .completed: return Theme.success
        }
    }
}
