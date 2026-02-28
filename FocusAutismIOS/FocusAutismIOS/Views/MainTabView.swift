import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tasks - now first
            NavigationStack {
                IOSTaskListView()
                    .navigationTitle("Tasks")
            }
            .tabItem { Label("Tasks", systemImage: "checklist") }
            .tag(0)

            // Focus
            NavigationStack {
                IOSFocusView()
                    .navigationTitle("Focus")
            }
            .tabItem { Label("Focus", systemImage: "flame") }
            .tag(1)

            // Emotions
            NavigationStack {
                IOSEmotionView()
                    .navigationTitle("Emotions")
            }
            .tabItem { Label("Emotions", systemImage: "heart") }
            .tag(2)

            // Tools
            NavigationStack {
                IOSToolsView()
                    .navigationTitle("Tools")
            }
            .tabItem { Label("Tools", systemImage: "sparkles") }
            .tag(3)

            // Progress
            NavigationStack {
                IOSProgressView()
                    .navigationTitle("Progress")
            }
            .tabItem { Label("Progress", systemImage: "chart.bar") }
            .tag(4)
        }
        .tint(Theme.accent)
        .sheet(isPresented: $appState.showEmotionLogger) {
            IOSEmotionLoggerSheet().environmentObject(appState)
        }
        .sheet(isPresented: $appState.showBreathingExercise) {
            IOSBreathingSheet()
        }
        .sheet(isPresented: $appState.showGroundingExercise) {
            IOSGroundingSheet()
        }
        .sheet(isPresented: $appState.showBodyScanExercise) {
            IOSBodyScanSheet()
        }
        .sheet(isPresented: $appState.showMuscleRelaxationExercise) {
            IOSMuscleRelaxationSheet()
        }
        .sheet(isPresented: $appState.showCognitiveReframingExercise) {
            IOSCognitiveReframingSheet()
        }
        .sheet(isPresented: $appState.showTaskEditor) {
            IOSTaskEditorSheet(task: nil).environmentObject(appState)
        }
        .sheet(isPresented: $appState.showSettings) {
            IOSSettingsView().environmentObject(appState)
        }
    }
}
