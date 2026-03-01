import SwiftUI

struct IOSTransitionPlanSheet: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    @State private var fromActivity: String = ""
    @State private var toActivity: String = ""
    @State private var newStep: String = ""
    @State private var transitionSteps: [String] = []
    @State private var timeNeeded: Int = 10
    @State private var newSensoryPrep: String = ""
    @State private var sensoryPrep: [String] = []
    @State private var showSuggestions = false
    
    // Common transition templates based on OT frameworks
    private let commonTransitions: [(from: String, to: String)] = [
        ("Focused work", "Break"),
        ("Screen time", "Physical activity"),
        ("Home", "Going out"),
        ("Social activity", "Alone time"),
        ("Sleep", "Morning routine"),
        ("One task", "Different task")
    ]
    
    private let suggestedSteps: [String] = [
        "Set a 5-minute warning timer",
        "Save current progress / find a stopping point",
        "Take 3 deep breaths",
        "Stand up and stretch",
        "Get materials ready for next activity",
        "Do a quick body check (tension, energy)",
        "Use the bathroom / get water",
        "Put away items from current activity",
        "Review what the next activity involves",
        "Set an intention for the next activity"
    ]
    
    private let suggestedSensoryPrep: [String] = [
        "Adjust lighting for next environment",
        "Put on noise-cancelling headphones",
        "Change into comfortable clothes",
        "Use a fidget tool during transition",
        "Apply pressure (weighted blanket, tight hug)",
        "Smell something calming (lavender, mint)",
        "Splash cold water on face / wrists",
        "Listen to a transition song",
        "Do 10 wall push-ups for proprioceptive input"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "arrow.triangle.swap")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        Text("Plan your transition between activities")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.white)
                        Text("Transitions can be hard — a plan makes them easier")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Quick templates
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Common transitions")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 6) {
                            ForEach(commonTransitions.indices, id: \.self) { i in
                                let t = commonTransitions[i]
                                Button(action: {
                                    fromActivity = t.from
                                    toActivity = t.to
                                }) {
                                    HStack(spacing: 4) {
                                        Text(t.from)
                                            .font(.system(size: 10, design: .rounded))
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 8))
                                        Text(t.to)
                                            .font(.system(size: 10, design: .rounded))
                                    }
                                    .lineLimit(1)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 4)
                                    .background(
                                        (fromActivity == t.from && toActivity == t.to)
                                        ? Color.orange.opacity(0.2)
                                        : Color.gray.opacity(0.2)
                                    )
                                    .foregroundColor(
                                        (fromActivity == t.from && toActivity == t.to)
                                        ? Color.orange
                                        : Color.gray
                                    )
                                    .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    // From / To activities
                    inputSection("Transitioning from", text: $fromActivity, placeholder: "e.g., Working on report")
                    inputSection("Transitioning to", text: $toActivity, placeholder: "e.g., Lunch break")
                    
                    // Time needed
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Time needed: \(timeNeeded) min")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        Text("How long do you usually need to switch?")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 8) {
                            ForEach([5, 10, 15, 20, 30], id: \.self) { minutes in
                                Button(action: { timeNeeded = minutes }) {
                                    Text("\(minutes)")
                                        .font(.system(size: 13, weight: .medium, design: .rounded))
                                        .frame(width: 44, height: 36)
                                        .background(timeNeeded == minutes ? Color.orange.opacity(0.2) : Color.gray.opacity(0.2))
                                        .foregroundColor(timeNeeded == minutes ? Color.orange : Color.gray)
                                        .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    // Transition steps
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Transition steps")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            Spacer()
                            Button(action: { showSuggestions.toggle() }) {
                                Text(showSuggestions ? "Hide ideas" : "Show ideas")
                                    .font(.system(size: 11, design: .rounded))
                                    .foregroundColor(.orange)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        Text("Break the transition into small, concrete steps")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundColor(.gray)
                        
                        if showSuggestions {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(suggestedSteps, id: \.self) { step in
                                    if !transitionSteps.contains(step) {
                                        Button(action: {
                                            transitionSteps.append(step)
                                        }) {
                                            HStack(spacing: 6) {
                                                Image(systemName: "plus.circle")
                                                    .font(.system(size: 10))
                                                Text(step)
                                                    .font(.system(size: 11, design: .rounded))
                                            }
                                            .foregroundColor(.orange)
                                            .padding(.vertical, 4)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                        
                        // Add custom step
                        HStack {
                            TextField("Add a step...", text: $newStep)
                                .textFieldStyle(.plain)
                                .font(.system(size: 13, design: .rounded))
                                .padding(10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                            Button(action: {
                                if !newStep.isEmpty {
                                    transitionSteps.append(newStep)
                                    newStep = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.orange)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        // Current steps (numbered for clarity)
                        ForEach(transitionSteps.indices, id: \.self) { i in
                            HStack(spacing: 8) {
                                Text("\(i + 1).")
                                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                    .foregroundColor(.orange)
                                    .frame(width: 20, alignment: .trailing)
                                Text(transitionSteps[i])
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(.white)
                                Spacer()
                                // Move up
                                if i > 0 {
                                    Button(action: {
                                        transitionSteps.swapAt(i, i - 1)
                                    }) {
                                        Image(systemName: "chevron.up")
                                            .font(.system(size: 9))
                                            .foregroundColor(.gray)
                                    }
                                    .buttonStyle(.plain)
                                }
                                // Remove
                                Button(action: { transitionSteps.remove(at: i) }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 9))
                                        .foregroundColor(.gray)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(6)
                        }
                    }
                    
                    // Sensory preparation
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Sensory preparation")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        Text("What sensory adjustments help you switch?")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundColor(.gray)
                        
                        // Tap-to-add sensory suggestions
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(suggestedSensoryPrep, id: \.self) { prep in
                                    if !sensoryPrep.contains(prep) {
                                        Button(action: { sensoryPrep.append(prep) }) {
                                            Text(prep)
                                                .font(.system(size: 10, design: .rounded))
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 5)
                                                .background(Color.gray.opacity(0.2))
                                                .foregroundColor(.gray)
                                                .cornerRadius(12)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        
                        // Custom sensory prep
                        HStack {
                            TextField("Add sensory prep...", text: $newSensoryPrep)
                                .textFieldStyle(.plain)
                                .font(.system(size: 13, design: .rounded))
                                .padding(10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                            Button(action: {
                                if !newSensoryPrep.isEmpty {
                                    sensoryPrep.append(newSensoryPrep)
                                    newSensoryPrep = ""
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.orange)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        ForEach(sensoryPrep.indices, id: \.self) { i in
                            HStack {
                                Image(systemName: "hand.raised")
                                    .font(.system(size: 10))
                                    .foregroundColor(.orange)
                                Text(sensoryPrep[i])
                                    .font(.system(size: 12, design: .rounded))
                                    .foregroundColor(.white)
                                Spacer()
                                Button(action: { sensoryPrep.remove(at: i) }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 9))
                                        .foregroundColor(.gray)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(6)
                        }
                    }
                    
                    // Preview card
                    if !fromActivity.isEmpty || !toActivity.isEmpty || !transitionSteps.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Your transition plan")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                if !fromActivity.isEmpty && !toActivity.isEmpty {
                                    HStack(spacing: 8) {
                                        Text(fromActivity)
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                            .foregroundColor(.gray)
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 10))
                                            .foregroundColor(.orange)
                                        Text(toActivity)
                                            .font(.system(size: 12, weight: .medium, design: .rounded))
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                if timeNeeded > 0 {
                                    HStack(spacing: 4) {
                                        Image(systemName: "clock")
                                            .font(.system(size: 10))
                                        Text("Allow \(timeNeeded) minutes")
                                            .font(.system(size: 11, design: .rounded))
                                    }
                                    .foregroundColor(.gray)
                                }
                                
                                if !transitionSteps.isEmpty {
                                    ForEach(transitionSteps.indices, id: \.self) { i in
                                        HStack(alignment: .top, spacing: 6) {
                                            Image(systemName: "circle")
                                                .font(.system(size: 8))
                                                .foregroundColor(.orange.opacity(0.6))
                                                .padding(.top, 3)
                                            Text(transitionSteps[i])
                                                .font(.system(size: 11, design: .rounded))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                            .padding(12)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(20)
            }
            .background(Color.black)
            .navigationTitle("Transition Planner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let plan = TransitionPlan(
                            fromActivity: fromActivity,
                            toActivity: toActivity,
                            transitionSteps: transitionSteps,
                            timeNeeded: timeNeeded,
                            sensoryPrep: sensoryPrep
                        )
                        appState.saveTransitionPlan(plan)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(fromActivity.isEmpty && toActivity.isEmpty)
                }
            }
        }
    }
    
    private func inputSection(_ title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            TextField(placeholder, text: text)
                .textFieldStyle(.plain)
                .font(.system(size: 13, design: .rounded))
                .padding(10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.white)
        }
    }
}
