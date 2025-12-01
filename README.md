# Knight's Deck

A medieval-themed roguelike deck-building card game for macOS.

## Features

### Core Gameplay
- **Turn-Based Card Combat**: Strategic card-based battles against enemies
- **Deck Building**: Start with a basic deck and improve it throughout your run
- **Energy System**: Manage your energy to play cards efficiently
- **Status Effects**: Strength, Weak, Vulnerable, and more

### Character Classes
- **Knight**: Defensive tank with high HP and blocking abilities (Available)
- **Archer**: Ranged attacker with poison (Coming soon)
- **Mage**: Spellcaster with AoE damage (Coming soon)

### Game Systems
- **Combat**: Face various enemies with unique AI patterns
- **Rewards**: Gain cards, relics, and gold after victories
- **Relics**: Powerful passive items that modify gameplay
- **Progression**: Advance through floors with increasing difficulty

## Project Structure

```
KnightsDeck/
├── AppDelegate.swift          # App entry point
├── GameViewController.swift    # Main game view
├── Models/                     # Data models
│   ├── Card.swift             # Card definitions
│   ├── Character.swift        # Player character
│   ├── Enemy.swift            # Enemy definitions
│   ├── Relic.swift            # Relic/artifact system
│   ├── CombatState.swift      # Combat management
│   └── GameState.swift        # Overall game state
└── Scenes/                     # SpriteKit scenes
    ├── MainMenuScene.swift    # Main menu
    ├── CharacterSelectScene.swift  # Character selection
    └── CombatScene.swift      # Combat gameplay
```

## How to Build

### Requirements
- macOS 12.0 or later
- Xcode 14.0 or later
- Swift 5.7+

### Build Instructions

1. **Create Xcode Project**:
   - Open Xcode
   - File → New → Project
   - Select "macOS" → "App"
   - Product Name: `KnightsDeck`
   - Interface: `Storyboard`
   - Language: `Swift`
   - Click "Next" and choose the `KnightsDeck` folder

2. **Add Game Files**:
   - Delete the default `ViewController.swift` and `Main.storyboard`
   - In Xcode, right-click on `KnightsDeck` folder → "Add Files to KnightsDeck"
   - Select all the Swift files in:
     - `Models/`
     - `Scenes/`
     - `AppDelegate.swift`
     - `GameViewController.swift`
   - Make sure "Copy items if needed" is checked

3. **Configure Project**:
   - Select the project in the navigator
   - Under "Deployment Info":
     - Set minimum macOS version to 12.0
     - Remove checkmark from "Main Interface" (leave blank)
   - Under "Signing & Capabilities":
     - Select your development team

4. **Update Info.plist**:
   - Replace the default Info.plist with the one provided
   - Or manually remove `NSMainStoryboardFile` key

5. **Build and Run**:
   - Press `Cmd + R` or click the Play button
   - The game should launch!

### Quick Build (Command Line)

If you prefer command line:

```bash
cd KnightsDeck
xcodebuild -scheme KnightsDeck -configuration Debug
```

## How to Play

1. **Main Menu**: Start a new game or continue (if save exists)
2. **Character Selection**: Choose your character class (currently only Knight available)
3. **Combat**:
   - Drag cards from your hand onto enemies to play them
   - Each card costs energy (shown as ⚡︎)
   - Click "END TURN" when done to let enemies act
   - Defeat all enemies to win the combat
4. **Progression**: After combat, receive rewards and advance to the next floor

### Combat Tips
- **Block** protects you from damage until the start of your next turn
- **Strength** increases damage dealt by attack cards
- Watch enemy **intents** to plan your defense
- Balance offense and defense!

## Game Design

### Card Types
- **Attack** (Red): Deal damage to enemies
- **Skill** (Blue): Defensive and utility effects
- **Power** (Purple): Permanent buffs for the combat

### Status Effects
- **Strength**: +X damage per attack
- **Weak**: -25% damage dealt
- **Vulnerable**: +50% damage taken

### Enemy AI
Enemies follow attack patterns and show their next intent:
- ⚔︎ = Attack
- 🛡 = Defend
- ↑ = Buff
- ↓ = Debuff

## Future Features

- [ ] Multiple character classes
- [ ] Map navigation system
- [ ] Shop system
- [ ] Campfire/Rest sites
- [ ] More enemy types and bosses
- [ ] Card upgrades
- [ ] More relics and synergies
- [ ] Sound effects and music
- [ ] Achievements
- [ ] Daily challenges

## Development Notes

This game uses **SpriteKit** for 2D rendering and is built entirely with native Swift for optimal macOS performance.

## License

Copyright © 2025 Knight's Deck. All rights reserved.
