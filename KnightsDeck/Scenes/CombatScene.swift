//
//  CombatScene.swift
//  KnightsDeck
//
//  Main combat scene with card gameplay
//

import SpriteKit

class CombatScene: SKScene {
    
    var combatState: CombatState!
    var cardNodes: [CardNode] = []
    var selectedCard: CardNode?
    var selectedEnemy: EnemyNode?
    
    var playerHealthBar: HealthBarNode!
    var enemyNodes: [EnemyNode] = []
    
    var energyLabel: SKLabelNode!
    var endTurnButton: SKShapeNode!
    
    var combatLogLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.15, green: 0.1, blue: 0.1, alpha: 1.0)
        
        // Get combat state from game state
        guard let combat = GameState.shared.currentCombat else {
            print("Error: No combat state!")
            return
        }
        combatState = combat
        
        setupUI()
        updateDisplay()
    }
    
    func setupUI() {
        // Player area
        setupPlayerArea()
        
        // Enemy area
        setupEnemyArea()
        
        // Hand area
        setupHandArea()
        
        // UI controls
        setupControls()
        
        // Combat log
        setupCombatLog()
    }
    
    // MARK: - UI Setup
    
    func setupPlayerArea() {
        // Player health bar
        playerHealthBar = HealthBarNode(
            maxValue: combatState.player.maxHealth,
            currentValue: combatState.player.currentHealth,
            size: CGSize(width: 300, height: 40)
        )
        playerHealthBar.position = CGPoint(x: 200, y: size.height - 100)
        addChild(playerHealthBar)
        
        // Player name
        let nameLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
        nameLabel.text = combatState.player.className
        nameLabel.fontSize = 24
        nameLabel.fontColor = .white
        nameLabel.position = CGPoint(x: 200, y: size.height - 70)
        nameLabel.horizontalAlignmentMode = .center
        addChild(nameLabel)
    }
    
    func setupEnemyArea() {
        let spacing: CGFloat = 250
        let startX = size.width - 400
        
        for (index, enemy) in combatState.enemies.enumerated() {
            let enemyNode = EnemyNode(enemy: enemy, size: CGSize(width: 200, height: 280))
            enemyNode.position = CGPoint(
                x: startX, 
                y: size.height - 200 - CGFloat(index) * spacing
            )
            enemyNode.name = "enemy_\(enemy.id)"
            addChild(enemyNode)
            enemyNodes.append(enemyNode)
        }
    }
    
    func setupHandArea() {
        // Hand will be positioned at bottom
        // Cards will be added dynamically
    }
    
    func setupControls() {
        // Energy display
        energyLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
        energyLabel.fontSize = 32
        energyLabel.position = CGPoint(x: 100, y: size.height - 200)
        addChild(energyLabel)
        
        // End turn button
        endTurnButton = SKShapeNode(rectOf: CGSize(width: 180, height: 60), cornerRadius: 10)
        endTurnButton.fillColor = SKColor(red: 0.6, green: 0.3, blue: 0.2, alpha: 1.0)
        endTurnButton.strokeColor = SKColor(red: 0.9, green: 0.7, blue: 0.5, alpha: 1.0)
        endTurnButton.lineWidth = 3
        endTurnButton.position = CGPoint(x: size.width - 120, y: 80)
        endTurnButton.name = "endTurn"
        
        let label = SKLabelNode(fontNamed: "Copperplate-Bold")
        label.text = "END TURN"
        label.fontSize = 22
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        endTurnButton.addChild(label)
        
        addChild(endTurnButton)
    }
    
    func setupCombatLog() {
        combatLogLabel = SKLabelNode(fontNamed: "Menlo")
        combatLogLabel.fontSize = 12
        combatLogLabel.fontColor = SKColor(white: 0.7, alpha: 1.0)
        combatLogLabel.horizontalAlignmentMode = .left
        combatLogLabel.verticalAlignmentMode = .top
        combatLogLabel.numberOfLines = 10
        combatLogLabel.preferredMaxLayoutWidth = 400
        combatLogLabel.position = CGPoint(x: 20, y: size.height / 2)
        addChild(combatLogLabel)
    }
    
    // MARK: - Display Updates
    
    func updateDisplay() {
        // Update player health
        playerHealthBar.updateValue(combatState.player.currentHealth)
        playerHealthBar.updateBlock(combatState.player.block)
        
        // Update energy
        energyLabel.text = "⚡︎ \(combatState.player.energy)/\(combatState.player.maxEnergy)"
        
        // Update enemies
        for enemyNode in enemyNodes {
            enemyNode.update()
        }
        
        // Update hand
        updateHand()
        
        // Update combat log
        let recentLogs = combatState.combatLog.suffix(10).joined(separator: "\n")
        combatLogLabel.text = recentLogs
        
        // Check if combat is over
        if combatState.isCombatOver {
            handleCombatEnd()
        }
    }
    
    func updateHand() {
        // Remove old card nodes
        cardNodes.forEach { $0.removeFromParent() }
        cardNodes.removeAll()
        
        // Create new card nodes
        let hand = combatState.player.hand
        let cardWidth: CGFloat = 140
        let cardHeight: CGFloat = 200
        let spacing: CGFloat = 10
        let totalWidth = CGFloat(hand.count) * (cardWidth + spacing) - spacing
        let startX = (size.width - totalWidth) / 2
        
        for (index, card) in hand.enumerated() {
            let cardNode = CardNode(card: card, size: CGSize(width: cardWidth, height: cardHeight))
            cardNode.position = CGPoint(
                x: startX + CGFloat(index) * (cardWidth + spacing) + cardWidth / 2,
                y: cardHeight / 2 + 20
            )
            cardNode.name = "card_\(card.id)"
            addChild(cardNode)
            cardNodes.append(cardNode)
        }
    }
    
    // MARK: - Input Handling
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        // Check for card selection
        for node in nodesAtPoint {
            if let cardNode = node as? CardNode ?? node.parent as? CardNode {
                selectedCard = cardNode
                return
            }
        }
        
        // Check for end turn button
        for node in nodesAtPoint {
            if node.name == "endTurn" {
                endTurn()
                return
            }
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        guard let card = selectedCard else { return }
        
        let location = event.location(in: self)
        let nodesAtPoint = nodes(at: location)
        
        // Check if dropped on enemy
        var targetEnemy: Enemy? = nil
        for node in nodesAtPoint {
            if let enemyNode = node as? EnemyNode ?? node.parent as? EnemyNode {
                targetEnemy = enemyNode.enemy
                break
            }
        }
        
        // Play the card
        if combatState.playCard(card.card, targetEnemy: targetEnemy) {
            updateDisplay()
        }
        
        selectedCard = nil
    }
    
    override func mouseDragged(with event: NSEvent) {
        guard let card = selectedCard else { return }
        
        let location = event.location(in: self)
        card.position = location
    }
    
    func endTurn() {
        combatState.endPlayerTurn()
        updateDisplay()
    }
    
    func handleCombatEnd() {
        GameState.shared.endCombat()
        
        // Show victory/defeat screen
        let resultLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
        resultLabel.fontSize = 64
        resultLabel.fontColor = combatState.playerWon ? .green : .red
        resultLabel.text = combatState.playerWon ? "VICTORY" : "DEFEAT"
        resultLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(resultLabel)
        
        // Add continue button after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.showContinueButton()
        }
    }
    
    func showContinueButton() {
        let button = SKShapeNode(rectOf: CGSize(width: 200, height: 60), cornerRadius: 10)
        button.fillColor = SKColor(red: 0.3, green: 0.5, blue: 0.3, alpha: 1.0)
        button.strokeColor = .white
        button.lineWidth = 2
        button.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)
        button.name = "continue"
        
        let label = SKLabelNode(fontNamed: "Copperplate-Bold")
        label.text = "CONTINUE"
        label.fontSize = 24
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        button.addChild(label)
        
        addChild(button)
    }
}

// MARK: - Card Node

class CardNode: SKShapeNode {
    let card: Card
    
    init(card: Card, size: CGSize) {
        self.card = card
        super.init()
        
        // Card background
        self.path = CGPath(roundedRect: CGRect(origin: CGPoint(x: -size.width/2, y: -size.height/2), size: size), cornerWidth: 8, cornerHeight: 8, transform: nil)
        
        // Color based on card type
        switch card.type {
        case .attack:
            self.fillColor = SKColor(red: 0.6, green: 0.2, blue: 0.2, alpha: 1.0)
        case .skill:
            self.fillColor = SKColor(red: 0.2, green: 0.4, blue: 0.6, alpha: 1.0)
        case .power:
            self.fillColor = SKColor(red: 0.4, green: 0.2, blue: 0.6, alpha: 1.0)
        }
        
        self.strokeColor = .white
        self.lineWidth = 2
        
        // Card name
        let nameLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
        nameLabel.text = card.name
        nameLabel.fontSize = 16
        nameLabel.fontColor = .white
        nameLabel.position = CGPoint(x: 0, y: size.height / 2 - 30)
        nameLabel.verticalAlignmentMode = .center
        addChild(nameLabel)
        
        // Cost
        let costCircle = SKShapeNode(circleOfRadius: 20)
        costCircle.fillColor = .black
        costCircle.strokeColor = .white
        costCircle.lineWidth = 2
        costCircle.position = CGPoint(x: -size.width / 2 + 25, y: size.height / 2 - 25)
        addChild(costCircle)
        
        let costLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
        costLabel.text = "\(card.cost)"
        costLabel.fontSize = 20
        costLabel.fontColor = .white
        costLabel.verticalAlignmentMode = .center
        costLabel.position = costCircle.position
        addChild(costLabel)
        
        // Description
        let descLabel = SKLabelNode(fontNamed: "Helvetica")
        descLabel.text = card.description
        descLabel.fontSize = 12
        descLabel.fontColor = .white
        descLabel.numberOfLines = 0
        descLabel.preferredMaxLayoutWidth = size.width * 0.8
        descLabel.position = CGPoint(x: 0, y: 0)
        descLabel.verticalAlignmentMode = .center
        addChild(descLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Enemy Node

class EnemyNode: SKNode {
    let enemy: Enemy
    let size: CGSize
    var healthBar: HealthBarNode!
    var intentLabel: SKLabelNode!
    
    init(enemy: Enemy, size: CGSize) {
        self.enemy = enemy
        self.size = size
        super.init()
        
        setupVisuals()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupVisuals() {
        // Enemy card background
        let background = SKShapeNode(rectOf: size, cornerRadius: 10)
        background.fillColor = SKColor(red: 0.3, green: 0.15, blue: 0.15, alpha: 1.0)
        background.strokeColor = SKColor(red: 0.8, green: 0.4, blue: 0.4, alpha: 1.0)
        background.lineWidth = 3
        addChild(background)
        
        // Enemy name
        let nameLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
        nameLabel.text = enemy.name
        nameLabel.fontSize = 20
        nameLabel.fontColor = .white
        nameLabel.position = CGPoint(x: 0, y: size.height / 2 - 30)
        nameLabel.verticalAlignmentMode = .center
        addChild(nameLabel)
        
        // Health bar
        healthBar = HealthBarNode(
            maxValue: enemy.maxHealth,
            currentValue: enemy.currentHealth,
            size: CGSize(width: size.width * 0.8, height: 30)
        )
        healthBar.position = CGPoint(x: 0, y: size.height / 2 - 60)
        addChild(healthBar)
        
        // Intent
        intentLabel = SKLabelNode(fontNamed: "Menlo")
        intentLabel.fontSize = 14
        intentLabel.fontColor = SKColor(red: 1.0, green: 0.9, blue: 0.6, alpha: 1.0)
        intentLabel.position = CGPoint(x: 0, y: -size.height / 2 + 40)
        intentLabel.verticalAlignmentMode = .center
        addChild(intentLabel)
        
        update()
    }
    
    func update() {
        if enemy.isDead {
            alpha = 0.3
            return
        }
        
        healthBar.updateValue(enemy.currentHealth)
        healthBar.updateBlock(enemy.block)
        
        // Show intent
        let intent = enemy.getNextIntent()
        intentLabel.text = getIntentText(intent)
    }
    
    func getIntentText(_ intent: EnemyIntent) -> String {
        switch intent {
        case .attack(let damage):
            return "⚔︎ \(damage)"
        case .defend(let block):
            return "🛡 \(block)"
        case .buff(let type, let amount):
            return "↑ \(type) +\(amount)"
        case .debuff(let type, let amount):
            return "↓ \(type) -\(amount)"
        case .unknown:
            return "?"
        }
    }
}

// MARK: - Health Bar Node

class HealthBarNode: SKNode {
    let maxValue: Int
    var currentValue: Int
    var block: Int = 0
    let size: CGSize
    
    var barBackground: SKShapeNode!
    var barForeground: SKShapeNode!
    var label: SKLabelNode!
    var blockLabel: SKLabelNode?
    
    init(maxValue: Int, currentValue: Int, size: CGSize) {
        self.maxValue = maxValue
        self.currentValue = currentValue
        self.size = size
        super.init()
        
        setupVisuals()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupVisuals() {
        // Background
        barBackground = SKShapeNode(rectOf: size, cornerRadius: 4)
        barBackground.fillColor = SKColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        barBackground.strokeColor = .black
        barBackground.lineWidth = 2
        addChild(barBackground)
        
        // Foreground (health)
        barForeground = SKShapeNode(rectOf: size, cornerRadius: 4)
        barForeground.fillColor = SKColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        barForeground.strokeColor = .clear
        addChild(barForeground)
        
        // Label
        label = SKLabelNode(fontNamed: "Copperplate-Bold")
        label.fontSize = 16
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        addChild(label)
        
        updateValue(currentValue)
    }
    
    func updateValue(_ newValue: Int) {
        currentValue = newValue
        
        // Update bar width
        let percentage = CGFloat(currentValue) / CGFloat(maxValue)
        barForeground.xScale = percentage
        barForeground.position = CGPoint(x: -size.width / 2 * (1 - percentage), y: 0)
        
        // Update label
        label.text = "\(currentValue) / \(maxValue)"
        
        // Color based on health percentage
        if percentage > 0.6 {
            barForeground.fillColor = SKColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0)
        } else if percentage > 0.3 {
            barForeground.fillColor = SKColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1.0)
        } else {
            barForeground.fillColor = SKColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        }
    }
    
    func updateBlock(_ blockAmount: Int) {
        block = blockAmount
        
        // Remove old block label
        blockLabel?.removeFromParent()
        
        if block > 0 {
            blockLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
            blockLabel!.text = "🛡 \(block)"
            blockLabel!.fontSize = 18
            blockLabel!.fontColor = SKColor(red: 0.7, green: 0.7, blue: 1.0, alpha: 1.0)
            blockLabel!.position = CGPoint(x: size.width / 2 + 40, y: 0)
            blockLabel!.verticalAlignmentMode = .center
            addChild(blockLabel!)
        }
    }
}
