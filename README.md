# FocusAutism

**⚠️ IT IS ENTIRELY AI GENERATED**

This is an iOS and macOS application designed to help autistic individuals with focus, emotional regulation, and task management. It uses scientifically-proven psychological techniques tailored for autism needs.

## Features

### 🎯 Pomodoro Timer (Focus)
- Customizable work/break intervals (default: 25 min work, 5 min break, 15 min long break after 4 sessions)
- Visual progress ring with gradient animation
- Session tracking and daily stats
- Calm transition sounds between modes

### 📋 Task Management
- Create, edit, and delete tasks
- Filter by status: All, To Do, In Progress, Completed
- Task difficulty rating (Easy, Medium, Hard)
- Estimated time tracking
- Context menus for quick actions

### 🧘 Emotional Regulation Tools
- **Breathing Exercises**: Guided box breathing (4-4-4-4 pattern) with visual animations
- **5-4-3-2-1 Grounding**: Engage all 5 senses to ground yourself in the present
- **Body Scan**: Progressive relaxation from head to toe
- **Progressive Muscle Relaxation**: Tense and release muscle groups
- **Cognitive Reframing**: Identify and reframe negative thoughts

### 📊 Progress Tracking
- Daily/weekly/monthly focus time statistics
- Streak tracking for consistency
- Emotional patterns visualization
- Sessions completed today

### 😊 Emotion Dashboard
- Log emotions with intensity levels (1-10)
- Color-coded emotions for easy identification
- Quick-log from any screen
- Historical emotion data

## Color Scheme

Designed with warm, calming colors (no cool blue tones):
- **Amber** - Primary accent
- **Terra Cotta** - Secondary accent  
- **Cream** - Background
- **Warm gray** - Text and UI elements

## Scientific Basis

This app incorporates evidence-based techniques for autism:

1. **Pomodoro Technique** - Helps with task initiation and reducing overwhelm by breaking work into manageable chunks
2. **Sensory Grounding (5-4-3-2-1)** - Reduces anxiety and helps with emotional regulation by anchoring to present moment
3. **Breathing Exercises** - Activates parasympathetic nervous system, reduces stress
4. **Progressive Muscle Relaxation** - Reduces physical tension which is often elevated in autistic individuals
5. **Cognitive Reframing** - Helps with black-and-white thinking patterns common in autism
6. **Body Scan** - Improves interoception (awareness of body states), which can be challenging for autistic individuals

## Building the App

### iOS Version (for iPhone)
1. Open `FocusAutismIOS/FocusAutismIOS.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run (Cmd+R)

To install on a physical iPhone:
```bash
cd FocusAutismIOS
xcodebuild -project FocusAutismIOS.xcodeproj -scheme FocusAutismIOS -configuration Debug -destination 'platform=iOS,id=YOUR_DEVICE_ID' install
```

### macOS Version
1. Open `FocusAutismApp` directory
2. Run `swift build` to build
3. Run `swift run` to launch

Or open in Xcode:
```bash
open FocusAutismApp/FocusAutismApp.xcodeproj
```

## Project Structure

```
FocusAutism/
├── FocusAutismIOS/           # iOS version (Xcode project)
│   └── FocusAutismIOS/
│       ├── Models/           # Data models
│       ├── ViewModels/       # App state management
│       ├── Views/            # UI components
│       │   └── Sheets/       # Modal sheets
│       ├── Utilities/        # Extensions and helpers
│       └── Assets.xcassets/  # App icons and assets
│
├── FocusAutismApp/           # macOS version (Swift Package)
│   └── Sources/
│       └── FocusAutismApp/
│           ├── Models/
│           ├── ViewModels/
│           ├── Views/
│           └── Utilities/
│
└── .gitignore
```

## Requirements

- **iOS**: 17.0+
- **macOS**: 13.0+
- **Xcode**: 15.0+

## License

MIT License

---

*This app was created with assistance from AI to help address the specific needs of autistic individuals for focus and emotional regulation.*
