//
//  MainScene.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit




class MainScene:SKScene, SKPhysicsContactDelegate,ProtocolEffectBlur{
    
    
    deinit{
        print("MainScene is being deInitialized.");
    }
    
    enum Scene{
        case MainScene
        case EndScene
        case Character_Menu
        case Dragons
        case BuyDragon
        case DragonsMenuScene
        case UpdateLeveCharacter
        case StarUpgrade
    }
    
    let gameinfo:GameInfo = GameInfo.shared
    static let accountInfo = AccountInfo()
    var isPlayerMoved:Bool = false
    var blurNode = SKEffectNode()
    let eggsClaim = EggsClaim(name: "eggsClaim")
   
    
    override func didMove(to view: SKView) {
        
        removeUIViews()
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanFrom(recognizer:)))
        
        self.view?.addGestureRecognizer(gestureRecognizer)
        self.view?.scene?.name = "MainScene"
        view.showsPhysics = true
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        gameinfo.mainScene = self
        
        loadBackground()
        loadgameinfo()
        loadGameEggs()
        addChild(eggsClaim)

        
    }
    
    func loadBackground(){
    
        let bg = SKSpriteNode()
            bg.texture = global.getMainTexture(main: .Main_Menu_Background_1)
            bg.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
            bg.size = CGSize(width: screenSize.width, height: screenSize.height)
            bg.zPosition = -10
            bg.name = Global.Main.Main_Menu_Background_1.rawValue
        self.addChild(bg)
        
        let cloud = SKSpriteNode()
            cloud.texture = global.getMainTexture(main: .Main_Menu_Background_2)
            cloud.position = CGPoint(x: screenSize.width/2, y: screenSize.height*0.40)
            cloud.size = CGSize(width: screenSize.width, height: screenSize.height*3/4)
            cloud.zPosition = -9
            cloud.name = Global.Main.Main_Menu_Background_2.rawValue
        self.addChild(cloud)
        
        let cloud2 = SKSpriteNode()
            cloud2.texture = global.getMainTexture(main: .Main_Menu_Background_3)
            cloud2.position = CGPoint(x: -20 + screenSize.width/2, y: 0)
            cloud2.size = CGSize(width: screenSize.width + 100, height: screenSize.height/2)
            cloud2.zPosition = -8
            cloud2.name = Global.Main.Main_Menu_Background_3.rawValue
        self.addChild(cloud2)
        
        let root = SKSpriteNode()
            root.color = .clear
            root.name = "main_menu_middle_root"
            root.size = CGSize(width: screenSize.width, height: screenSize.height*0.7)
            root.position = CGPoint(x: screenSize.width/2, y: screenSize.height*0.55)
            root.zPosition = -7
        self.addChild(root)
        // note... anchor of root is 0.5, 0.5
        
        let bd_one = SKSpriteNode()
            bd_one.anchorPoint = CGPoint(x: 0.5, y: 1)
            bd_one.texture = global.getMainTexture(main: .Main_Menu_Building_1)
            bd_one.position = CGPoint(x: 0, y: root.size.height/2)
            bd_one.size = CGSize(width: screenSize.width/2, height: screenSize.height/2)
            bd_one.name = "main_menu_building_1"
        root.addChild(bd_one)
        
        let bd_one_shade = SKSpriteNode()
            bd_one_shade.anchorPoint = CGPoint(x: 0.5, y: 1)
            bd_one_shade.texture = global.getMainTexture(main: .Main_Menu_Building_1_Additional)
            bd_one_shade.position = CGPoint(x: 0, y: -25)
            bd_one_shade.size = CGSize(width: screenSize.width/2, height: screenSize.height/2)
            bd_one_shade.name = "main_menu_building_1_Additional"
        bd_one.addChild(bd_one_shade)
        
        let bd_two = SKSpriteNode()
            bd_two.anchorPoint = CGPoint(x: 0.5, y: 1)
            bd_two.texture = global.getMainTexture(main: .Main_Menu_Building_2)
            bd_two.position = CGPoint(x: bd_one.size.width/3, y: bd_one.position.y - bd_one.size.height/2)
            bd_two.size = CGSize(width: screenSize.width/3, height: screenSize.height/3)
            bd_two.name = "main_menu_building_2"
        root.addChild(bd_two)
        
        let bd_three = SKSpriteNode()
            bd_three.anchorPoint = CGPoint(x: 0.5, y: 1)
            bd_three.texture = global.getMainTexture(main: .Main_Menu_Building_3)
            bd_three.position = CGPoint(x: -bd_one.size.width/3, y: bd_one.position.y - bd_one.size.height/2)
            bd_three.size = CGSize(width: screenSize.width/3, height: screenSize.height/3.5)
            bd_three.name = "main_menu_building_3"
        root.addChild(bd_three)
        
        let bd_one_button = createUIButton(bname: "character_building_button", offsetPosX: bd_one.position.x, offsetPosY: bd_one.position.y - bd_one.size.height/2 + 10, typeButtom: .PurpleButton)
            root.addChild(bd_one_button)
        let bd_two_button = createUIButton(bname: "building_2_button_dragons", offsetPosX: bd_two.position.x, offsetPosY: bd_two.position.y - bd_two.size.height/2 - 15, typeButtom: .PurpleButton)
            root.addChild(bd_two_button)
        let bd_three_button = createUIButton(bname: "building_3_button", offsetPosX: bd_three.position.x, offsetPosY: bd_three.position.y - bd_three.size.height/2 - 50, typeButtom: .PurpleButton)
            root.addChild(bd_three_button)
        
     
        let LONGESTSTRCOUNT:CGFloat = 11
        
        // Button Labels
        let bd_one_label = SKLabelNode()
            bd_one_label.text = "CHARACTERS"
            bd_one_label.fontName = "GillSans-Bold"
            bd_one_label.fontSize = bd_one_button.size.width/LONGESTSTRCOUNT
            bd_one_button.addChild(bd_one_label)
        
        
        // SIDEKICK
        let bd_two_label = SKLabelNode()
            bd_two_label.text = "DRAGONS"
            bd_two_label.fontName = "GillSans-Bold"
            bd_two_label.fontSize =  bd_two_button.size.width/LONGESTSTRCOUNT
            bd_two_button.addChild(bd_two_label)
        
        // LEADERBOARD
        let bd_three_label = SKLabelNode()
            bd_three_label.text = "LEADERBOARD"
            bd_three_label.fontName = "GillSans-Bold"
            bd_three_label.fontSize = bd_three_button.size.width/LONGESTSTRCOUNT
            bd_three_button.addChild(bd_three_label)
        
        //DRAG TO MOVE
        let dragtomove = SKSpriteNode()
            dragtomove.size = CGSize(width: screenSize.width/2, height: screenSize.height/32)
            dragtomove.position = CGPoint(x: 0, y: -screenSize.height/4)
            dragtomove.texture = global.getMainTexture(main: .Main_Menu_Drag_To_Start)
            dragtomove.name = "drag_to_move"
            root.addChild(dragtomove)
        
        // Drag arrow Left
        let arrowLeft = SKSpriteNode()
            arrowLeft.size = CGSize(width: dragtomove.size.height, height: dragtomove.size.height*1.2)
            arrowLeft.position = CGPoint(x: dragtomove.position.x - dragtomove.size.width/2 - 20, y: dragtomove.position.y)
            arrowLeft.texture = global.getMainTexture(main: .Main_Menu_Arrow)
            arrowLeft.name = "main_menu_arrow_left"
            arrowLeft.zRotation = CGFloat(Double.pi)
            root.addChild(arrowLeft)
        
        // Drag arrow Right
        let arrowRight = SKSpriteNode()
        
            arrowRight.size = CGSize(width: dragtomove.size.height, height: dragtomove.size.height*1.2)
            arrowRight.position = CGPoint(x: dragtomove.position.x + dragtomove.size.width/2 + 20, y: dragtomove.position.y)
            arrowRight.texture = global.getMainTexture(main: .Main_Menu_Arrow)
            arrowRight.name = "main_menu_arrow_right"
            root.addChild(arrowRight)
        
        // Actions to sprites
        let buildMove = SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: -5, duration: 2.3), SKAction.moveBy(x: 0, y: 5, duration: 1.8)]))
            bd_one.run(buildMove)
            bd_two.run(buildMove)
            bd_three.run(buildMove)
        
        cloud2.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: 15, duration: 3), SKAction.moveBy(x: 0, y: -15, duration: 3)])))
        
        cloud2.run(SKAction.repeatForever(SKAction.sequence([SKAction.scale(to: 1.0, duration: 3.5), SKAction.scale(to: 1.1, duration: 3)])))
        
        arrowLeft.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: -5, y: 0, duration: 0.3), SKAction.moveBy(x: 5, y: 0, duration: 0.4)])))
        
        arrowRight.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 5, y: 0, duration: 0.3), SKAction.moveBy(x: -5, y: 0, duration: 0.4)])))
        
    }
    
    private func loadgameinfo(){
        // Check if any error from loading gameinfo
        let check = gameinfo.load(scene: self)
     
        
        if(!check.0){
            print("LOADING ERROR: ", check.1)
            return
        }

        let player = gameinfo.getCurrentToonNode()
        player.position = CGPoint(x: screenSize.midX, y: 250)
        self.addChild(player)
    }
    
    // MARK: COLLECTIONVIEW EGGS UP LEFT SCREEN
    private func loadGameEggs() {
          
        view?.addSubview(GameInfo.tableInfoBarEggs)
    }
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var pos:CGPoint!
        
        for touch in touches{
            
            pos = touch.location(in: self)
        }
        
       
        
        let childs = self.nodes(at: pos)
        for c in childs{
            if c.name == "character_building_button"{
                gameinfo.prepareToChangeScene(scene: .Character_Menu,skscene: self)
            }
            else if c.name == "building_2_button_dragons" {
                gameinfo.prepareToChangeScene(scene: .Dragons,skscene: self)
            }
            else if c.name == "icon_settings"{
                c.run(gameinfo.mainAudio.getAction(type: .ChangeOption))
                scene?.backgroundBlack(withSpinnerActive: false)
                scene?.view?.addSubview(gameinfo.showMenuSettings())
             
            }
            else if c.name == "icon_cancel"{
                
                c.run(gameinfo.mainAudio.getAction(type: .ChangeOption))
                removeBlur(blurNode: blurNode)
                childNode(withName: "bgSettings")?.removeFromParent()
            }
            else if ((c.name?.contains("Btn")) == true){
                c.run(gameinfo.mainAudio.getAction(type: .ChangeOption))

                guard let key = c.name?.replacingOccurrences(of: "Btn", with: "").lowercased(),
                      let node = c as? SKSpriteNode else { return}
            
              //  setInfoUser(key: key ,node: node)
                    
          
                }
            else if (c.name?.contains("tap") == true) {
                guard let name = c.name else { return }
                managedPressTapButon(name: name)
                
            }
        }
    }
    

    private func managedPressTapButon(name:String) {
        
        let str = name.components(separatedBy: CharacterSet.decimalDigits).joined(separator: "")

        switch str {
            case "tapToHatchSlot_":
            backgroundBlack(withSpinnerActive: true)
                addChild(eggsClaim.viewTapToHatch())
            case "tapHatch":
                gameinfo.prepareToChangeScene(scene: .BuyDragon,skscene: self)
            
        default:break
        }
    }
    @objc func handlePanFrom(recognizer : UIPanGestureRecognizer) {
        
        let toon = gameinfo.getCurrentToon()
        let player = gameinfo.getCurrentToonNode()
        
    
        if !isPlayerMoved && scene?.isPaused == false{
            isPlayerMoved = true
            
            gameinfo.changeGameState(.Start)
            gameinfo.infobar?.remove()
            eggsClaim.disableAlphaEggsAndSettings()
            player.position.y = 50
            /*
            guard let attack = toon.attack(scene: self, gameState: gameinfo.gamestate) else { return }
            player.run(attack)
       //     _ = gameinfo.dragon.map {  gameinfo.addChild($0.dragon) }
             */
        }
        
        if recognizer.state == .began {
            
        } else if recognizer.state == .changed {
            let locomotion = recognizer.translation(in: recognizer.view)
            
             player.position.x = player.position.x + locomotion.x*2.0
            
         /*   if (player.position.y  < screenSize.height - player.size.height) {
                player.position.y = player.position.y - locomotion.y*2.0
            }*/
          
            recognizer.setTranslation(CGPoint(x: 0,y: 0), in: self.view)
            if (player.position.x < 0 ){
                player.position.x = 0
            }
            else if (player.position.x > screenSize.width){
                player.position.x = screenSize.width
            }/* else if (player.position.y < 0 ) {
                player.position.y =  player.size.height
            }*/
            
            if (locomotion.x < -1){
                player.run(SKAction.rotate(toAngle: 0.0872665, duration: 0.1))
            }
            else if (locomotion.x > 0.5){
                player.run(SKAction.rotate(toAngle: -0.0872665, duration: 0.1))
            }
            else if (locomotion.x == 0.0){
                player.run(SKAction.rotate(toAngle: 0, duration: 0.1))
            }
            
        } else if recognizer.state == .ended {
            player.run(SKAction.rotate(toAngle: 0, duration: 0.1))
            
        }
        else if recognizer.state == .cancelled{
            print ("FAILED CANCEL")
        }
        else if recognizer.state == .failed{
            print ("FAILED")
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        let toon = gameinfo.getCurrentToon()
        let player = gameinfo.getCurrentToonNode()
      
        
        self.gameinfo.dragon?[0].dragon.position = CGPoint(x: player.position.x-75, y: player.position.y-50)
        self.gameinfo.dragon?[1].dragon.position = CGPoint(x: player.position.x+75, y: player.position.y-50)
        
       
        toon.updateProjectile(node:player)
        self.gameinfo.dragon?[0].updateProjectile(node: player,direcction: .Left)
        self.gameinfo.dragon?[1].updateProjectile(node: player,direcction: .Right)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var contactType:ContactType = .None
        var higherNode:SKSpriteNode?
        var lowerNode:SKSpriteNode?
        
        
        
        guard ((contact.bodyA.node as? SKSpriteNode) != nil) && ((contact.bodyB.node as? SKSpriteNode) != nil) else { return }
        
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask{
            higherNode = contact.bodyA.node as! SKSpriteNode?
            lowerNode = contact.bodyB.node as! SKSpriteNode?
        }
        else if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            higherNode = contact.bodyB.node as! SKSpriteNode?
            lowerNode = contact.bodyA.node as! SKSpriteNode?
        }
        else{  return }
        
        guard let h_node = higherNode, let l_node = lowerNode else { return }

        
        if (h_node.physicsBody!.categoryBitMask == PhysicsCategory.Imune) && l_node.name!.contains("Regular") {
            contactType = .Immune
        }
        else if (l_node.name!.contains("Enemy_Ball_Hand_") && (h_node.name!.contains("Enemy_FX_"))) {
            contactType = .BallEnemyByToon
        }
        else if (l_node.name!.contains("Enemy_") && h_node.name!.contains("bullet")){
            contactType = .EnemyGotHit
        }
        else if l_node.name! == "toon" && h_node.name! == "coin"{
            contactType = .PlayerGetCoin
        }
        else if l_node.name! == "toon" && (h_node.name == "ruby" || h_node.name == "diammond" || h_node.name! == "amethyst") {
            contactType = .PlayerGetGem
        }
        else if l_node.name! == "toon"  && h_node.name!.contains("Enemy"){
            contactType = .HitByEnemy
        }
        else if l_node.name!.contains("dragon")  && h_node.name!.contains("Enemy"){
            contactType = .HitByDragon
        }
        else if l_node.name! == "toon" && ["common","bronze","golden","magical","silver"].contains(where: h_node.name!.contains) {
            
            contactType = .HitByEggs
        }
        else if l_node.name! == "toon" && h_node.name! == "mushroom" {
            contactType = .ToonByMushroom
        }
        else if l_node.name! == "toon" && h_node.name! == "clover" {
            contactType = .ToonByClover
        }
        else if l_node.name! == "toon" && h_node.name! == "flower" {
            contactType = .ToonByFlower
        }
        
        else if l_node.name! == "toon" && h_node.name! == "magnet" {
            contactType = .ToonByMagnet
        }
        else if l_node.name!.contains("toon") && h_node.name == "Enemy_Attack"{
            // Handle case where bullet hit enemy's attack
             return
        }
        
        contactUpdate(lowNode: l_node, highNode: h_node, contactType: contactType)
    }
  
    func contactUpdate(lowNode: SKSpriteNode, highNode: SKSpriteNode, contactType:ContactType){
        var regular = gameinfo.regular_enemies
        var boss = gameinfo.boss
        var armored = gameinfo.armored
        var cofre = gameinfo.cofre
        var buitre = gameinfo.buitre
        let toon = gameinfo.getCurrentToon()
        let player = gameinfo.getCurrentToonNode()
       
        switch contactType{
            
        case .HitByEggs:
            run(gameinfo.mainAudio.getAction(type: .Gem))
            guard let icon =  Currency.EggsCurrencyType.allCases.filter({ $0.name == highNode.name?.capitalized}).first else { return }
            do {
                if let data = try EggsDB.add(egg: icon) {
                    
                    GameInfo.tableInfoBarEggs.addEggs(typeEgg:data)
                }
            }catch  let error {
                print("Error HitEggs \(error.localizedDescription)")
            }
        
        case .ToonByMushroom:
            let name = "Shield"
            if (player.childNode(withName: name) == nil) {
                let aura = toon.showAuraShield(atlas: name,gameState: .Running)
                player.addChild(aura)
            }
            
        case .ToonByMagnet: break
            /*
            guard let attack = toon.attack(scene: self, gameState: .Running) else { return }
            
            DispatchQueue.main.asyncAfter(wallDeadline: .now()) { [self] in
                physicsWorld.speed = 2
                player.run(.group([
                    
                    gameinfo.mainAudio.getAction(type: .Magnet),
                    attack,
                    self.gameinfo.mainAudio.getAction(type: .Jade_Attack)
                ]))
                self.gameinfo.changeGameState(.Attack)
            }
             */
        case .ToonByFlower:
            
            let name = "AuraPlayer"
            if (player.childNode(withName: name) == nil) {
                let aura = toon.showAuraShield(atlas: name,gameState: .Running)
                player.addChild(aura)
            }
          
               
        case .ToonByClover:
    
            let nameButton =  "BulletButton"
            self.enumerateChildNodes(withName: nameButton) { node, obj in
                node.removeFromParent()
            }
            
            self.run(.sequence([
                gameinfo.mainAudio.getAction(type: .Clover),
                .run {
                    self.gameinfo.currentBullet += 1
                },
                .wait(forDuration: 15),
                .run {
                    self.gameinfo.currentBullet -= 1
                }]))
       
            
        case .BallEnemyByToon:
            
            lowNode.destroy()
            self.run(gameinfo.mainAudio.getAction(type: .BallToIce))

            let sideEffectX =  highNode.name!.contains("Enemy_FX_R")
           
            let position = self.convert(highNode.position, from: highNode.parent!)
            
            guard let emitter = SKEmitterNode().contactBallHandEnemy(sideEffectX: sideEffectX, position: position) else { return}
            
            emitter.run(.sequence([.wait(forDuration: 5),.removeFromParent()]))
            self.addChild(emitter)
            
        case .EnemyGotHit:
           
            // Generate FX Effect
            //converting bullet to mainscene's coordinate
            let newPos = self.convert(highNode.position, from: highNode.parent!)
            guard let effect = gameinfo.getToonBulletEmmiterNode(x: newPos.x, y: newPos.y) else { return }
            self.addChild(effect)
            
            // update enemy
            highNode.destroy()
            
            if lowNode.name!.contains("Regular"){
                regular?.enemyModel?.run(.applyImpulse(CGVector(dx: 0,dy: 1000), duration: 0.1))
                regular?.decreaseHP(ofTarget: lowNode, hitBy: highNode,scene: self)
            }
            else if lowNode.name!.contains("Boss"){
                boss?.decreaseHP(ofTarget: lowNode, hitBy: highNode,scene: self)
            }
            else if lowNode.name!.contains("Enemy_Armored"){
                armored?.decreaseHP(ofTarget: lowNode, hitBy: highNode,scene: self)
            }
            else if lowNode.name!.contains("Enemy_Buitre"){
                buitre?.decreaseHP(ofTarget: lowNode, hitBy: highNode,scene: self)
            }
            else if lowNode.name!.contains("Cofre"){
                
                cofre?.decreaseHP(ofTarget: lowNode, hitBy: highNode,scene: self)
            }
            else{
                print("WARNING: Should not reach here. Check contactUpdate in StartGame.swift H-\(highNode) L- \(lowNode)")
            }
         
       
            /// Contact with enemy
        case .HitByEnemy:
            
            guard let hitparticle = SKEmitterNode().contactEnemy(node: lowNode) else { return }
            self.addChild(hitparticle)
            self.run(gameinfo.mainAudio.getAction(type: .Player_Death))
            let bg = SKSpriteNode(color: .red.withAlphaComponent(0.5), size: CGSize(width: screenSize.maxX, height: screenSize.maxY))
            bg.anchorPoint = CGPoint(x: 0, y: 0)
            bg.run(.sequence([.fadeIn(withDuration: 0.5),
                              .colorize(with: .white.withAlphaComponent(0.5), colorBlendFactor: 1, duration: 0.5),
                              .run { [self] in
                                bg.removeFromParent()
                                lowNode.removeAllActions()
                                lowNode.removeFromParent()
                                highNode.removeAllActions()
                                  gameinfo.prepareToChangeScene(scene: .EndScene,skscene: self)
            }]))
            self.addChild(bg)
            
        case .Immune:
            
            self.run(gameinfo.mainAudio.getAction(type: .Puff))
            guard let enemy = lowNode as? Enemy else { return }
            if let emitter = SKEmitterNode(fileNamed: "selectedChar-One") {
                emitter.position = enemy.position
                emitter.run(.sequence([.wait(forDuration: 0.5),.removeFromParent()]))
                self.addChild(emitter)
               
            }
            enemy.defeated()
            lowNode.destroy()
            
        case .PlayerGetGem:
            self.run(self.gameinfo.mainAudio.getAction(type: .Gem))
            
            let currency = Currency.CurrencyType.init(rawValue: highNode.name!.capitalized)
            
            if currency != .None {
                self.gameinfo.addCoin(amount: currency!.currency)
                addLabelAddCoin(sknode: lowNode,currency:currency!.currency)
            }
            highNode.destroy()
            
        case .PlayerGetCoin:
            self.run(self.gameinfo.mainAudio.getAction(type: .Coin))
            
            let currency = Currency.CurrencyType.init(rawValue: highNode.name!.capitalized)
            
            if currency != .None {
                
                self.gameinfo.addCoin(amount: currency!.currency)
                addLabelAddCoin(sknode: lowNode,currency:currency!.currency)
            }
            highNode.destroy()
            
        case .None: break
        case .HitByDragon:
            
            print("contacto con dragon")
        }
    }
  
    // MARK: ADD LABEL COIN WHEN PLAYER GET ITEM
    func addLabelAddCoin(sknode:SKSpriteNode,currency:Int) {
        
        let label = SKLabelNode(fontNamed: "Cartwheel", andText: "+\(currency)", andSize: 30, fontColor: .yellow, withShadow:.black )
        label?.position = sknode.position
        addChild(label!)
        label?.run(.sequence([
            .wait(forDuration: 0.5),
            .fadeOut(withDuration: 0.5),
            .run {
                label?.removeFromParent()
            }
        ]))
    }
    
   
   
   
}


