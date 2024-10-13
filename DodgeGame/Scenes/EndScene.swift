//
//  EndScene.swift
//  DodgeGame
//
//  Created by Tom Scott on 12/6/23.
//

import SpriteKit

class EndScene: SKScene {
    // Screen bounds
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // Styling properties
    let fontName = "Geneva"
    let textColor = UIColor.white
    
    // SK Nodes
    var statusLabel = SKLabelNode()
    let restartButton = SKSpriteNode()
    let menuButton = SKSpriteNode()
    
    // Establish the menu buttons
    override func didMove(to view: SKView) {
        createMenu()
    }

    func createMenu() {
        statusLabel.name = "status"
        statusLabel.color = textColor
        statusLabel.fontName = fontName
        statusLabel.fontSize = 36
        statusLabel.position = CGPoint(x: 204, y: 600)
        
        restartButton.name = "restartGame"
        restartButton.size = CGSize(width: 200, height: 60)
        restartButton.color = .green
        restartButton.position = CGPoint(x: 204, y: 517)
        restartButton.texture = SKTexture(imageNamed: "RestartButton.png")
        
        menuButton.name = "mainMenu"
        menuButton.size = CGSize(width: 200, height: 60)
        menuButton.color = .red
        menuButton.position = CGPoint(x: 204, y: 417)
        menuButton.texture = SKTexture(imageNamed: "MainMenuButton.png")
        
        self.addChild(statusLabel)
        self.addChild(restartButton)
        self.addChild(menuButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "restartGame" {
                restartGame()
            } else if touchedNode.name == "mainMenu" {
                mainMenu()
            }
        }
    }
    
    func restartGame() {
        let transition = SKTransition.crossFade(withDuration: 2)
        let newScene = GameScene()
        newScene.level = 0
        newScene.size = CGSize(width: screenWidth, height: screenHeight)
        newScene.scaleMode = .fill
        newScene.backgroundColor = .black
        self.view?.presentScene(newScene, transition: transition)
    }
    
    func mainMenu() {
        let transition = SKTransition.crossFade(withDuration: 2)
        let newScene = MenuScene()
        newScene.size = CGSize(width: screenWidth, height: screenHeight)
        newScene.scaleMode = .fill
        newScene.backgroundColor = .black
        self.view?.presentScene(newScene, transition: transition)
    }
}
