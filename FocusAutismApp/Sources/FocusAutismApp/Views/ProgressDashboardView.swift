import SwiftUI

struct ProgressDashboardView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Progress")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        Text("Your growth over time")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                    }
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.top, 24)

                weeklyChart
                    .padding(.horizontal, 28)

                HStack(alignment: .top, spacing: 20) {
                    focusStats
                        .frame(maxWidth: .infinity)
                    emotionStats
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 28)

                dailyGoalCard
                    .padding(.horizontal, 28)
                    .padding(.bottom, 24)
            }
        }
    }

    // MARK: - Weekly Chart
    private var weeklyChart: some View {
        let data = appState.weeklyFocusData
        return VStack(alignment: .leading, spacing: 14) {
            Text("This Week")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textPrimary)

            HStack(alignment: .bottom, spacing: 14) {
                WeeklyBarView(day: "Mon", minutes: data.count > 0 ? data[0] : 0)
                WeeklyBarView(day: "Tue", minutes: data.count > 1 ? data[1] : 0)
                WeeklyBarView(day: "Wed", minutes: data.count > 2 ? data[2] : 0)
                WeeklyBarView(day: "Thu", minutes: data.count > 3 ? data[3] : 0)
                WeeklyBarView(day: "Fri", minutes: data.count > 4 ? data[4] : 0)
                WeeklyBarView(day: "Sat", minutes: data.count > 5 ? data[5] : 0)
                WeeklyBarView(day: "Sun", minutes: data.count > 6 ? data[6] : 0)
            }
            .frame(height: 180)
        }
        .padding(18)
        .background(Theme.card)
        .cornerRadius(14)
    }

    // MARK: - Focus Stats
    private var focusStats: some View {
        let total = appState.focusSessions.count
        let successful = appState.focusSessions.filter { $0.wasSuccessful }.count
        let totalMin = appState.focusSessions.reduce(0) { $0 + Int($1.duration / 60) }
        let avg = total > 0 ? totalMin / total : 0

        return VStack(alignment: .leading, spacing: 14) {
            Text("Focus Stats")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textPrimary)

            VStack(spacing: 10) {
                statRow("Total Sessions", "\(total)")
                statRow("Successful", "\(successful)")
                statRow("Total Time", "\(totalMin) min")
                statRow("Avg Length", "\(avg) min")
                statRow("Today", "\(appState.todaysFocusMinutes) min")
            }
        }
        .padding(18)
        .background(Theme.card)
        .cornerRadius(14)
    }

    // MARK: - Emotion Stats
    private var emotionStats: some View {
        let most = appState.todayEmotionData.max(by: { $0.value < $1.value })?.key
        let todayCount = appState.todayEmotionData.values.reduce(0, +)

        return VStack(alignment: .leading, spacing: 14) {
            Text("Emotion Stats")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textPrimary)

            VStack(spacing: 10) {
                statRow("All-time Logs", "\(appState.emotionalLogs.count)")
                statRow("Today's Logs", "\(todayCount)")
                statRow("Most Common", most?.rawValue ?? "N/A")
                statRow("Energy", appState.currentEnergyLevel.rawValue)
                statRow("Current Mood", appState.currentEmotion.rawValue)
            }
        }
        .padding(18)
        .background(Theme.card)
        .cornerRadius(14)
    }

    // MARK: - Daily Goal
    private var dailyGoalCard: some View {
        let prog = min(Double(appState.completedSessionsToday) / max(1, Double(appState.dailyGoal)), 1.0)
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Daily Goal")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text("\(appState.completedSessionsToday)/\(appState.dailyGoal) sessions")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(Theme.textSecondary)
            }

            ProgressView(value: prog)
                .tint(prog >= 1.0 ? Theme.success : Theme.accent)

            if prog >= 1.0 {
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Theme.warning)
                    Text("Goal reached! You showed up for yourself today.")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(Theme.success)
                }
            }
        }
        .padding(18)
        .background(Theme.card)
        .cornerRadius(14)
    }

    private func statRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(Theme.textSecondary)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
        }
    }
}

struct WeeklyBarView: View {
    let day: String
    let minutes: Int

    private var h: CGFloat { CGFloat(min(minutes * 2, 140)) }

    var body: some View {
        VStack(spacing: 6) {
            if minutes > 0 {
                RoundedRectangle(cornerRadius: 4)
                    .fill(LinearGradient(colors: [Theme.accent, Theme.accentLight], startPoint: .bottom, endPoint: .top))
                    .frame(height: h)
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Theme.textMuted.opacity(0.2))
                    .frame(height: 4)
            }

            Text(day)
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(Theme.textMuted)

            Text("\(minutes)m")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}
