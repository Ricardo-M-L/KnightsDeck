//
//  CharacterSelectScene.swift
//  KnightsDeck
//
//  Character class selection screen
//

import SpriteKit

class CharacterSelectScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.1, green: 0.1, blue: 0.15, alpha: 1.0)
        
        setupUI()
    }
    
    func setupUI() {
        // Title
        let title = SKLabelNode(fontNamed: "Copperplate-Bold")
        title.text = "CHOOSE YOUR HERO"
        title.fontSize = 48
        title.fontColor = .white
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.85)
        addChild(title)
        
        // Character cards
        let cardWidth: CGFloat = 280
        let cardHeight: CGFloat = 400
        let spacing: CGFloat = 40
        let startX = (size.width - (cardWidth * 3 + spacing * 2)) / 2
        
        // Knight
        createCharacterCard(
            characterClass: .knight,
            position: CGPoint(x: startX + cardWidth / 2, y: size.height / 2),
            size: CGSize(width: cardWidth, height: cardHeight)
        )
        
        // Archer (coming soon)
        createCharacterCard(
            characterClass: .archer,
            position: CGPoint(x: startX + cardWidth * 1.5 + spacing, y: size.height / 2),
            size: CGSize(width: cardWidth, height: cardHeight),
            comingSoon: true
        )
        
        // Mage (coming soon)
        createCharacterCard(
            characterClass: .mage,
            position: CGPoint(x: startX + cardWidth * 2.5 + spacing * 2, y: size.height / 2),
            size: CGSize(width: cardWidth, height: cardHeight),
            comingSoon: true
        )
        
        // Back button
        let backButton = createButton(
            text: "BACK",
            position: CGPoint(x: 100, y: 50),
            name: "back"
        )
        addChild(backButton)
    }
    
    func createCharacterCard(characterClass: CharacterClass, position: CGPoint, size: CGSize, comingSoon: Bool = false) {
        let card = SKShapeNode(rectOf: size, cornerRadius: 12)
        card.fillColor = comingSoon ? SKColor(white: 0.2, alpha: 0.5) : SKColor(red: 0.25, green: 0.2, blue: 0.15, alpha: 1.0)
        card.strokeColor = SKColor(red: 0.8, green: 0.7, blue: 0.5, alpha: 1.0)
        card.lineWidth = 3
        card.position = position
        card.name = comingSoon ? nil : "character_\(characterClass.rawValue)"
        addChild(card)
        
        // Character name
        let nameLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
        nameLabel.text = getClassName(characterClass)
        nameLabel.fontSize = 32
        nameLabel.fontColor = comingSoon ? SKColor(white: 0.5, alpha: 1.0) : .white
        nameLabel.position = CGPoint(x: 0, y: size.height * 0.35)
        nameLabel.verticalAlignmentMode = .center
        card.addChild(nameLabel)
        
        if comingSoon {
            let comingSoonLabel = SKLabelNode(fontNamed: "Copperplate")
            comingSoonLabel.text = "Coming Soon"
            comingSoonLabel.fontSize = 20
            comingSoonLabel.fontColor = SKColor(red: 0.8, green: 0.6, blue: 0.2, alpha: 1.0)
            comingSoonLabel.position = CGPoint(x: 0, y: 0)
            comingSoonLabel.verticalAlignmentMode = .center
            card.addChild(comingSoonLabel)
            return
        }
        
        // Character description
        let descLabel = SKLabelNode(fontNamed: "Helvetica")
        descLabel.text = getClassDescription(characterClass)
        descLabel.fontSize = 14
        descLabel.fontColor = SKColor(white: 0.8, alpha: 1.0)
        descLabel.preferredMaxLayoutWidth = size.width * 0.8
        descLabel.numberOfLines = 0
        descLabel.position = CGPoint(x: 0, y: -20)
        descLabel.verticalAlignmentMode = .center
        card.addChild(descLabel)
        
        // Stats
        let statsLabel = SKLabelNode(fontNamed: "Menlo")
        statsLabel.text = getClassStats(characterClass)
        statsLabel.fontSize = 16
        statsLabel.fontColor = SKColor(red: 0.9, green: 0.9, blue: 0.6, alpha: 1.0)
        statsLabel.numberOfLines = 0
        statsLabel.preferredMaxLayoutWidth = size.width * 0.8
        statsLabel.position = CGPoint(x: 0, y: -size.height * 0.25)
        statsLabel.verticalAlignmentMode = .center
        card.addChild(statsLabel)
    }
    
    func getClassName(_ characterClass: CharacterClass) -> String {
        switch characterClass {
        case .knight: return "KNIGHT"
        case .archer: return "ARCHER"
        case .mage: return "MAGE"
        }
    }
    
    func getClassDescription(_ characterClass: CharacterClass) -> String {
        switch characterClass {
        case .knight:
            return "A defensive warrior who excels at blocking and withstanding attacks."
        case .archer:
            return "A ranged attacker with quick strikes and poison arrows."
        case .mage:
            return "A powerful spellcaster with devastating area-of-effect magic."
        }
    }
    
    func getClassStats(_ characterClass: CharacterClass) -> String {
        switch characterClass {
        case .knight:
            return "HP: 80\nEnergy: 3\nStarting Cards: 10"
        case .archer:
            return "HP: 65\nEnergy: 3\nStarting Cards: 10"
        case .mage:
            return "HP: 70\nEnergy: 3\nStarting Cards: 10"
        }
    }
    
    func createButton(text: String, position: CGPoint, name: String) -> SKNode {
        let button = SKShapeNode(rectOf: CGSize(width: 150, height: 50), cornerRadius: 8)
        button.fillColor = SKColor(red: 0.3, green: 0.25, blue: 0.2, alpha: 1.0)
        button.strokeColor = SKColor(red: 0.8, green: 0.7, blue: 0.5, alpha: 1.0)
        button.lineWidth = 2
        button.position = position
        button.name = name
        
        let label = SKLabelNode(fontNamed: "Copperplate-Bold")
        label.text = text
        label.fontSize = 20
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        button.addChild(label)
        
        return button
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        for node in nodesAtPoint {
            if let name = node.name {
                if name.starts(with: "character_") {
                    let className = String(name.dropFirst("character_".count))
                    if let characterClass = CharacterClass(rawValue: className) {
                        startGame(with: characterClass)
                    }
                } else if name == "back" {
                    goBack()
                }
            }
        }
    }
    
    func startGame(with characterClass: CharacterClass) {
        GameState.shared.startNewGame(characterClass: characterClass)
        
        // Start first combat
        let enemies = [Enemy.bandit, Enemy.goblin]
        GameState.shared.startCombat(enemies: enemies)
        
        // Transition to combat scene
        let combatScene = CombatScene(size: size)
        combatScene.scaleMode = scaleMode
        view?.presentScene(combatScene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    func goBack() {
        let mainMenu = MainMenuScene(size: size)
        mainMenu.scaleMode = scaleMode
        view?.presentScene(mainMenu, transition: SKTransition.fade(withDuration: 0.5))
    }
}
