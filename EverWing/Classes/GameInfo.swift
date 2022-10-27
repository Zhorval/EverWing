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
    
    var currentBullet:Int { get set }
    var mainAudio:AVAudio {get}
    var getGameState:GameState { get }
    var isMapStart:Bool? { get set}
    func addChild(_ sknode: SKNode)
    func changeGameState(_ state: GameState)
    func getCurrentToonNode() -> SKSpriteNode
    func createCloud(completion:@escaping(Bool)->Void)
    func loadBackground(scene:SKScene?,isStartMap:Bool)
    // CAMBIAR ESTA FUNCION POR LA DE LOADBACKGROUND
    func showEffectFxBossAppears(typeBoss:BossType)
    func stopAudio(type:AVAudio.BgroundSoundType)
    func getScene()->SKScene?
    
}

class GameInfo: GameInfoDelegate{
    
    deinit {
        print ("GameInfo Class deinitiated!")
    }
    
    // Debug Variables
    private var counter:Int = 0 // only for debug - no purpose
    
    // Main Variables
    weak private var mainScene:SKScene?
    //   private var accountInfo:AccountInfo = AccountInfo()
    
    var currentLevel:Int  = 1 {
        willSet {
            wavesForNextLevel = wavesForNextLevel + currentLevel
            currentBullet += 1
            
        }
    }
    
    var currentBullet =  1 {
        willSet {
            self.addChild(showInfoBulletScreen(level: newValue,isStartGame: false))
            MainScene.accountInfo.getCurrentToon().changeTextureProjectile(level: newValue)
        }
    }
    
    private var currentGold:Int  = 0 // tracking local current in-game
    private var currentHighscore:Int = 0
    private var timer:Timer?
    var infobar:Infobar = Infobar(name: "infobar")
    let DMG = 10
    
    // Secondary Variables
    private var wavesForNextLevel:Int = 3
    var gamestate:GameState = .NoState
    var getGameState: GameState {
        gamestate
    }
    private var timePerWave:Double  = 6// time to call each wave
    
    // Public Variables
    let mainAudio:AVAudio = AVAudio()
    var regular_enemies:EnemyModel?
    var dragon:[DragonsModel]?
    var boss:EnemyModel?
    var fireball_enemy:EnemyModel?
    var armored:EnemyModel?
    var buitre:EnemyModel?
    var cofre:EnemyModel?
    var map:Map?
    var isMapStart: Bool?
    static var currentPlayerPosition:CGPoint = .zero
    
    static var tableInfoBarEggs = CustomCollectionViewEggs(frame: CGRect(x: 10, y: 50, width: screenSize.width/2, height: 60),
                                                           items: Currency.EggsCurrencyType.items, view: nil,
                                                           isCollection: false) { _ in} handlerDeselect: { _ in} handlerTapAudio: {  }

  
    
     init(){
         
        // Models
        fireball_enemy = EnemyModel(type: .Fireball)
        regular_enemies = EnemyModel(type: .Regular)
  /*      dragon = [
                DragonsModel(type: .Roa),
                DragonsModel(type: .Bubbles)
                ]*/
        boss    =  EnemyModel(type: .Boss)
        armored =  EnemyModel(type: .Armored)
        cofre   =  EnemyModel(type: .Cofre)
        buitre  =  EnemyModel(type: .Buitre)
         
        // delegates
         regular_enemies?.delegate = self
         boss?.delegate = self
         fireball_enemy?.delegate = self
         cofre?.delegate = self
         armored?.delegate = self
         buitre?.delegate = self
         
    }
    
    
    
    func load(scene: SKScene,audio:AVAudio.BgroundSoundType = .Background_Start) -> (Bool, String){
        
        var loadStatus:(Bool, String) = (true, "No errors")
        
        mainScene = scene
        
        // play background music
        mainAudio.play(type: audio)
        
        if !MainScene.accountInfo.load(){
            return (false, "MainScene.accountInfo error")
        }
        
        addChild(infobar)
        
        
        loadStatus = self.createWalls()
        
        
        return loadStatus
    }
    
    /// This function update background when player destroy Boss
    func loadBackground(scene:SKScene?,isStartMap:Bool) {
        
        guard let mainScene = scene else {
            return
        }
        
        map = Map(maps: SKTextureAtlas().loadAtlas(name: Global.Background.allCases.randomElement()!.rawValue , prefix: nil), scene: mainScene)
        
        if isStartMap {
            map?.run()
            self.isMapStart = false
            
        }
    }
    
    //MARK: RETURN DELEGATE SCENE
    func getScene() -> SKScene? {
        guard let mainScene = self.mainScene  else { return nil }
        return mainScene
    }
    
    //MARK: CHOOSE AUDIO MENU SCENES
    func stopAudio(type: AVAudio.BgroundSoundType) {
        mainAudio.play(type: type)
    }
   
    // MARK: CREATE PANEL SETTINGS
    func showMenuSettings(scene:SKScene) {
        
        var result:Settings? = nil
        
        do {
            let request = Settings.fetchRequest()
            
            let data =  try (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.fetch(request)
            
                result =  data?.first
        } catch {
             fatalError()
        }
        let label = { (text:String,name:String,point:CGPoint)  -> SKLabelNode in
            
             let label = SKLabelNode()
                 label.fontName = "Cartwheel"
                 label.text = text
                 label.name = name
                 label.fontSize = 30
                 label.position = point
                 label.zPosition = 10
            
            return label
        }
        
        
        let bg = SKSpriteNode(imageNamed: "bgSettings")
            bg.color = .red
            bg.name = "bgSettings"
            bg.position = CGPoint(x: screenSize.midX, y: screenSize.midY)
            bg.size = CGSize(width: screenSize.width * 0.85, height: screenSize.height * 0.7)
            bg.zPosition = +1
            self.addChild(bg)
        
        let labelHeader = SKLabelNode(fontNamed: "Cartwheel", andText: "Settings", andSize: 40, fontColor: .yellow,withShadow: .black)
            labelHeader?.position = CGPoint(x: 0, y: bg.frame.height*0.43)
            labelHeader?.zPosition = +1
            bg.addChild(labelHeader!)
        
        /// Button icon cancel
        let iconCancel = scene.createUIButton(bname: "icon_cancel", offsetPosX: bg.frame.width/2, offsetPosY: (bg.frame.height/2),typeButtom: .CancelButton)
        
            iconCancel.size = CGSize(width: 35, height: 35)
            iconCancel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            bg.addChild(iconCancel)
       
        
        /// Begin Label SFX
        let labelSFX = SKLabelNode(fontNamed: "Cartwheel", andText: "SFX", andSize: 40, fontColor: .brown,withShadow: .white)
            labelSFX?.position = CGPoint(x: -bg.frame.width*0.2, y:  bg.frame.height*0.3)
            bg.addChild(labelSFX!)
        
        let buttonSFX = scene.createUIButton(bname: "BtnSfx", offsetPosX:  bg.frame.width*0.2, offsetPosY:  bg.frame.height*0.3,typeButtom: result?.value(forKey: "sfx") as! Bool  ? .BlueButton : .BrownButton)
            bg.addChild(buttonSFX)
        
        let labelSfxOff = label(result?.value(forKey: "sfx") as! Bool ? "On":"Off","Sfx",CGPoint(x: 0, y:0))
            buttonSFX.addChild(labelSfxOff)
        /// --- End label SFX
    
        /// Begin  label music
        let labelMusic = SKLabelNode(fontNamed: "Cartwheel", andText: "MUSIC", andSize: 40, fontColor: .brown,withShadow: .white)
            labelMusic?.position = CGPoint(x: -bg.frame.width*0.2, y: bg.frame.height*0.15 )
            bg.addChild(labelMusic!)
        
        let buttonMusic = scene.createUIButton(bname: "BtnMusic", offsetPosX: bg.frame.width*0.2, offsetPosY: bg.frame.height*0.15,typeButtom: result?.value(forKey: "music") as! Bool ? .BlueButton : .BrownButton)
            bg.addChild(buttonMusic)
        
        let labelMusicOff =   label(result?.value(forKey: "music") as! Bool ? "On":"Off","Music",CGPoint(x: 0, y: 0))
            buttonMusic.addChild(labelMusicOff)
        /// End label music
        
        
        /// Begin label voice
        let labelVoice = SKLabelNode(fontNamed: "Cartwheel", andText: "VOICE", andSize: 40, fontColor: .brown,withShadow: .white)
            labelVoice?.position = CGPoint(x: -bg.frame.width*0.2, y: 0)
            bg.addChild(labelVoice!)
        
        let buttonlabelVoice = scene.createUIButton(bname: "BtnVoice", offsetPosX: bg.frame.width*0.2, offsetPosY: 0,typeButtom: result?.value(forKey: "voice") as! Bool ? .BlueButton : .BrownButton)
            bg.addChild(buttonlabelVoice)
        
        let labelVoiceOff = label(result?.value(forKey:"voice") as! Bool ? "ON":"OFF","Voice",CGPoint(x: 0, y: 0))
            buttonlabelVoice.addChild(labelVoiceOff)
        /// End label voice
        
        /// Label Player movement
        let labelPlayerMovement = SKLabelNode(fontNamed: "Cartwheel", andText: "PLAYER MOVEMENT", andSize: 20, fontColor: .brown,withShadow: .white)
                        labelPlayerMovement?.position = CGPoint(x: 0, y: -bg.frame.height/5)
            labelPlayerMovement?.zPosition = 10
            bg.addChild(labelPlayerMovement!)
        
        // Buttons slow/fast player movement
        let slowBtn = scene.createUIButton(bname: "BtnSlow", offsetPosX: -bg.frame.width/4, offsetPosY: -bg.frame.height/5*2+50, typeButtom: result?.value(forKey: "slow") as! Bool  ? .BlueButton : .BrownButton)
            slowBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            bg.addChild(slowBtn)
        
        let labelSlowBtn = SKLabelNode(fontNamed: "Cartwheel", andText: "Slow", andSize: 25, fontColor: .white, withShadow: .black)
            labelSlowBtn?.position = CGPoint(x: 0, y: 0)
            labelSlowBtn?.zPosition = 10
            slowBtn.addChild(labelSlowBtn!)
        
        // Button fast player movement
        let btnFast = scene.createUIButton(bname: "BtnFast", offsetPosX: bg.frame.width/4, offsetPosY: -bg.frame.height/5*2+50, typeButtom: result?.value(forKey: "fast") as! Bool ? .BrownButton : .BlueButton)
            btnFast.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            btnFast.zPosition = 10
            bg.addChild(btnFast)
        
        let labelFastBtn = SKLabelNode(fontNamed: "Cartwheel", andText: "Fast", andSize: 25, fontColor: .white, withShadow: .black)
            labelFastBtn?.position = CGPoint(x: 0, y: 0)
            labelFastBtn?.zPosition = 10
            btnFast.addChild(labelFastBtn!)
        
        /// Label version
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let labelVersion = SKLabelNode(fontNamed: "Cartwheel", andText: "V\(version)", andSize: 15, fontColor: .brown,withShadow: .white)
            labelVersion?.position = CGPoint(x: 0, y: -bg.frame.height/2+10)
            bg.addChild(labelVersion!)
    }
    
 
    // MARK: CREATE CLOUDS WHEN DEFEAD BOSS
    func createCloud(completion:@escaping(Bool)->Void) {
        
        guard let mainscene = mainScene else { return }

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
        
        loadBackground(scene:mainscene,isStartMap: true)
        completion(true)
    }
    
    // MARK: PHYSICS WALL SCREEN
    private func createWalls() -> (Bool, String){
        
        guard let mainscene = mainScene else{
            return (false, "mainScene is nil")
        }
        // create invisible wall
        
        let border = SKSpriteNode()
        border.name = "Physics_Wall"
        border.physicsBody = SKPhysicsBody(edgeLoopFrom:  mainscene.view!.bounds)
        border.physicsBody!.categoryBitMask = PhysicsCategory.Wall
        border.physicsBody?.isDynamic = false
        mainscene.addChild(border)
        
        return (true, "No errors")
    }

    private func didFinishSpawningEnemy(){
        self.changeGameState(.BossEncounter)
    }
    
    //  Only called when the gamestate is spawning. 
    //  This function is called every second.
    
    @objc private func running(){
        guard let mainScene = mainScene else {
            return
        }
        
        switch randomInt(min: 0, max: 100) {
            
            case 0..<10:
                fireball_enemy?.spawn(scene: mainScene,typeBoss: nil,baseHP: nil)
            case 10..<80:
                let hp = armored?.RegularBaseHP
                self.armored?.spawn(scene: mainScene,typeBoss: nil,baseHP: hp)
            case 80..<100:
                let hp = cofre?.RegularBaseHP
                self.cofre?.spawn(scene: mainScene,typeBoss: nil,baseHP: hp)
            case 90..<100:
                let hp = buitre?.RegularBaseHP
                self.buitre?.spawn(scene: mainScene, typeBoss: nil, baseHP: hp)
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
            infobar.addTime()
            
            // Show infobar level bullet
            mainscene.addChild(showInfoBulletScreen(level: currentBullet))
            
            mainscene.run(.repeatForever(mainAudio.getAction(type: .GameIntro)),withKey: "gameIntro")
            mainscene.run(.sequence([.wait(forDuration: 2),.run {
                mainscene.removeAction(forKey: "gameIntro")
            }]))
            
            
            
            loadBackground(scene: mainscene,isStartMap: true)
            // Cloud action
            let moveDownCloud = SKAction.moveTo(y: -screenSize.height*1.5, duration: 1)
            
            // Buildings Action
            let scaleAction = SKAction.scale(to: 0.7, duration: 0.3)
            let moveAction = SKAction.moveTo(y: screenSize.height/3, duration: 0.3)
           
            let buildingsAction = SKAction.sequence([SKAction.run(SKAction.group([scaleAction, moveAction]), onChildWithName: "main_menu_middle_root"), SKAction.wait(forDuration: 1.5), SKAction.run {
                self.mainScene?.childNode(withName: "main_menu_middle_root")?.removeFromParent()
                self.mainScene?.childNode(withName: Global.Main.Main_Menu_Background_1.rawValue)?.removeFromParent()
                self.mainScene?.childNode(withName: Global.Main.Main_Menu_Background_2.rawValue)?.removeFromParent()
                self.mainScene?.childNode(withName: Global.Main.Main_Menu_Background_3.rawValue)?.removeFromParent()
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
            infobar.fadeAway()
        

            mainscene.run(SKAction.sequence([SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_1.rawValue + "0"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_2.rawValue + "1"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_1.rawValue + "2"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_2.rawValue + "3")]))
            
        
            mainscene.run(SKAction.sequence([
                buildingsAction,
                SKAction.wait(forDuration: 2),
                SKAction.run{
                    self.changeGameState(.Spawning)
                },
                
                SKAction.wait(forDuration: 0.2),
                SKAction.run {
                    MainScene.accountInfo.getCurrentToon().getNode().run(SKAction.repeatForever(SKAction.sequence([
                    SKAction.run { [self] in
                      
                        self.addChild((MainScene.accountInfo.getCurrentToon().getBullet()?.shoot())!)
                        
                       /* self.addChild(self.dragon?[0].shoot())
                        self.addChild(self.dragon?[1].shoot())*/
                    },
                    SKAction.wait(forDuration: 0.06)])))
                }
            ]),withKey: "shoot")
            
        case .WaitingState:
            
            regular_enemies?.increaseDifficulty()
            fireball_enemy?.increaseDifficulty()
            armored?.increaseDifficulty()
            boss?.increaseDifficulty()
            changeGameState(.Spawning)
            getCurrentToon().addLevel()
            
         
        case .Attack:
          
            guard let mainScene = mainScene else { return  }

            timer?.invalidate()
            
            for x in mainScene.children {
                guard let _ = x as? Enemy else { continue}
                regular_enemies?.enemyModel?.enumerateChildNodes(withName: "Enemy*", using: { node, obj in
                    self.regular_enemies?.explode(sknode: node as? Enemy, scene: mainScene)
                })
            }
    
        case .Spawning:
            
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(running), userInfo: nil, repeats: true)
            
            let action = SKAction.sequence([SKAction.run({
                let hp = self.regular_enemies!.RegularBaseHP * CGFloat(self.currentLevel)
                self.regular_enemies?.spawn(scene: mainscene,typeBoss: nil,baseHP: hp)
              
            })])
            
            //totalWaves
            //wavesForNextLevel
            print("Waves \(wavesForNextLevel) ")
            let spawnAction = SKAction.repeat(.sequence([action,.wait(forDuration: 1.3)]), count: wavesForNextLevel)
            let endAction = SKAction.run(didFinishSpawningEnemy)
            
            
            mainscene.run(SKAction.sequence([spawnAction, endAction]))
            
        case .BossEncounter:
            // use this state to cancel the timer - invalidate
            timer?.invalidate()
            showMessageAlertBoss()
            currentLevel += 1
            getCurrentToon().getBullet()?.setBulletLevel(level: currentLevel)
        
        case .Running: break
        default:
            print("Current State: ", gamestate)
        }
    }
    
    // Info bar screen level bullet
    func showInfoBulletScreen(level:Int,isStartGame:Bool = true) ->SKSpriteNode{
        
        
        self.mainScene?.childNode(withName: "BulletButton")?.removeFromParent()
        
        let icon = SKSpriteNode(imageNamed: "BulletButton")
        icon.name = "BulletButton"
        icon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        icon.position = CGPoint(x: screenSize.maxX-50 , y: screenSize.height*0.8)
        icon.zPosition = 100
        
        let iconBullet = BulletMaker().make(level: BulletMaker.Level(rawValue: level)!, char: MainScene.accountInfo.getCurrentToon().getCharacter())
    
        
        if !isStartGame  {
            let shield = getCurrentToon().liveShield(duration: 10,size: icon.size.width / 2 * 1.1) 
            icon.addChild(shield)
        }
        icon.addChild(iconBullet)
        
        
        let level = SKLabelNode(fontNamed: "Cartwheel", andText: "Level \(level)", andSize: 18, fontColor: .white, withShadow: .black,name:"ScreenLevelBulletShadow")
            level?.name = "ScreenLevelBullet"
            level?.position.y = -icon.frame.height/2
        
        icon.addChild(level!)
        
        icon.run(.sequence([.wait(forDuration: 10),.removeFromParent()]))
        
        return icon
        
    }

    /// Show message begin boss appears
    private func showMessageAlertBoss() {
        
        guard let mainScene = mainScene,
              let typeBoss = BossType.allCases.randomElement(),
              let boss = boss else { return }
        
        mainScene.childNode(withName: "Boss_Shadow")?.removeFromParent()
        

        let shadow = SKSpriteNode(texture: typeBoss.getTextureShadow(),size: CGSize(width: screenSize.width*0.6, height: screenSize.width*0.62))
            shadow.name = "Boss_Shadow"
            shadow.position = CGPoint(x: 0.5, y: 1)
            shadow.position = CGPoint(x: screenSize.midX, y: screenSize.height - shadow.size.height)
            shadow.run(.sequence([.wait(forDuration: 6),.fadeOut(withDuration: 1),.run {
            shadow.removeFromParent()
        }]))
        
        mainScene.run(.sequence([.run {
            self.addChild(shadow)
            self.addMessageBossAppear(type: typeBoss)
            self.showMessageLateralDangerBossAppear()
        }]))
        
        DispatchQueue.main.asyncAfter(deadline: .now()+8) {
            
             let hp = boss.BossBaseHP * CGFloat(self.currentLevel)
             self.boss?.spawn(scene: mainScene, typeBoss: typeBoss, baseHP: hp)
        }
    }
    
    // Show effect Fx when appear Boss
    func showEffectFxBossAppears(typeBoss:BossType) {
         guard let mainScene = mainScene else {
             return
         }
         
        var texture:String?
        var glaciar:Enemy?
         

        switch typeBoss {
            case .Mildred:
                 texture = "plants"
            case .Spike:
                texture = "Ice"
            case .Pinky,.Ice_Queen,.Monster_King,.Monster_Queen:
                texture = "plants"
        }
        
        let unitY = Int(round(Float(screenSize.height) / 10))
        
       
        let ice = SKSpriteNode(texture: SKTexture(imageNamed: texture!), size: CGSize(width: 70, height: unitY))
        ice.run(typeBoss.audioFX)
        if typeBoss == .Mildred {
            ice.run(.repeatForever(.sequence([
                .resize(toWidth: 80, duration: 0.2),
                .resize(toWidth: 70, duration: 0.2),
            
            ])))
        }
        
        let texturePlant = SKTextureAtlas().loadAtlas(name: "Plants", prefix: nil)
        let isMilfred = typeBoss == .Mildred
       
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
        
            for x in 0...10 {
                
                let copy = ice.copy() as? SKSpriteNode
                if typeBoss == .Mildred {
                    copy?.xScale = -1
                }
                copy?.name = "ice_L\(x)"
                copy?.position = CGPoint(x: 10, y: (x * (unitY-20)))
                mainScene.addChild(copy!)
                
                let copyR = ice.copy() as? SKSpriteNode
                copyR?.name = "ice_R\(x)"
                copyR?.position = CGPoint(x: Int(screenSize.maxX)-10, y: (x * (unitY-20)))
                mainScene.addChild(copyR!)
            }

            mainScene.run(.wait(forDuration: 5), completion: {
                let _ = mainScene.children.map { (node:SKNode) in
                    if node.name?.contains("ice") == true {
                        node.removeFromParent()
            }}})
        
    }
    
    //Show message lateral boss appears
    private func showMessageLateralDangerBossAppear()  {
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
        
        let action = SKAction.repeat(mainAudio.getAction(type: .Boss_Alarm), count: 2)
            mainscene.run(action,withKey: "audioBoss")
            mainscene.run(.sequence([
                .wait(forDuration: 3),.run {
                    mainscene.removeAction(forKey: "audioBoss")
                    mainscene.childNode(withName: "bgDangerAlertL")?.removeFromParent()
                    mainscene.childNode(withName: "bgDangerAlertR")?.removeFromParent()
                },
                .removeFromParent()
            ]))
    }
    
    // Show message Boss type before appears
    private func addMessageBossAppear(type:BossType) {
        
        let messageTypeBoss = SKSpriteNode(color: .black.withAlphaComponent(0.5), size: CGSize(width: 250, height: 75))
        messageTypeBoss.position = CGPoint(x: screenSize.width/2, y: screenSize.height-100)
        
        guard let nameBoss = boss?.bossType.rawValue else { return }
        let label = SKLabelNode(fontNamed: "Cartwheel", andText: nameBoss, andSize: 30, fontColor: .yellow, withShadow: .white)!
        label.position = CGPoint(x: 0, y: -2)
        label.text = nameBoss
        messageTypeBoss.addChild(label)
        
        let weaknessLabel = SKLabelNode(fontNamed: "Cartwheel", andText: "WEAKNESS", andSize: 25, fontColor: .white, withShadow: .yellow)
        weaknessLabel?.position = CGPoint(x: 0, y: -35)
        weaknessLabel?.text = "WEAKNESS"
        messageTypeBoss.addChild(weaknessLabel!)
        
        let weaknessIcon = SKSpriteNode(texture: type.weakness, size: CGSize(width: 50, height: 50))
        weaknessIcon.position = CGPoint(x: messageTypeBoss.frame.width/2, y: 0)
        messageTypeBoss.addChild(weaknessIcon)
        
        addChild(messageTypeBoss)
        
        messageTypeBoss.run(.wait(forDuration: 5)) {
            messageTypeBoss.removeFromParent()
        }
    }
    
    func getCurrentToon() -> Toon{
        return MainScene.accountInfo.getCurrentToon()
    }
     func getCurrentToonNode() -> SKSpriteNode{
         return MainScene.accountInfo.getCurrentToon().getNode()
    }
    
     func requestCurrentToonIndex() -> Int{
        return MainScene.accountInfo.getCurrentToonIndex()
    }    
    
     func getCurrentToonBullet() -> Projectile{
         return MainScene.accountInfo.getCurrentToon().getBullet()!
    }
    
     func getToonBulletEmmiterNode(x px:CGFloat, y py:CGFloat) -> SKEmitterNode?{
         return MainScene.accountInfo.getCurrentToon().getBullet()!.generateTouchedEnemyEmmiterNode(x: px, y: py)
    }
     func requestChangeToon(index: Int){
        MainScene.accountInfo.selectToonIndex(index: index)
    }
     func requestToonDescription(index id:Int) -> [String]{
         
        return MainScene.accountInfo.getToonDescriptionByIndex(index: id)
    }
    
     func requestToonName(index id:Int) -> String{
        return MainScene.accountInfo.getNameOfToonByIndex(index: id)
    }
    
     func requestToonTitle(index id:Int) -> String{
        return MainScene.accountInfo.getTitleOfToonByIndex(index: id)
    }
    
     func requestToonBulletLevel(index id:Int) -> Int{
        return MainScene.accountInfo.getBulletLevelOfToonByIndex(index: id)
    }
    
     func requestUpgradeBullet() -> (Bool, String){
        let (success, response) = MainScene.accountInfo.upgradeBullet()
        
        if success {
            infobar.updateGoldBalanceLabel(balance: MainScene.accountInfo.getGoldBalance())
        }
        return (success, response)
    }
    
     func prepareToChangeScene(){
        
       map?.prepareToChangeScene()
    }
    
     func addCoin(amount:Int){
        currentGold += amount
         
         infobar.updateGoldLabel(coinCount: self.currentGold)
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
