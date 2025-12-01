//
//  Character.swift
//  KnightsDeck
//
//  Player character model
//

import Foundation

enum CharacterClass: String, Codable {
    case knight
    case archer
    case mage
}

struct StatusEffect: Codable {
    let type: String // "strength", "weak", "vulnerable", "poison", etc.
    var stacks: Int
    var duration: Int? // nil for permanent effects
}

class Character: Codable {
    let characterClass: CharacterClass
    var maxHealth: Int
    var currentHealth: Int
    var block: Int
    var energy: Int
    let maxEnergy: Int
    var gold: Int
    
    var deck: [Card]
    var hand: [Card]
    var drawPile: [Card]
    var discardPile: [Card]
    var exhaustPile: [Card]
    
    var relics: [String] // Relic IDs
    var statusEffects: [StatusEffect]
    
    init(characterClass: CharacterClass) {
        self.characterClass = characterClass
        self.maxHealth = 80
        self.currentHealth = 80
        self.block = 0
        self.maxEnergy = 3
        self.energy = 3
        self.gold = 0
        
        // Initialize with starting deck based on class
        switch characterClass {
        case .knight:
            self.deck = Card.knightStarterDeck()
        case .archer:
            self.deck = [] // TODO: Implement archer deck
        case .mage:
            self.deck = [] // TODO: Implement mage deck
        }
        
        self.hand = []
        self.drawPile = []
        self.discardPile = []
        self.exhaustPile = []
        self.relics = []
        self.statusEffects = []
    }
    
    // MARK: - Health Management
    
    func takeDamage(_ amount: Int) {
        let actualDamage = max(0, amount - block)
        block = max(0, block - amount)
        currentHealth = max(0, currentHealth - actualDamage)
    }
    
    func heal(_ amount: Int) {
        currentHealth = min(maxHealth, currentHealth + amount)
    }
    
    func gainBlock(_ amount: Int) {
        var blockAmount = amount
        
        // Apply strength modifier if present
        if let strengthEffect = statusEffects.first(where: { $0.type == "strength" }) {
            blockAmount += strengthEffect.stacks
        }
        
        block += max(0, blockAmount)
    }
    
    // MARK: - Energy Management
    
    func resetEnergy() {
        energy = maxEnergy
    }
    
    func spendEnergy(_ amount: Int) -> Bool {
        guard energy >= amount else { return false }
        energy -= amount
        return true
    }
    
    // MARK: - Status Effects
    
    func addStatusEffect(_ effect: StatusEffect) {
        if let index = statusEffects.firstIndex(where: { $0.type == effect.type }) {
            statusEffects[index].stacks += effect.stacks
        } else {
            statusEffects.append(effect)
        }
    }
    
    func removeStatusEffect(_ type: String) {
        statusEffects.removeAll { $0.type == type }
    }
    
    func getStatusEffectStacks(_ type: String) -> Int {
        return statusEffects.first(where: { $0.type == type })?.stacks ?? 0
    }
    
    func updateStatusEffects() {
        // Reduce duration and remove expired effects
        statusEffects = statusEffects.compactMap { effect in
            guard var duration = effect.duration else { return effect }
            duration -= 1
            if duration <= 0 { return nil }
            
            var updatedEffect = effect
            updatedEffect.duration = duration
            return updatedEffect
        }
    }
    
    // MARK: - Card Management
    
    func addCardToDeck(_ card: Card) {
        deck.append(card)
    }
    
    func removeCardFromDeck(_ cardId: UUID) {
        deck.removeAll { $0.id == cardId }
    }
    
    var isDead: Bool {
        return currentHealth <= 0
    }
}

// MARK: - Character Info

extension Character {
    var className: String {
        switch characterClass {
        case .knight:
            return "Knight"
        case .archer:
            return "Archer"
        case .mage:
            return "Mage"
        }
    }
    
    var classDescription: String {
        switch characterClass {
        case .knight:
            return "A defensive warrior who excels at blocking and withstanding attacks."
        case .archer:
            return "A ranged attacker with quick strikes and poison arrows."
        case .mage:
            return "A powerful spellcaster with devastating area-of-effect magic."
        }
    }
}
