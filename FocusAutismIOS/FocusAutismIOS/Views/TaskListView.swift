import SwiftUI

struct IOSTaskListView: View {
    @EnvironmentObject var appState: AppState
    @State private var showAdd = false
    @State private var selectedFilter: TaskStatus? = nil
    
    private var filteredTasks: [TaskItem] {
        if let filter = selectedFilter {
            return appState.tasks.filter { $0.status == filter }
        }
        return appState.tasks
    }
    
    private var pendingTasks: [TaskItem] {
        appState.tasks.filter { $0.status == .pending || $0.status == .inProgress }
    }
    
    private var completedTasks: [TaskItem] {
        appState.tasks.filter { $0.status == .completed }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Stats overview
                HStack(spacing: 12) {
                    statBox(value: "\(pendingTasks.count)", label: "Active", color: Theme.accent, icon: "flame")
                    statBox(value: "\(completedTasks.count)", label: "Done", color: Theme.success, icon: "checkmark.circle")
                    statBox(value: "\(appState.tasks.count)", label: "Total", color: Theme.warning, icon: "list.bullet")
                }
                .padding(.horizontal, 4)
                
                // Quick add button
                Button(action: { showAdd = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Add New Task")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                            Text("Break your goals into small steps")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Theme.textMuted)
                    }
                    .padding(16)
                    .background(
                        LinearGradient(
                            colors: [Theme.accent.opacity(0.2), Theme.accent.opacity(0.05)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(Theme.textPrimary)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.accent.opacity(0.3), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 4)
                
                // Current focus
                if let task = appState.currentTask {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(Theme.accent)
                            Text("Currently Focusing")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                        }
                        
                        focusTaskCard(task)
                    }
                    .padding(.horizontal, 4)
                }
                
                // Filter tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        filterChip("All", nil)
                        filterChip("To Do", .pending)
                        filterChip("In Progress", .inProgress)
                        filterChip("Completed", .completed)
                    }
                    .padding(.horizontal, 4)
                }
                
                // Tasks list
                if filteredTasks.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.seal")
                            .font(.system(size: 48))
                            .foregroundColor(Theme.success.opacity(0.5))
                        
                        Text(selectedFilter == nil ? "No tasks yet" : "No \(selectedFilter!.rawValue.lowercased()) tasks")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        
                        Text("Tap + to add your first task")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(Theme.textMuted)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(40)
                    .background(Theme.card)
                    .cornerRadius(16)
                    .padding(.horizontal, 4)
                } else {
                    VStack(spacing: 10) {
                        ForEach(filteredTasks) { task in
                            taskCard(task)
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Theme.bg)
        .sheet(isPresented: $showAdd) {
            IOSTaskEditorSheet(task: nil).environmentObject(appState)
        }
    }
    
    private func statBox(value: String, label: String, color: Color, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(Theme.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Theme.card)
        .cornerRadius(14)
    }
    
    private func filterChip(_ title: String, _ status: TaskStatus?) -> some View {
        Button(action: { selectedFilter = status }) {
            Text(title)
                .font(.system(size: 13, weight: selectedFilter == status ? .semibold : .medium, design: .rounded))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(selectedFilter == status ? Theme.accent : Theme.card)
                .foregroundColor(selectedFilter == status ? .white : Theme.textSecondary)
                .cornerRadius(20)
        }
        .buttonStyle(.plain)
    }
    
    private func focusTaskCard(_ task: TaskItem) -> some View {
        Button(action: {}) {
            HStack(spacing: 14) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Theme.accent)
                    .frame(width: 4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Label("\(Int(task.estimatedDuration/60))m", systemImage: "clock")
                        Label(task.priority.rawValue, systemImage: "flag")
                    }
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(Theme.textMuted)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Theme.accent.opacity(0.2))
                        .frame(width: 32, height: 32)
                    Image(systemName: "play.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.accent)
                }
            }
            .padding(14)
            .background(Theme.accent.opacity(0.1))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.accent.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    private func taskCard(_ task: TaskItem) -> some View {
        Button(action: { appState.selectTask(task) }) {
            HStack(spacing: 14) {
                // Checkbox
                Button(action: {
                    var updatedTask = task
                    if task.status == .completed {
                        updatedTask.status = .pending
                    } else {
                        updatedTask.status = .completed
                    }
                    appState.updateTask(updatedTask)
                }) {
                    Image(systemName: task.status == .completed ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 22))
                        .foregroundColor(task.status == .completed ? Theme.success : Theme.textMuted)
                }
                .buttonStyle(.plain)
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(task.status == .completed ? Theme.textMuted : Theme.textPrimary)
                        .strikethrough(task.status == .completed)
                        .lineLimit(2)
                    
                    HStack(spacing: 10) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 10))
                            Text("\(Int(task.estimatedDuration/60))m")
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "flag")
                                .font(.system(size: 10))
                            Text(task.priority.rawValue)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: task.category.icon)
                                .font(.system(size: 10))
                            Text(task.category.rawValue)
                        }
                    }
                    .font(.system(size: 10, design: .rounded))
                    .foregroundColor(Theme.textMuted)
                }
                
                Spacer()
                
                // Status badge
                statusBadge(task.status)
            }
            .padding(14)
            .background(appState.currentTask?.id == task.id ? Theme.cardHover : Theme.card)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(appState.currentTask?.id == task.id ? Theme.accent.opacity(0.5) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button(action: { appState.selectTask(task) }) {
                Label("Select for Focus", systemImage: "flame")
            }
            Button(action: { 
                var updatedTask = task
                if task.status == .completed {
                    updatedTask.status = .pending
                } else {
                    updatedTask.status = .completed
                }
                appState.updateTask(updatedTask)
            }) {
                Label(task.status == .completed ? "Mark Incomplete" : "Mark Complete", systemImage: "checkmark")
            }
            Button(role: .destructive, action: { appState.deleteTask(task) }) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private func statusBadge(_ status: TaskStatus) -> some View {
        Text(status.rawValue)
            .font(.system(size: 10, weight: .semibold, design: .rounded))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor(status).opacity(0.15))
            .foregroundColor(badgeColor(status))
            .cornerRadius(8)
    }
    
    private func badgeColor(_ status: TaskStatus) -> Color {
        switch status {
        case .completed: return Theme.success
        case .inProgress: return Theme.accent
        case .pending: return Theme.textMuted
        case .blocked: return Theme.danger
        case .paused: return Theme.warning
        }
    }
}
