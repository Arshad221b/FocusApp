import Foundation
import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var tasks: [TaskItem] = []
    @Published var focusSessions: [FocusSession] = []
    @Published var emotionalLogs: [EmotionalState] = []
    @Published var currentTask: TaskItem?
    @Published var timerState: TimerState = .idle
    @Published var timeRemaining: TimeInterval = 0
    @Published var currentSession: FocusSession?
    
    @Published var showEmotionLogger = false
    @Published var showGroundingExercise = false
    @Published var showBreathingExercise = false
    @Published var showTaskEditor = false
    @Published var showSettings = false
    
    @Published var currentEnergyLevel: EnergyLevel = .medium
    @Published var currentEmotion: Emotion = .calm
    @Published var currentEmotionIntensity: Int = 5
    
    @Published var dailyGoal: Int = 8
    @Published var completedSessionsToday: Int = 0
    
    @Published var settings: AppSettings = AppSettings()
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    var todaysFocusMinutes: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return focusSessions
            .filter { $0.startTime >= today && $0.wasSuccessful }
            .reduce(0) { $0 + Int($1.duration / 60) }
    }
    
    var weeklyFocusData: [Int] {
        var data: [Int] = []
        for i in 0..<7 {
            let date = Calendar.current.date(byAdding: .day, value: -6 + i, to: Date())!
            let dayStart = Calendar.current.startOfDay(for: date)
            let dayEnd = Calendar.current.date(byAdding: .day, value: 1, to: dayStart)!
            let minutes = focusSessions
                .filter { $0.startTime >= dayStart && $0.startTime < dayEnd && $0.wasSuccessful }
                .reduce(0) { $0 + Int($1.duration / 60) }
            data.append(minutes)
        }
        return data
    }
    
    var todayEmotionData: [Emotion: Int] {
        let today = Calendar.current.startOfDay(for: Date())
        var counts: [Emotion: Int] = [:]
        for log in emotionalLogs where log.timestamp >= today {
            counts[log.primaryEmotion, default: 0] += 1
        }
        return counts
    }
    
    init() {
        loadData()
    }
    
    func startFocusSession() {
        guard let task = currentTask else { return }
        
        let duration = TimeInterval(settings.focusDuration * 60)
        timeRemaining = duration
        
        currentSession = FocusSession(
            startTime: Date(),
            taskDescription: task.title,
            emotionalState: EmotionalState(
                primaryEmotion: currentEmotion,
                intensity: currentEmotionIntensity,
                energyLevelBefore: currentEnergyLevel
            )
        )
        
        timerState = .focusing
        startTimer()
        
        if task.status == .pending {
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                tasks[index].status = .inProgress
            }
        }
    }
    
    func startBreak() {
        timerState = .onBreak
        let duration = TimeInterval(settings.shortBreakDuration * 60)
        timeRemaining = duration
        startTimer()
    }
    
    func startLongBreak() {
        timerState = .onLongBreak
        let duration = TimeInterval(settings.longBreakDuration * 60)
        timeRemaining = duration
        startTimer()
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
        if timerState == .focusing {
            timerState = .paused
        }
    }
    
    func resumeTimer() {
        if timerState == .paused {
            timerState = .focusing
            startTimer()
        }
    }
    
    func stopSession() {
        timer?.invalidate()
        timer = nil
        
        if var session = currentSession {
            session.endTime = Date()
            session.duration = Date().timeIntervalSince(session.startTime)
            session.wasSuccessful = timerState == .completed
            focusSessions.append(session)
            
            if let task = currentTask, let index = tasks.firstIndex(where: { $0.id == task.id }) {
                tasks[index].focusSessions.append(session)
                tasks[index].actualDuration += session.duration
            }
            
            if session.wasSuccessful {
                completedSessionsToday += 1
            }
        }
        
        timerState = .idle
        currentSession = nil
        saveData()
    }
    
    func emergencyReset() {
        timer?.invalidate()
        timer = nil
        timerState = .idle
        currentSession = nil
        
        if let task = currentTask, let index = tasks.firstIndex(where: { $0.id == task.id }) {
            if tasks[index].status == .inProgress {
                tasks[index].status = .paused
            }
        }
        
        showEmotionLogger = true
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                
                if self.timerState == .focusing {
                    self.currentSession?.interruptions += 1
                }
            } else {
                self.handleTimerComplete()
            }
        }
    }
    
    private func handleTimerComplete() {
        timer?.invalidate()
        timer = nil
        
        switch timerState {
        case .focusing:
            timerState = .completed
            stopSession()
            
            if completedSessionsToday % settings.sessionsBeforeLongBreak == 0 {
                startLongBreak()
            } else {
                startBreak()
            }
            
        case .onBreak, .onLongBreak:
            timerState = .idle
            
        default:
            break
        }
    }
    
    func addTask(_ task: TaskItem) {
        tasks.append(task)
        if currentTask == nil {
            currentTask = task
        }
        saveData()
    }
    
    func updateTask(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            if currentTask?.id == task.id {
                currentTask = task
            }
        }
        saveData()
    }
    
    func deleteTask(_ task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
        if currentTask?.id == task.id {
            currentTask = tasks.first
        }
        saveData()
    }
    
    func selectTask(_ task: TaskItem) {
        if timerState == .focusing || timerState == .paused {
            return
        }
        currentTask = task
    }
    
    func logEmotion(_ state: EmotionalState) {
        emotionalLogs.append(state)
        
        currentEmotion = state.primaryEmotion
        currentEmotionIntensity = state.intensity
        
        if let index = emotionalLogs.firstIndex(where: { $0.id == state.id }) {
            emotionalLogs[index].energyLevelAfter = currentEnergyLevel
        }
        
        saveData()
    }
    
    func updateEnergyLevel(_ level: EnergyLevel) {
        currentEnergyLevel = level
    }
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: "tasks"),
           let decoded = try? JSONDecoder().decode([TaskItem].self, from: data) {
            tasks = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: "focusSessions"),
           let decoded = try? JSONDecoder().decode([FocusSession].self, from: data) {
            focusSessions = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: "emotionalLogs"),
           let decoded = try? JSONDecoder().decode([EmotionalState].self, from: data) {
            emotionalLogs = decoded
        }
        
        if let data = UserDefaults.standard.data(forKey: "settings"),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = decoded
        }
        
        currentTask = tasks.first(where: { $0.status == .inProgress }) ?? tasks.first
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(data, forKey: "tasks")
        }
        
        if let data = try? JSONEncoder().encode(focusSessions) {
            UserDefaults.standard.set(data, forKey: "focusSessions")
        }
        
        if let data = try? JSONEncoder().encode(emotionalLogs) {
            UserDefaults.standard.set(data, forKey: "emotionalLogs")
        }
        
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: "settings")
        }
    }
}

enum TimerState: String {
    case idle = "Ready"
    case focusing = "Focusing"
    case paused = "Paused"
    case onBreak = "Break"
    case onLongBreak = "Long Break"
    case completed = "Completed"
}

struct AppSettings: Codable {
    var focusDuration: Int = 25
    var shortBreakDuration: Int = 5
    var longBreakDuration: Int = 15
    var sessionsBeforeLongBreak: Int = 4
    
    var autoStartBreaks: Bool = true
    var autoStartFocus: Bool = false
    
    var soundEnabled: Bool = true
    var notificationsEnabled: Bool = true
    
    var darkMode: Bool = true
    
    var showEnergyTracker: Bool = true
    var showEmotionTracker: Bool = true
    
    var defaultTaskDuration: Int = 25
    var pomodoroVariations: [Int] = [15, 25, 30, 45, 60]
}
