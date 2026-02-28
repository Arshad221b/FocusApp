import Foundation
import SwiftUI

struct EmotionalState: Identifiable, Codable, Hashable {
    let id: UUID
    var timestamp: Date
    var primaryEmotion: Emotion
    var secondaryEmotions: [Emotion]
    var intensity: Int
    var triggers: [String]
    var notes: String
    var regulationStrategyUsed: [RegulationStrategy]
    var effectivenessRating: Int?
    var physicalSymptoms: [PhysicalSymptom]
    var energyLevelBefore: EnergyLevel
    var energyLevelAfter: EnergyLevel?
    
    init(id: UUID = UUID(), timestamp: Date = Date(), primaryEmotion: Emotion, secondaryEmotions: [Emotion] = [], intensity: Int = 5, triggers: [String] = [], notes: String = "", regulationStrategyUsed: [RegulationStrategy] = [], effectivenessRating: Int? = nil, physicalSymptoms: [PhysicalSymptom] = [], energyLevelBefore: EnergyLevel = .medium, energyLevelAfter: EnergyLevel? = nil) {
        self.id = id
        self.timestamp = timestamp
        self.primaryEmotion = primaryEmotion
        self.secondaryEmotions = secondaryEmotions
        self.intensity = intensity
        self.triggers = triggers
        self.notes = notes
        self.regulationStrategyUsed = regulationStrategyUsed
        self.effectivenessRating = effectivenessRating
        self.physicalSymptoms = physicalSymptoms
        self.energyLevelBefore = energyLevelBefore
        self.energyLevelAfter = energyLevelAfter
    }
}

enum Emotion: String, Codable, CaseIterable, Hashable {
    case joy = "Joy"
    case excitement = "Excitement"
    case contentment = "Contentment"
    case hope = "Hope"
    case gratitude = "Gratitude"
    case pride = "Pride"
    case calm = "Calm"
    case interest = "Interest"
    case surprise = "Surprise"
    case sadness = "Sadness"
    case fear = "Fear"
    case anxiety = "Anxiety"
    case anger = "Anger"
    case frustration = "Frustration"
    case overwhelm = "Overwhelm"
    case shame = "Shame"
    case guilt = "Guilt"
    case loneliness = "Loneliness"
    case confusion = "Confusion"
    case numbness = "Numbness"
    case dissociation = "Dissociation"
    case hyperfocus = "Hyperfocus"
    case meltdown = "Meltdown"
    case shutdown = "Shutdown"
    
    var category: EmotionCategory {
        switch self {
        case .joy, .excitement, .contentment, .hope, .gratitude, .pride, .calm, .interest:
            return .positive
        case .surprise:
            return .neutral
        case .sadness, .fear, .anxiety, .anger, .frustration, .overwhelm, .shame, .guilt, .loneliness:
            return .negative
        case .confusion, .numbness, .dissociation:
            return .neutral
        case .hyperfocus, .meltdown, .shutdown:
            return .autismSpecific
        }
    }
    
    var color: Color {
        switch category {
        case .positive:
            return .green
        case .negative:
            return .red
        case .neutral:
            return .gray
        case .autismSpecific:
            return .purple
        }
    }
    
    var icon: String {
        switch self {
        case .joy: return "face.smiling"
        case .excitement: return "star.fill"
        case .contentment: return "leaf"
        case .hope: return "sun.max"
        case .gratitude: return "heart.fill"
        case .pride: return "crown.fill"
        case .calm: return "water"
        case .interest: return "eye"
        case .surprise: return "burst"
        case .sadness: return "cloud.rain"
        case .fear: return "bolt.fill"
        case .anxiety: return "waveform"
        case .anger: return "flame.fill"
        case .frustration: return "xmark.circle"
        case .overwhelm: return "square.stack.3d.up"
        case .shame: return "eye.slash"
        case .guilt: return "exclamationmark.triangle"
        case .loneliness: return "person.fill.xmark"
        case .confusion: return "questionmark.circle"
        case .numbness: return "circle.dashed"
        case .dissociation: return "square.dashed"
        case .hyperfocus: return "scope"
        case .meltdown: return "hurricane"
        case .shutdown: return "moon.zzz"
        }
    }
}

enum EmotionCategory: String, Codable {
    case positive = "Positive"
    case negative = "Negative"
    case neutral = "Neutral"
    case autismSpecific = "Autism-Specific"
}

enum RegulationStrategy: String, Codable, CaseIterable {
    case deepBreathing = "Deep Breathing"
    case boxBreathing = "Box Breathing"
    case physiologicalSigh = "Physiological Sigh"
    case grounding54321 = "5-4-3-2-1 Grounding"
    case progressiveMuscleRelaxation = "Progressive Muscle Relaxation"
    case sensoryModulation = "Sensory Modulation"
    case timeOut = "Take a Break"
    case movement = "Physical Movement"
    case socialSupport = "Seek Support"
    case journalWriting = "Journal Writing"
    case cognitiveReframing = "Cognitive Reframing"
    case scheduledWorry = "Scheduled Worry Time"
    case bodyScan = "Body Scan"
    case visualBreathing = "Visual Breathing"
    case coldWater = "Cold Water / Cold Object"
    case weightedBlanket = "Weighted Pressure"
    case noiseCancelling = "Noise Cancellation"
    case darkRoom = "Dark Room"
    case favObject = "Fidget / Comfort Object"
    case taskSwitching = "Task Switching"
    
    var description: String {
        switch self {
        case .deepBreathing: return "Slow, deep breaths to activate parasympathetic nervous system"
        case .boxBreathing: return "4-4-4-4 breathing pattern used by Navy SEALs for stress regulation"
        case .physiologicalSigh: return "Double inhale followed by extended exhale - scientifically proven to quickly reduce stress"
        case .grounding54321: return "Name 5 things you see, 4 you hear, 3 you feel, 2 you smell, 1 you taste"
        case .progressiveMuscleRelaxation: return "Tense and release muscle groups to release physical tension"
        case .sensoryModulation: return "Adjust sensory environment - lighting, sound, textures"
        case .timeOut: return "Take a planned break in a safe space"
        case .movement: return "Gentle movement to release built-up energy and regulate nervous system"
        case .socialSupport: return "Reach out to a trusted person for support"
        case .journalWriting: return "Write down thoughts and feelings to process emotions"
        case .cognitiveReframing: return "Challenge and reframe negative thought patterns"
        case .scheduledWorry: return "Designate a specific time to worry, reducing anxiety outside that time"
        case .bodyScan: return "Systematically notice sensations in your body"
        case .visualBreathing: return "Follow a visual breathing guide to regulate breath"
        case .coldWater: return "Cold water on face/hands activates dive reflex to reduce heart rate"
        case .weightedBlanket: return "Apply deep pressure to calm nervous system"
        case .noiseCancelling: return "Reduce auditory input to prevent overstimulation"
        case .darkRoom: return "Reduce visual input to prevent overstimulation"
        case .favObject: return "Use a familiar object for comfort and grounding"
        case .taskSwitching: return "Temporarily switch to a different task"
        }
    }
    
    var estimatedTime: TimeInterval {
        switch self {
        case .deepBreathing, .boxBreathing, .visualBreathing:
            return 60
        case .physiologicalSigh:
            return 30
        case .grounding54321, .bodyScan:
            return 120
        case .progressiveMuscleRelaxation:
            return 300
        case .sensoryModulation, .timeOut, .movement, .noiseCancelling, .darkRoom:
            return 300
        case .socialSupport, .journalWriting, .cognitiveReframing, .scheduledWorry:
            return 600
        case .coldWater, .weightedBlanket, .favObject:
            return 120
        case .taskSwitching:
            return 180
        }
    }
}

enum PhysicalSymptom: String, Codable, CaseIterable {
    case headache = "Headache"
    case muscleTension = "Muscle Tension"
    case racingHeart = "Racing Heart"
    case shallowBreath = "Shallow Breath"
    case stomachIssues = "Stomach Issues"
    case fatigue = "Fatigue"
    case tremor = "Tremor"
    case sweating = "Sweating"
    case numbness = "Numbness"
    case dissociation = "Dissociation"
    case sensitivityToLight = "Sensitivity to Light"
    case sensitivityToSound = "Sensitivity to Sound"
    case sensoryOverload = "Sensory Overload"
}
