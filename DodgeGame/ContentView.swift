//
//  ContentView.swift
//  DodgeGame
//
//  Created by Tom Scott on 11/13/23.
//

import SwiftUI
import SpriteKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

var scene: SKScene {
    let scene = MenuScene()
    scene.size = CGSize(width: screenWidth, height: screenHeight)
    scene.scaleMode = .fill
    scene.backgroundColor = .black
    return scene
}

struct ContentView: View {
    var body: some View {
        VStack {
            SpriteView(scene: scene)
                .frame(width: screenWidth, height: screenHeight)
                .ignoresSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

