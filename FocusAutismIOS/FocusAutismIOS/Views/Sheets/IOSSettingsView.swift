import SwiftUI

struct IOSSettingsView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Focus settings
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Focus Timer")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)

                        VStack(spacing: 12) {
                            settingSlider("Focus Duration", value: $appState.settings.focusDuration, range: 5...60, step: 5, unit: "min")
                            settingSlider("Short Break", value: $appState.settings.shortBreakDuration, range: 1...15, step: 1, unit: "min")
                            settingSlider("Long Break", value: $appState.settings.longBreakDuration, range: 10...30, step: 5, unit: "min")
                        }
                        .padding(14)
                        .background(Theme.bgSecondary)
                        .cornerRadius(12)
                    }

                    // Goals
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Goals")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)

                        VStack(spacing: 12) {
                            settingStepper("Daily Session Goal", value: $appState.dailyGoal, range: 1...20)
                        }
                        .padding(14)
                        .background(Theme.bgSecondary)
                        .cornerRadius(12)
                    }

                    // Notifications
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Notifications")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)

                        VStack(spacing: 12) {
                            settingToggle("Sound", isOn: $appState.settings.soundEnabled)
                            settingToggle("System Notifications", isOn: $appState.settings.notificationsEnabled)
                        }
                        .padding(14)
                        .background(Theme.bgSecondary)
                        .cornerRadius(12)
                    }

                    // Data
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Data")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)

                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Clear All Data")
                                    .font(.system(size: 14, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                Text("Remove all tasks, sessions, and emotion logs")
                                    .font(.system(size: 11, design: .rounded))
                                    .foregroundColor(Theme.textMuted)
                            }
                            Spacer()
                            Button(action: {
                                appState.tasks = []
                                appState.focusSessions = []
                                appState.emotionalLogs = []
                                appState.currentTask = nil
                                appState.completedSessionsToday = 0
                                appState.saveData()
                            }) {
                                Text("Clear")
                                    .font(.system(size: 13, weight: .medium, design: .rounded))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Theme.danger.opacity(0.15))
                                    .foregroundColor(Theme.danger)
                                    .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(14)
                        .background(Theme.bgSecondary)
                        .cornerRadius(12)
                    }

                    // About
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Focus Autism")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                            Text("Version 1.0")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                            Text("Built with evidence-based techniques for autism and ADHD focus.")
                                .font(.system(size: 11, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.bgSecondary)
                        .cornerRadius(12)
                    }
                }
                .padding(20)
            }
            .background(Theme.bg)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func settingSlider(_ label: String, value: Binding<Int>, range: ClosedRange<Int>, step: Int, unit: String) -> some View {
        VStack(spacing: 6) {
            HStack {
                Text(label)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text("\(value.wrappedValue) \(unit)")
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundColor(Theme.textSecondary)
            }
            Slider(value: Binding(get: { Double(value.wrappedValue) }, set: { value.wrappedValue = Int($0) }),
                   in: Double(range.lowerBound)...Double(range.upperBound),
                   step: Double(step))
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

    private func settingToggle(_ label: String, isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn) {
            Text(label)
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(Theme.textPrimary)
        }
        .toggleStyle(.switch)
        .tint(Theme.accent)
    }
}
