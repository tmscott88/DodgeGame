//
//  GameScene.swift
//  DodgeGame
//
//  Created by Tom Scott on 12/5/23.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // Screen bounds
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // Styling properties
    let fontName = "Geneva"
    let textColor = UIColor.white
    
    // SK Nodes
    let player = SKSpriteNode()
    let goal = SKSpriteNode()
    let levelText = SKLabelNode()
    var livesText = SKLabelNode()
    var collided: Bool = false
    
    struct PhysicsCategory {
        static let Enemy: UInt32 = 1
        static let Player: UInt32 = 2
        static let Goal: UInt32 = 4
    }
    
    // Game state properties
    var level: Int = 0
    let maxLevel: Int = 3
    var lives: Int = 3
    let maxLives: Int = 3
    
    // Runs when the scene has loaded into a View
    override func didMove(to view: SKView) {
        // Configure collisions
        self.physicsWorld.contactDelegate = self
        generateEnemies()
        createPlayer()
        createGoal()
        createUIText()
    }
    
    func generateEnemies() {
        var startX = 50
        var startY = 500
        
        switch level {
        case 0:
            // Easy Spawn Pattern
            for _ in 1...5 {
                // Spawn an Enemy at these coordinates with this color
                createEnemy(pos: CGPoint(x: startX, y: startY), color: .blue)
                // This must increment more than the Enemy's size
                startX += 50
            }
        case 1:
            // Medium Spawn Pattern
            for _ in 1...3 {
                createEnemy(pos: CGPoint(x: startX - 30, y: startY), color: .blue)
                startX += 30
                startY += 60
            }
            for _ in 1...3 {
                createEnemy(pos: CGPoint(x: startX, y: startY - 200), color: .blue)
                startX += 30
                startY += 60
            }
        case 2:
            // Hard Spawn Pattern
            for _ in 1...4 {
                // Spawn an Enemy at these coordinates with this color
                createEnemy(pos: CGPoint(x: startX, y: startY), color: .blue)
                // This must increment more than the Enemy's size
                startX += 50
            }
        default:
            return
        }
    }
    
    // Create an "enemy" entity
    func createEnemy(pos: CGPoint, color: UIColor) {
        
        // Animation Sequences
        var sequence: SKAction
        var repeatSequence: SKAction
        
        // Basic Properties
        let enemy = SKSpriteNode()
        enemy.size = CGSize(width: 25, height: 25)
        enemy.color = color
        enemy.position = pos
        enemy.name = "enemy"
        
        // Physics Properties
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.frame.size)
        enemy.physicsBody?.isDynamic = false
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.usesPreciseCollisionDetection = true
        
        // Check for collision with the Player
        enemy.physicsBody!.categoryBitMask = PhysicsCategory.Enemy
        enemy.physicsBody!.contactTestBitMask = PhysicsCategory.Player
        
        // Add the enemy (node) to the end of the GameScene's list
        self.addChild(enemy)
        
        switch level {
        case 0:
            // Animation Set 1 (ensure these move further than the enemy's size)
            let moveRight = SKAction.move(by: CGVector(dx: 100, dy: 0), duration: 1.0)
            let moveLeft = SKAction.move(by: CGVector(dx: -100, dy: 0), duration: 1.0)
            let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 1.0)
            let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 1.0)
            let wait = SKAction.wait(forDuration: 0.25)
    
            // Animation Sequence 1
            // RIGHT, DOWN, LEFT, UP, WAIT
            
            // Compile the animation sequence
            sequence = SKAction.sequence([moveRight, moveDown, moveLeft, moveUp, wait])
            // Repeat the animation sequence until the scene ends
            repeatSequence = SKAction.repeatForever(sequence)
            // Execute the animation sequence
            enemy.run(repeatSequence)
        case 1:
            // Animation Set 2
            let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 0.75)
            let moveRight = SKAction.move(by: CGVector(dx: 100, dy: 0), duration: 0.75)
            let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 0.75)
            let moveLeft = SKAction.move(by: CGVector(dx: -100, dy: 0), duration: 0.75)
            
            // Animation Sequence 2
            // DOWN, RIGHT, UP, RIGHT, DOWN, UP, LEFT, DOWN, LEFT, UP
            sequence = SKAction.sequence([moveDown, moveRight, moveUp, moveRight, moveDown, moveUp, moveLeft, moveDown, moveLeft, moveUp])
            repeatSequence = SKAction.repeatForever(sequence)
            enemy.run(repeatSequence)
        case 2:
            // Animation Set 3
            let moveDownRight = SKAction.move(by: CGVector(dx: 100, dy: -100), duration: 0.5)
            let moveUpRight = SKAction.move(by: CGVector(dx: 100, dy: 100), duration: 0.5)
            let moveLeft = SKAction.move(by: CGVector(dx: -100, dy: 0), duration: 0.5)
            let moveRight = SKAction.move(by: CGVector(dx: 100, dy: 0), duration: 0.5)
            let moveUp = SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 0.5)
            let moveDown = SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 0.5)
            let wait = SKAction.wait(forDuration: 0.25)
            
            // Animation Sequence 3
            // DOWN-RIGHT DIAG, LEFT, UP-RIGHT DIAG, LEFT, WAIT, DOWN, RIGHT, UP, LEFT
            sequence = SKAction.sequence([moveDownRight, moveLeft, moveUpRight, moveLeft, wait, moveDown, moveRight, moveUp, moveLeft])
            repeatSequence = SKAction.repeatForever(sequence)
            enemy.run(repeatSequence)
        default:
            return
        }
    }
    
    func createPlayer() {
        player.size = CGSize(width: 50, height: 50)
        player.color = UIColor.red
        // Set X position halfways on the screen, Y position relative to the bottom of the screen
        player.position = CGPoint(x: screenWidth / 2, y: UIScreen.main.bounds.minY + 100)
        
        // Physics Properties
        player.physicsBody = SKPhysicsBody(rectangleOf: player.frame.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.usesPreciseCollisionDetection = true
        
        // Check for collision with an Enemy
        player.physicsBody!.categoryBitMask = PhysicsCategory.Player
        player.physicsBody!.contactTestBitMask = PhysicsCategory.Enemy
        
        // Add the player (node) to end of the GameScene's list
        self.addChild(player)
    }
    
    func createGoal() {
        goal.size = CGSize(width: 50, height: 50)
        goal.color = UIColor.green
        // Set X position halfways on the screen, Y position relative to the top of the screen
        goal.position = CGPoint(x: screenWidth / 2, y: screenHeight - 100)
        
        // Physics Properties
        goal.physicsBody = SKPhysicsBody(rectangleOf: goal.frame.size)
        goal.physicsBody!.affectedByGravity = false
        goal.physicsBody!.usesPreciseCollisionDetection = true
        
        // Check for collision with the Player
        goal.physicsBody!.categoryBitMask = PhysicsCategory.Goal
        goal.physicsBody!.contactTestBitMask = PhysicsCategory.Player
        
        // Add the goal (node) to end of the GameScene's list
        self.addChild(goal)
    }
    
    func createUIText() {
        // Level Indicator
        levelText.color = textColor
        levelText.fontName = fontName
        levelText.fontSize = 18
        levelText.position = CGPoint(x: 60, y: screenHeight - 100)
        
        // Lives Indicator
        livesText.color = textColor
        livesText.fontName = fontName
        livesText.fontSize = 18
        livesText.position = CGPoint(x: screenWidth - 50, y: screenHeight - 100)
        
        levelText.text = "Level: \(level + 1) of \(maxLevel)"
        livesText.text = "Lives: \(lives)/\(maxLives)"
        
        self.addChild(levelText)
        self.addChild(livesText)
    }
    
    func updateLives() {
        lives -= 1
        livesText.text = "Lives: \(lives)/\(maxLives)"
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let newLocation = CGPoint(x: location.x, y: location.y)
            let move = SKAction.move(to: newLocation, duration: 0.1)
            player.run(move)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Define collision object, check Player against the collider bodies
        let collisionObject = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        
        // If the Player collides with an Enemy, decrement lives and check if the level should reset or end the game
        if !(collided) {
            if collisionObject.categoryBitMask == PhysicsCategory.Enemy {
                collided = true
                // Delete the Player on collision
                contact.bodyB.node?.removeFromParent()
                // Decrement the lives count
                updateLives()
                // If lives reach zero, show lose screen. Otherwise, restart the level
                if (lives <= 0) {
                    endGame(success: false)
                } else {
                    restart(level: level, lives: lives)
                }
            }
            // If the Player collides with the Goal, next level/Game Over (success)
            else if collisionObject.categoryBitMask == PhysicsCategory.Goal {
                nextLevel()
            }
        }
    }
    
    func restart(level: Int, lives: Int) {
        let transition = SKTransition.crossFade(withDuration: 2)
        let newScene = GameScene()
        newScene.lives = lives
        newScene.level = level
        newScene.size = CGSize(width: screenWidth, height: screenHeight)
        newScene.scaleMode = .fill
        newScene.backgroundColor = .black
        self.view?.presentScene(newScene, transition: transition)
    }
    
    func endGame(success: Bool) {
        // If success, show end game scene, otherwise game over
        let transition = SKTransition.crossFade(withDuration: 2)
        let newScene = EndScene()
        newScene.size = CGSize(width: screenWidth, height: screenHeight)
        newScene.scaleMode = .fill
        newScene.backgroundColor = .black
        
        if (success) {
            newScene.statusLabel.text = "YOU WIN"
        } else {
            newScene.statusLabel.text = "YOU LOSE"
        }
        self.view?.presentScene(newScene, transition: transition)
    }
    
    func nextLevel() {
        level += 1
        // If level has reached the limit, show win screen. Otherwise, start the next level and reset lives
        if level == 3 {
            endGame(success: true)
        } else if level < 3 {
            restart(level: level, lives: maxLives)
        }
    }
}
    
