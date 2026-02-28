import SwiftUI

struct IOSTaskEditorSheet: View {
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
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    // Title
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Title")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                        TextField("What do you need to do?", text: $title)
                            .textFieldStyle(.plain)
                            .font(.system(size: 14, design: .rounded))
                            .padding(12)
                            .background(Theme.bgSecondary)
                            .cornerRadius(8)
                            .foregroundColor(Theme.textPrimary)
                    }

                    // Description
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Description (optional)")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                        TextEditor(text: $desc)
                            .frame(height: 60)
                            .padding(8)
                            .background(Theme.bgSecondary)
                            .cornerRadius(8)
                            .foregroundColor(Theme.textPrimary)
                            .scrollContentBackground(.hidden)
                            .font(.system(size: 13, design: .rounded))
                    }

                    // Duration
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Duration: \(duration) min")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                        Slider(value: Binding(get: { Double(duration) }, set: { duration = Int($0) }),
                               in: 5...120, step: 5)
                            .tint(Theme.accent)
                    }

                    // Difficulty
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Difficulty")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.textSecondary)
                            Spacer()
                            Text("\(difficulty)/10")
                                .font(.system(size: 12, design: .monospaced))
                                .foregroundColor(Theme.textMuted)
                        }
                        Slider(value: Binding(get: { Double(difficulty) }, set: { difficulty = Int($0) }),
                               in: 1...10, step: 1)
                            .tint(Theme.accent)
                    }

                    // Priority
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Priority")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                        Picker("Priority", selection: $priority) {
                            ForEach(TaskPriority.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.segmented)
                    }

                    // Category
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Category")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                        Picker("Category", selection: $category) {
                            ForEach(TaskCategory.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.menu)
                        .padding(10)
                        .background(Theme.bgSecondary)
                        .cornerRadius(8)
                    }

                    // Energy
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Energy Required")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                        Picker("Energy", selection: $energyLevel) {
                            ForEach(EnergyLevel.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.segmented)
                    }

                    // Subtasks
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Subtasks")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textSecondary)

                        HStack {
                            TextField("Add subtask...", text: $newSubtask)
                                .textFieldStyle(.plain)
                                .font(.system(size: 13, design: .rounded))
                                .padding(10)
                                .background(Theme.bgSecondary)
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
                                    .font(.system(size: 13, design: .rounded))
                                    .foregroundColor(Theme.textPrimary)
                                    .strikethrough(subtasks[i].isCompleted)

                                Spacer()

                                Button(action: { subtasks.remove(at: i) }) {
                                    Image(systemName: "xmark").font(.system(size: 11)).foregroundColor(Theme.textMuted)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(8)
                            .background(Theme.bgSecondary)
                            .cornerRadius(6)
                        }
                    }
                }
                .padding(20)
            }
            .background(Theme.bg)
            .navigationTitle(existingTask == nil ? "Add Task" : "Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveTask() }
                        .fontWeight(.semibold)
                        .disabled(title.isEmpty)
                }
            }
        }
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
