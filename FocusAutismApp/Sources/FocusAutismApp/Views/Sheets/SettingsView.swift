import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Settings")
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

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    settingsSection("Focus") {
                        settingSlider("Focus Duration", value: $appState.settings.focusDuration, range: 5...60, step: 5, unit: "min")
                        settingSlider("Short Break", value: $appState.settings.shortBreakDuration, range: 1...15, step: 1, unit: "min")
                        settingSlider("Long Break", value: $appState.settings.longBreakDuration, range: 10...30, step: 5, unit: "min")
                        settingStepper("Sessions before long break", value: $appState.settings.sessionsBeforeLongBreak, range: 2...8)
                        settingStepper("Daily goal (sessions)", value: $appState.dailyGoal, range: 1...20)
                    }

                    settingsSection("Notifications") {
                        settingToggle("Sound", isOn: $appState.settings.soundEnabled, desc: "Play sound when timer ends")
                        settingToggle("Notifications", isOn: $appState.settings.notificationsEnabled, desc: "Show system notifications")
                    }

                    settingsSection("Data") {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Clear All Data")
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                Text("Remove all tasks, sessions, and logs")
                                    .font(.system(size: 11, design: .rounded))
                                    .foregroundColor(Theme.textMuted)
                            }
                            Spacer()
                            Button(action: {
                                appState.tasks = []; appState.focusSessions = []; appState.emotionalLogs = []
                                appState.currentTask = nil; appState.completedSessionsToday = 0; appState.saveData()
                            }) {
                                Text("Clear")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .padding(.horizontal, 14).padding(.vertical, 6)
                                    .background(Theme.danger.opacity(0.15))
                                    .foregroundColor(Theme.danger)
                                    .cornerRadius(6)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(24)
            }
        }
        .frame(width: 480, height: 520)
        .background(Theme.bg)
    }

    private func settingsSection<V: View>(_ title: String, @ViewBuilder content: () -> V) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
            VStack(spacing: 10) {
                content()
            }
            .padding(14)
            .background(Theme.card)
            .cornerRadius(12)
        }
    }

    private func settingSlider(_ label: String, value: Binding<Int>, range: ClosedRange<Int>, step: Int, unit: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
            }
            Spacer()
            Text("\(value.wrappedValue) \(unit)")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(Theme.textSecondary)
                .frame(width: 50, alignment: .trailing)
            Slider(value: Binding(get: { Double(value.wrappedValue) }, set: { value.wrappedValue = Int($0) }),
                   in: Double(range.lowerBound)...Double(range.upperBound),
                   step: Double(step))
                .frame(width: 140)
                .tint(Theme.accent)
        }
    }

    private func settingStepper(_ label: String, value: Binding<Int>, range: ClosedRange<Int>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(Theme.textPrimary)
            Spacer()
            Stepper("\(value.wrappedValue)", value: value, in: range)
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Theme.textPrimary)
        }
    }

    private func settingToggle(_ label: String, isOn: Binding<Bool>, desc: String) -> some View {
        Toggle(isOn: isOn) {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                Text(desc)
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(Theme.textMuted)
            }
        }
        .toggleStyle(.switch)
        .tint(Theme.accent)
    }
}
