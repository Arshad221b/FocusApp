import SwiftUI

struct TaskEditorSheet: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    let existingTask: TaskItem?

    @State private var title = ""
    @State private var desc = ""
    @State private var duration: Int = 25
    @State private var priority: TaskPriority = .medium
    @State private var category: TaskCategory = .general
    @State private var energyLevel: EnergyLevel = .medium
    @State private var difficulty: Int = 5
    @State private var subtasks: [Subtask] = []
    @State private var newSubtask = ""

    init(task: TaskItem?) {
        self.existingTask = task
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(existingTask == nil ? "Add Task" : "Edit Task")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.textMuted)
                        .font(.system(size: 20))
                }
                .buttonStyle(.plain)
            }
            .padding(20)
            .background(Theme.sidebar)

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    field("Title") {
                        TextField("What do you need to do?", text: $title)
                            .textFieldStyle(.plain)
                            .font(.system(size: 13, design: .rounded))
                            .padding(10)
                            .background(Theme.card)
                            .cornerRadius(8)
                            .foregroundColor(Theme.textPrimary)
                    }

                    field("Description") {
                        TextEditor(text: $desc)
                            .frame(height: 60)
                            .padding(8)
                            .background(Theme.card)
                            .cornerRadius(8)
                            .foregroundColor(Theme.textPrimary)
                            .scrollContentBackground(.hidden)
                            .font(.system(size: 12, design: .rounded))
                    }

                    HStack(spacing: 16) {
                        field("Duration") {
                            Stepper("\(duration) min", value: $duration, in: 5...180, step: 5)
                                .font(.system(size: 12, design: .rounded))
                                .padding(10)
                                .background(Theme.card)
                                .cornerRadius(8)
                                .foregroundColor(Theme.textPrimary)
                        }
                        field("Difficulty") {
                            HStack {
                                Slider(value: Binding(get: { Double(difficulty) }, set: { difficulty = Int($0) }),
                                       in: 1...10, step: 1)
                                    .tint(Theme.accent)
                                Text("\(difficulty)")
                                    .font(.system(size: 12, design: .monospaced))
                                    .foregroundColor(Theme.textPrimary)
                                    .frame(width: 20)
                            }
                            .padding(10)
                            .background(Theme.card)
                            .cornerRadius(8)
                        }
                    }

                    HStack(spacing: 16) {
                        field("Priority") {
                            Picker("Priority", selection: $priority) {
                                ForEach(TaskPriority.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                            }
                            .pickerStyle(.menu)
                            .padding(10)
                            .background(Theme.card)
                            .cornerRadius(8)
                            .foregroundColor(Theme.textPrimary)
                        }
                        field("Category") {
                            Picker("Category", selection: $category) {
                                ForEach(TaskCategory.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                            }
                            .pickerStyle(.menu)
                            .padding(10)
                            .background(Theme.card)
                            .cornerRadius(8)
                            .foregroundColor(Theme.textPrimary)
                        }
                        field("Energy") {
                            Picker("Energy", selection: $energyLevel) {
                                ForEach(EnergyLevel.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                            }
                            .pickerStyle(.menu)
                            .padding(10)
                            .background(Theme.card)
                            .cornerRadius(8)
                            .foregroundColor(Theme.textPrimary)
                        }
                    }

                    field("Subtasks") {
                        VStack(spacing: 8) {
                            HStack {
                                TextField("Add subtask...", text: $newSubtask)
                                    .textFieldStyle(.plain)
                                    .font(.system(size: 12, design: .rounded))
                                    .padding(10)
                                    .background(Theme.card)
                                    .cornerRadius(8)
                                    .foregroundColor(Theme.textPrimary)
                                Button(action: {
                                    if !newSubtask.isEmpty { subtasks.append(Subtask(title: newSubtask)); newSubtask = "" }
                                }) {
                                    Image(systemName: "plus.circle.fill").foregroundColor(Theme.accent)
                                }
                                .buttonStyle(.plain)
                            }

                            ForEach(subtasks.indices, id: \.self) { i in
                                HStack {
                                    Button(action: { subtasks[i].isCompleted.toggle() }) {
                                        Image(systemName: subtasks[i].isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(subtasks[i].isCompleted ? Theme.success : Theme.textMuted)
                                    }
                                    .buttonStyle(.plain)

                                    Text(subtasks[i].title)
                                        .font(.system(size: 12, design: .rounded))
                                        .foregroundColor(Theme.textPrimary)
                                        .strikethrough(subtasks[i].isCompleted)

                                    Spacer()

                                    Button(action: { subtasks.remove(at: i) }) {
                                        Image(systemName: "xmark").font(.system(size: 10)).foregroundColor(Theme.textMuted)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(8)
                                .background(Theme.bgSecondary)
                                .cornerRadius(6)
                            }
                        }
                    }
                }
                .padding(24)
            }

            // Footer
            HStack {
                Spacer()
                Button(action: saveTask) {
                    Text("Save Task")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 24).padding(.vertical, 10)
                        .background(Theme.accent)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .disabled(title.isEmpty)
                .opacity(title.isEmpty ? 0.4 : 1)
            }
            .padding(20)
            .background(Theme.sidebar)
        }
        .frame(width: 520, height: 600)
        .background(Theme.bg)
        .onAppear {
            if let t = existingTask {
                title = t.title; desc = t.detailedDescription
                duration = Int(t.estimatedDuration / 60)
                priority = t.priority; category = t.category
                energyLevel = t.energyLevel; difficulty = t.difficulty
                subtasks = t.subtasks
            }
        }
    }

    private func field<V: View>(_ label: String, @ViewBuilder content: () -> V) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textSecondary)
            content()
        }
    }

    private func saveTask() {
        let task = TaskItem(
            id: existingTask?.id ?? UUID(),
            title: title,
            detailedDescription: desc,
            estimatedDuration: TimeInterval(duration * 60),
            priority: priority,
            status: existingTask?.status ?? .pending,
            createdAt: existingTask?.createdAt ?? Date(),
            energyLevel: energyLevel,
            difficulty: difficulty,
            subtasks: subtasks,
            category: category
        )
        if existingTask != nil { appState.updateTask(task) }
        else { appState.addTask(task) }
        dismiss()
    }
}
