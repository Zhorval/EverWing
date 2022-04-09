//
//  GameInfo.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
import Foundation
import SpriteKit

protocol GameInfoDelegate{
    
    var mainAudio:AVAudio {get}
    func addChild(_ sknode: SKNode)
    func changeGameState(_ state: GameState)
    func getCurrentToonNode() -> SKSpriteNode
    func createCloud()
    func loadBackground(scene:SKScene?)
    func addDMG() -> Int
    
    
}

class GameInfo: GameInfoDelegate{
    
    deinit {
        print ("GameInfo Class deinitiated!")
    }
    
    // Debug Variables
    private var counter:Int = 0 // only for debug - no purpose
    
    // Main Variables
    weak private var mainScene:SKScene?
    private var account:AccountInfo
    private var currentLevel:Int
    private var currentGold:Int  // tracking local current in-game
    private var currentHighscore:Int
    private var timer:Timer?
    static var infobar:Infobar?
    static var DMG = 15
    
    // Secondary Variables
    private var wavesForNextLevel:Int = 1
    private var gamestate:GameState
    private var timePerWave:Double // time to call each wave
    
    // Extra Variables - Maybe need to be removed later on
    private var spawningDelay:Int = 0
    var accountGoldLabel:HUD?
    
    // Public Variables
    var mainAudio:AVAudio
    var regular_enemies:EnemyModel
    var dragon:[DragonsModel]
    var boss:EnemyModel
    var fireball_enemy:EnemyModel
    var goblin:EnemyModel
    var cofre:EnemyModel
    var map:Map?
    
    
    
     init(){
        mainAudio = AVAudio()
        currentLevel = 0
        currentGold = 0
        currentHighscore = 0
        account = AccountInfo()
         
        // Models
         fireball_enemy = EnemyModel(type: .Fireball)
        regular_enemies = EnemyModel(type: .Regular)
        dragon = [
                DragonsModel(type: .Roa),
                    DragonsModel(type: .Bubbles)
                ]
        boss   =  EnemyModel(type: .Boss)
        goblin =  EnemyModel(type: .Goblin)
        cofre  =  EnemyModel(type: .Cofre)

        gamestate = .NoState
        timePerWave = 3.0 // 3.0 is default
         GameInfo.infobar = Infobar(name: "infobar")
         
        // delegates
        regular_enemies.delegate = self
        boss.delegate = self
        fireball_enemy.delegate = self
        cofre.delegate = self
        goblin.delegate = self
    }
    
    
    func loadTimerProjectileTemp() {
        GameInfo.infobar?.addTimeProjectileTemp()
    }
    
    func load(scene: SKScene) -> (Bool, String){
        
        var loadStatus:(Bool, String) = (true, "No errors")
        
        mainScene = scene
        
        // play background music
        mainAudio.play(type: .Background_Start)
        if !account.load(){
            return (false, "account error")
        }
        
        guard let infobar =  GameInfo.infobar else { return  (false,"Account error")}
        // update infobar
        addChild(infobar)
        
        loadStatus = self.createWalls()
        
        return loadStatus
    }
    
    /// Add level DMG when contact clover
    func addDMG() -> Int {
        GameInfo.DMG +=   account.getLevel() + 1
        GameInfo.infobar?.updatePanelDMG(level: GameInfo.DMG)
        return GameInfo.DMG
    }
    
    /// This function update background when player destroy Boss
    
    internal func loadBackground(scene:SKScene?) {
        
        guard let mainScene = scene else {
            return
        }

        map = Map(maps: SKTextureAtlas().loadAtlas(name: Global.Background.allCases.randomElement()!.rawValue, prefix: nil), scene: mainScene)
       
        map?.run()
    }
    
    
    // MARK: CREATE CLOUDS WHEN DEFEAD BOSS
    func createCloud() {
        
        guard let mainscene = mainScene else {
            print("Escena falsa")
            return
        }

        map?.prepareToChangeScene()
        map?.defeated()
        map =  nil
        
       
        // Cloud action
        let moveDownCloud = SKAction.moveTo(y: -screenSize.height*1.5, duration: 3)
        
        // Create 4 clouds
        for i in 0...3{
            let cloud = SKSpriteNode()
            if ( i % 2 == 0){
                cloud.texture = global.getMainTexture(main: .StartCloud_1)
                cloud.name = Global.Main.StartCloud_1.rawValue + String(i)
            }
            else{
                cloud.texture = global.getMainTexture(main: .StartCloud_2)
                cloud.name = Global.Main.StartCloud_2.rawValue + String(i)
            }
           
            cloud.size = CGSize(width: screenSize.width, height: screenSize.height*1.5)
            cloud.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            cloud.position = CGPoint(x: screenSize.width/2, y: screenSize.height)
            cloud.zPosition = 100
            mainscene.addChild(cloud)
            
            cloud.run(.sequence([moveDownCloud,.run{
                cloud.removeAllActions()
                cloud.removeFromParent()
            }]))
        }
        
        loadBackground(scene:mainscene)
    }
    
    // MARK: PHYSICS WALL SCREEN
    private func createWalls() -> (Bool, String){
        
        guard let mainscene = mainScene else{
            return (false, "mainScene is nil")
        }
        // create invisible wall
        
        let border = SKSpriteNode()
        border.name = "border"
        border.physicsBody = SKPhysicsBody(edgeLoopFrom:  mainscene.view!.bounds)
        border.physicsBody!.categoryBitMask = PhysicsCategory.Wall
        border.physicsBody?.isDynamic = false
        mainscene.addChild(border)
        
        return (true, "No errors")
    }

    private func didFinishSpawningEnemy(){
        mainScene!.run(SKAction.sequence([SKAction.run { [self] in
            self.changeGameState(.BossEncounter)
            // show boss incoming
            showMessageAlertBoss()

            }, SKAction.wait(forDuration: 5), SKAction.run {
                
                self.boss.spawn(scene: self.mainScene!)
                
            }]))
    }
    
    //  Only called when the gamestate is spawning. 
    //  This function is called every second.
    
    @objc private func running(){
        guard let mainScene = mainScene else {
            return
        }
        
        switch randomInt(min: 0, max: 100) {
            case 0..<10:
                fireball_enemy.spawn(scene: mainScene)
            case 10..<30:
                self.goblin.spawn(scene: self.mainScene!)
            case 30..<100:
                self.cofre.spawn(scene: self.mainScene!)
            default: break
        }
        
    }
    
    private func updateGameState(){
        guard let mainscene = mainScene else{
            print ("ERROR D00: Check updateGameState() from GameInfo")
            return
        }
        
        switch gamestate {
        case .Start:
            // Start timer game
            GameInfo.infobar?.addTime()
            
            // Show infobar level bullet
            mainscene.addChild(showInfoBulletScreen())
            
            mainscene.run(.repeatForever(mainAudio.getAction(type: .GameIntro)),withKey: "gameIntro")
            mainscene.run(.sequence([.wait(forDuration: 2),.run {
                mainscene.removeAction(forKey: "gameIntro")
            }]))
            
            let textures = SKTextureAtlas().loadAtlas(name: Global.Background.allCases.randomElement()!.rawValue, prefix: nil)
            
            // Load Map
            map = Map(maps: textures, scene: mainscene)
            // Load Map
           // map = Map(maps: global.getTextures(textures: .Map_Ragnarok), scene: mainscene)

            // Cloud action
            let moveDownCloud = SKAction.moveTo(y: -screenSize.height*1.5, duration: 1)
            
            // Buildings Action
            let scaleAction = SKAction.scale(to: 0.7, duration: 0.3)
            let moveAction = SKAction.moveTo(y: screenSize.height/3, duration: 0.3)
           
            let buildingsAction = SKAction.sequence([SKAction.run(SKAction.group([scaleAction, moveAction]), onChildWithName: "main_menu_middle_root"), SKAction.wait(forDuration: 1.5), SKAction.run {
                self.mainScene!.childNode(withName: "main_menu_middle_root")!.removeFromParent()
                self.mainScene!.childNode(withName: Global.Main.Main_Menu_Background_1.rawValue)!.removeFromParent()
                self.mainScene!.childNode(withName: Global.Main.Main_Menu_Background_2.rawValue)!.removeFromParent()
                self.mainScene!.childNode(withName: Global.Main.Main_Menu_Background_3.rawValue)!.removeFromParent()
                self.map!.run()
                
                }])
                
        
            // Create 4 clouds
            for i in 0...3{
                let cloud = SKSpriteNode()
                if ( i % 2 == 0){
                    cloud.texture = global.getMainTexture(main: .StartCloud_1)
                    cloud.name = Global.Main.StartCloud_1.rawValue + String(i)
                }
                else{
                    cloud.texture = global.getMainTexture(main: .StartCloud_2)
                    cloud.name = Global.Main.StartCloud_2.rawValue + String(i)
                }
                cloud.size = CGSize(width: screenSize.width, height: screenSize.height*1.5)
                cloud.anchorPoint = CGPoint(x: 0.5, y: 0)
                cloud.position = CGPoint(x: screenSize.width/2, y: screenSize.height)
                cloud.zPosition = -1
                mainscene.addChild(cloud)
            }
            
            // Running Actions
            GameInfo.infobar?.fadeAway()
        

            mainscene.run(SKAction.sequence([SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_1.rawValue + "0"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_2.rawValue + "1"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_1.rawValue + "2"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_2.rawValue + "3")]))
            
        
            mainscene.run(SKAction.sequence([
                buildingsAction,
                SKAction.wait(forDuration: 3),
                SKAction.run{
                    self.changeGameState(.Spawning)
                                       
                },
                    SKAction.wait(forDuration: 0.2), SKAction.run {
                        self.account.getCurrentToon().getNode().run(SKAction.repeatForever(SKAction.sequence([
                        SKAction.run { [self] in
                            
                                self.addChild(self.account.getCurrentToon().getBullet().shoot())
                                self.addChild(self.dragon[0].shoot())
                                self.addChild(self.dragon[1].shoot())
                        },
                        SKAction.wait(forDuration: 0.06)])))
                }
            ]))
            
        case .WaitingState:
            
            regular_enemies.increaseDifficulty()
            fireball_enemy.increaseDifficulty()
            boss.increaseDifficulty()
            self.changeGameState(.Spawning)
            
        case .Spawning:
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(running), userInfo: nil, repeats: true)
            
            /// Number total waves enemys  ATTENTION
            wavesForNextLevel = randomInt(min: 1, max: 2)
            
            let action = SKAction.sequence([SKAction.run({
            self.regular_enemies.spawn(scene: mainscene)
            self.cofre.spawn(scene: mainscene)
            self.goblin.spawn(scene: mainscene)
                
                
            }), SKAction.wait(forDuration: 1)])
            
            //totalWaves
            //wavesForNextLevel
            let spawnAction = SKAction.repeat(action, count: wavesForNextLevel)
            let endAction = SKAction.run(didFinishSpawningEnemy)
            
            
            mainscene.run(SKAction.sequence([spawnAction, endAction]))
            
        case .BossEncounter:
            // use this state to cancel the timer - invalidate
            timer?.invalidate()
       
        default:
            print("Current State: ", gamestate)
        }
    }
    
    // Info bar screen level bullet
    private func showInfoBulletScreen() ->SKSpriteNode{
        
        let icon = SKSpriteNode(imageNamed: "BulletButton")
        icon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        icon.position = CGPoint(x: screenSize.maxX-50 , y: screenSize.height*0.8)
        icon.zPosition = 100
        
        let textDMG = SKLabelNode(fontNamed: "Qebab Shadow FFP")
        textDMG.horizontalAlignmentMode = .right
        textDMG.name = "DMG"
        textDMG.fontSize = 20
        textDMG.fontColor = UIColor.red
        textDMG.text = String("\(GameInfo.DMG)")
        textDMG.position = CGPoint(x: icon.position.x - icon.frame.width/2, y: screenSize.height*0.8)
        self.addChild(textDMG)
        
        let levelBullet = account.getBulletLevelOfToonByIndex(index: account.getCurrentToonIndex())
        let iconBuller = BulletMaker().make(level: BulletMaker.Level(rawValue: levelBullet)!, char: account.getCurrentToon().getCharacter())
       
        if levelBullet > 30 {
            iconBuller.setScale(0.5)
        }
            icon.addChild(iconBuller)
        
        
        let level = SKLabelNode(fontNamed: "Cartwheel", andText: "Level \(account.getCurrentToon().getLevel())", andSize: 18, withShadow: .black,name:"ScreenLevelBulletShadow")
            level?.name = "ScreenLevelBullet"
            level?.position.y = -icon.frame.height/2
        icon.addChild(level!)
        
        return icon
        
    }

    /// Show message begin boss appears
    private func showMessageAlertBoss() {
        
        let shadow = boss.showShadowBoss()
            shadow.run(.sequence([.wait(forDuration: 3),.fadeOut(withDuration: 1),.run {
                shadow.removeFromParent()
                
            }]))
        
        addChild(shadow)
        
       addMessageBossAppear(type: boss)
    //   showMessageLateralBossAppear()
        if boss.bossType == .Spike || boss.bossType == .Mildred {
            
            showEffectFxBossAppears(typeBoss:boss,typeAudio: boss.bossType)
            guard let mainScene = mainScene else {
                return
            }
            mainScene.run(.wait(forDuration: 10))
        }
        
    }
    
    // Show effect Fx when appear Boss    
    private func showEffectFxBossAppears(typeBoss:EnemyModel,typeAudio:BossType) {
        
        var texture:String?
        var glaciar:Enemy?
        
        switch typeBoss.bossType {
            case .Mildred:
                 texture = "plants"
            case .Spike:
                texture = "Ice"
            case .Pinky,.Ice_Queen,.Monster_King,.Monster_Queen: break
        }
        
        let unitX = Int(round(Float(screenSize.width - 100) / 3))
        let unitY = Int(round(Float(screenSize.height) / 6))
        
       
        let ice = SKSpriteNode(texture: SKTexture(imageNamed: texture!), size: CGSize(width: 70, height: unitY))
        ice.run(typeBoss.bossType.audioFX)
        if typeBoss.bossType == .Mildred {
            ice.run(.repeatForever(.sequence([
                .resize(toWidth: 80, duration: 0.2),
                .resize(toWidth: 70, duration: 0.2),
            
            ])))
            
        }
        
        let texturePlant = SKTextureAtlas().loadAtlas(name: "Plants", prefix: nil)
        let isMilfred = typeBoss.bossType == .Mildred
       
        if isMilfred {
             glaciar = Enemy(texture: texturePlant.first!)
            glaciar!.run(.repeatForever(.sequence([
                .animate(with: texturePlant, timePerFrame: 0.5),
                .resize(toHeight: screenSize.height - 100, duration: 1)
                ])))
        } else {
             glaciar =  Enemy(imageNamed: "glaciar")
             glaciar?.Physics(speed: CGVector(dx: 0, dy: -700))
        }
        
     
        
            for x in 0...6 {
                
                guard let copyGlaciar = glaciar?.copy() as? Enemy else { return }
                copyGlaciar.name = "Enemy_Regular_\(x)"
                copyGlaciar.position = CGPoint(x: CGFloat(x * unitX) , y: screenSize.height-(copyGlaciar.frame.height)/2)
                
                copyGlaciar.run(.sequence([
                    .wait(forDuration: random(min: 1, max: 4)),
                    .run {
                        if !isMilfred {
                            SKAction.moveTo(y: 0, duration: 3)
                        }
                    },
                    
                    .run{ copyGlaciar.removeFromParent()}
                ]))
                addChild(copyGlaciar)
                
                
                let copy = ice.copy() as? SKSpriteNode
                if typeBoss.bossType == .Mildred {
                    copy?.xScale = -1
                }
                copy?.name = "ice_L\(x)"
                copy?.position = CGPoint(x: 10, y: (x * (unitY-20)))
                addChild(copy!)
                
                let copyR = ice.copy() as? SKSpriteNode
                copyR?.name = "ice_R\(x)"
                copyR?.position = CGPoint(x: Int(screenSize.maxX)-10, y: (x * (unitY-20)))
                addChild(copyR!)
            }
            
            guard let mainScene = mainScene else {
                return
            }

            mainScene.run(.wait(forDuration: 5), completion: {
                let _ = mainScene.children.map { (node:SKNode) in
                    if node.name?.contains("ice") == true {
                        node.removeFromParent()
                    }}})
        
    }
    
    //Show message lateral boss appears
    private func showMessageLateralBossAppear()  {
        guard let mainscene = mainScene else{
            print ("ERROR D00: Check showMessageAlertBoss() from GameInfo")
            return
        }
        
        let bgDangerAlertL = SKSpriteNode(color: .gray.withAlphaComponent(0.3), size: CGSize(width: 50, height: screenSize.height))
            bgDangerAlertL.position = CGPoint(x: screenSize.minX+10, y: screenSize.midY)
            bgDangerAlertL.name = "bgDangerAlertL"
            addChild(bgDangerAlertL)
        
            let bgDangerAlertR = bgDangerAlertL.copy() as? SKSpriteNode
            bgDangerAlertR?.position = CGPoint(x: screenSize.maxX-10, y: screenSize.midY)
        bgDangerAlertR?.name = "bgDangerAlertR"
            addChild(bgDangerAlertR!)
        
        let dangerAlertL = SKSpriteNode(imageNamed: "dangerBoss")
            dangerAlertL.name = "dangerAlarmL"
            dangerAlertL.size = CGSize(width: bgDangerAlertL.frame.width, height: bgDangerAlertL.frame.height)
            bgDangerAlertL.addChild(dangerAlertL)
        
        let dangerAlertR = dangerAlertL.copy() as? SKSpriteNode
            dangerAlertR?.xScale = -1
            dangerAlertR?.name = "dangerAlarmR"
            dangerAlertR?.size = CGSize(width: bgDangerAlertL.frame.width, height: bgDangerAlertL.frame.height)
            bgDangerAlertR?.addChild(dangerAlertR!)
        
        dangerAlertL.run(SKAction.blink)
        dangerAlertR?.run(SKAction.blink)
        
        let action = SKAction.repeatForever(mainAudio.getAction(type: .Boss_Alarm))
            mainscene.run(action,withKey: "audioBoss")
            mainscene.run(.sequence([
                .wait(forDuration: 5),.run {
                    mainscene.removeAction(forKey: "audioBoss")
                    mainscene.childNode(withName: "bgDangerAlertL")?.removeFromParent()
                    mainscene.childNode(withName: "bgDangerAlertR")?.removeFromParent()
                }]))
    }
    
    // Show message Boss type before appears
    private func addMessageBossAppear(type:EnemyModel) {
        
        let messageTypeBoss = SKSpriteNode(color: .black.withAlphaComponent(0.5), size: CGSize(width: 250, height: 75))
        messageTypeBoss.position = CGPoint(x: screenSize.width/2, y: screenSize.height-100)
        
        let label = SKLabelNode(fontNamed: "Cartwheel", andText: boss.bossType.rawValue, andSize: 30, withShadow: .white)
        label?.position = CGPoint(x: 0, y: -2)
        label?.fontColor = .yellow
        label?.text = boss.bossType.rawValue
        messageTypeBoss.addChild(label!)
        
        let weaknessLabel = SKLabelNode(fontNamed: "Cartwheel", andText: "WEAKNESS", andSize: 25, withShadow: .yellow)
        weaknessLabel?.position = CGPoint(x: 0, y: -35)
        weaknessLabel?.fontColor = .white
        weaknessLabel?.text = "WEAKNESS"
        messageTypeBoss.addChild(weaknessLabel!)
        
        let weaknessIcon = SKSpriteNode(texture: type.bossType.weakness, size: CGSize(width: 50, height: 50))
        weaknessIcon.position = CGPoint(x: messageTypeBoss.frame.width/2, y: 0)
        messageTypeBoss.addChild(weaknessIcon)
        
        addChild(messageTypeBoss)
        
        messageTypeBoss.run(.wait(forDuration: 2)) {
            messageTypeBoss.removeFromParent()
        }
    }
    
     func getCurrentToon() -> Toon{
        return account.getCurrentToon()
    }
     func getCurrentToonNode() -> SKSpriteNode{
       return account.getCurrentToon().getNode()
    }
    
     func requestCurrentToonIndex() -> Int{
        return account.getCurrentToonIndex()
    }    
    
     func getCurrentToonBullet() -> Projectile{
        return account.getCurrentToon().getBullet()
    }
    
     func duplicateToonBullet() {
          account.getCurrentToon().addLevel()
    }
    
     func getToonBulletEmmiterNode(x px:CGFloat, y py:CGFloat) -> SKEmitterNode{
        return account.getCurrentToon().getBullet().generateTouchedEnemyEmmiterNode(x: px, y: py)
    }
     func requestChangeToon(index: Int){
        self.account.selectToonIndex(index: index)
    }
     func requestToonDescription(index id:Int) -> [String]{
        return self.account.getToonDescriptionByIndex(index: id)
    }
    
     func requestToonName(index id:Int) -> String{
        return self.account.getNameOfToonByIndex(index: id)
    }
    
     func requestToonTitle(index id:Int) -> String{
        return self.account.getTitleOfToonByIndex(index: id)
    }
    
     func requestToonBulletLevel(index id:Int) -> Int{
        return self.account.getBulletLevelOfToonByIndex(index: id)
    }
    
     func requestUpgradeBullet() -> (Bool, String){
        let (success, response) = self.account.upgradeBullet()
        
        if success {
            GameInfo.infobar?.updateGoldBalanceLabel(balance: self.account.getGoldBalance())
        }
        return (success, response)
    }
    
     func prepareToChangeScene(){
        boss.delegate = nil
        regular_enemies.delegate = nil
        fireball_enemy.delegate = nil
        mainAudio.stop()
        map?.prepareToChangeScene()
        timer?.invalidate()
        
    }
    
     func addCoin(amount:Int){
        currentGold += amount
         GameInfo.infobar?.updateGoldLabel(coinCount: self.currentGold)
    }
    
     func getCurrentGold() -> Int{
        return self.currentGold
    }
    
    // delegate functions
     func addChild(_ sknode: SKNode){
        guard let mainscene = mainScene else{
            print ("Error:: mainScene does not exist - check Gameinfo Class/ addChild Function")
            return
        }
       
        mainscene.addChild(sknode)
    }
    
     func changeGameState(_ state: GameState){
        gamestate = state
        updateGameState()
    }
    
    
    
}
