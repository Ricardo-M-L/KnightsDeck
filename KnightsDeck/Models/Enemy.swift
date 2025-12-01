//
//  Enemy.swift
//  KnightsDeck
//
//  Enemy data model with AI patterns
//

import Foundation

enum EnemyIntent {
    case attack(damage: Int)
    case defend(block: Int)
    case buff(type: String, amount: Int)
    case debuff(type: String, amount: Int)
    case unknown
}

enum EnemyType: String, Codable {
    case normal
    case elite
    case boss
}

class Enemy: Codable {
    let id: UUID
    let name: String
    let type: EnemyType
    var maxHealth: Int
    var currentHealth: Int
    var block: Int
    var statusEffects: [StatusEffect]
    
    // AI pattern
    let attackPattern: [String] // Array of action types that repeat
    var patternIndex: Int
    
    // Rewards
    let goldReward: Int
    let cardReward: Bool
    
    init(id: UUID = UUID(),
         name: String,
         type: EnemyType,
         maxHealth: Int,
         attackPattern: [String],
         goldReward: Int,
         cardReward: Bool = false) {
        self.id = id
        self.name = name
        self.type = type
        self.maxHealth = maxHealth
        self.currentHealth = maxHealth
        self.block = 0
        self.statusEffects = []
        self.attackPattern = attackPattern
        self.patternIndex = 0
        self.goldReward = goldReward
        self.cardReward = cardReward
    }
    
    // MARK: - Health Management
    
    func takeDamage(_ amount: Int) {
        let actualDamage = max(0, amount - block)
        block = max(0, block - amount)
        currentHealth = max(0, currentHealth - actualDamage)
    }
    
    func gainBlock(_ amount: Int) {
        block += amount
    }
    
    func resetBlock() {
        block = 0
    }
    
    // MARK: - Status Effects
    
    func addStatusEffect(_ effect: StatusEffect) {
        if let index = statusEffects.firstIndex(where: { $0.type == effect.type }) {
            statusEffects[index].stacks += effect.stacks
        } else {
            statusEffects.append(effect)
        }
    }
    
    func getStatusEffectStacks(_ type: String) -> Int {
        return statusEffects.first(where: { $0.type == type })?.stacks ?? 0
    }
    
    // MARK: - AI
    
    func getNextIntent() -> EnemyIntent {
        let action = attackPattern[patternIndex % attackPattern.count]
        
        switch action {
        case "attack_small":
            return .attack(damage: 6 + getStatusEffectStacks("strength"))
        case "attack_medium":
            return .attack(damage: 10 + getStatusEffectStacks("strength"))
        case "attack_large":
            return .attack(damage: 16 + getStatusEffectStacks("strength"))
        case "defend":
            return .defend(block: 8)
        case "buff_strength":
            return .buff(type: "strength", amount: 2)
        case "debuff_weak":
            return .debuff(type: "weak", amount: 1)
        default:
            return .unknown
        }
    }
    
    func executeIntent(against target: Character) {
        let intent = getNextIntent()
        
        switch intent {
        case .attack(let damage):
            var finalDamage = damage
            
            // Apply vulnerable
            if getStatusEffectStacks("vulnerable") > 0 {
                finalDamage = Int(Double(finalDamage) * 1.5)
            }
            
            // Apply weak
            if getStatusEffectStacks("weak") > 0 {
                finalDamage = Int(Double(finalDamage) * 0.75)
            }
            
            target.takeDamage(finalDamage)
            
        case .defend(let blockAmount):
            gainBlock(blockAmount)
            
        case .buff(let type, let amount):
            addStatusEffect(StatusEffect(type: type, stacks: amount, duration: nil))
            
        case .debuff(let type, let amount):
            target.addStatusEffect(StatusEffect(type: type, stacks: amount, duration: 1))
            
        case .unknown:
            break
        }
        
        // Advance pattern
        patternIndex += 1
    }
    
    var isDead: Bool {
        return currentHealth <= 0
    }
}

// MARK: - Predefined Enemies

extension Enemy {
    static let bandit = Enemy(
        name: "Bandit",
        type: .normal,
        maxHealth: 40,
        attackPattern: ["attack_small", "attack_medium"],
        goldReward: 20
    )
    
    static let goblin = Enemy(
        name: "Goblin",
        type: .normal,
        maxHealth: 35,
        attackPattern: ["attack_small", "debuff_weak", "attack_medium"],
        goldReward: 18
    )
    
    static let cultist = Enemy(
        name: "Cultist",
        type: .normal,
        maxHealth: 45,
        attackPattern: ["buff_strength", "attack_medium", "attack_medium"],
        goldReward: 25
    )
    
    static let slime = Enemy(
        name: "Slime",
        type: .normal,
        maxHealth: 50,
        attackPattern: ["attack_small", "defend", "attack_small"],
        goldReward: 15
    )
    
    static let banditLeader = Enemy(
        name: "Bandit Leader",
        type: .elite,
        maxHealth: 90,
        attackPattern: ["buff_strength", "attack_large", "attack_medium", "attack_medium"],
        goldReward: 50,
        cardReward: true
    )
    
    static let orcWarrior = Enemy(
        name: "Orc Warrior",
        type: .elite,
        maxHealth: 100,
        attackPattern: ["attack_medium", "attack_large", "defend"],
        goldReward: 55,
        cardReward: true
    )
    
    // Boss
    static let darkKnight = Enemy(
        name: "Dark Knight",
        type: .boss,
        maxHealth: 250,
        attackPattern: ["attack_medium", "attack_large", "buff_strength", "attack_large", "defend"],
        goldReward: 100,
        cardReward: true
    )
}
