//
//  MenuScene.swift
//  DodgeGame
//
//  Created by Tom Scott on 12/5/23.
//
// * MultiLine Text in a SpriteKit scene (Solved by blocksberg01): https://developer.apple.com/forums/thread/82994

import SpriteKit

class MenuScene: SKScene {
    // Screen bounds
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // Styling properties
    let fontName = "Geneva"
    let textColor = UIColor.white
    
    // SK Nodes
    var startButton = SKSpriteNode()
    let titleLabel = SKLabelNode(text: "Maze Game")
    let descriptionLabel = SKLabelNode(text: "Rules: Drag the red sprite along the screen to dodge the moving enemies. The player will have three lives per level. Reach the green goal at the top to advance the level. Hitting the blue enemy sprites will lose one life, and if you lose all lives, the game ends. Complete all levels to win the game!")
    
    // Establish the menu buttons
    override func didMove(to view: SKView) {
        createMenu()
    }

    func createMenu() {
        titleLabel.name = "title"
        titleLabel.color = textColor
        titleLabel.fontName = fontName
        titleLabel.fontSize = 36
        titleLabel.position = CGPoint(x: 204, y: 600)
        
        startButton.name = "startGame"
        startButton.size = CGSize(width: 200, height: 60)
        startButton.color = .green
        startButton.position = CGPoint(x: 204, y: 517)
        startButton.texture = SKTexture(imageNamed: "StartButton.png")
        
        
        descriptionLabel.color = textColor
        descriptionLabel.fontName = fontName
        descriptionLabel.fontSize = 18
        descriptionLabel.position = CGPoint(x: 204, y: 300)
        
        // MultiLine Formatting
        descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.preferredMaxLayoutWidth = screenWidth - 20
        
        self.addChild(titleLabel)
        self.addChild(startButton)
        self.addChild(descriptionLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "startGame" {
                startGame()
            }
        }
    }
    
    func startGame() {
        let transition = SKTransition.crossFade(withDuration: 2)
        let newScene = GameScene()
        newScene.level = 0
        newScene.size = CGSize(width: screenWidth, height: screenHeight)
        newScene.scaleMode = .fill
        newScene.backgroundColor = .black
        self.view?.presentScene(newScene, transition: transition)
    }
}
