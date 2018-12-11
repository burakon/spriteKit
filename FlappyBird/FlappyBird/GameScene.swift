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
    let jumpSound = SKAction.playSoundFileNamed("jumpSound.mp3", waitForCompletion: false)
    // バックグラウンドの音楽(BGM)を作る https://maoudamashii.jokersounds.com/ 自分の好きな曲使ってください
    let backSound = SKAction.playSoundFileNamed("backSound.mp3", waitForCompletion: false)
    
    
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
    
    
    
    // アプリ起動時(ゲーム開始時)に呼ばれる
    override func didMove(to view: SKView) {
        
        // 音楽を流す
            // 下記2行を書いたところでアプリを起動すると、両方の音楽がアプリ起動と同時に流れるのでビルドしてもらいたい
        self.run(backSound, withKey: "backSound")
        self.run(jumpSound, withKey: "jumpSound")
        
        // ↑で作った登場人物を表示するための関数を書く
        createParts()
    }
    
    // 登場人物を表示するための関数
    func createParts(){
        
        // 背景(backGroundView)を作ろう
        // backViewに画像bg.pngを入れる
        let backView = SKSpriteNode(imageNamed: "bg.png")
        // 最初に置く場所を決める
        backView.position = CGPoint(x: 0, y: 0)
        //動かし続ける repeatForever
        backView.run(SKAction.repeatForever(SKAction.sequence([
            // 13秒かけて右から左にbackViewが動く
            SKAction.moveTo(x: -self.size.width, duration: 13.0),
            // 13秒かけて動き終わったら最初の位置にすぐ戻る
            SKAction.moveTo(x: 0, duration: 0.0)
            ])))
        // backViewを表示する
        self.addChild(backView)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
