import SwiftUI

struct IOSProgressView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Progress")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    Text("Every session builds momentum toward your goals")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 4)

                // Main stats - big cards
                HStack(spacing: 12) {
                    bigStatCard(
                        value: "\(appState.completedSessionsToday)",
                        label: "Today's Sessions",
                        icon: "flame.fill",
                        color: Theme.accent,
                        progress: min(Double(appState.completedSessionsToday) / max(1, Double(appState.dailyGoal)), 1.0)
                    )
                    bigStatCard(
                        value: "\(appState.todaysFocusMinutes)",
                        label: "Minutes Focused",
                        icon: "clock.fill",
                        color: Theme.success,
                        progress: min(Double(appState.todaysFocusMinutes) / 120, 1.0) // 2 hour target
                    )
                }
                
                // Weekly overview
                VStack(alignment: .leading, spacing: 16) {
                    Text("This Week")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    
                    // Weekly bar chart
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(0..<7, id: \.self) { i in
                            let minutes = i < appState.weeklyFocusData.count ? appState.weeklyFocusData[i] : 0
                            let maxMinutes = max(appState.weeklyFocusData.max() ?? 1, 1)
                            
                            VStack(spacing: 8) {
                                ZStack(alignment: .bottom) {
                                    // Background bar
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Theme.card)
                                        .frame(height: 100)
                                    
                                    // Filled bar
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(
                                            LinearGradient(
                                                colors: [Theme.accent, Theme.accent.opacity(0.6)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(height: minutes > 0 ? max(8, CGFloat(minutes) / CGFloat(maxMinutes) * 100) : 0)
                                }
                                
                                VStack(spacing: 2) {
                                    Text("\(minutes)")
                                        .font(.system(size: 10, weight: .bold, design: .rounded))
                                        .foregroundColor(minutes > 0 ? Theme.textPrimary : Theme.textMuted)
                                    Text(["Mon","Tue","Wed","Thu","Fri","Sat","Sun"][i])
                                        .font(.system(size: 9, design: .rounded))
                                        .foregroundColor(Theme.textMuted)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(height: 140)
                    
                    // Weekly stats row
                    HStack(spacing: 16) {
                        miniStat("Total", "\(appState.weeklyFocusData.reduce(0, +))", "min", Theme.accent)
                        miniStat("Average", "\(appState.weeklyFocusData.isEmpty ? 0 : appState.weeklyFocusData.reduce(0, +) / 7)", "min/day", Theme.success)
                        miniStat("Best Day", "\(appState.weeklyFocusData.max() ?? 0)", "min", Theme.warning)
                    }
                }
                .padding(18)
                .background(Theme.card)
                .cornerRadius(16)

                // Streak and achievements
                HStack(spacing: 12) {
                    streakCard
                    completionRateCard
                }

                // Emotion insights
                VStack(alignment: .leading, spacing: 14) {
                    Text("Emotional Insights")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    
                    let recentEmotions = Array(appState.emotionalLogs.suffix(10))
                    
                    if recentEmotions.isEmpty {
                        HStack {
                            Image(systemName: "heart.slash")
                                .font(.system(size: 24))
                                .foregroundColor(Theme.textMuted)
                            VStack(alignment: .leading) {
                                Text("No emotion data yet")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                Text("Start logging your emotions to see patterns")
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(Theme.textMuted)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Theme.card)
                        .cornerRadius(12)
                    } else {
                        // Most common emotion
                        let emotionCounts = Dictionary(grouping: recentEmotions, by: { $0.primaryEmotion })
                        let topEmotion = emotionCounts.max(by: { $0.value.count < $1.value.count })?.key ?? .calm
                        
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(Theme.accent.opacity(0.2))
                                    .frame(width: 50, height: 50)
                                Image(systemName: topEmotion.icon)
                                    .font(.system(size: 22))
                                    .foregroundColor(Theme.accent)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Most frequent")
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(Theme.textMuted)
                                Text(topEmotion.rawValue)
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                Text("\(emotionCounts[topEmotion]?.count ?? 0) times recently")
                                    .font(.system(size: 11, design: .rounded))
                                    .foregroundColor(Theme.textMuted)
                            }
                            
                            Spacer()
                        }
                        .padding(16)
                        .background(Theme.card)
                        .cornerRadius(12)
                        
                        // Average intensity
                        let avgIntensity = recentEmotions.isEmpty ? 0 : recentEmotions.reduce(0) { $0 + $1.intensity } / recentEmotions.count
                        HStack {
                            Text("Average Intensity")
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                            Spacer()
                            Text("\(avgIntensity)/10")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(avgIntensity > 6 ? Theme.danger : (avgIntensity > 3 ? Theme.warning : Theme.success))
                        }
                        .padding(16)
                        .background(Theme.card)
                        .cornerRadius(12)
                    }
                }

                // Task completion
                VStack(alignment: .leading, spacing: 14) {
                    Text("Task Progress")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    
                    let totalTasks = appState.tasks.count
                    let completedTasks = appState.tasks.filter { $0.status == .completed }.count
                    let completionRate = totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0
                    
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Completed")
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(Theme.textMuted)
                                Text("\(completedTasks) of \(totalTasks)")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                            }
                            Spacer()
                            Text("\(Int(completionRate * 100))%")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(Theme.success)
                        }
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Theme.bgSecondary)
                                    .frame(height: 12)
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Theme.success)
                                    .frame(width: geo.size.width * completionRate, height: 12)
                            }
                        }
                        .frame(height: 12)
                    }
                    .padding(16)
                    .background(Theme.card)
                    .cornerRadius(12)
                }

                // Daily goal
                VStack(alignment: .leading, spacing: 14) {
                    HStack {
                        Text("Daily Goal")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        Spacer()
                        Text("\(appState.completedSessionsToday)/\(appState.dailyGoal) sessions")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(Theme.textMuted)
                    }
                    
                    let goalProgress = min(Double(appState.completedSessionsToday) / max(1, Double(appState.dailyGoal)), 1.0)
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Theme.bgSecondary)
                                .frame(height: 16)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: goalProgress >= 1.0 ? [Theme.success, Theme.success.opacity(0.7)] : [Theme.accent, Theme.accentLight],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geo.size.width * goalProgress, height: 16)
                        }
                    }
                    .frame(height: 16)
                    
                    if goalProgress >= 1.0 {
                        HStack(spacing: 8) {
                            Image(systemName: "star.fill")
                                .foregroundColor(Theme.warning)
                            Text("Goal reached! Great work!")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.success)
                        }
                    } else {
                        let remaining = appState.dailyGoal - appState.completedSessionsToday
                        Text("\(remaining) more session\(remaining == 1 ? "" : "s") to reach your goal")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(Theme.textMuted)
                    }
                }
                .padding(18)
                .background(Theme.card)
                .cornerRadius(16)
                
                // Settings
                Button(action: { appState.showSettings = true }) {
                    HStack {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Theme.textMuted)
                        Text("Settings")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(Theme.textMuted)
                    }
                    .padding(16)
                    .background(Theme.card)
                    .cornerRadius(14)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Theme.bg)
    }

    private func bigStatCard(value: String, label: String, icon: String, color: Color, progress: Double) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(color)
            }
            
            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
            
            Text(label)
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Theme.textMuted)
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.bgSecondary)
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geo.size.width * progress, height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.card)
        .cornerRadius(16)
    }

    private var streakCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "calendar.badge.checkmark")
                    .foregroundColor(Theme.warning)
                Text("Current Streak")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(Theme.textMuted)
            }
            Text("\(currentStreak)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
            Text("day\(currentStreak == 1 ? "" : "s")")
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Theme.card)
        .cornerRadius(14)
    }

    private var completionRateCard: some View {
        let completed = appState.tasks.filter { $0.status == .completed }.count
        let total = appState.tasks.count
        let rate = total > 0 ? Double(completed) / Double(total) : 0
        
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(Theme.success)
                Text("Completion Rate")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(Theme.textMuted)
            }
            Text("\(Int(rate * 100))%")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
            Text("\(completed)/\(total) tasks")
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Theme.card)
        .cornerRadius(14)
    }

    private func miniStat(_ label: String, _ value: String, _ unit: String, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 10, design: .rounded))
                .foregroundColor(Theme.textMuted)
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(color)
            Text(unit)
                .font(.system(size: 9, design: .rounded))
                .foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
    }

    private var currentStreak: Int {
        var streak = 0
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        for dayOffset in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: today) {
                let hasSession = appState.focusSessions.contains { session in
                    calendar.isDate(session.startTime, inSameDayAs: date) && session.wasSuccessful
                }
                if hasSession {
                    streak += 1
                } else if dayOffset > 0 {
                    break
                }
            }
        }
        return streak
    }
}
