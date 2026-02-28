import Foundation
import SwiftUI
import Collections

struct FocusSession: Identifiable, Codable {
    let id: UUID
    var startTime: Date
    var endTime: Date?
    var duration: TimeInterval
    var taskDescription: String
    var wasSuccessful: Bool
    var interruptions: Int
    var emotionalState: EmotionalState?
    
    init(id: UUID = UUID(), startTime: Date = Date(), endTime: Date? = nil, duration: TimeInterval = 0, taskDescription: String = "", wasSuccessful: Bool = false, interruptions: Int = 0, emotionalState: EmotionalState? = nil) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.taskDescription = taskDescription
        self.wasSuccessful = wasSuccessful
        self.interruptions = interruptions
        self.emotionalState = emotionalState
    }
}

struct TaskItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var detailedDescription: String
    var estimatedDuration: TimeInterval
    var actualDuration: TimeInterval
    var priority: TaskPriority
    var status: TaskStatus
    var createdAt: Date
    var completedAt: Date?
    var energyLevel: EnergyLevel
    var difficulty: Int
    var subtasks: [Subtask]
    var category: TaskCategory
    var focusSessions: [FocusSession]
    var blockedBy: [UUID]
    
    init(id: UUID = UUID(), title: String, detailedDescription: String = "", estimatedDuration: TimeInterval = 25 * 60, actualDuration: TimeInterval = 0, priority: TaskPriority = .medium, status: TaskStatus = .pending, createdAt: Date = Date(), completedAt: Date? = nil, energyLevel: EnergyLevel = .medium, difficulty: Int = 5, subtasks: [Subtask] = [], category: TaskCategory = .general, focusSessions: [FocusSession] = [], blockedBy: [UUID] = []) {
        self.id = id
        self.title = title
        self.detailedDescription = detailedDescription
        self.estimatedDuration = estimatedDuration
        self.actualDuration = actualDuration
        self.priority = priority
        self.status = status
        self.createdAt = createdAt
        self.completedAt = completedAt
        self.energyLevel = energyLevel
        self.difficulty = difficulty
        self.subtasks = subtasks
        self.category = category
        self.focusSessions = focusSessions
        self.blockedBy = blockedBy
    }
}

struct Subtask: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    
    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

enum TaskPriority: String, Codable, CaseIterable {
    case urgent = "Urgent"
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    
    var color: Color {
        switch self {
        case .urgent: return .red
        case .high: return .orange
        case .medium: return .yellow
        case .low: return .green
        }
    }
}

enum TaskStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case inProgress = "In Progress"
    case completed = "Completed"
    case blocked = "Blocked"
    case paused = "Paused"
}

enum EnergyLevel: String, Codable, CaseIterable {
    case veryLow = "Very Low"
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    case veryHigh = "Very High"
    
    var value: Int {
        switch self {
        case .veryLow: return 1
        case .low: return 2
        case .medium: return 3
        case .high: return 4
        case .veryHigh: return 5
        }
    }
    
    var color: Color {
        switch self {
        case .veryLow: return .gray
        case .low: return .blue
        case .medium: return .green
        case .high: return .yellow
        case .veryHigh: return .orange
        }
    }
}

enum TaskCategory: String, Codable, CaseIterable {
    case work = "Work"
    case study = "Study"
    case personal = "Personal"
    case health = "Health"
    case social = "Social"
    case general = "General"
    
    var icon: String {
        switch self {
        case .work: return "briefcase"
        case .study: return "book"
        case .personal: return "person"
        case .health: return "heart"
        case .social: return "person.2"
        case .general: return "square.grid.2x2"
        }
    }
}
