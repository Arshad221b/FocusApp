import SwiftUI

struct MainContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Tab = .focus

    enum Tab: String, CaseIterable {
        case focus    = "Focus"
        case tasks    = "Tasks"
        case emotions = "Emotions"
        case progress = "Progress"
        case tools    = "Tools"

        var icon: String {
            switch self {
            case .focus:    return "flame"
            case .tasks:    return "checklist"
            case .emotions: return "heart"
            case .progress: return "chart.bar"
            case .tools:    return "sparkles"
            }
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            sidebar
                .frame(width: 200)

            Divider().background(Theme.textMuted.opacity(0.2))

            mainContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Theme.bg)
        }
        .background(Theme.bg)
        .sheet(isPresented: $appState.showEmotionLogger) {
            EmotionLoggerSheet()
                .environmentObject(appState)
        }
        .sheet(isPresented: $appState.showGroundingExercise) {
            GroundingExerciseView()
        }
        .sheet(isPresented: $appState.showBreathingExercise) {
            BreathingExerciseView()
        }
        .sheet(isPresented: $appState.showTaskEditor) {
            TaskEditorSheet(task: nil)
                .environmentObject(appState)
        }
        .sheet(isPresented: $appState.showSettings) {
            SettingsView()
                .environmentObject(appState)
        }
    }

    // MARK: - Sidebar
    private var sidebar: some View {
        VStack(spacing: 0) {
            // App title
            HStack(spacing: 10) {
                Image(systemName: "flame")
                    .font(.system(size: 18))
                    .foregroundColor(Theme.accent)
                Text("Focus")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Button(action: { appState.showSettings = true }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 13))
                        .foregroundColor(Theme.textMuted)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 16)

            // Nav items
            VStack(spacing: 4) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    sidebarButton(tab)
                }
            }
            .padding(.horizontal, 10)

            Spacer()

            // Quick status
            quickStatus
                .padding(14)
        }
        .background(Theme.sidebar)
    }

    private func sidebarButton(_ tab: Tab) -> some View {
        Button(action: { withAnimation(.easeInOut(duration: 0.15)) { selectedTab = tab } }) {
            HStack(spacing: 10) {
                Image(systemName: tab.icon)
                    .font(.system(size: 13))
                    .frame(width: 20)
                Text(tab.rawValue)
                    .font(.system(size: 13, weight: selectedTab == tab ? .semibold : .regular, design: .rounded))
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(selectedTab == tab ? Theme.accentSoft : Color.clear)
            .foregroundColor(selectedTab == tab ? Theme.accent : Theme.textSecondary)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }

    private var quickStatus: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Today")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(Theme.textMuted)
                Spacer()
                Text("\(appState.todaysFocusMinutes) min")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundColor(Theme.textPrimary)
            }

            ProgressView(value: Double(appState.todaysFocusMinutes),
                         total: max(1, Double(appState.dailyGoal * 25)))
                .tint(Theme.accent)

            HStack(spacing: 6) {
                Circle()
                    .fill(Theme.accent)
                    .frame(width: 6, height: 6)
                Text(appState.currentEmotion.rawValue)
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(Theme.textSecondary)
            }
        }
        .padding(12)
        .background(Theme.card)
        .cornerRadius(10)
    }

    // MARK: - Main Content
    @ViewBuilder
    private var mainContent: some View {
        switch selectedTab {
        case .focus:    FocusView()
        case .tasks:    TaskListView()
        case .emotions: EmotionDashboardView()
        case .progress: ProgressDashboardView()
        case .tools:    ToolsView()
        }
    }
}
