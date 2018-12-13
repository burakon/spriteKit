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
    // 鳥がぶつかりそうになる緑色の竹(下に表示するからBottom)
    var pipeBottom = SKSpriteNode()
    
    // SKNodeは画像が使えない、見えない物体のみの存在。いるんだけど見えないものです。(何のために使うかはまだ説明がないので後述します)
        // SKNode -> 画像をつけることができない
    var blockingObjects = SKNode()
    
    // ----スコアに関係するもの
    
    // 何秒の間ゲームオーバーにならずにあそべたか、プレイ時間をスコアにしたもの。数字が入る
    var score = Int(0)
    // スコアを表示するためのラベルを作る
    var scoreLabel = SKLabelNode()
    
    // ---タイマー(時間を管理するもの)
    
    // createStageTimer ステージをつくるために必要なタイマーを作る
    var createStageTimer = Timer()
    // scoreTimer スコア(プレイ時間)を管理するためのタイマーを作る
    var scoreTimer = Timer()
    
    // スコアを入れる文字を作る
    var scoreString = String()
    
    
    
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
    func createParts() {
        
        // 初期化
        bird = SKSpriteNode()
        gameOverImage = SKSpriteNode()
        blockingObjects = SKNode()
        
        score = Int(0)
        
        // ----背景(backView)を作る関数(2枚の背景が動くことを確認したら、関数にしてみよう)
        createBackView()
        
        // ----スコアラベルを作る
        //初期化
        scoreLabel = SKLabelNode()
        // SKSceneにあるscoreLabelを取得する(必要性がわからないので一旦コメントアウト)
        // scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
        // scoreの数字を取得して表示する
        scoreLabel.text = "\(score)"
        // 文字の色は白(好きな色選んでね)
        scoreLabel.color = UIColor.white
        // 文字の大きさ
        scoreLabel.fontSize = 50
        // 好きな文字の種類を選ぼう(どう選ぼう？)
        scoreLabel.fontName = "HelveticaNeue-Bold"
        // zポジション おくいきを表す。大きいほど手前に、小さいほど奥にいく
        scoreLabel.zPosition = 14
        
        // ----スコアラベルの背景を作る
        let scoreBackView = SKShapeNode()
        scoreBackView.position = CGPoint(x: 0, y: 0)
        scoreBackView.path = CGPath(roundedRect: CGRect(x: CGFloat (-50), y: CGFloat (-30), width: CGFloat(100), height: CGFloat(100)),
                                    cornerWidth: 50, cornerHeight: 50, transform: nil)
        // strokeColor = 透明
        scoreBackView.strokeColor = UIColor.clear
        // 塗りつぶす色 = すきなの選んでね
        scoreBackView.fillColor = UIColor.gray
        // 奥域を文字の14よりも奥にするので13にする
        scoreBackView.zPosition = 13
        // scoreBackViewをscoreLabelに描画する
        scoreLabel.addChild(scoreBackView)
        // ラベルが表示されていることを確認しよう！(そのあとコメントアウトしてる)
        // self.addChild(scoreLabel)
        
        // ----
        
        // createStageTimer ステージを作るために必要なタイマーを初期化
        createStageTimer = Timer()
        // scoreTimer スコア(プレイ時間)を管理するためのタイマーを初期化
        scoreTimer = Timer()
        
        // ----
        
        // 重力を感じる世界にする
        self.physicsWorld.contactDelegate = self
        // 重力を設定、リアルな地球は dx 0, dy -9.8
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        
        // ----
        
        // この辺りまだいまいちわからない
        // 再プレイする時に必要になる初期化
        blockingObjects.removeAllChildren()
        // 初期化
        gameOverImage = SKSpriteNode()
        // 新しく描画
        self.addChild(blockingObjects)
        
        
        // ----gameover画面作成
        
        // テクスチャー作る、画像を直接spritnodeにつけられないのでテクスチャーを作る必要がある
        let gameOverTexture = SKTexture(imageNamed: "GameOverImage.jpg")
        gameOverImage = SKSpriteNode(texture: gameOverTexture)
        gameOverImage.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        // 鳥とか障害より奥にする
        gameOverImage.zPosition = 11
        // 描画しておく
        self.addChild(gameOverImage)
        // 描画するけど、ゲームオーバーになるまで隠しておく(これをかかないと最初から最後までずっとgameoverが表示される、ぜひ表示してみてね)
        gameOverImage.isHidden = true
        
        // ----鳥を作ろう
        
        // テクスチャーを作る
        let birdTexture = SKTexture(imageNamed: "bird.png")
        // テクスチャーを貼る
        bird = SKSpriteNode(texture: birdTexture)
        // 鳥の位置を決める
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        // 鳥に当たり判定をつける
        // 高さの半分の直系の当たり判定の円を作る
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.height/2)
        // 物理的なリアクションが取れる（はねかえる、とか）
        bird.physicsBody?.isDynamic = true
        // ころころ回らないようにする
        bird.physicsBody?.allowsRotation = false
        
        
        // ----鳥にカテゴリーをつける、表示する

        // 鳥はカテゴリー1 にする
        bird.physicsBody?.categoryBitMask = 1
        // カテゴリー2 のものにぶつかった時に衝突判定するように設定する
        bird.physicsBody?.collisionBitMask = 2
        bird.physicsBody?.contactTestBitMask = 2
        
        // 鳥と障害物は同じzPositionにしよう
        bird.zPosition = 10
        
        // 鳥を表示する
        self.addChild(bird)
        
        
        // ----地面に落ちたらゲームオーバーになるようにする
        
        // groundは地面だけで画像は表示しないのでSKNodeにする
        let ground = SKNode()
        ground.position = CGPoint(x: -325, y: -700)
        // 大きさを設定、幅は画面の横幅、高さは１
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        // 物理影響を受けないので下に落ちないようになる
        ground.physicsBody?.isDynamic = false
        
        // 鳥がカテゴリー2のものとぶつかるとゲームオーバーにしたいので、2にする
        ground.physicsBody?.categoryBitMask = 2
        // blockingObjectsに描画
        blockingObjects.addChild(ground)
        
        // ----4秒ごとに障害物(パイプ)を作成するタイマーを動かす
        
        createStageTimer = Timer.scheduledTimer(timeInterval: 4,
                                                target: self,
                                                selector: #selector(createPipe),
                                                userInfo: nil,
                                                repeats: true)
        
        // ---- 1秒ごとにscoreをプラスしていくタイマーを動かす
        
        createStageTimer = Timer.scheduledTimer(timeInterval: 1,
                                                target: self,
                                                selector: #selector(updateScore),
                                                userInfo: nil,
                                                repeats: true)
        

    }
    
    // １秒ごとにスコアをどんどんプラスしていく
    @objc func updateScore() {
        score = score + 1
        scoreLabel.text = "\(score)"
    }
    
    // 障害物を作成する、上下のもの、高さをランダムに変えていく
    @objc func createPipe() {
        
        // ----パイプを作るのに必要な情報を定義
        let randomLength = arc4random() % UInt32(self.frame.size.height / 2)
        // 引きたい数(命名変えたい)
        let offset = CGFloat(randomLength) - self.frame.size.height / 4
        // 真ん中の鳥が通る空間
        let gap = bird.size.height * 3
        
        // ----上のパイプを作る
        // テクスチャーを作成
        let pipeTopTexture = SKTexture(imageNamed: "pipeTopImage.png")
        // テクスチャーを貼り付け
        pipeTop = SKSpriteNode(texture: pipeTopTexture)
        // 後で良い計算式考えて
        pipeTop.position = CGPoint(x: self.frame.midX + self.frame.width / 2,
                                   y: self.frame.midY + pipeTop.size.height / 2 + gap / 2 + offset)
        // ぶつかり判定をする大きさを指定
        pipeTop.physicsBody = SKPhysicsBody(rectangleOf: pipeTop.size)
        // 重さを与えるかどうか( false -> 重さがないので落ちない)
        pipeTop.physicsBody?.isDynamic = false
        
        // 鳥とぶつかってゲームオーバーにしたいので、鳥とぶつかるようにカテゴリーを2にする
        pipeTop.physicsBody?.categoryBitMask = 2
        // blockingObjectsにaddChild
        blockingObjects.addChild(pipeTop)
        
        // ----下のパイプを作る

        // テクスチャーを作成
        let pipeBottomTexture = SKTexture(imageNamed: "pipeBottomImage.png")
        // テクスチャーを貼り付け
        pipeBottom = SKSpriteNode(texture: pipeBottomTexture)
        // 後で良い計算式考えて
        pipeBottom.position = CGPoint(x: self.frame.midX + self.frame.width / 2,
                                   y: self.frame.midY - pipeBottom.size.height / 2 - gap / 2 + offset)
        // ぶつかり判定をする大きさを指定
        pipeBottom.physicsBody = SKPhysicsBody(rectangleOf: pipeBottom.size)
        // 重さを与えるかどうか( false -> 重さがないので落ちない)
        pipeBottom.physicsBody?.isDynamic = false
        // 鳥とぶつかってゲームオーバーにしたいので、鳥とぶつかるようにカテゴリーを2にする
        pipeBottom.physicsBody?.categoryBitMask = 2
        // blockingObjectsにaddChild
        blockingObjects.addChild(pipeBottom)

        // ----パイプに動きをつける
        let pipeMove = SKAction.moveBy(x: -self.frame.width, y: 0, duration: 4 )
        pipeTop.run(pipeMove)
        pipeBottom.run(pipeMove)
        
        
    }
    
    
    // 背景(backView)を作る関数
    func createBackView() {
        // 背景(backView)を作ろう
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
        
        // 1枚だけでは黒い画面が見えてしまうので、2枚目を作ろう
        // backView2に画像bg.pngを入れる
        let backView2 = SKSpriteNode(imageNamed: "bg.png")
        // 最初に置く場所を決める (初期位置をbackViewと変える)
        backView2.position = CGPoint(x: self.frame.width, y: 0)
        //動かし続ける repeatForever
        backView2.run(SKAction.repeatForever(SKAction.sequence([
            // 13秒かけて右から左にbackViewが動く(位置をbackViewと変える)
            SKAction.moveTo(x: 0, duration: 13.0),
            // 13秒かけて動き終わったら最初の位置にすぐ戻る(位置をbackViewと変える)
            SKAction.moveTo(x: self.frame.width, duration: 0.0)
            ])))
        // backView2を表示する
        self.addChild(backView2)
    }
    
    // ----delegateメソッドを書いていく
    // 衝突した場合に呼ばれる関数
    func didBegin(_ contact: SKPhysicsContact) {
        // ぶつかったら止まるようにする(息の根を止める
        blockingObjects.speed = 0
        
        // ゲームオーバーイメージを表示させる
        gameOverImage.isHidden = false
        
        // 時間を止める
        scoreTimer.invalidate()
        createStageTimer.invalidate()
        
        // scoreをゼロにする(なんで？説明できない
        score = 0
        // label初期化
        scoreLabel.removeAllChildren()
        
        // blockingObjectsに乗っている全てに子供を削除、全てのやりかけの行動も削除
        blockingObjects.removeAllActions()
        blockingObjects.removeAllChildren()
        
        // ----セーブデータを比較して、今までのスコアより大きければ更新する
        let ud = UserDefaults.standard
        // userDefaultに入っているsaveDataを取得する
        self.scoreString = ud.object(forKey: "saveData") as! String
        
        // セーブデータのscoreStringと、今プレイしたゲームのscoreLabelの文字をくらべて、今プレイしたゲームのscoreLabelが大きかったら
        if Int(self.scoreString)! < Int(scoreLabel.text!)! {
            // saveDataとしてuserDefaultsに保存する
            ud.set(scoreLabel.text, forKey: "saveData")
        }
        
        // ----音楽を止める
        self.removeAction(forKey: "backSound")
        self.removeAction(forKey: "jumpSound")
    }

    // ----タッチした時の処理を書こう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // ----ゲームオーバー中だったら
        if gameOverImage.isHidden == false {
            
            // ----再度ゲームをはじめる
            // ゲームオーバーイメージを隠す
            gameOverImage.isHidden = true
            // 鳥を初期化
            bird.removeFromParent()
            // 再度ゲームを起動するのでゲームに必要なパーツを作る
            createParts()
        } else {
          // ---- else ゲームプレイ中の場合
            
            // 鳥の動きを一度止める(よくわかってない)
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            // y軸に力を与えて、500の力でジャンプさせる
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
            run(jumpSound)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
