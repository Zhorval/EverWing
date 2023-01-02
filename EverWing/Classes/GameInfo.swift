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
    var isMapStart:Bool? { get set}
    func addChild(_ sknode: SKNode)
    func changeGameState(_ state: GameState)
    func getCurrentToonNode() -> SKSpriteNode
    func createCloud(completion:@escaping(Bool)->Void)
    func loadBackground(scene:SKScene?,isStartMap:Bool)
    func showEffectFxBossAppears(typeBoss:BossType)
    func stopAudio(type:AVAudio.BgroundSoundType)
    func getScene()->SKScene?
    func prepareToChangeScene(scene:MainScene.Scene,skscene:SKScene)
    func prepareToDragonBuyChangeScene<T>(scene:MainScene.Scene,skscene:SKScene,data:T) where T: ProtocolTableViewGenericCell

}




final class GameInfo: GameInfoDelegate{
    
    static let shared = GameInfo()
    
    
    deinit {
        print ("GameInfo Class deinitiated!")
    }
    
   
    // Main Variables
    weak var mainScene:SKScene?
    
    var currentLevel:Int  = 1 {
        willSet {
            wavesForNextLevel = wavesForNextLevel + currentLevel
            currentBullet += 1
        }
    }
    
    var currentBullet =  1 {
        willSet {
            self.addChild(showInfoBulletScreen(level: newValue,isStartGame: false))
          //  accountInfo.getCurrentToon().changeTextureProjectile(level: newValue)
        }
    }
    
    private var currentGold:Int  = 0 // tracking local current in-game
    private var currentHighscore:Int = 0
    private var timer:Timer? {
        willSet {
            print("timer cambiado")
        }
    }
    var infobar:Infobar?
    let DMG = 10
    
    // Secondary Variables
    private var wavesForNextLevel:Int = 3
    var gamestate:GameState = .NoState
    
    private var timePerWave:Double  = 6// time to call each wave
    
    // Public Variables
    let mainAudio:AVAudio = AVAudio()
    
    var regular_enemies:EnemyModel?
    
    let accountInfo:AccountInfo = AccountInfo()
    
    var map:Map?
    
    var isMapStart: Bool?
    
    static var currentPlayerPosition:CGPoint = .zero
    
    static var tableInfoBarEggs = CustomCollectionViewEggs(frame: CGRect(x: 10, y: 50, width: screenSize.width/2, height: 60),
                                                           items: Currency.EggsCurrencyType.items, view: nil,
                                                           typeGridCollection: .eggs) { _ in} handlerDeselect: { _ in} handlerTapAudio: {  }

  
    
     init(){
             print("LLamo init gameinfo \(gamestate)")
             // Models
           
             regular_enemies = EnemyModel(type: .Regular)
             // delegates
             regular_enemies?.delegate = self
    }
    
    
    
    func load(scene: SKScene?,audio:AVAudio.BgroundSoundType = .Background_Start) -> (Bool, String){
        
        var loadStatus:(Bool, String) = (true, "No errors")
        
        guard let mainScene = scene else { fatalError() }
       
        self.mainScene = mainScene
        
        mainAudio.play(type: audio)
        
        if !accountInfo.load(){
            return (false, "accountInfo error")
        }
        
        infobar = Infobar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width*0.2),scene: mainScene)
        
        mainScene.view?.addSubview(infobar!)
        
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
    func showMenuSettings() -> UIView {
        
        guard let view = mainScene?.genericViewItem(title: "SETTINGS") else { return UIView()}
        let getTitleButton =  { (item:Bool) -> [String:Any] in   return item ? ["ON":true] : ["OFF":false]   }
        
        
        let label = { (text:String,rect:CGRect)  -> UILabel in
            
            let label =  UILabel(frame:rect).shadowText(colorText: .brown, colorShadow: .white, aligment: .center)
            label.font = UIFont(name:"Cartwheel",size:view.frame.width*0.08)
            label.text = text
            label.textAlignment = .center
            return label
        }
        
        let button = { (rect:CGRect,disable:[String:Any]) ->UIButton in
            
            var text:[String:Any] = disable
            
            let button = UIButton(frame: rect)
            
            
            if disable.first?.key == "SFX" ||  disable.first?.key == "MUSIC" ||  disable.first?.key == "VOICE" {
                text = getTitleButton(disable.first!.value as! Bool)
            }
            
            button.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
            button.setTitle(text.first?.key, for: .normal)
            button.setBackgroundImage(UIImage(named: disable.first!.value as! Bool ? "BlueButton" : "BrownButton"), for: .normal)
            button.setBackgroundImage(UIImage(named:"PurpleButton"), for: .highlighted)
            button.accessibilityLabel =  disable.first?.key
            button.addTarget(self, action: #selector(GameInfo.tapSettingsBtn), for: .touchUpInside)
            
            return button
        }

        
        do {
            if let data = try ManagedDB.shared.context.fetch(Settings.fetchRequest()).first  {
                
                let width = view.frame.width*0.3
                let height = view.frame.height*0.1
                let marginMinX = view.frame.width*0.1
                let marginMaxX = view.frame.width/2
                
                view.addSubview(label("SFX",CGRect(x: marginMinX, y: view.frame.height*0.2, width: width, height: height)))
                
                view.addSubview(button(CGRect(x: marginMaxX, y: view.frame.height*0.2, width: width, height: height),["SFX":data.sfx]))

                view.addSubview(label("MUSIC",CGRect(x: marginMinX, y: view.frame.height*0.35, width: width, height: height)))
                view.addSubview(button(CGRect(x: marginMaxX, y: view.frame.height*0.35, width: width, height: height),["MUSIC":data.music]))

                view.addSubview(label("VOICE",CGRect(x: marginMinX, y: view.frame.height*0.5, width: width, height: height)))
                view.addSubview(button(CGRect(x: marginMaxX, y: view.frame.height*0.5, width: width, height: height),["VOICE":data.voice]))
                
                view.addSubview(label("PLAYER MOVEMENT",CGRect(x: 0, y: view.frame.height*0.65, width: view.frame.width, height: height)))

                view.addSubview(button(CGRect(x:marginMinX,y: view.frame.height*0.75, width: width, height: height),["SLOW":data.slow]))
               
                view.addSubview(button(CGRect(x: marginMaxX*1.1, y: view.frame.height*0.75, width: width, height: height),["FAST":data.fast]))

                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                view.addSubview(label("V\(version)",CGRect(x: view.frame.width/2-50, y: view.frame.height*0.92, width: width, height: height)))
            }
            
        } catch {
             fatalError()
        }
        return view
    }
    
    @objc func tapSettingsBtn(sender:UIButton) {
       
        var title = ""
        
        mainScene?.run(mainAudio.getAction(type: .ChangeOption))
        
        do {
            let managed = ManagedDB.shared.context
            let fetch = try managed.fetch(Settings.fetchRequest()).first!
            let key = sender.accessibilityLabel!.lowercased()
            
            guard let val = fetch.value(forKey: key) as? Bool else { fatalError()}
            
            let toogle = !val
            
            fetch.setValue(toogle, forKey: key)
            
            try managed.save()
            
            sender.setBackgroundImage(UIImage(named:toogle ? "BlueButton": "BrownButton"), for: .normal)
           
            if  sender.titleLabel?.text == "ON"  {
                title = "OFF"
            } else if sender.titleLabel?.text == "OFF" {
                title = "ON"
            } else {
                title = (sender.titleLabel?.text)!
            }
            sender.setTitle(title , for: .normal)
            
        } catch let error {
            print(error.localizedDescription)
        }
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
                regular_enemies?.enemyType = .Fireball
            case 10..<20:
                regular_enemies?.enemyType = .Armored
            case 20..<80:
                regular_enemies?.enemyType = .Regular
            case 80..<100:
                regular_enemies?.enemyType = .Cofre
            case 90..<100:
                regular_enemies?.enemyType = .Buitre
            default: break
        }
        regular_enemies?.spawn(scene: mainScene, typeBoss: nil, baseHP: nil)
    }
    
    private func updateGameState(){
        guard let mainscene = mainScene else{
            print ("ERROR D00: Check updateGameState() from GameInfo")
            return
        }
        
        switch gamestate {
        case .Start:
            
            loadBackground(scene: mainscene,isStartMap: true)

            
            // Show infobar level bullet
            mainscene.addChild(showInfoBulletScreen(level: currentBullet))
            
            mainscene.run(.repeatForever(mainAudio.getAction(type: .GameIntro)),withKey: "gameIntro")
            mainscene.run(.sequence([.wait(forDuration: 2),.run {
                mainscene.removeAction(forKey: "gameIntro")
            }]))
            
            
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
   //         infobar.fadeAway()
        

            mainscene.run(SKAction.sequence([SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_1.rawValue + "0"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_2.rawValue + "1"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_1.rawValue + "2"), SKAction.wait(forDuration: 0.4), SKAction.run(moveDownCloud, onChildWithName: Global.Main.StartCloud_2.rawValue + "3")]))
            
        
            mainscene.run(SKAction.sequence([ 
                buildingsAction,
                SKAction.wait(forDuration: 3),
               
                SKAction.run { [weak self] in
                    self?.accountInfo.getCurrentToon().getNode().run(SKAction.repeatForever(SKAction.sequence([
                    SKAction.run { [weak self] in

                        guard let proyectil = self?.accountInfo.getCurrentToon().getBullet()?.shoot() else { return }

                        self?.addChild(proyectil)
                    
                    },
                    SKAction.wait(forDuration: 0.1)])))
                },
                SKAction.run{
                    self.changeGameState(.Spawning)
                }
            ]),withKey: "shoot")
            
        case .WaitingState:
            
            regular_enemies?.increaseDifficulty()
         
            changeGameState(.Spawning)
            
            getCurrentToon().addLevel()
            
         
        case .Attack:
          
            guard let mainScene = mainScene else { return  }

            mainScene.run(.sequence([  mainAudio.getAction(type: .Magnet), mainAudio.getAction(type: .Jade_Attack)]))

            mainScene.physicsWorld.speed = 4
    
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
            print("BossEncounter")
            timer?.invalidate()
            showMessageAlertBoss() { [weak self] _ in
                self?.currentLevel += 1
                self?.getCurrentToon().getBullet()?.setBulletLevel(level: self?.currentLevel ?? 1)
                self?.regular_enemies?.enemyType =  .Boss
                self?.regular_enemies?.spawn(scene: mainscene, typeBoss: BossType.allCases.randomElement()!, baseHP: 1000)
            }
            
            print("Fin Bossencounter")
        
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
        
        let iconBullet = BulletMaker().make(level: BulletMaker.Level(rawValue: level)!, char: accountInfo.getCurrentToon().getCharacter())
        
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
    private func showMessageAlertBoss(completion:@escaping(Bool)->Void) {
      
        guard let typeBoss = BossType.allCases.randomElement() else { return }

        let image = UIImage(named:typeBoss.rawValue)?.maskWithColor(color: .black)
        let shadow = SKSpriteNode(texture: SKTexture(image: image!),size: CGSize(width: screenSize.width*0.6, height: screenSize.width*0.62))
            shadow.name = "Boss_Shadow"
            shadow.alpha = 0.8
            shadow.position = CGPoint(x: 0.5, y: 1)
            shadow.position = CGPoint(x: screenSize.midX, y: screenSize.height - shadow.size.height)
            shadow.run(.sequence([.wait(forDuration: 8),.fadeOut(withDuration: 1),.run {
            shadow.removeFromParent()
        }]))
      
            self.addChild(shadow)
            self.addMessageBossAppear(type: typeBoss) { finnish in
                completion(finnish)
            }
            self.showMessageLateralDangerBossAppear()
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
    private func addMessageBossAppear(type:BossType,completion:@escaping(Bool)->Void) {
        
        let messageTypeBoss = SKSpriteNode(color: .black.withAlphaComponent(0.5), size: CGSize(width: 250, height: 75))
        messageTypeBoss.position = CGPoint(x: screenSize.width/2, y: screenSize.height-100)
        
        guard let nameBoss = regular_enemies?.bossType.rawValue else { return }
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
        
        messageTypeBoss.run(.sequence([
            .wait(forDuration: 7),
            .fadeOut(withDuration: 0.5),
            .removeFromParent(),
            .run{  completion(true) }
        ]))
    }
    
    func getCurrentToon() -> Toon{
        return accountInfo.getCurrentToon()
    }
     func getCurrentToonNode() -> SKSpriteNode{
         return accountInfo.getCurrentToon().getNode()
    }
    
     func requestCurrentToonIndex() -> Int{
         return accountInfo.getCurrentToonIndex()
    }    
    
     func getCurrentToonBullet() -> Projectile{
         return accountInfo.getCurrentToon().getBullet()!
    }
    
     func getToonBulletEmmiterNode(x px:CGFloat, y py:CGFloat) -> SKEmitterNode?{
         return accountInfo.getCurrentToon().getBullet()!.generateTouchedEnemyEmmiterNode(x: px, y: py)
    }
     func requestChangeToon(index: Int){
         accountInfo.selectToonIndex(index: index)
    }
     func requestToonDescription(index id:Int) -> String{
         
         return accountInfo.getToonDescriptionByIndex(index: id)
    }
    
     func requestToonName(index id:Int) -> String{
         return accountInfo.getNameOfToonByIndex(index: id)
    }
    
     func requestToonTitle(index id:Int) -> String{
         return accountInfo.getTitleOfToonByIndex(index: id)
    }
    
     func requestToonBulletLevel(index id:Int) -> Int{
         return accountInfo.getBulletLevelOfToonByIndex(index: id)
    }
    
     func requestUpgradeBullet() -> (Bool, String){
         let (success, response) = accountInfo.upgradeBullet()
        
        if success {
          //  infobar.updateGoldBalanceLabel(balance: accountInfo!?.getGoldBalance())
        }
        return (success, response)
    }
    
     func prepareToChangeScene(){
        
       map?.prepareToChangeScene()
    }
    
     func addCoin(amount:Int){
        currentGold += amount
         
      //   infobar.updateGoldLabel(coinCount: self.currentGold)
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
         print("GAMESTATE GAMEINFO",state)
        updateGameState()
    }
    
}


extension GameInfo {
    
    func prepareToDragonBuyChangeScene<T>(scene:MainScene.Scene,skscene:SKScene,data:T) where T: ProtocolTableViewGenericCell {
        
        skscene.removeUIViews()
        self.prepareToChangeScene()
        skscene.recursiveRemovingSKActions(sknodes: skscene.children)
        skscene.removeAllChildren()
        skscene.removeAllActions()
        
        switch scene{
        case .BuyDragon:
            let newScene = BuyDragon(size: skscene.size,dragons: data as! BuyEggs)
            skscene.view?.presentScene(newScene)
        case .DragonsMenuScene:
            let newScene = DragonsMenuScene(size: skscene.size)
                skscene.view?.presentScene(newScene)
        case .MainScene:
            let newScene = MainScene(size: skscene.size)
                skscene.view?.presentScene(newScene)
        case .StarUpgrade: break
         /*   let newScene = StarUpgrade(size: skscene.size)
            skscene.view?.presentScene(newScene)*/
        default: break
            
        }
    }
    
    // MARK: PREPARE SCENE
    func prepareToChangeScene(scene:MainScene.Scene,skscene:SKScene){
        // remove all gestures
        guard let gestures = skscene.view?.gestureRecognizers else { return }
        
        for gesture in gestures{
            skscene.view?.removeGestureRecognizer(gesture)
        }

        mainScene?.removeAllActions()
        mainScene?.removeAllChildren()
        mainAudio.stop()
        switch scene {
        case .EndScene:
            skscene.physicsWorld.speed = 0.4
            
            skscene.run(SKAction.sequence([SKAction.wait(forDuration: 4), SKAction.run {
            self.prepareToChangeScene()
                skscene.recursiveRemovingSKActions(sknodes: skscene.children)
                skscene.removeAllChildren()
                skscene.removeAllActions()
                skscene.removeUIViews()
                
            let scene = EndGame(size: skscene.size)
                scene.collectedCoins = self.getCurrentGold()
                skscene.view?.presentScene(scene)
                }]))
            
        case .Character_Menu:
            skscene.removeUIViews()

            self.prepareToChangeScene()
            skscene.recursiveRemovingSKActions(sknodes: skscene.children)
            skscene.removeAllChildren()
            skscene.removeAllActions()

            let newScene = CharacterMenuScene(size: skscene.size)
            newScene.gameinfo = GameInfo.shared
            skscene.view?.presentScene(newScene)
            
        case .Dragons:
            self.prepareToChangeScene()
            skscene.recursiveRemovingSKActions(sknodes: skscene.children)
            skscene.removeAllChildren()
            skscene.removeAllActions()
            
            let newScene = DragonsMenuScene(size: skscene.size)
            skscene.view?.presentScene(newScene)
            
        case .BuyDragon:
            skscene.removeUIViews()
            self.prepareToChangeScene()
            skscene.recursiveRemovingSKActions(sknodes: skscene.children)
            skscene.removeAllChildren()
            skscene.removeAllActions()
            
            let newScene = BuyDragon(size: skscene.size,dragons: BuyEggs.items.randomElement()!)
            skscene.view?.presentScene(newScene)
            
        case .MainScene:
            skscene.removeUIViews()
            self.prepareToChangeScene()
            skscene.recursiveRemovingSKActions(sknodes: skscene.children)
            skscene.removeAllChildren()
            skscene.removeAllActions()
            
            let newScene = MainScene(size: skscene.size)
            skscene.view?.presentScene(newScene)
            
        case.UpdateLeveCharacter:
            skscene.removeUIViews()
            self.prepareToChangeScene()
            skscene.removeAllChildren()
            skscene.removeAllActions()
            skscene.recursiveRemovingSKActions(sknodes: skscene.children)
            
     /*       let newScene = UpgradeCharacter(size: skscene.size,character: character!,gameInfo: self)
            skscene.view?.presentScene(newScene)*/
            
            
        default:
            print("Should not reach here. PrepareToChangeScene from MainScene")
        }
    }
    
    
    
    @objc func tapButtonCancel(sender:UIButton) {
        
        guard let mainscene = mainScene else {
            print("Error gameinfo tapbuttonCancel not found scene")
            return
        }
        mainscene.removeBackgroundBlack(removeBlur: nil)
        
    }
  

}

