import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddTask = false
    @State private var filterStatus: TaskStatus? = nil
    @State private var filterCategory: TaskCategory? = nil

    var filteredTasks: [TaskItem] {
        appState.tasks.filter { task in
            (filterStatus == nil || task.status == filterStatus) &&
            (filterCategory == nil || task.category == filterCategory)
        }.sorted { t1, t2 in
            if t1.priority != t2.priority {
                return t1.priority.rawValue < t2.priority.rawValue
            }
            return t1.createdAt > t2.createdAt
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 14) {
                Text("Tasks")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                Spacer()

                Picker("Status", selection: $filterStatus) {
                    Text("All Status").tag(nil as TaskStatus?)
                    ForEach(TaskStatus.allCases, id: \.self) { s in
                        Text(s.rawValue).tag(s as TaskStatus?)
                    }
                }
                .frame(width: 130)

                Picker("Category", selection: $filterCategory) {
                    Text("All Categories").tag(nil as TaskCategory?)
                    ForEach(TaskCategory.allCases, id: \.self) { c in
                        Text(c.rawValue).tag(c as TaskCategory?)
                    }
                }
                .frame(width: 140)

                Button(action: { showingAddTask = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                        Text("Add Task")
                    }
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Theme.accent)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 20)

            Divider().background(Theme.textMuted.opacity(0.2))

            // Task list
            ScrollView {
                LazyVStack(spacing: 10) {
                    if filteredTasks.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "tray")
                                .font(.system(size: 32))
                                .foregroundColor(Theme.textMuted)
                            Text("No tasks yet")
                                .font(.system(size: 15, design: .rounded))
                                .foregroundColor(Theme.textSecondary)
                            Text("Tap \"Add Task\" to break your goals into manageable steps")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(Theme.textMuted)
                        }
                        .padding(.top, 60)
                    } else {
                        ForEach(filteredTasks) { task in
                            taskRow(task)
                        }
                    }
                }
                .padding(24)
            }
        }
        .sheet(isPresented: $showingAddTask) {
            TaskEditorSheet(task: nil)
                .environmentObject(appState)
        }
    }

    private func taskRow(_ task: TaskItem) -> some View {
        let selected = appState.currentTask?.id == task.id
        return HStack(spacing: 0) {
            // Priority bar
            RoundedRectangle(cornerRadius: 2)
                .fill(priorityColor(task.priority))
                .frame(width: 4)
                .padding(.vertical, 8)

            HStack(spacing: 14) {
                // Main info
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 8) {
                        Image(systemName: task.category.icon)
                            .font(.system(size: 11))
                            .foregroundColor(Theme.textMuted)
                        Text(task.title)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                            .strikethrough(task.status == .completed, color: Theme.textMuted)
                    }

                    if !task.detailedDescription.isEmpty {
                        Text(task.detailedDescription)
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                            .lineLimit(1)
                    }

                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                            Text("\(Int(task.estimatedDuration / 60))m")
                        }
                        if !task.subtasks.isEmpty {
                            HStack(spacing: 4) {
                                Image(systemName: "checklist")
                                Text("\(task.subtasks.filter { $0.isCompleted }.count)/\(task.subtasks.count)")
                            }
                        }
                    }
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(Theme.textMuted)
                }

                Spacer()

                // Status badge
                Text(task.status.rawValue)
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor(task.status).opacity(0.15))
                    .foregroundColor(statusColor(task.status))
                    .cornerRadius(4)

                // Context menu
                Menu {
                    Button("Select for Focus") { appState.selectTask(task) }
                    Button("Edit") { appState.showTaskEditor = true }
                    Divider()
                    Button("Delete", role: .destructive) { appState.deleteTask(task) }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 12))
                        .foregroundColor(Theme.textMuted)
                        .frame(width: 28, height: 28)
                }
                .menuStyle(.borderlessButton)
                .frame(width: 28)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
        .background(selected ? Theme.cardHover : Theme.card)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(selected ? Theme.accent.opacity(0.4) : Color.clear, lineWidth: 1.5)
        )
        .contentShape(Rectangle())
        .onTapGesture { appState.selectTask(task) }
    }

    private func priorityColor(_ p: TaskPriority) -> Color {
        switch p {
        case .urgent: return Theme.priorityUrgent
        case .high:   return Theme.priorityHigh
        case .medium: return Theme.priorityMedium
        case .low:    return Theme.priorityLow
        }
    }

    private func statusColor(_ s: TaskStatus) -> Color {
        switch s {
        case .completed:  return Theme.success
        case .inProgress: return Theme.accent
        case .pending:    return Theme.textMuted
        case .blocked:    return Theme.danger
        case .paused:     return Theme.warning
        }
    }
}
