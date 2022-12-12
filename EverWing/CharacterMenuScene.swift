//
//  CharacterMenuScene.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit



protocol ProtocolTaskScenes {
    func doTask(gb:Global.Main)
}



class CharacterMenuScene:SKScene,ProtocolTaskScenes{
    
    deinit{
        print("CharacterMenuScene deinitiated")
    }
  
    
    private enum Update{
        case ToonSelected,ToonChanged
    }

    private var charNode = SKSpriteNode()
   
    var gameinfo:GameInfo!
    
    private var currToonIndex = 0 {
        willSet {
            gameinfo.requestChangeToon(index: newValue)
        }
    }
    private let bulletMaker = BulletMaker()
    
    override func didMove(to view: SKView) {
        
       self.anchorPoint = CGPoint(x: 0, y:0)
        currToonIndex = gameinfo.requestCurrentToonIndex()
        loadBackground()
        load()
        
       let _ = self.view?.subviews.filter{$0.restorationIdentifier == "infobar"}.map { $0.removeFromSuperview()}
    }
    
    private func loadBackground(){
        let bg = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_Background))
        bg.anchorPoint = CGPoint(x: 0, y: 0)
        bg.size = CGSize(width: screenSize.width, height: screenSize.height)
        self.addChild(bg)
    }
    
    private func load(){
        
        let check = gameinfo.load(scene: self,audio: .CharacterMenuScene)
        if(!check.0){
            print("LOADING ERROR: ", check.1)
            return
        }
        
        currToonIndex = self.gameinfo.requestCurrentToonIndex()

        let title = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_TitleMenu))
            title.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            title.size = CGSize(width: screenSize.width*0.6, height:  screenSize.height*0.1)
            title.position = CGPoint(x: screenSize.width/2, y: UIDevice().isPhone() ? screenSize.height*0.9 :screenSize.height)

        
        let titleLabel = SKLabelNode(fontNamed: "Family Guy")
            titleLabel.text = "EVERWING ACADEMY"
            titleLabel.fontColor = SKColor(red: 254/255, green: 189/255, blue: 62/255, alpha: 1)
            titleLabel.fontSize = screenSize.width/28
            title.addChild(titleLabel.shadowNode(nodeName: "monogradient"))
        self.addChild(title)
        
        let backarrow = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_BackArrow))
            backarrow.name = Global.Main.Character_Menu_BackArrow.rawValue
            backarrow.position = CGPoint(x: screenSize.width*0.1, y: title.position.y + 3)
            backarrow.size = CGSize(width: screenSize.width/8, height: screenSize.height*0.06)
        self.addChild(backarrow)
        
        let Larrow = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_LeftArrow))
            Larrow.position.x = screenSize.width*0.1
            Larrow.position.y = screenSize.height*0.6
            Larrow.size = CGSize(width: screenSize.width/8, height: screenSize.height*0.1)
            Larrow.name = Global.Main.Character_Menu_LeftArrow.rawValue
        self.addChild(Larrow)
        
        let Rarrow = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_RightArrow))
            Rarrow.position.x = screenSize.width*0.9
            Rarrow.position.y = screenSize.height*0.6
            Rarrow.size = CGSize(width: screenSize.width/8, height: screenSize.height*0.1)
            Rarrow.name = Global.Main.Character_Menu_RightArrow.rawValue
        self.addChild(Rarrow)
        
        do {
            charNode.texture = SKTexture(image: UIImage(named: try ManagedDB.shared.getCharacterPlayer().name!.rawValue)!)
            charNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            charNode.position = CGPoint(x: screenSize.midX, y: screenSize.height * 0.6)
            charNode.size = CGSize(width: screenSize.width/1.5, height: screenSize.height/2.55)
            charNode.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.moveBy(x: 0, y: 10, duration: 1),
                SKAction.moveBy(x: 0, y: -10, duration: 1.2)])))
            self.addChild(charNode)
        } catch {
            fatalError()
        }
      
        let gEffect = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_GroundEffect))
        let scaleY = SKAction.scaleY(to: -0.4, duration: 0)
        let scaleX = SKAction.scaleX(to: 2, duration: 0)
        let distort = SKAction.group([scaleX, scaleY])
            gEffect.name = Global.Main.Character_Menu_GroundEffect.rawValue
            gEffect.position = CGPoint(x: charNode.position.x, y: screenSize.height*0.35)
            gEffect.run(distort)
        self.addChild(gEffect)
        
        do {
            try drawPanelWood(character: ManagedDB.shared.getCharacterByName(name:  ManagedDB.shared.getCharacterPlayer().name!))
            
        } catch  { fatalError()}
        
        update(Case: .ToonChanged)
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var pos:CGPoint!
        
        for touch in touches{
            pos = touch.location(in: self)
        }
      
        for c in nodes(at: pos){
            if c.name == Global.Main.Character_Menu_BackArrow.rawValue{
                doTask(gb: .Character_Menu_BackArrow)
            }
            else if c.name == Global.Main.Character_Menu_RightArrow.rawValue{
                doTask(gb: .Character_Menu_RightArrow)
            }
            else if c.name == Global.Main.Character_Menu_LeftArrow.rawValue{
                doTask(gb: .Character_Menu_LeftArrow)
            }
        }
    }
    
    internal func doTask(gb:Global.Main){
        
        self.run(gameinfo.mainAudio.getAction(type: .ChangeOption))

        switch gb {
            case .Character_Menu_BackArrow:
              
                gameinfo.prepareToChangeScene(scene: .MainScene, skscene: self)
                
            case .Character_Menu_LeftArrow:
             
                prevArrow(currToon: MainScene.accountInfo.getToonByIndex(index: currToonIndex))
            
            case .Character_Menu_RightArrow:
              
               nextArrow(currToon: MainScene.accountInfo.getToonByIndex(index: currToonIndex))
           
            default:
                print("Should not reach Here - doTask from CharacterMenuScene")
        }
    }
    
    private func update(Case: Update){
    
        let toon = MainScene.accountInfo.getToonByIndex(index: currToonIndex)
    
        let groundEffect = self.childNode(withName: Global.Main.Character_Menu_GroundEffect.rawValue)!
      
        switch Case {
      
        case .ToonChanged:
          
            if toon.getCharacter()  != gameinfo.accountInfo.getActualPlayer().getCharacter(){
                groundEffect.isHidden = true
               
            }
            else{
                groundEffect.isHidden = false
               
            }
            updateToonUI(toon: toon)
      
        case .ToonSelected:
            self.gameinfo.requestChangeToon(index: self.currToonIndex)
            groundEffect.isHidden = false
           
            selectedCharAnimation()
        }
    }
       
    private func updateToonUI(toon:Toon){
        
        charNode.texture! =  SKTexture(imageNamed: toon.getCharacter().rawValue)
        
        do {
            let newToon = try ManagedDB.shared.getCharacterByName(name: toon.getCharacter())
            
            self.drawPanelWood(character:  newToon)
        }catch {
            fatalError()
        }
    }
   
    private func nextArrow(currToon:Toon){
        currToonIndex +=  1
        
        if (currToonIndex >= MainScene.accountInfo.getTotalCharacter()-1){
            currToonIndex = 0
        }
      
        update(Case: .ToonChanged)
    }
    
    private func prevArrow(currToon:Toon){
        currToonIndex -= 1
        
        if (currToonIndex < 0){
            currToonIndex = MainScene.accountInfo.getTotalCharacter()-1
        }
        
        update(Case: .ToonChanged)
    }
  
    private func selectedCharAnimation(){
        
        let yPos:CGFloat = screenSize.height*0.3
        
        let removeChildAction = SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()])
        let effect1 = SKEmitterNode(fileNamed: "selectedChar-One.sks")
        effect1?.position.y = yPos
        effect1?.position.x = screenSize.width/2
        effect1?.run(removeChildAction)
        effect1?.zPosition = -1.0
        addChild(effect1!)
        
        let effect2 = SKEmitterNode(fileNamed: "selectedChar-One.sks")
        effect2?.position.y = yPos
        effect2?.position.x = screenSize.width/2
        effect2?.run(removeChildAction)
        effect2?.zPosition = -1.0
        effect2?.emissionAngle = 0.698132 // Double.pi/180 * 40
        effect2?.xAcceleration = -550
        addChild(effect2!)
        
        let effect3 = SKEmitterNode(fileNamed: "selectedChar-Two.sks")
        effect3?.position.y = yPos
        effect3?.position.x = screenSize.width/2
        effect3?.run(removeChildAction)
        effect3?.zPosition = 0.0
        addChild(effect3!)
        
        let effect4 = SKEmitterNode(fileNamed: "selectedChar-Three.sks")
        effect4?.position.y = yPos
        effect4?.position.x = screenSize.width/2
        effect4?.run(removeChildAction)
        effect4?.zPosition = 1.0
        addChild(effect4!)
        
        let effect5 = SKEmitterNode(fileNamed: "selectedChar-Three.sks")
        effect5?.position.y = yPos
        effect5?.position.x = screenSize.width/2
        effect5?.run(removeChildAction)
        effect5?.zPosition = 1.0
        effect5?.emissionAngle = CGFloat(Double.pi/180 * 80)
        effect5?.xAcceleration = -400
        addChild(effect5!)
        
    }
}

extension CharacterMenuScene {
    
    /// #Description: Draw the bottom panel of wood
    private func drawPanelWood(character:CharactersDB) {
        
        let _ = self.view?.subviews.filter {$0.tag == 100}.map { $0.removeFromSuperview()}
     
        let panelWood = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height*0.3))
            panelWood.tag = 100
            panelWood.setBackgroundImage(img: UIImage(named: "characterPanel")!)
            self.view?.addSubview(panelWood)
            panelWood.translatesAutoresizingMaskIntoConstraints = false
            panelWood.leadingAnchor.constraint(equalTo: view!.leadingAnchor,constant: 0).isActive = true
            panelWood.trailingAnchor.constraint(equalTo: view!.trailingAnchor,constant: 0).isActive = true
            panelWood.bottomAnchor.constraint(equalTo: view!.bottomAnchor,constant: 0).isActive = true
            panelWood.heightAnchor.constraint(equalToConstant: screenSize.height*0.3).isActive = true
            panelWood.layoutIfNeeded()
        
        
        let panelTitle = UIImageView(image: UIImage(named: "panelWoodTitle")!)
            panelWood.addSubview(panelTitle)
            panelTitle.translatesAutoresizingMaskIntoConstraints = false
            panelTitle.centerXAnchor.constraint(equalTo: panelWood.centerXAnchor).isActive = true
            panelTitle.bottomAnchor.constraint(equalTo: panelWood.topAnchor,constant:0).isActive = true
            panelTitle.widthAnchor.constraint(equalToConstant: panelWood.frame.width/1.5).isActive = true
            panelTitle.heightAnchor.constraint(equalToConstant: (panelWood.frame.width/2)/3).isActive = true
        
        let characterName = UILabel()
            .addFontAndText(font: "Cartwheel", text: (character.characters?.name!.rawValue)!, size: 28)
            .shadowText(colorText: UIColor(patternImage: UIImage.gradientImage(bounds: panelTitle.bounds, colors: [.yellow,.orange])), colorShadow: .black, aligment: .center)
        panelTitle.addSubview(characterName)
        characterName.translatesAutoresizingMaskIntoConstraints = false
        characterName.centerXAnchor.constraint(equalTo: panelTitle.centerXAnchor).isActive = true
        characterName.centerYAnchor.constraint(equalTo: panelTitle.centerYAnchor,constant: -10).isActive = true
        characterName.layoutIfNeeded()
        
        let typeCharacter = UILabel()
            .addFontAndText(font: "Cartwheel", text: character.characters!.name!.type, size: 18)
            .shadowText(colorText: UIColor(patternImage: UIImage.gradientImage(bounds: panelTitle.bounds, colors: [.red,.yellow])), colorShadow: .black, aligment: .center)
        panelTitle.addSubview(typeCharacter)
        typeCharacter.translatesAutoresizingMaskIntoConstraints = false
        typeCharacter.topAnchor.constraint(equalTo: characterName.bottomAnchor).isActive = true
        typeCharacter.centerXAnchor.constraint(equalTo: characterName.centerXAnchor,constant: 0).isActive = true
        typeCharacter.layoutIfNeeded()
        

        let v1 = partialViewRank(pasteView: panelWood
                                 ,size: CGSize(width: panelWood.frame.width*0.9, height: max(60,panelWood.frame.height/4)),
                                 character: character)
        
        let txtDamage = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: 14, weight: .heavy), text: "DAMAGE", color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        panelWood.addSubview(txtDamage)
        txtDamage.translatesAutoresizingMaskIntoConstraints = false
        txtDamage.centerXAnchor.constraint(equalTo: panelWood.centerXAnchor,constant: -panelWood.frame.width/4).isActive = true
        txtDamage.topAnchor.constraint(equalTo: v1.bottomAnchor,constant: 0).isActive = true
        
        let txtPrisma = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: 14, weight: .heavy), text: (character.characters?.ability!.rawValue)!.uppercased(), color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        panelWood.addSubview(txtPrisma)
        txtPrisma.translatesAutoresizingMaskIntoConstraints = false
        txtPrisma.centerXAnchor.constraint(equalTo: panelWood.centerXAnchor,constant: panelWood.frame.width/4).isActive = true
        txtPrisma.topAnchor.constraint(equalTo: txtDamage.topAnchor,constant: 0).isActive = true
 
        let _ = partialViewProperties(pasteView:panelWood,size: CGSize(width: panelWood.frame.width*0.9, height: max(60,panelWood.frame.height/3)),character:character)
        
        showButtonsDown(panelWood: panelWood,character: character)

        
    }
    
    private func showButtonsDown(panelWood:UIView,character:CharactersDB) {
       
        let progress = { (v:UIView) -> UIView in
            return self.createBarProgress(size:v.frame.size,time: 4,character: character)
        }
        
        let btnShadow = { (title:String) -> UIButton in
            
            let myBtn = UIButton()
                myBtn.setBackgroundImage(UIImage(named: "BlueButton"), for: .normal)
                myBtn.setTitle(title, for: .normal)
                myBtn.layer.shadowRadius = 2
            myBtn.layer.shadowOpacity = 0.5
                myBtn.layer.shadowColor = UIColor.black.cgColor
                myBtn.setTitleShadowColor(.black, for: .normal)
                myBtn.titleLabel?.shadowOffset = CGSize(width: 1, height: 1)
                myBtn.titleLabel?.textAlignment = .center
                myBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
                myBtn.titleLabel?.numberOfLines = 0
            
            return myBtn
        }
            
        let btnUpgrade = btnShadow("UPGRADE\n\(character.characters!.name!.updateBulletCoin)")
        
            let iconCoin = UIImage(named: "coin")!.resized(to: CGSize(width: panelWood.frame.width*0.05, height: panelWood.frame.width*0.05))
                btnUpgrade.setImage(iconCoin, for: .normal)
                btnUpgrade.imageEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0  )
                btnUpgrade.semanticContentAttribute = .forceRightToLeft
                btnUpgrade.contentEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
                panelWood.addSubview(btnUpgrade)
               
                btnUpgrade.translatesAutoresizingMaskIntoConstraints = false
                btnUpgrade.centerXAnchor.constraint(equalTo: panelWood.centerXAnchor,constant: -panelWood.frame.width/4).isActive = true
                btnUpgrade.widthAnchor.constraint(equalToConstant: max(150,panelWood.frame.width/4)).isActive = true
                btnUpgrade.heightAnchor.constraint(equalToConstant: max(60,(panelWood.frame.width/4)/3)).isActive = true
                btnUpgrade.bottomAnchor.constraint(equalTo: panelWood.bottomAnchor,constant: -5).isActive = true
                btnUpgrade.addAction(for: .touchUpInside) {
           
                    let progress = progress(btnUpgrade)
                    panelWood.addSubview(progress)
                    progress.translatesAutoresizingMaskIntoConstraints = false
                    progress.bottomAnchor.constraint(equalTo: btnUpgrade.topAnchor).isActive = true
                    progress.leadingAnchor.constraint(equalTo: btnUpgrade.leadingAnchor).isActive = true
                    progress.widthAnchor.constraint(equalTo: btnUpgrade.widthAnchor).isActive = true
                    progress.heightAnchor.constraint(equalToConstant: btnUpgrade.frame.height/3).isActive = true
                }

    let btnEquip = btnShadow("EQUIPPED")
        panelWood.addSubview(btnEquip)
        btnEquip.translatesAutoresizingMaskIntoConstraints = false
        btnEquip.centerXAnchor.constraint(equalTo: panelWood.centerXAnchor,constant: panelWood.frame.width/4).isActive = true
        btnEquip.widthAnchor.constraint(equalTo: btnUpgrade.widthAnchor).isActive = true
        btnEquip.heightAnchor.constraint(equalTo: btnUpgrade.heightAnchor).isActive = true
        btnEquip.bottomAnchor.constraint(equalTo: panelWood.bottomAnchor,constant: -5).isActive = true
        btnEquip.addAction(for: .touchUpInside) {
            do {
                if try ManagedDB.shared.changePlayerEquip(character: character.characters!) {
                    self.update(Case: .ToonSelected)
                    self.gameinfo.requestChangeToon(index: Toon.Character.allCases.firstIndex { $0.rawValue == character.characters?.name?.rawValue}!)
                }
            } catch let error {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    private func showRectangleProperties(side:Direction,panelWood:UIView,character:CharactersDB) {
        
        let rectangleBck = UIView().cornerRadius(radius: 5)
            rectangleBck.backgroundColor = UIColor(red: 205/255, green: 157/255, blue: 112/255, alpha: 1).withAlphaComponent(0.8)
            panelWood.addSubview(rectangleBck)
            rectangleBck.translatesAutoresizingMaskIntoConstraints = false
           
            if side == .Left {
                rectangleBck.leadingAnchor.constraint(equalTo: panelWood.leadingAnchor,constant: 5).isActive = true
            } else {
                rectangleBck.leadingAnchor.constraint(equalTo: panelWood.centerXAnchor,constant: 5).isActive = true
            }
                
            rectangleBck.heightAnchor.constraint(equalToConstant: panelWood.frame.height*0.9).isActive = true
            rectangleBck.widthAnchor.constraint(equalToConstant: panelWood.frame.width*0.48).isActive = true
            rectangleBck.centerYAnchor.constraint(equalTo: panelWood.centerYAnchor).isActive = true

            rectangleBck.layoutIfNeeded()
    
        let txtBase = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: 16, weight: .heavy), text: "BASE:", color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
            rectangleBck.addSubview(txtBase)
            txtBase.translatesAutoresizingMaskIntoConstraints = false
            txtBase.leadingAnchor.constraint(equalTo: rectangleBck.centerXAnchor,constant: -10).isActive = true
            txtBase.topAnchor.constraint(equalTo: rectangleBck.topAnchor,constant: 0).isActive = true
        
        let txtValBase = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: 16, weight: .heavy), text: "15", color: .white)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
            rectangleBck.addSubview(txtValBase)
            txtValBase.translatesAutoresizingMaskIntoConstraints = false
            txtValBase.leadingAnchor.constraint(equalTo: txtBase.trailingAnchor,constant: 5).isActive = true
            txtValBase.topAnchor.constraint(equalTo: txtBase.topAnchor,constant: 0).isActive = true
        
        let txtBonus = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: 16, weight: .heavy), text: "BONUS:", color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
            rectangleBck.addSubview(txtBonus)
            txtBonus.translatesAutoresizingMaskIntoConstraints = false
            txtBonus.leadingAnchor.constraint(equalTo: rectangleBck.centerXAnchor,constant: -10).isActive = true
            txtBonus.centerYAnchor.constraint(equalTo: rectangleBck.centerYAnchor,constant: 0).isActive = true
        
        let txtValBonus = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: 16, weight: .heavy), text: "18", color: .white)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
            rectangleBck.addSubview(txtValBonus)
            txtValBonus.translatesAutoresizingMaskIntoConstraints = false
            txtValBonus.leadingAnchor.constraint(equalTo: txtBonus.trailingAnchor,constant: 5).isActive = true
            txtValBonus.topAnchor.constraint(equalTo: txtBonus.topAnchor,constant: 0).isActive = true
        
        let txtTotal = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: 16, weight: .heavy), text: "TOTAL:", color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
            rectangleBck.addSubview(txtTotal)
            txtTotal.translatesAutoresizingMaskIntoConstraints = false
            txtTotal.leadingAnchor.constraint(equalTo: rectangleBck.centerXAnchor,constant: -10).isActive = true
            txtTotal.bottomAnchor.constraint(equalTo: rectangleBck.bottomAnchor,constant: 0).isActive = true
        
        let txtValTotal = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: 16, weight: .heavy), text: "\(15+18)", color: .white)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
            rectangleBck.addSubview(txtValTotal)
            txtValTotal.translatesAutoresizingMaskIntoConstraints = false
            txtValTotal.leadingAnchor.constraint(equalTo: txtTotal.trailingAnchor,constant: 5).isActive = true
            txtValTotal.bottomAnchor.constraint(equalTo: rectangleBck.bottomAnchor,constant: 0).isActive = true
        
        let backIcon = UIImageView(image: UIImage(named: "BulletButton")!)
            rectangleBck.addSubview(backIcon)
            backIcon.translatesAutoresizingMaskIntoConstraints = false
            backIcon.trailingAnchor.constraint(equalTo: rectangleBck.centerXAnchor,constant: -rectangleBck.frame.width*0.05).isActive = true
            backIcon.centerYAnchor.constraint(equalTo: rectangleBck.centerYAnchor,constant: 0).isActive = true
            backIcon.widthAnchor.constraint(equalTo: rectangleBck.heightAnchor,constant: -5).isActive = true
            backIcon.heightAnchor.constraint(equalTo: backIcon.widthAnchor).isActive = true
           
           
        if side == .Right {
            let inset:CGFloat = UIDevice().isPhone() ? 15 : 5
            let image = UIImage(named: (character.characters?.ability!.rawValue)!)?.resized(to: backIcon.frame.insetBy(dx: inset, dy: inset).size)
            let vImage = UIImageView(image: image)
            backIcon.addSubview(vImage)
            vImage.translatesAutoresizingMaskIntoConstraints = false
            vImage.centerXAnchor.constraint(equalTo: backIcon.centerXAnchor).isActive = true
            vImage.centerYAnchor.constraint(equalTo: backIcon.centerYAnchor).isActive = true
            
        } else {
                
             let _ = drawBulletIconBullet(charModel: character, viewPaste: backIcon)!
            
            let txtLVL = UILabel()
                .addTextWithFont(font: UIFont.systemFont(ofSize: 18, weight: .heavy), text: "LV \(character.level)", color: .white)
                .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
            backIcon.addSubview(txtLVL)
            txtLVL.translatesAutoresizingMaskIntoConstraints = false
            txtLVL.bottomAnchor.constraint(equalTo: backIcon.bottomAnchor,constant: 0).isActive = true
            txtLVL.centerXAnchor.constraint(equalTo: backIcon.centerXAnchor,constant: 0).isActive = true
        }
     
    }
    
    private func drawBulletIconBullet(charModel:CharactersDB,viewPaste:UIView) -> UIView? {
        
         bulletMaker.makeBulletCharacter( char: charModel, view: viewPaste)
    }
    
    private func ShowViewSummons() {
        
        showGenericViewTable(skScene: self, items: BuySummons.items, title: "STAR SUMMONS",gameInfo: gameinfo) { v in
            
            self.view?.addSubview(v)
        }
    }
    
    private func ShowTableInfo(character:CharactersDB) {
        
        let items = Toon.Character.Table.items.filter { $0.name == character.characters?.name?.rawValue}
       
        self.view?.scene?.genericTableView(items: items,gameInfo: gameinfo)
    }
    
    private func createBarProgress(size:CGSize, time:Int,character:CharactersDB) -> UIView {
        
        let progress = ProgressView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height/2),time: time) { _ in
            
            self.gameinfo.prepareToChangeScene(scene: .UpdateLeveCharacter, skscene: self,character: character)
        }
        
        return progress
    }
    
    private func partialViewRank(pasteView:UIView,size:CGSize,character:CharactersDB)  -> UIView{
        
        let btnShadow = { (title:String,button:String) -> UIButton in
            
            let myBtn = UIButton()
                myBtn.setBackgroundImage(UIImage(named: button), for: .normal)
                myBtn.setTitle(title, for: .normal)
                myBtn.layer.shadowRadius = 2
                myBtn.layer.shadowOpacity = 0.5
                myBtn.layer.shadowColor = UIColor.black.cgColor
                myBtn.setTitleShadowColor(.black, for: .normal)
                myBtn.titleLabel?.shadowOffset = CGSize(width: 1, height: 1)
                myBtn.titleLabel?.textAlignment = .center
                myBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
                myBtn.titleLabel?.numberOfLines = 0
            
            return myBtn
        }
        
        let color = UIColor(red: 205/255, green: 157/255, blue: 112/255, alpha: 1).withAlphaComponent(0.8)
        let backView = UIView().addRect(size: CGRect(x: 0, y: 0, width: size.width, height: size.height), fillColor: color, strokeColor: .black,shadow: true)
            pasteView.addSubview(backView)
            backView.translatesAutoresizingMaskIntoConstraints = false
            backView.topAnchor.constraint(equalTo: pasteView.topAnchor, constant: 5).isActive = true
            backView.centerXAnchor.constraint(equalTo: pasteView.centerXAnchor, constant: 0).isActive = true
            backView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            backView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            backView.layoutIfNeeded()
        
        let iconInfo = btnShadow("i","BlueButton")
            iconInfo.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            backView.addSubview(iconInfo)
            iconInfo.translatesAutoresizingMaskIntoConstraints = false
            iconInfo.centerYAnchor.constraint(equalTo: backView.topAnchor,constant: 0).isActive = true
            iconInfo.centerXAnchor.constraint(equalTo: backView.leadingAnchor,constant: 0).isActive = true
            iconInfo.widthAnchor.constraint(equalToConstant: 50).isActive = true
            iconInfo.heightAnchor.constraint(equalToConstant: 50).isActive = true
            iconInfo.layoutIfNeeded()
            iconInfo.addAction(for: .touchUpInside) {
                self.ShowTableInfo(character: character)
            }
        
        
        let rank = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: 18, weight: .heavy), text: "RANK:", color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
            backView.addSubview(rank)
            rank.translatesAutoresizingMaskIntoConstraints = false
            rank.leadingAnchor.constraint(equalTo: backView.leadingAnchor,constant: 5).isActive = true
            rank.topAnchor.constraint(equalTo: backView.topAnchor,constant: 5).isActive = true
            rank.layoutIfNeeded()
        
        let nRank = CGFloat((character.characters?.name!.rank)!)
        let progress = ProgressView(frame: CGRect(x: 0, y: 0, width: 0, height: 0),progress:5/nRank,label:.init(format: "1/%.0f", nRank))
            backView.addSubview(progress)
            progress.translatesAutoresizingMaskIntoConstraints = false
            progress.leadingAnchor.constraint(equalTo: rank.trailingAnchor,constant: 10).isActive = true
            progress.topAnchor.constraint(equalTo: rank.topAnchor,constant: 0).isActive = true
            progress.heightAnchor.constraint(equalTo: rank.heightAnchor,constant: 0).isActive = true
            progress.trailingAnchor.constraint(equalTo: backView.centerXAnchor,constant: 0).isActive = true
            progress.layoutIfNeeded()
        
        let btnSummon = btnShadow("SUMMON STAR\nSHARDS","GreenButton")
            btnSummon.contentEdgeInsets = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
            backView.addSubview(btnSummon)
            btnSummon.translatesAutoresizingMaskIntoConstraints = false
            btnSummon.widthAnchor.constraint(equalToConstant: max(120,backView.frame.width/3)).isActive = true
            btnSummon.heightAnchor.constraint(equalToConstant: 50).isActive = true
            btnSummon.topAnchor.constraint(equalTo: rank.topAnchor,constant: 0).isActive = true
            btnSummon.centerXAnchor.constraint(equalTo: backView.centerXAnchor,constant: backView.frame.width/4+25).isActive = true
            btnSummon.addAction(for: .touchUpInside) {
                self.ShowViewSummons()
            }
        
        let iconCard = UIImageView(image: UIImage(named: "cardGold"))
            backView.addSubview(iconCard)
            iconCard.translatesAutoresizingMaskIntoConstraints = false
            iconCard.centerXAnchor.constraint(equalTo: btnSummon.leadingAnchor).isActive = true
            iconCard.centerYAnchor.constraint(equalTo: btnSummon.centerYAnchor).isActive = true
            iconCard.widthAnchor.constraint(equalToConstant: 50).isActive = true
            iconCard.heightAnchor.constraint(equalTo: iconCard.widthAnchor).isActive = true
        
        let sizeStart:CGSize = CGSize(width: (pasteView.frame.width/2)/14, height: (pasteView.frame.width/2)/14)
        
         rank.drawStart(number: 0, margin: .bottomLeft, size: sizeStart,totalStart: 12)
        
        return backView
    }
    
    private func partialViewProperties(pasteView:UIView,size:CGSize,character:CharactersDB)  -> UIView {
        
        let backView = UIView().addRect(size: CGRect(x: 0, y: 0, width: size.width, height: size.height), fillColor: .brown.withAlphaComponent(1), strokeColor: .black,shadow: true)
            backView.layer.shadowOffset = CGSize(width: 2, height: 2)
            backView.layer.shadowColor = UIColor.darkGray.cgColor
            backView.layer.shadowRadius = 10
            backView.layer.cornerRadius = 10
            backView.layer.opacity = 1
            backView.layer.shadowOpacity = 1
            pasteView.addSubview(backView)
            backView.translatesAutoresizingMaskIntoConstraints = false
            backView.centerXAnchor.constraint(equalTo: pasteView.centerXAnchor).isActive = true
            backView.centerYAnchor.constraint(equalTo: pasteView.centerYAnchor).isActive = true
            backView.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            backView.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            backView.layoutIfNeeded()
        
        showRectangleProperties(side: .Left,panelWood:backView,character: character)
        
        showRectangleProperties(side: .Right,panelWood:backView,character: character)
    
        return backView
    }
}
