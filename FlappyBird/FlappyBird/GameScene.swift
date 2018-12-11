//
//  GameScene.swift
//  FlappyBird
//
//  Created by Her on 2018/12/11.
//  Copyright © 2018 Her. All rights reserved.
//

import SpriteKit
import GameplayKit

// SKPhysicsContactDelegateを追加、物体と物体がぶつかった時に呼ばれるメソッド群
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // 飛ぶ鳥 bird を作る
    var bird = SKSpriteNode()
    // ゲームオーバー時の画像を作る
    var gameOverImage = SKSpriteNode()
    // タップ時に鳥が跳ねる音
    let jumpSound = SKAction.playSoundFileNamed("sound.mp3", waitForCompletion: false)
    // バックグラウンド音 https://maoudamashii.jokersounds.com/ 自分の好きな曲使ってください
    let backSound = SKAction.playSoundFileNamed("buckSound.mp3", waitForCompletion: false)
    
    override func didMove(to view: SKView) {
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
