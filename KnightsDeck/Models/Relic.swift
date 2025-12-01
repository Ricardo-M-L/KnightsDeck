//
//  Relic.swift
//  KnightsDeck
//
//  Relic/Artifact system
//

import Foundation

struct Relic: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    let rarity: CardRarity
    let effectType: String
    let effectValue: Int
    
    init(id: UUID = UUID(),
         name: String,
         description: String,
         rarity: CardRarity,
         effectType: String,
         effectValue: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.rarity = rarity
        self.effectType = effectType
        self.effectValue = effectValue
    }
}

// MARK: - Predefined Relics

extension Relic {
    static let bloodVial = Relic(
        name: "Blood Vial",
        description: "At the start of each combat, heal 2 HP",
        rarity: .common,
        effectType: "heal_on_combat_start",
        effectValue: 2
    )
    
    static let energyRing = Relic(
        name: "Energy Ring",
        description: "Gain 1 additional energy at the start of each turn",
        rarity: .rare,
        effectType: "bonus_energy",
        effectValue: 1
    )
    
    static let ironPlate = Relic(
        name: "Iron Plate",
        description: "Gain 3 block at the start of each turn",
        rarity: .common,
        effectType: "bonus_block_per_turn",
        effectValue: 3
    )
    
    static let knightsBadge = Relic(
        name: "Knight's Badge",
        description: "Gain 1 Strength at the start of combat",
        rarity: .uncommon,
        effectType: "strength_on_combat_start",
        effectValue: 1
    )
    
    static let goldenChalice = Relic(
        name: "Golden Chalice",
        description: "Gain 25% more gold from combats",
        rarity: .uncommon,
        effectType: "bonus_gold",
        effectValue: 25
    )
    
    static let ancientCoin = Relic(
        name: "Ancient Coin",
        description: "Start each combat with 1 extra card in hand",
        rarity: .rare,
        effectType: "extra_draw",
        effectValue: 1
    )
    
    static let shieldOfValor = Relic(
        name: "Shield of Valor",
        description: "Whenever you gain block, gain 1 additional block",
        rarity: .rare,
        effectType: "block_multiplier",
        effectValue: 1
    )
    
    static let berserkersAxe = Relic(
        name: "Berserker's Axe",
        description: "Deal 50% more damage but take 25% more damage",
        rarity: .rare,
        effectType: "damage_multiplier",
        effectValue: 50
    )
}
