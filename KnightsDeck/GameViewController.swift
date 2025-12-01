//
//  GameViewController.swift
//  KnightsDeck
//
//  Main game view controller
//

import Cocoa
import SpriteKit

class GameViewController: NSViewController {
    
    var skView: SKView!
    
    override func loadView() {
        // Create SKView
        skView = SKView(frame: NSRect(x: 0, y: 0, width: 1280, height: 780))
        self.view = skView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        // Start with main menu
        if let scene = MainMenuScene(fileNamed: "MainMenuScene") {
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        } else {
            // Fallback: create scene programmatically
            let scene = MainMenuScene(size: CGSize(width: 1280, height: 780))
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
        }
    }
}
