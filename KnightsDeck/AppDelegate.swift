//
//  AppDelegate.swift
//  KnightsDeck
//
//  Application lifecycle
//

import Cocoa
import SpriteKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create window
        let windowWidth: CGFloat = 1280
        let windowHeight: CGFloat = 780
        
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: windowWidth, height: windowHeight),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "Knight's Deck"
        window.makeKeyAndOrderFront(nil)
        window.center()
        
        // Set up the game view controller
        let viewController = GameViewController()
        window.contentViewController = viewController
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Save game state if needed
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
