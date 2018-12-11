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
    
    // ---- ゲームに必要な主人公をつくろう
    
    // 飛ぶ鳥 bird を作る
        // SKSpriteNode -> 画像をつけることができる
    var bird = SKSpriteNode()
    // ゲームオーバー時の画像を作る
    var gameOverImage = SKSpriteNode()
    // タップ時に鳥が跳ねる音を作る
    let jumpSound = SKAction.playSoundFileNamed("sound.mp3", waitForCompletion: false)
    // バックグラウンドの音楽(BGM)を作る https://maoudamashii.jokersounds.com/ 自分の好きな曲使ってください
    let backSound = SKAction.playSoundFileNamed("buckSound.mp3", waitForCompletion: false)
    
    
    // ----ゲームに必要な登場人物をひとつずつ作っていくよ
    
    // 鳥がぶつかりそうになる緑色の竹(上に表示するからTop)
    var pipeTop = SKSpriteNode()
    
    // SKNodeは画像が使えない、見えない物体のみの存在。いるんだけど見えないものです。(何のために使うかはまだ説明がないので後述します)
        // SKNode -> 画像をつけることができない
    var blockingObjects = SKNode()
    
    // ----スコアに関係するもの
    
    // 何秒の間ゲームオーバーにならずにあそべたか、プレイ時間をスコアにしたもの。数字が入る
    var score = Int(0)
    // スコアを表示するためのラベルを作る
    var scoreLabel = SKLabelNode()
    
    // ---タイマー(時間を管理するもの)
    
    // 背景を動かすためのタイマー
    // backGroundTimer 背景を動かすために必要なタイマーを作る
    var backGroundTimer = Timer()
    // scoreTimer スコア(プレイ時間)を管理するためのタイマーを作る
    var scoreTimer = Timer()
    
    // LINEに投稿するための文字を作る
    var LineString = String()
    
    override func didMove(to view: SKView) {
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
