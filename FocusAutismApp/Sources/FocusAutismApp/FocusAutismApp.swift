import SwiftUI
import Logging
import Collections

let logger = Logger(label: "com.focusautism.app")

@main
struct FocusAutismApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environmentObject(appState)
                .frame(minWidth: 1000, minHeight: 700)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {}
            CommandMenu("Focus") {
                Button("Start Focus Session") {
                    appState.startFocusSession()
                }
                .keyboardShortcut("f", modifiers: [.command, .shift])
                
                Button("Take a Break") {
                    appState.startBreak()
                }
                .keyboardShortcut("b", modifiers: [.command, .shift])
                
                Button("Emergency Reset") {
                    appState.emergencyReset()
                }
                .keyboardShortcut("r", modifiers: [.command, .option])
            }
            
            CommandMenu("Emotions") {
                Button("Log Emotional State") {
                    appState.showEmotionLogger = true
                }
                .keyboardShortcut("e", modifiers: [.command])
                
                Button("Quick Grounding Exercise") {
                    appState.showGroundingExercise = true
                }
                .keyboardShortcut("g", modifiers: [.command])
                
                Button("Breathing Exercise") {
                    appState.showBreathingExercise = true
                }
                .keyboardShortcut("b", modifiers: [.command, .option])
            }
        }
    }
}
