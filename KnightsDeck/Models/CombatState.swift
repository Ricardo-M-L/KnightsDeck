//
//  CombatState.swift
//  KnightsDeck
//
//  Manages the state of combat encounters
//

import Foundation

class CombatState {
    var player: Character
    var enemies: [Enemy]
    var turnNumber: Int
    var isPlayerTurn: Bool
    var combatLog: [String]
    
    init(player: Character, enemies: [Enemy]) {
        self.player = player
        self.enemies = enemies
        self.turnNumber = 1
        self.isPlayerTurn = true
        self.combatLog = []
        
        // Initialize combat
        startCombat()
    }
    
    // MARK: - Combat Flow
    
    func startCombat() {
        // Shuffle deck into draw pile
        player.drawPile = player.deck.shuffled()
        player.hand = []
        player.discardPile = []
        
        // Draw starting hand
        drawCards(5)
        
        addLog("Combat begins!")
        addLog("Drew 5 cards.")
    }
    
    func startPlayerTurn() {
        isPlayerTurn = true
        turnNumber += 1
        
        // Reset player state
        player.block = 0
        player.resetEnergy()
        
        // Update status effects
        player.updateStatusEffects()
        
        // Draw cards
        drawCards(5)
        
        addLog("\n--- Turn \(turnNumber) ---")
        addLog("Drew 5 cards. Energy: \(player.energy)/\(player.maxEnergy)")
    }
    
    func endPlayerTurn() {
        isPlayerTurn = false
        
        // Discard hand
        player.discardPile.append(contentsOf: player.hand)
        player.hand = []
        
        addLog("Turn ended. Discarded hand.")
        
        // Enemy turn
        executeEnemyTurn()
    }
    
    func executeEnemyTurn() {
        addLog("\n--- Enemy Turn ---")
        
        for enemy in enemies where !enemy.isDead {
            // Reset block
            enemy.resetBlock()
            
            // Execute intent
            let intent = enemy.getNextIntent()
            addLog("\(enemy.name) uses \(intentDescription(intent))")
            enemy.executeIntent(against: player)
            
            // Check if player died
            if player.isDead {
                addLog("You have been defeated!")
                return
            }
        }
        
        // Start player turn
        startPlayerTurn()
    }
    
    // MARK: - Card Actions
    
    func playCard(_ card: Card, targetEnemy: Enemy?) -> Bool {
        guard player.spendEnergy(card.cost) else {
            addLog("Not enough energy!")
            return false
        }
        
        // Remove card from hand
        guard let index = player.hand.firstIndex(where: { $0.id == card.id }) else {
            return false
        }
        player.hand.remove(at: index)
        
        // Apply card effects
        for effect in card.effects {
            applyCardEffect(effect, from: card, to: targetEnemy)
        }
        
        // Move card to discard
        player.discardPile.append(card)
        
        addLog("Played \(card.name). Energy: \(player.energy)/\(player.maxEnergy)")
        
        // Check if all enemies dead
        if enemies.allSatisfy({ $0.isDead }) {
            endCombat(victory: true)
        }
        
        return true
    }
    
    func applyCardEffect(_ effect: CardEffect, from card: Card, to targetEnemy: Enemy?) {
        switch effect.type {
        case "damage":
            guard let target = targetEnemy else { return }
            dealDamage(effect.value, to: target)
            
        case "block":
            player.gainBlock(effect.value)
            addLog("Gained \(effect.value) block")
            
        case "draw":
            drawCards(effect.value)
            
        case "strength":
            player.addStatusEffect(StatusEffect(type: "strength", stacks: effect.value, duration: nil))
            addLog("Gained \(effect.value) Strength")
            
        case "weak":
            guard let target = targetEnemy else { return }
            target.addStatusEffect(StatusEffect(type: "weak", stacks: effect.value, duration: 2))
            addLog("Applied \(effect.value) Weak")
            
        case "vulnerable":
            guard let target = targetEnemy else { return }
            target.addStatusEffect(StatusEffect(type: "vulnerable", stacks: effect.value, duration: 2))
            addLog("Applied \(effect.value) Vulnerable")
            
        default:
            break
        }
    }
    
    func dealDamage(_ baseDamage: Int, to enemy: Enemy) {
        var damage = baseDamage
        
        // Apply strength modifier
        let strength = player.getStatusEffectStacks("strength")
        damage += strength
        
        // Apply enemy vulnerable
        if enemy.getStatusEffectStacks("vulnerable") > 0 {
            damage = Int(Double(damage) * 1.5)
        }
        
        // Apply player weak
        if player.getStatusEffectStacks("weak") > 0 {
            damage = Int(Double(damage) * 0.75)
        }
        
        enemy.takeDamage(damage)
        addLog("Dealt \(damage) damage to \(enemy.name)")
        
        if enemy.isDead {
            addLog("\(enemy.name) has been defeated!")
        }
    }
    
    // MARK: - Card Drawing
    
    func drawCards(_ count: Int) {
        for _ in 0..<count {
            drawCard()
        }
    }
    
    func drawCard() {
        // If draw pile is empty, shuffle discard into draw pile
        if player.drawPile.isEmpty {
            if player.discardPile.isEmpty {
                return // No cards to draw
            }
            player.drawPile = player.discardPile.shuffled()
            player.discardPile = []
            addLog("Shuffled discard pile into draw pile.")
        }
        
        let card = player.drawPile.removeFirst()
        player.hand.append(card)
    }
    
    // MARK: - Combat End
    
    func endCombat(victory: Bool) {
        if victory {
            addLog("\n=== VICTORY ===")
            
            // Calculate rewards
            let totalGold = enemies.reduce(0) { $0 + $1.goldReward }
            player.gold += totalGold
            addLog("Gained \(totalGold) gold!")
        } else {
            addLog("\n=== DEFEAT ===")
        }
    }
    
    var isCombatOver: Bool {
        return player.isDead || enemies.allSatisfy { $0.isDead }
    }
    
    var playerWon: Bool {
        return !player.isDead && enemies.allSatisfy { $0.isDead }
    }
    
    // MARK: - Helpers
    
    func addLog(_ message: String) {
        combatLog.append(message)
        print(message) // Also print to console for debugging
    }
    
    func intentDescription(_ intent: EnemyIntent) -> String {
        switch intent {
        case .attack(let damage):
            return "Attack for \(damage) damage"
        case .defend(let block):
            return "Defend for \(block) block"
        case .buff(let type, let amount):
            return "Gain \(amount) \(type)"
        case .debuff(let type, let amount):
            return "Apply \(amount) \(type)"
        case .unknown:
            return "???"
        }
    }
}
