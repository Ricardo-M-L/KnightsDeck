//
//  Card.swift
//  KnightsDeck
//
//  Core card data model
//

import Foundation

enum CardType: String, Codable {
    case attack
    case skill
    case power
}

enum CardRarity: String, Codable {
    case common
    case uncommon
    case rare
}

enum CardTarget: String, Codable {
    case enemy
    case allEnemies
    case self_
    case none
}

struct CardEffect: Codable {
    let type: String // "damage", "block", "draw", "strength", etc.
    let value: Int
    let target: CardTarget
    
    enum CodingKeys: String, CodingKey {
        case type, value, target
    }
}

struct Card: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    let cost: Int
    let type: CardType
    let rarity: CardRarity
    let effects: [CardEffect]
    let imageName: String?
    var isUpgraded: Bool
    
    init(id: UUID = UUID(), 
         name: String, 
         description: String, 
         cost: Int, 
         type: CardType, 
         rarity: CardRarity, 
         effects: [CardEffect],
         imageName: String? = nil,
         isUpgraded: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.cost = cost
        self.type = type
        self.rarity = rarity
        self.effects = effects
        self.imageName = imageName
        self.isUpgraded = isUpgraded
    }
    
    // Create an upgraded version of this card
    func upgraded() -> Card {
        var upgradedEffects = effects.map { effect in
            CardEffect(type: effect.type, 
                      value: effect.value + 3, // Simple upgrade: +3 to all values
                      target: effect.target)
        }
        
        return Card(id: UUID(),
                   name: name + "+",
                   description: description,
                   cost: max(0, cost - 1), // Reduce cost by 1 (minimum 0)
                   type: type,
                   rarity: rarity,
                   effects: upgradedEffects,
                   imageName: imageName,
                   isUpgraded: true)
    }
}

// MARK: - Default Card Data

extension Card {
    // Starting deck cards
    static let strike = Card(
        name: "Strike",
        description: "Deal 6 damage",
        cost: 1,
        type: .attack,
        rarity: .common,
        effects: [CardEffect(type: "damage", value: 6, target: .enemy)]
    )
    
    static let defend = Card(
        name: "Defend",
        description: "Gain 5 block",
        cost: 1,
        type: .skill,
        rarity: .common,
        effects: [CardEffect(type: "block", value: 5, target: .self_)]
    )
    
    // Knight cards
    static let shieldBash = Card(
        name: "Shield Bash",
        description: "Deal 8 damage. Gain 5 block.",
        cost: 2,
        type: .attack,
        rarity: .common,
        effects: [
            CardEffect(type: "damage", value: 8, target: .enemy),
            CardEffect(type: "block", value: 5, target: .self_)
        ]
    )
    
    static let heavyBlow = Card(
        name: "Heavy Blow",
        description: "Deal 14 damage",
        cost: 2,
        type: .attack,
        rarity: .common,
        effects: [CardEffect(type: "damage", value: 14, target: .enemy)]
    )
    
    static let ironWill = Card(
        name: "Iron Will",
        description: "Gain 12 block. Gain 1 Strength.",
        cost: 1,
        type: .skill,
        rarity: .uncommon,
        effects: [
            CardEffect(type: "block", value: 12, target: .self_),
            CardEffect(type: "strength", value: 1, target: .self_)
        ]
    )
    
    static let cleave = Card(
        name: "Cleave",
        description: "Deal 8 damage to ALL enemies",
        cost: 1,
        type: .attack,
        rarity: .common,
        effects: [CardEffect(type: "damage", value: 8, target: .allEnemies)]
    )
    
    static let shieldWall = Card(
        name: "Shield Wall",
        description: "Gain 18 block",
        cost: 2,
        type: .skill,
        rarity: .uncommon,
        effects: [CardEffect(type: "block", value: 18, target: .self_)]
    )
    
    static let revenge = Card(
        name: "Revenge",
        description: "Deal damage equal to block lost this turn",
        cost: 1,
        type: .attack,
        rarity: .rare,
        effects: [CardEffect(type: "revenge_damage", value: 0, target: .enemy)]
    )
    
    static let rampage = Card(
        name: "Rampage",
        description: "Gain 2 Strength",
        cost: 1,
        type: .power,
        rarity: .rare,
        effects: [CardEffect(type: "strength", value: 2, target: .self_)]
    )
    
    // Get starting deck for Knight class
    static func knightStarterDeck() -> [Card] {
        return [
            strike, strike, strike, strike, strike,
            defend, defend, defend, defend,
            shieldBash
        ]
    }
}
