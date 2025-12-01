//
//  GameState.swift
//  KnightsDeck
//
//  Overall game state management
//

import Foundation

enum GamePhase {
    case mainMenu
    case characterSelect
    case map
    case combat
    case reward
    case shop
    case rest
    case gameOver
}

class GameState {
    static let shared = GameState()
    
    var currentPhase: GamePhase
    var player: Character?
    var currentFloor: Int
    var currentCombat: CombatState?
    var seed: UInt64
    
    private init() {
        self.currentPhase = .mainMenu
        self.currentFloor = 0
        self.seed = UInt64.random(in: 0...UInt64.max)
    }
    
    // MARK: - Game Flow
    
    func startNewGame(characterClass: CharacterClass) {
        player = Character(characterClass: characterClass)
        currentFloor = 1
        currentPhase = .map
        seed = UInt64.random(in: 0...UInt64.max)
    }
    
    func startCombat(enemies: [Enemy]) {
        guard let player = player else { return }
        currentCombat = CombatState(player: player, enemies: enemies)
        currentPhase = .combat
    }
    
    func endCombat() {
        guard let combat = currentCombat else { return }
        
        if combat.playerWon {
            currentPhase = .reward
        } else {
            currentPhase = .gameOver
        }
    }
    
    func advanceFloor() {
        currentFloor += 1
        if currentFloor % 16 == 0 {
            // Boss floor
            startCombat(enemies: [Enemy.darkKnight])
        } else {
            currentPhase = .map
        }
    }
    
    // MARK: - Rewards
    
    func generateCardRewards(count: Int = 3) -> [Card] {
        // Simple random card generation
        let availableCards = [
            Card.strike, Card.defend, Card.shieldBash,
            Card.heavyBlow, Card.ironWill, Card.cleave,
            Card.shieldWall, Card.revenge, Card.rampage
        ]
        
        return (0..<count).map { _ in
            availableCards.randomElement()!
        }
    }
    
    // MARK: - Save/Load
    
    func saveGame() {
        // TODO: Implement save to disk
    }
    
    func loadGame() -> Bool {
        // TODO: Implement load from disk
        return false
    }
}
