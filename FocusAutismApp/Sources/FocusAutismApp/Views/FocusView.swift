import SwiftUI

struct FocusView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Focus Session")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        Text(timerSubtitle)
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                    }
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)

                // Timer ring
                timerRing
                    .padding(.vertical, 8)

                // Current task
                if let task = appState.currentTask {
                    currentTaskCard(task)
                        .padding(.horizontal, 32)
                } else {
                    noTaskCard
                        .padding(.horizontal, 32)
                }

                // Controls
                timerControls
                    .padding(.horizontal, 32)

                // Energy & Emotion quick tracker
                energyEmotionBar
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
            }
        }
    }

    // MARK: - Timer subtitle
    private var timerSubtitle: String {
        switch appState.timerState {
        case .focusing: return "Stay with it. You're doing well."
        case .paused:   return "Take your time. Resume when ready."
        case .onBreak:  return "Rest your mind. Breathe slowly."
        case .onLongBreak: return "You've earned a longer rest."
        case .completed: return "Session complete. Nice work."
        default:         return "Select a task and begin when you're ready."
        }
    }

    // MARK: - Timer Ring
    private var timerRing: some View {
        ZStack {
            // Track
            Circle()
                .stroke(Theme.card, lineWidth: 10)
                .frame(width: 240, height: 240)

            // Progress
            Circle()
                .trim(from: 0, to: progress)
                .stroke(timerColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .frame(width: 240, height: 240)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.4), value: appState.timeRemaining)

            // Center content
            VStack(spacing: 6) {
                Text(stateLabel)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.textMuted)
                    .textCase(.uppercase)
                    .tracking(1.5)

                Text(timeString)
                    .font(.system(size: 48, weight: .light, design: .monospaced))
                    .foregroundColor(Theme.textPrimary)
            }
        }
    }

    private var timerColor: Color {
        switch appState.timerState {
        case .focusing:           return Theme.timerFocus
        case .paused:             return Theme.timerPause
        case .onBreak, .onLongBreak: return Theme.timerBreak
        case .completed:          return Theme.success
        default:                  return Theme.textMuted
        }
    }

    private var progress: Double {
        let total: TimeInterval
        switch appState.timerState {
        case .focusing:  total = TimeInterval(appState.settings.focusDuration * 60)
        case .onBreak:   total = TimeInterval(appState.settings.shortBreakDuration * 60)
        case .onLongBreak: total = TimeInterval(appState.settings.longBreakDuration * 60)
        default:         return 0
        }
        guard total > 0 else { return 0 }
        return (total - appState.timeRemaining) / total
    }

    private var timeString: String {
        let m = Int(appState.timeRemaining) / 60
        let s = Int(appState.timeRemaining) % 60
        return String(format: "%02d:%02d", m, s)
    }

    private var stateLabel: String {
        switch appState.timerState {
        case .focusing:  return "focus"
        case .paused:    return "paused"
        case .onBreak:   return "break"
        case .onLongBreak: return "long break"
        case .completed: return "done"
        default:         return "ready"
        }
    }

    // MARK: - Task Cards
    private func currentTaskCard(_ task: TaskItem) -> some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Theme.accent)
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                if !task.detailedDescription.isEmpty {
                    Text(task.detailedDescription)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(Theme.textSecondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Image(systemName: task.category.icon)
                .foregroundColor(Theme.textMuted)
                .font(.system(size: 14))
        }
        .padding(16)
        .frame(maxWidth: 500)
        .background(Theme.card)
        .cornerRadius(12)
    }

    private var noTaskCard: some View {
        HStack {
            Image(systemName: "arrow.right.circle")
                .foregroundColor(Theme.textMuted)
            Text("Go to Tasks to add and select a task")
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(Theme.textSecondary)
        }
        .padding(16)
        .frame(maxWidth: 500)
        .background(Theme.card)
        .cornerRadius(12)
    }

    // MARK: - Controls
    private var timerControls: some View {
        HStack(spacing: 14) {
            if appState.timerState == .idle || appState.timerState == .completed {
                warmButton("Start Focus", icon: "play.fill", color: Theme.accent) {
                    appState.startFocusSession()
                }
                .disabled(appState.currentTask == nil)
                .opacity(appState.currentTask == nil ? 0.4 : 1)

            } else if appState.timerState == .focusing || appState.timerState == .paused {
                if appState.timerState == .paused {
                    warmButton("Resume", icon: "play.fill", color: Theme.success) {
                        appState.resumeTimer()
                    }
                }
                warmButton("Pause", icon: "pause.fill", color: Theme.warning) {
                    appState.pauseTimer()
                }
                warmButton("Stop", icon: "stop.fill", color: Theme.danger) {
                    appState.stopSession()
                }

            } else if appState.timerState == .onBreak || appState.timerState == .onLongBreak {
                warmButton("Skip Break", icon: "forward.fill", color: Theme.textMuted) {
                    appState.emergencyReset()
                }
            }
        }
    }

    private func warmButton(_ label: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                Text(label)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(color.opacity(0.3), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Energy/Emotion Bar
    private var energyEmotionBar: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Energy")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.textMuted)
                Picker("Energy", selection: $appState.currentEnergyLevel) {
                    ForEach(EnergyLevel.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 280)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Feeling")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.textMuted)
                Picker("Emotion", selection: $appState.currentEmotion) {
                    ForEach(Emotion.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                }
                .frame(maxWidth: 200)
            }

            Spacer()

            Button(action: { appState.showEmotionLogger = true }) {
                HStack(spacing: 4) {
                    Image(systemName: "plus.circle")
                    Text("Log")
                }
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(Theme.accent)
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(Theme.card)
        .cornerRadius(12)
    }
}
