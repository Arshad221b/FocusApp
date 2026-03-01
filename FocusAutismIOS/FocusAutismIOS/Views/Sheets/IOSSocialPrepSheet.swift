import SwiftUI

struct IOSSocialPrepSheet: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    @State private var situationType: SocialSituationType = .gathering
    @State private var whoWillBeThere: String = ""
    @State private var newChallenge: String = ""
    @State private var challenges: [String] = []
    @State private var newStrategy: String = ""
    @State private var strategies: [String] = []
    @State private var exitPlan: String = ""
    @State private var energyBudget: Int = 5
    @State private var recoveryPlan: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "person.2.circle")
                            .font(.system(size: 40))
                            .foregroundColor(Color(hex: "7090D0"))
                        Text("Prepare for a social situation")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(Theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Situation type
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What kind of situation?")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Theme.textPrimary)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 6) {
                            ForEach(SocialSituationType.allCases, id: \.self) { type in
                                Button(action: { situationType = type }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: type.icon)
                                            .font(.system(size: 11))
                                        Text(type.rawValue)
                                            .font(.system(size: 11, design: .rounded))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(situationType == type ? Color(hex: "7090D0").opacity(0.2) : Theme.bgSecondary)
                                    .foregroundColor(situationType == type ? Color(hex: "7090D0") : Theme.textMuted)
                                    .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    // Who will be there
                    inputSection("Who will be there?", text: $whoWillBeThere, placeholder: "e.g., 3 coworkers, my friend Alex")
                    
                    // Energy budget
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Energy budget: \(energyBudget)/10")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Theme.textPrimary)
                            Spacer()
                        }
                        Text("How much energy can you afford to spend?")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundColor(Theme.textMuted)
                        Slider(value: Binding(get: { Double(energyBudget) }, set: { energyBudget = Int($0) }), in: 1...10, step: 1)
                            .tint(Color(hex: "7090D0"))
                    }
                    
                    // Possible challenges
                    listSection("Possible challenges", items: $challenges, newItem: $newChallenge, placeholder: "e.g., Loud music, small talk")
                    
                    // Coping strategies
                    listSection("My coping strategies", items: $strategies, newItem: $newStrategy, placeholder: "e.g., Take breaks every 30 min")
                    
                    // Exit plan
                    inputSection("Exit plan", text: $exitPlan, placeholder: "e.g., I'll say I have an early morning")
                    
                    // Recovery plan
                    inputSection("Recovery plan (after)", text: $recoveryPlan, placeholder: "e.g., Quiet time at home, favorite show")
                }
                .padding(20)
            }
            .background(Theme.bg)
            .navigationTitle("Social Preparation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let prep = SocialSituationPrep(
                            situationType: situationType,
                            whoWillBeThere: whoWillBeThere,
                            possibleChallenges: challenges,
                            copingStrategies: strategies,
                            exitPlan: exitPlan,
                            energyBudget: energyBudget,
                            recoveryPlan: recoveryPlan
                        )
                        appState.saveSocialPrep(prep)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func inputSection(_ title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
            TextField(placeholder, text: text)
                .textFieldStyle(.plain)
                .font(.system(size: 13, design: .rounded))
                .padding(10)
                .background(Theme.bgSecondary)
                .cornerRadius(8)
                .foregroundColor(Theme.textPrimary)
        }
    }
    
    private func listSection(_ title: String, items: Binding<[String]>, newItem: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(Theme.textPrimary)
            
            HStack {
                TextField(placeholder, text: newItem)
                    .textFieldStyle(.plain)
                    .font(.system(size: 13, design: .rounded))
                    .padding(10)
                    .background(Theme.bgSecondary)
                    .cornerRadius(8)
                    .foregroundColor(Theme.textPrimary)
                Button(action: {
                    if !newItem.wrappedValue.isEmpty {
                        items.wrappedValue.append(newItem.wrappedValue)
                        newItem.wrappedValue = ""
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color(hex: "7090D0"))
                }
                .buttonStyle(.plain)
            }
            
            ForEach(items.wrappedValue.indices, id: \.self) { i in
                HStack {
                    Text(items.wrappedValue[i])
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(Theme.textPrimary)
                    Spacer()
                    Button(action: { items.wrappedValue.remove(at: i) }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 9))
                            .foregroundColor(Theme.textMuted)
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
