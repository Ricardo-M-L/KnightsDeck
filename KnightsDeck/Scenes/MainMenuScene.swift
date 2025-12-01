//
//  MainMenuScene.swift
//  KnightsDeck
//
//  Main menu screen
//

import SpriteKit

class MainMenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.1, green: 0.1, blue: 0.15, alpha: 1.0)
        
        setupUI()
    }
    
    func setupUI() {
        // Title
        let title = SKLabelNode(fontNamed: "Copperplate-Bold")
        title.text = "KNIGHT'S DECK"
        title.fontSize = 72
        title.fontColor = .white
        title.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        addChild(title)
        
        // Subtitle
        let subtitle = SKLabelNode(fontNamed: "Copperplate")
        subtitle.text = "A Roguelike Card Adventure"
        subtitle.fontSize = 24
        subtitle.fontColor = SKColor(white: 0.8, alpha: 1.0)
        subtitle.position = CGPoint(x: size.width / 2, y: size.height * 0.62)
        addChild(subtitle)
        
        // New Game Button
        let newGameButton = createButton(
            text: "NEW GAME",
            position: CGPoint(x: size.width / 2, y: size.height * 0.45),
            name: "newGame"
        )
        addChild(newGameButton)
        
        // Continue Button (disabled if no save)
        let continueButton = createButton(
            text: "CONTINUE",
            position: CGPoint(x: size.width / 2, y: size.height * 0.35),
            name: "continue"
        )
        continueButton.alpha = 0.5 // TODO: Enable when save exists
        addChild(continueButton)
        
        // Quit Button
        let quitButton = createButton(
            text: "QUIT",
            position: CGPoint(x: size.width / 2, y: size.height * 0.25),
            name: "quit"
        )
        addChild(quitButton)
    }
    
    func createButton(text: String, position: CGPoint, name: String) -> SKNode {
        let button = SKShapeNode(rectOf: CGSize(width: 300, height: 60), cornerRadius: 8)
        button.fillColor = SKColor(red: 0.3, green: 0.25, blue: 0.2, alpha: 1.0)
        button.strokeColor = SKColor(red: 0.8, green: 0.7, blue: 0.5, alpha: 1.0)
        button.lineWidth = 3
        button.position = position
        button.name = name
        
        let label = SKLabelNode(fontNamed: "Copperplate-Bold")
        label.text = text
        label.fontSize = 28
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
                handleButtonClick(name)
            }
        }
    }
    
    func handleButtonClick(_ buttonName: String) {
        switch buttonName {
        case "newGame":
            // Transition to character select
            let characterSelectScene = CharacterSelectScene(size: size)
            characterSelectScene.scaleMode = scaleMode
            view?.presentScene(characterSelectScene, transition: SKTransition.fade(withDuration: 0.5))
            
        case "continue":
            // TODO: Load saved game
            break
            
        case "quit":
            NSApplication.shared.terminate(nil)
            
        default:
            break
        }
    }
}
