//
//  DragonsScene.swift
//  EverWing
//
//  Created by Pablo  on 28/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.


import Foundation
import SpriteKit

enum ActionButton:String,CaseIterable {
   case BackArrow          = "backArrow"
   case GetEggs            = "GetEggs"
   case Sell               = "SellDragon"
   case Index              = "Index"
   case CancelInfoDragon   = "CancelInfoDragon"
   case CancelFruitSell    = "CancelFruitSell"
  
   case btnMainToSell      = "btnMainToSell"
  
   case btnSellFruit       = "btnSellFruit"
   case txtSellFruit       = "txtSellFruit"
   case btnCancelBuyGem    = "btnCancelBuyGem"
   case btnBuyCoin         = "btnBuyCoin"

   
   var getNameView:String {
       switch self {
       
       case .GetEggs:               return "nodeMain"
       case .Sell:                  return "sellMainPage"
       case .Index:                 return  "indexMainPage"
       case .CancelInfoDragon:      return "viewInfoDragon"
       case .CancelFruitSell:       return "viewSellFruit"
     
       case .btnMainToSell:         return "viewBuyGem"
      
       case .btnSellFruit:          return "viewBuyGem"
       case .txtSellFruit:          return "viewBuyGem"
       case .btnCancelBuyGem:       return "viewBuyGem"
       case .BackArrow,.btnBuyCoin: return ""
           
       }
   }
}

class DragonsMenuScene:SKScene,ProtocolTaskScenes,ProtocolEffectBlur {
    
         
    private var gameinfo:GameInfo = GameInfo.shared
    
    private var eggsPage:UIView? = nil
    
    private var isHiddenPopup: Bool = false
    
    var blurNode: SKEffectNode = SKEffectNode()
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: screenSize.width, height: screenSize.height)
        scene?.name = "DragonsMenuScene"
       
        loadBackground()
        load()
        showMainPage()
    }
    
    private func loadBackground() {
        let bg = SKSpriteNode(texture: SKTexture(imageNamed: "Dragons_Background"))
        bg.anchorPoint = CGPoint(x: 0, y: 0)
        bg.size = CGSize(width: screenSize.width, height: screenSize.height)
        self.addChild(bg)
    }
    
    private func load(){
        
        // Title
        let title = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_TitleMenu))
        title.position = CGPoint(x:screenSize.midX,y:screenSize.height*0.85)
        title.size = CGSize(width: screenSize.width*0.6, height: screenSize.height*0.1)
        
        let titleLabel = SKLabelNode(fontNamed: "Family Guy")
        titleLabel.text = "DRAGON ROOST"
        titleLabel.fontColor = SKColor(red: 254/255, green: 189/255, blue: 62/255, alpha: 1)
        titleLabel.fontSize = screenSize.width/28
        title.addChild(titleLabel.shadowNode(nodeName: "titleEffectNodeLabel"))
        self.addChild(title)
        
       
        // BackArrow
        let backarrow = SKSpriteNode(texture: global.getMainTexture(main: .Character_Menu_BackArrow))
        backarrow.name = ActionButton.BackArrow.rawValue
        backarrow.position = CGPoint(x: title.frame.minX - 50, y: title.position.y + 3)
        backarrow.size = CGSize(width: screenSize.width/8, height: screenSize.height*0.06)
        self.addChild(backarrow)
        
        
        let bgIcons = SKSpriteNode(texture: SKTexture(imageNamed: "bgSandDragonScene"),
                                   size: CGSize(width: screenSize.width,
                                                height: screenSize.height*0.1))
        bgIcons.position = CGPoint(x: screenSize.midX, y: screenSize.minY)
        addChild(bgIcons)
        
        let sizeBtn = CGSize(width: screenSize.width/4, height: screenSize.width/10)
        let Btneggs = self.createUIButton(bname: ActionButton.GetEggs.rawValue,
                                          offsetPosX: screenSize.minX + screenSize.width*0.2,
                                          offsetPosY: screenSize.minY + sizeBtn.height/2,
                                          typeButtom: .GreenButton)
        Btneggs.size  = sizeBtn
        addChild(Btneggs)
        
        let labelEggs = SKLabelNode(fontNamed: "Cartwheel", andText: "GET EGGS", andSize: Btneggs.size.width*0.2, fontColor: .white, withShadow: .black,name: "labelEggsShadow")
        Btneggs.addChild(labelEggs!)
        
        let iconShieldEgg = SKSpriteNode(texture: SKTexture(imageNamed: Global.GUIButtons.ShieldEggs.rawValue),
                                         size: CGSize(width: Btneggs.size.width * 0.4, height: Btneggs.size.width * 0.5))
        iconShieldEgg.position = CGPoint(x:Btneggs.frame.width/2,y:0)
        
        let action = SKAction.repeatForever(.sequence(
            [.rotate(byAngle: -0.2, duration: 0.1),
             .rotate(byAngle: 0.2, duration: 0.1),
             .wait(forDuration: 5)
            ]))
        
        iconShieldEgg.run(action)
        Btneggs.addChild(iconShieldEgg)
        
        let Btnsell = self.createUIButton(bname: ActionButton.Sell.rawValue,
                                          offsetPosX: screenSize.width/2,
                                          offsetPosY: screenSize.minY + sizeBtn.height/2,
                                          typeButtom: .GreenButton)
        Btnsell.size  = sizeBtn
        addChild(Btnsell)
        
        let labelSell = SKLabelNode(fontNamed: "Cartwheel", andText: "SELL",
                                    andSize: Btneggs.size.width*0.2, fontColor: .white,
                                    withShadow: .black)
        labelSell?.name = ActionButton.Sell.rawValue
        Btnsell.addChild(labelSell!)
        
        
        let BtnIndex = self.createUIButton(bname: ActionButton.Index.rawValue,
                                           offsetPosX: screenSize.maxX - screenSize.width*0.2,
                                           offsetPosY: screenSize.minY + sizeBtn.height/2,
                                           typeButtom: .GreenButton)
        BtnIndex.size  = sizeBtn
        addChild(BtnIndex)
        
        let labelIndex = SKLabelNode(fontNamed: "Cartwheel",
                                     andText: "INDEX",
                                     andSize: Btneggs.size.width*0.2, fontColor: .white,
                                     withShadow: .black)
        BtnIndex.addChild(labelIndex!)
        
        let BtnBook = SKSpriteNode(texture: SKTexture(imageNamed: Global.GUIButtons.BookButton.rawValue),
                                   size: CGSize(width: BtnIndex.size.width * 0.5, height: BtnIndex.size.width * 0.6))
        BtnBook.position = CGPoint(x:BtnIndex.frame.width*0.4,y:0)
        BtnIndex.addChild(BtnBook)
    }
    
    /// - Description: Create the generic view for displaying all collections
    /// - Parameters : @width: CGFloat   width for view
    ///               @typeGrid: Enum TypeGridCollection Only display toon in th view main
    /// - Returns:    The view created
    private func templateMainGeneric(frame:CGRect,typeGrid:TypeGridCollection,hasCancelBtn:Bool) -> UIView {
        
        let sizePlayer = max(screenSize.width, screenSize.height)
        
        let mainView = UIView(frame: frame)
        mainView.setBackgroundImage(img: UIImage(named: typeGrid.picture)!)
        mainView.tag = 1
        self.view?.addSubview(mainView)
        
        if hasCancelBtn {
            
            let btnCancel = UIButton(frame: CGRect(x: frame.width - frame.size.width*0.1,
                                                   y: -frame.size.width*0.07 ,
                                                   width: frame.size.width*0.15,
                                                   height: frame.size.width*0.15))
            
            btnCancel.setImage(UIImage(named: "CancelButton"), for: .normal)
            btnCancel.addTarget(self, action: #selector(tapButtonCancel), for: .touchUpInside)
            mainView.addSubview(btnCancel)
        }
        
        if typeGrid == .main {
            let toon = gameinfo.getCurrentToonNode()
            toon.scale(to: CGSize(width: sizePlayer*0.06 , height: sizePlayer*0.1))
            toon.position = CGPoint(x: screenSize.midX, y: screenSize.height * 0.7)
            view!.scene?.addChild(toon)
        }
        
        return mainView
    }
    
    private func ManagedCollectionInView(view:UIView,type:TypeGridCollection,select:@escaping(Dragons)->Void,deSelect:@escaping(Dragons)->Void) -> UICollectionView{
       
       
        return  CustomCollectionViewEggs(frame: view.frame, items: Dragons.items, view: view, typeGridCollection: type) { [self] dragon in
            
             switch type {
                 case .eggs: break
                 case .main:  showPanelDragonCircle(item: dragon)
                 case .index: DetailDragonSelectCollection(dragon:dragon)
                 case .sell:  select(dragon)
              }
        }  handlerDeselect: { dragon in
            switch type {
                case .eggs,.main,.index: break
                case .sell:  deSelect(dragon)
            }
         }
           handlerTapAudio: { [self] in
                run(gameinfo.mainAudio.getAction(type: .ChangeOption))
        }
    }
    
    @objc private func tapCircleDragon(_ sender:UIButton) {

        if let nameImage = sender.restorationIdentifier {
                
        /*    guard let dragon =  Dragons.items.filter({ $0.picture.name == nameImage }).first else { return }
        
            showPanelDragonCircle(item: dragon)       */ }
    }
    
    // Search for purchased dragons in the database
    private func SearchDragonBuyInDB() -> Bool{
        
        let managed = ManagedDB.shared.context
        
        do {
            return try managed.fetch(DragonsBuyDB.fetchRequest()).count > 0
            
        }catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
  
    @objc func tapCounter() {
      //  childNode(withName:"viewBuyGem")?.removeFromParent()
        self.viewBuyGem(item: BuyFruit.items)
    }
    
    /****************************************************   END FUNCTIONS MENU SELL MAIN PAGE  *************************************************************/
  
    
    @objc override func tapButtonCancel(sender:UIButton) {

        removeUIViews()
        
        removeBackgroundBlack(removeBlur: blurNode)
        
        showMainPage()
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            guard let pos  = nodes(at: touch.location(in: self)).first,
                  let name =  pos.name,
                  let action = ActionButton(rawValue: name) else { return }
            
            run(gameinfo.mainAudio.getAction(type: .ChangeOption))

            print("Name",pos.name)
            switch action {
                
            case .GetEggs:                              genericTableView(items:BuyEggs.items)
             
            case .Sell:                                 SellMainPage(isBulkSell: .Bulk, isFeedBtn: false,item: nil)
            
            case .Index:                                showIndexPageBook()
                
            case .btnMainToSell,.btnCancelBuyGem,
                 .CancelFruitSell,.CancelInfoDragon:        removeBackgroundBlack(removeBlur: blurNode)
                                                            showMainPage()
                
            case .btnSellFruit, .txtSellFruit:         AnimationSellDragonGetFruit()
            
            case .BackArrow:                           doTask(gb: .Character_Menu_BackArrow)
                
            case .btnBuyCoin:
                if !howDo(pos:pos) {
                    showTypeListObject(pos:pos)
                }
            }
        }
    }
    
    //MARK: ACTION WHEN TAP BUTTON GREEN SELL DRAGON FOR FRUIT
    @objc private func sellTapButton(sender: UIButton) {
        
        sender.isEnabled = false
        
        guard let arimethic = sender.restorationIdentifier?.components(separatedBy: " ").first,
              let strTotal = sender.restorationIdentifier?.components(separatedBy: " ").last,
              let total = Int(strTotal) else { fatalError() }
        
        run(gameinfo.mainAudio.getAction(type: .ChangeOption))
        
        createAnimationFruitSell(typeObject: Icons.fruit,numberFruit: total) {  _  in
          
            if ManagedDB.addFruitTotal(addFruit: total,arimethic: arimethic) {
                self.tapButtonCancel(sender:sender)
            }
        }
    }

    
    //MARK: SHOW VIEW WHEN SELECT DRAGON COLLECTIONVIEW INDEX
    private func DetailDragonSelectCollection(dragon:Dragons) {
        
        let width = screenSize.width*0.9
        let height = screenSize.height*0.8
        let marginX = (screenSize.width-width)/2
        let marginY = (screenSize.height-height)/2
        let rect = CGRect(x: marginX, y: marginY, width: width, height: height)
        
        if let nodeMain = scene?.view?.subviews.filter({ $0.tag == 1}).first {
            
            UIView.animate(withDuration: 0.05) {
                nodeMain.transform = CGAffineTransform(translationX: screenSize.width, y: 0)
            
            } completion: { _ in
                nodeMain.removeFromSuperview()
            }
        }
        
        
        let view = templateMainGeneric(frame: rect, typeGrid: .index, hasCancelBtn: true)
        
        let dragonIcon = UIImageView(image: UIImage(named: dragon.picture.name)!)
        view.addSubview(dragonIcon)
        dragonIcon.translatesAutoresizingMaskIntoConstraints = false
        dragonIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dragonIcon.widthAnchor.constraint(equalToConstant: view.frame.width*0.5).isActive = true
        dragonIcon.heightAnchor.constraint(equalToConstant: view.frame.width*0.5).isActive = true
        dragonIcon.topAnchor.constraint(equalTo: view.topAnchor,constant: 10).isActive = true
        
        ManagedDB.shared.isBuyDragon(name: dragon.name) { exist in
             if !exist {
                 dragonIcon.image = dragonIcon.image?.maskWithColor(color: .black)
             }
        }
    
        let arrowL = UIButton()
            arrowL.setImage(UIImage(named:"iconExtra_0")!, for: .normal)
            arrowL.addTarget(self, action: #selector(tapArrowL(_:)), for: .touchUpInside)
            arrowL.restorationIdentifier = "\(dragon.picture.name)_Left"
        view.addSubview(arrowL)
        
        arrowL.translatesAutoresizingMaskIntoConstraints = false
        arrowL.centerYAnchor.constraint(equalTo: dragonIcon.centerYAnchor,constant: 0).isActive = true
        arrowL.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5).isActive = true
        
        let arrowR = UIButton()
            arrowR.setImage(UIImage(named:"iconExtra_1")!, for: .normal)
            arrowR.addTarget(self, action: #selector(tapArrowL(_:)), for: .touchUpInside)
            arrowR.restorationIdentifier = "\(dragon.picture.name)_Right"
            view.addSubview(arrowR)
        
        arrowR.translatesAutoresizingMaskIntoConstraints = false
        arrowR.centerYAnchor.constraint(equalTo: dragonIcon.centerYAnchor,constant: 0).isActive = true
        arrowR.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -5).isActive = true
        
        let element = UIImageView(image: UIImage(named: dragon.element + "_Weakness"))
            view.addSubview(element)
        
        element.translatesAutoresizingMaskIntoConstraints = false
        element.bottomAnchor.constraint(equalTo: dragonIcon.bottomAnchor,constant: 0).isActive = true
        element.leadingAnchor.constraint(equalTo: dragonIcon.trailingAnchor,constant: 15).isActive = true
        
        
        var star = UIImageView()
        let number = dragon.picture.name.getNumberStarName()
        for x in 0...2 {
            let image = x <= number ? "starB" : "starGray"
            star = UIImageView(image: UIImage(named: image))
            let x =  star.image!.size.width + CGFloat(CGFloat(x-1) * star.image!.size.width)
            view.addSubview(star)
            star.translatesAutoresizingMaskIntoConstraints = false
            star.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: x).isActive = true
            star.topAnchor.constraint(equalTo: dragonIcon.bottomAnchor,constant: 20).isActive = true
            star.widthAnchor.constraint(equalToConstant: star.frame.width).isActive = true
            star.heightAnchor.constraint(equalToConstant: star.frame.height).isActive = true
        }
        
        let sizeFont = view.frame.width * 0.05
        let shape = UIView()
            shape.layer.backgroundColor = UIColor(red: 212/255, green: 172/255, blue: 112/255, alpha: 0.5).cgColor
            shape.layer.cornerRadius = 10
            shape.layer.shadowOpacity = 1
            shape.layer.shadowColor = UIColor.black.withAlphaComponent(1).cgColor
            shape.layer.shadowRadius = 4
            view.addSubview(shape)
       
        shape.translatesAutoresizingMaskIntoConstraints = false
        shape.topAnchor.constraint(equalTo: star.bottomAnchor,constant: 10).isActive = true
        shape.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shape.widthAnchor.constraint(equalToConstant: view.frame.width*0.9).isActive = true
        shape.heightAnchor.constraint(equalToConstant: view.frame.height*0.4).isActive = true
        shape.layoutIfNeeded()
        
        let name = UILabel()
            .addTextWithFont(font: .systemFont(ofSize: sizeFont, weight: .bold), text: "Name:", color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        
        shape.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.leadingAnchor.constraint(equalTo: shape.leadingAnchor,constant: 20).isActive = true
        name.topAnchor.constraint(equalTo: shape.topAnchor,constant: 10).isActive = true
        
        let valueName = UILabel()
            .addTextWithFont(font: .systemFont(ofSize: sizeFont, weight: .bold), text: dragon.name, color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)

        shape.addSubview(valueName)
        valueName.translatesAutoresizingMaskIntoConstraints = false
        valueName.trailingAnchor.constraint(equalTo: shape.trailingAnchor,constant: -20).isActive = true
        valueName.topAnchor.constraint(equalTo: shape.topAnchor,constant: 10).isActive = true
        
        
        let rarity = UILabel()
            .addTextWithFont(font: .systemFont(ofSize: sizeFont, weight: .bold), text: "Rarity:", color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)

        shape.addSubview(rarity)
        rarity.translatesAutoresizingMaskIntoConstraints = false
        rarity.trailingAnchor.constraint(equalTo: name.trailingAnchor,constant: 0).isActive = true
        rarity.topAnchor.constraint(equalTo: name.bottomAnchor,constant: 10).isActive = true
        
        
        let valueRarity = UILabel()
            .addTextWithFont(font: .systemFont(ofSize: sizeFont, weight: .bold), text: dragon.rarity.rawValue, color: .white)
            .shadowText(colorText: dragon.colorFontRarityElement(), colorShadow: .black, aligment: .center)

        shape.addSubview(valueRarity)
        valueRarity.translatesAutoresizingMaskIntoConstraints = false
        valueRarity.trailingAnchor.constraint(equalTo: valueName.trailingAnchor,constant: 0).isActive = true
        valueRarity.topAnchor.constraint(equalTo: valueName.bottomAnchor,constant: 10).isActive = true

        
        let type = UILabel()
            .addTextWithFont(font: .systemFont(ofSize: sizeFont, weight: .bold), text: "Type:", color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)

        shape.addSubview(type)
        type.translatesAutoresizingMaskIntoConstraints = false
        type.trailingAnchor.constraint(equalTo: rarity.trailingAnchor,constant: 0).isActive = true
        type.topAnchor.constraint(equalTo: rarity.bottomAnchor,constant: 10).isActive = true
        
        let valueType = UILabel()
            .addTextWithFont(font: .systemFont(ofSize: sizeFont, weight: .bold), text: dragon.type, color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        
        shape.addSubview(valueType)
        valueType.translatesAutoresizingMaskIntoConstraints = false
        valueType.trailingAnchor.constraint(equalTo: valueRarity.trailingAnchor,constant: 0).isActive = true
        valueType.topAnchor.constraint(equalTo: valueRarity.bottomAnchor,constant: 10).isActive = true
        
        let class_ = UILabel()
            .addTextWithFont(font: .systemFont(ofSize: sizeFont, weight: .bold), text: "Class:", color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)

        shape.addSubview(class_)
        class_.translatesAutoresizingMaskIntoConstraints = false
        class_.trailingAnchor.constraint(equalTo: type.trailingAnchor,constant: 0).isActive = true
        class_.topAnchor.constraint(equalTo: type.bottomAnchor,constant: 10).isActive = true
        
        let valueClass = UILabel()
            .addTextWithFont(font: .systemFont(ofSize: sizeFont, weight: .bold), text: dragon.class_, color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)

        shape.addSubview(valueClass)
        valueClass.translatesAutoresizingMaskIntoConstraints = false
        valueClass.trailingAnchor.constraint(equalTo: valueType.trailingAnchor,constant: 0).isActive = true
        valueClass.topAnchor.constraint(equalTo: valueType.bottomAnchor,constant: 10).isActive = true
        
        let skills = UILabel()
            .addTextWithFont(font: .systemFont(ofSize: sizeFont, weight: .bold), text: "Skills:", color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)

        shape.addSubview(skills)
        skills.translatesAutoresizingMaskIntoConstraints = false
        skills.trailingAnchor.constraint(equalTo: class_.trailingAnchor,constant: 0).isActive = true
        skills.topAnchor.constraint(equalTo: class_.bottomAnchor,constant: 10).isActive = true
        
        
        let txtDiscover = UILabel()
            .addTextWithFont(font: .systemFont(ofSize: 20, weight: .bold), text: "Discover", color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)

        txtDiscover.numberOfLines = 0
        view.addSubview(txtDiscover)
        txtDiscover.translatesAutoresizingMaskIntoConstraints = false
        txtDiscover.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        txtDiscover.centerYAnchor.constraint(equalTo: view.bottomAnchor,constant: -view.frame.height*0.07).isActive = true
  
        
        let viewTemp = UIView(frame: .zero)
        shape.addSubview(viewTemp)
        
        viewTemp.translatesAutoresizingMaskIntoConstraints = false
        viewTemp.topAnchor.constraint(equalTo: skills.bottomAnchor,constant: 0).isActive = true
        viewTemp.leadingAnchor.constraint(equalTo: shape.leadingAnchor).isActive = true
        viewTemp.trailingAnchor.constraint(equalTo: shape.trailingAnchor).isActive = true
        viewTemp.heightAnchor.constraint(equalToConstant: 100).isActive = true
        viewTemp.layoutIfNeeded()
        
        for x in 0..<dragon.icons.count{
            
            let valueSkills = MyButton(frame: .zero, item: dragon, view: viewTemp, index: x)  { _ in }
            valueSkills.setImage(UIImage(named: dragon.icons[x].rawValue),for: .normal)
            shape.addSubview(valueSkills)
            
            let width = viewTemp.frame.width/6
            let marginX = (width  - (CGFloat(x+1) * width) - 15)
            
            valueSkills.translatesAutoresizingMaskIntoConstraints = false
            valueSkills.heightAnchor.constraint(equalToConstant: width).isActive = true
            valueSkills.widthAnchor.constraint(equalToConstant: width).isActive = true
            valueSkills.topAnchor.constraint(equalTo: valueClass.bottomAnchor,constant: 0).isActive = true
            valueSkills.trailingAnchor.constraint(equalTo: shape.trailingAnchor,constant: marginX).isActive = true
        }
        
        scene?.view?.addSubview(view)
    }
    
    
    // Handler for the arrow in the detail dragon view
    @objc func tapArrowL(_ event:UIButton) {
       
        
        guard let slice = event.restorationIdentifier?.components(separatedBy: "_"),
              let lastView = view?.subviews.last,
              let dir = slice.last ,
              let direction = Direction(rawValue: dir) else { return }
        
        self.run(gameinfo.mainAudio.getAction(type: .ChangeOption))
        
        let name = slice[0]
        let index = slice[1]
        
        let getDragon:(Direction)->Dragons? =  { direction in
            
            guard let idx = index.last ,
                  var number = Int(String(idx)) else { return nil }
            
            switch direction {
                case .Left:
                    number -= 1
                if number  > 0 {
                    return Dragons.items.filter { $0.picture.name == "\(name)_T\(number)_icon"}.first
                    
                }
                
                case .Right:
                    number += 1
                  if number  < 4 {
                      return Dragons.items.filter { $0.picture.name == "\(name)_T\(number)_icon"}.first
                      
                  }
            }
            return nil
        }
        
        
        guard let dragon = getDragon(direction) else {
            event.isEnabled = false;
            return
        }
            
        lastView.removeFromSuperview()
    
        DetailDragonSelectCollection(dragon: dragon)
    }
}




extension String{
    
    
    // Get number start of the name dragon
    func getNumberStarName() -> Int
    {
        var number = 0
        
        if self.contains("T1") {
            number = 0
        } else if self.contains("T2") {
            number = 1
        } else if self.contains("T3") {
            number = 2
        }
        return number
    }
    
}

extension DragonsMenuScene {
    
    
    // MARK: SHOW MAIN PAGE SCREEN
    private func showMainPage() {
    
        let width =  min(screenSize.width,screenSize.height) > 500 ? 600 : min(screenSize.width,screenSize.height)
        let frame = CGRect(x: 0, y: 0, width: width, height: width)
        
        let mainView = templateMainGeneric(frame:frame, typeGrid: .main, hasCancelBtn: false)

        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.widthAnchor.constraint(equalToConstant: width).isActive = true
        mainView.heightAnchor.constraint(equalToConstant: width).isActive = true
        mainView.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view!.bottomAnchor,constant: -(view?.frame.height)!*0.1).isActive = true
        
        

       /*
       
        let dragonRight = UIButton(frame: CGRect(x:  (width -  sizeCircle), y:  screenSize.height*0.05, width: sizeCircle, height:  sizeCircle))
        dragonRight.setImage(UIImage(named: "WC02_T1_icon")?.resized(to: CGSize(width: sizeCircle*0.8, height: sizeCircle*0.8)), for: .normal)
        dragonRight.imageView?.contentMode = .scaleAspectFit
        dragonRight.restorationIdentifier = "WC02_T1_icon"

        dragonRight.layer.cornerRadius = sizeCircle/2
        dragonRight.backgroundColor = .black.withAlphaComponent(0.5)
        dragonRight.addTarget(self, action: #selector(tapCircleDragon), for: .touchUpInside)
        mainView.addSubview(dragonRight)
        
        let dragonLeft = UIButton(frame: CGRect(x: sizeCircle/2, y: screenSize.height*0.05, width: sizeCircle, height:  sizeCircle))
        dragonLeft.setImage(UIImage(named: "LC01_T1_icon")?.resized(to: CGSize(width: sizeCircle*0.8, height: sizeCircle*0.8)), for: .normal)
        dragonLeft.restorationIdentifier = "LC01_T1_icon"
        dragonLeft.backgroundColor = .black.withAlphaComponent(0.5)
        dragonLeft.layer.cornerRadius = sizeCircle/4
        dragonLeft.addTarget(self, action: #selector(tapCircleDragon), for: .touchUpInside)
        mainView.addSubview(dragonLeft)*/
        
        if SearchDragonBuyInDB() {
            
            let collection = ManagedCollectionInView(view: mainView, type: .main) { _ in } deSelect: { _ in }

            mainView.addSubview(collection)
            collection.translatesAutoresizingMaskIntoConstraints = false
            collection.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
            collection.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
            collection.widthAnchor.constraint(equalTo: mainView.widthAnchor,constant: -mainView.frame.width*0.15).isActive = true
            collection.heightAnchor.constraint(equalTo: mainView.heightAnchor,constant: -mainView.frame.height*0.15).isActive = true
            
        } else {
            
            let txtInsideTable = UILabel(frame: mainView.bounds)
                .addFontAndText(font: "Cartwheel", text: "EARN GOLD TO\nBUY DRAGONS", size: mainView.bounds.width/8)
                .shadowText(colorText: .brown, colorShadow: .white, aligment: .center)
          
            txtInsideTable.numberOfLines = 0
            mainView.addSubview(txtInsideTable)
            
            txtInsideTable.translatesAutoresizingMaskIntoConstraints = false
            txtInsideTable.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
            txtInsideTable.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
            
            let arrow = UIImageView(image: UIImage(named: "arrowBrown")!)
            mainView.addSubview(arrow)
            
            arrow.translatesAutoresizingMaskIntoConstraints = false
            arrow.centerXAnchor.constraint(equalTo: mainView.centerXAnchor,constant: 0).isActive = true
            arrow.topAnchor.constraint(equalTo: txtInsideTable.bottomAnchor).isActive = true
            arrow.widthAnchor.constraint(equalToConstant: mainView.frame.width/4).isActive = true
            arrow.heightAnchor.constraint(equalTo: arrow.widthAnchor).isActive = true
            arrow.topAnchor.constraint(equalTo: txtInsideTable.bottomAnchor).isActive = true
        }
    }
    
    private func showIndexPageBook(){
        
        let width = screenSize.width*0.9
        let height = screenSize.height*0.8
        let marginX = (screenSize.width-width)/2
        let marginY = (screenSize.height-height)/2
        let rect = CGRect(x: marginX, y: marginY, width: width, height: height)
        
        (UIApplication.shared.delegate as? AppDelegate)?.preloadData { d in
           
            self.scene?.backgroundBlack(withSpinnerActive: false)
            
            let view = self.templateMainGeneric(frame: rect, typeGrid: .sell, hasCancelBtn: true)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraint(equalTo: (self.scene?.view!.leadingAnchor)!,constant: marginX).isActive = true
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
            view.topAnchor.constraint(equalTo: (self.scene?.view!.topAnchor)!,constant: marginY).isActive = true
            
            let gradient = UIImage.gradientImage(bounds: view.bounds, colors: [.white,.white])
            
            let title = UILabel()
                .addFontAndText(font: "Cartwheel", text: "YOUR COLLECTION:", size: view.frame.width*0.07)
                .shadowText(colorText: UIColor(patternImage: gradient), colorShadow: .black,aligment: .center)
            view.addSubview(title)
            
            title.translatesAutoresizingMaskIntoConstraints = false
            title.topAnchor.constraint(equalTo: view.topAnchor,constant: 20).isActive = true
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            
            let getPercent = Double(ManagedDB.getNumberDragonBuy())/Double(Dragons.items.count)
            let totalWidth = (view.frame.width*0.8)*getPercent
            
            let barProgress = UIImageView()
            barProgress.image = UIImage(named: "barProgress")
            barProgress.contentMode = .scaleAspectFill

            view.addSubview(barProgress)
            
            barProgress.translatesAutoresizingMaskIntoConstraints = false
            barProgress.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            barProgress.topAnchor.constraint(equalTo: title.bottomAnchor,constant: 10).isActive = true
            barProgress.widthAnchor.constraint(equalTo: title.widthAnchor).isActive = true
            
            let progress = UIImageView(image:UIImage(named: "progress"))
            barProgress.addSubview(progress)
        
            progress.translatesAutoresizingMaskIntoConstraints = false
            progress.heightAnchor.constraint(equalTo:barProgress.heightAnchor,constant: 0).isActive = true
            progress.leadingAnchor.constraint(equalTo: barProgress.leadingAnchor, constant: 10).isActive = true
            progress.centerYAnchor.constraint(equalTo: barProgress.centerYAnchor, constant: 0).isActive = true
           
            UIView.animate(withDuration: 1) {
                progress.widthAnchor.constraint(equalToConstant: totalWidth).isActive = true
            }
            
            let textProgress = UILabel()
                .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
            textProgress.font =  UIFont.systemFont(ofSize: view.frame.width*0.05, weight: .bold)
            textProgress.text = "COLLECTED \(ManagedDB.getNumberDragonBuy())/\(Dragons.items.count)"
            barProgress.addSubview(textProgress)
            
            textProgress.translatesAutoresizingMaskIntoConstraints = false
            textProgress.centerXAnchor.constraint(equalTo: barProgress.centerXAnchor, constant: 0).isActive = true
            textProgress.centerYAnchor.constraint(equalTo: barProgress.centerYAnchor, constant: 0).isActive = true
            
            
            let collection =  self.ManagedCollectionInView(view: view,type: .index) { _ in } deSelect: { _ in }
            view.addSubview(collection)
            
            collection.translatesAutoresizingMaskIntoConstraints = false
            collection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            collection.widthAnchor.constraint(equalToConstant: width*0.95).isActive = true
            collection.heightAnchor.constraint(equalToConstant: height*0.75).isActive = true
            collection.topAnchor.constraint(equalTo: barProgress.bottomAnchor,constant: 40).isActive = true
            
        }
    }
    
    // REVISAR ESTA FUNCION
    private func SellMainPage(isBulkSell:typeGenericView,isFeedBtn:Bool,item: Dragons?) {
        
        let width = screenSize.width*0.95
        let height = screenSize.height*0.8
        let marginX = (screenSize.width-width)/2
        let marginY = (screenSize.height-height)/2
        
        let rect = CGRect(x: marginX, y: marginY, width: width, height: height)

        removeUIViews()
        
        let view = templateMainGeneric(frame: rect, typeGrid: .sell, hasCancelBtn: true)
        let gradient = UIImage.gradientImage(bounds: view.bounds, colors: [.orange, .yellow])

        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: (scene?.view!.leadingAnchor)!,constant: marginX).isActive = true
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.topAnchor.constraint(equalTo: (scene?.view!.topAnchor)!,constant: marginY).isActive = true
        
        
        if isBulkSell == .Bulk {
            
            partialViewBulkSell(view: view,gradient:gradient)
           
        } else if isBulkSell == .Feed {
            
            partialViewSellIndividual(view:view,item: item!,gradient:gradient, isFeedBtn: isFeedBtn)

        } else {
            partialViewEvolve(view:view,item: item!,gradient:gradient, isFeedBtn: false)
        }
        
        let bagFruit = UIImageView(image:UIImage(named: "bagFruit"))
            view.addSubview(bagFruit)
        
        bagFruit.translatesAutoresizingMaskIntoConstraints = false
        bagFruit.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -20).isActive = true
        bagFruit.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50).isActive = true
        bagFruit.widthAnchor.constraint(equalToConstant: view.frame.height*0.2).isActive = true
        bagFruit.heightAnchor.constraint(equalToConstant: view.frame.height*0.2).isActive = true
      
        
        let getMoreFruit = UILabel()
            .addFontAndText(font: "Cartwheel", text: "GET MORE\nDRAGONFRUIT", size: view.frame.width*0.06)
            .shadowText(colorText: UIColor(patternImage: gradient), colorShadow: .black,aligment: .center)
            getMoreFruit.numberOfLines = 0
            view.addSubview(getMoreFruit)
        
        getMoreFruit.translatesAutoresizingMaskIntoConstraints = false
        getMoreFruit.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: view.frame.width/4).isActive = true
        getMoreFruit.topAnchor.constraint(equalTo:bagFruit.topAnchor,constant: -15).isActive = true
        
        let contadorMoreFruit = UIImageView(frame: CGRect(x: width*0.5, y: view.frame.height*0.87,
                                                          width: view.frame.width*0.4,
                                                          height: view.frame.width*0.1))
            contadorMoreFruit.image = UIImage(named: "counter")
            contadorMoreFruit.isUserInteractionEnabled = true
            
        let totalFruit = UILabel()
                .addFontAndText(font: "Cartwheel", text: "\(ManagedDB.getFruitTotal())"
                .convertDecimal(), size: contadorMoreFruit.frame.width*0.10)
                .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
        contadorMoreFruit.addSubview(totalFruit)
        
        totalFruit.translatesAutoresizingMaskIntoConstraints = false
        totalFruit.centerYAnchor.constraint(equalTo: contadorMoreFruit.centerYAnchor,constant: 0).isActive = true
        totalFruit.centerXAnchor.constraint(equalTo: contadorMoreFruit.centerXAnchor,constant: 0).isActive = true

        view.addSubview(contadorMoreFruit)

        let iconPlus =  UIButton()
            iconPlus.setImage(UIImage(named: "btnAdd"), for: .normal)
            iconPlus.addTarget(self, action: #selector(tapCounter), for: .touchUpInside)
        contadorMoreFruit.addSubview(iconPlus)
        
        iconPlus.translatesAutoresizingMaskIntoConstraints = false
        iconPlus.widthAnchor.constraint(equalTo: contadorMoreFruit.heightAnchor,constant: 0).isActive = true
        iconPlus.heightAnchor.constraint(equalTo: contadorMoreFruit.heightAnchor,constant: 0).isActive = true
        iconPlus.trailingAnchor.constraint(equalTo: contadorMoreFruit.trailingAnchor,constant: iconPlus.frame.width).isActive = true

        scene?.view?.addSubview(view)
    }
    
    /// - Description: Partial view to evolve the dragons
    private func partialViewEvolve(view:UIView,item: Dragons,gradient:UIImage, isFeedBtn: Bool) {
        
        partialViewHeader(view:view,item:item,isFeedBtn:false)
        
        let title = UILabel()
            .addFontAndText(font: "Cartwheel", text: "CHOOSE EVO PARTNER", size: view.frame.height*0.05)
            .shadowText(colorText: UIColor(patternImage: gradient), colorShadow: .black,aligment: .center)
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.5
        title.textAlignment = .center
        title.lineBreakMode = .byWordWrapping
        view.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -view.frame.height*0.1).isActive = true
        title.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -50).isActive = true

        let text = """
                        Choose a dragon to evolve together.
                        Only dragons of the same name and level can be used.
                  """
        
        let subtitle = UILabel()
            .addFontAndText(font: "Cartwheel", text: text, size: view.frame.height*0.03)
            .shadowText(colorText: .black, colorShadow: .white,aligment: .center)
        subtitle.numberOfLines = 0
        subtitle.adjustsFontSizeToFitWidth = false
        subtitle.minimumScaleFactor = 0.75
        subtitle.textAlignment = .left
        subtitle.lineBreakMode = .byWordWrapping
        view.addSubview(subtitle)
        
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.centerXAnchor.constraint(equalTo: title.centerXAnchor).isActive = true
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        subtitle.heightAnchor.constraint(equalToConstant: 100).isActive = true
        subtitle.widthAnchor.constraint(equalTo:view.widthAnchor,constant: -25).isActive = true
        
        
        
        let collection = ManagedCollectionInView(view: view, type: .sell) { dragonSelected in
            
        } deSelect: { dragonDeselect in
            
        }
        view.addSubview(collection)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.topAnchor.constraint(equalTo: subtitle.bottomAnchor).isActive = true
        collection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collection.heightAnchor.constraint(equalToConstant: view.frame.height*0.25).isActive = true
        collection.widthAnchor.constraint(equalToConstant: view.frame.height/2).isActive = true


        
    }
    
    /// - Description: View partial for header generic,  left show dragon  image and the dragon info to right
    private func partialViewHeader(view:UIView,item:Dragons,isFeedBtn:Bool)  {

        view.subviews.first {$0.tag == 1000}?.removeFromSuperview()
        
        let header = UIView()
        header.tag  = 1000
        view.addSubview(header)
        
        let imgDragon = UIImageView(image: UIImage(named: item.picture.name))
        header.addSubview(imgDragon)
        
        let width = UIDevice().isPhone() ? view.frame.height*0.2 : view.frame.height*0.3
        imgDragon.translatesAutoresizingMaskIntoConstraints  = false
        imgDragon.widthAnchor.constraint(equalToConstant: width).isActive = true
        imgDragon.heightAnchor.constraint(equalTo: imgDragon.widthAnchor).isActive = true
        imgDragon.topAnchor.constraint(equalTo: view.topAnchor,constant: 40).isActive = true
        imgDragon.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -view.frame.width/4 ).isActive = true

        let shape = UIView()
        shape.backgroundColor = UIColor(red: 239 / 255, green: 204/255, blue: 151/255, alpha: 0.5)
        shape.layer.cornerRadius = view.frame.width * 0.05
        shape.layer.borderColor = UIColor.darkText.withAlphaComponent(0.8).cgColor
        shape.layer.borderWidth = 1
        shape.layer.shadowColor = UIColor.gray.cgColor
        shape.layer.shadowOffset = CGSize(width: 10, height:  1)
        header.addSubview(shape)
       
        shape.translatesAutoresizingMaskIntoConstraints = false
        shape.topAnchor.constraint(equalTo: imgDragon.topAnchor,constant: 0).isActive = true
        shape.leadingAnchor.constraint(equalTo: view.centerXAnchor,constant: 5).isActive = true
        shape.widthAnchor.constraint(equalToConstant: view.frame.width*0.45).isActive = true
        
        if  UIDevice().isPhone() {
            shape.heightAnchor.constraint(equalToConstant: view.frame.height*0.25).isActive = true
        } else {
            shape.heightAnchor.constraint(equalTo:imgDragon.heightAnchor,constant: 30).isActive = true
        }
        
        let imgHeart = UIButton()
            imgHeart.setImage(UIImage(named: "heartOff"), for: .normal)
            imgHeart.setImage(UIImage(named: "heartOn"), for: .selected)
        header.addSubview(imgHeart)
        
        imgHeart.translatesAutoresizingMaskIntoConstraints = false
        imgHeart.widthAnchor.constraint(equalToConstant: (view.frame.width/2)*0.2).isActive = true
        imgHeart.heightAnchor.constraint(equalTo: imgHeart.widthAnchor).isActive = true
        imgHeart.bottomAnchor.constraint(equalTo: shape.bottomAnchor).isActive = true
        imgHeart.trailingAnchor.constraint(equalTo: shape.leadingAnchor,constant: -5).isActive = true

        var star = UIImageView()
        /// Icons Stars
        for x in 0...2 {
            let numberStart = item.picture.name.getNumberStarName()
            let picture = x <= numberStart ? "starB" : "starGray"
            star = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.height*0.05, height: view.frame.height*0.05))
            star.image = UIImage(named:  picture)!
            shape.addSubview(star)
            
            star.translatesAutoresizingMaskIntoConstraints = false
            star.widthAnchor.constraint(equalToConstant: (view.frame.width/2)/6).isActive = true
            star.heightAnchor.constraint(equalTo: star.widthAnchor).isActive = true
            star.topAnchor.constraint(equalTo: shape.topAnchor,constant: 5).isActive = true
            let marginX = Double((view.frame.width/2)/6)  * CGFloat(x) + 5
            star.leadingAnchor.constraint(equalTo: shape.leadingAnchor, constant: marginX).isActive = true
        }
    
        let name = UILabel()
            .addFontAndText(font: "Cartwheel", text: item.name, size: (view.frame.width/2)*0.1)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
        shape.addSubview(name)
    
        name.translatesAutoresizingMaskIntoConstraints = false
        name.leadingAnchor.constraint(equalTo: shape.leadingAnchor,constant: 10).isActive = true
        name.topAnchor.constraint(equalTo:star.bottomAnchor, constant: 10).isActive = true
        
        let subtitle = UILabel()
            .addFontAndText(font: "Cartwheel", text: "\(item.rarity)", size: (view.frame.width/2)*0.1)
            .shadowText(colorText: item.colorFontRarityElement(), colorShadow: .black, aligment: .center)
        shape.addSubview(subtitle)
        
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.leadingAnchor.constraint(equalTo: shape.leadingAnchor,constant: 10).isActive = true
        subtitle.topAnchor.constraint(equalTo: name.bottomAnchor,constant:5).isActive = true
     
        if isFeedBtn  && item.getLevel()  {
            
            item.setMaxLevel()
        }
        let level = UILabel()
            .addFontAndText(font: "Cartwheel", text: "LVL \(item.level) \(item.class_)", size: (view.frame.width/2)*0.1)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        shape.addSubview(level)
        
        level.translatesAutoresizingMaskIntoConstraints = false
        level.leadingAnchor.constraint(equalTo: shape.leadingAnchor,constant: 10).isActive = true
        level.topAnchor.constraint(equalTo: subtitle.bottomAnchor,constant:5).isActive = true
        level.layoutIfNeeded()
        
        let barProgress = UIImageView(image: UIImage(named: "barProgress"))
        shape.addSubview(barProgress)
        
        barProgress.translatesAutoresizingMaskIntoConstraints = false
        barProgress.topAnchor.constraint(equalTo: level.bottomAnchor,constant:0).isActive = true
        barProgress.centerXAnchor.constraint(equalTo: shape.centerXAnchor).isActive = true
        barProgress.widthAnchor.constraint(equalTo: shape.widthAnchor,constant: -30).isActive = true
        barProgress.heightAnchor.constraint(equalToConstant: view.frame.width*0.45/4.3).isActive = true
        barProgress.layoutIfNeeded()

        let barProgresPercent  = round(item.getPercent(width: barProgress.frame.width))
        
        let progress = UIImageView(image: UIImage(named: "progress"))
        shape.addSubview(progress)
        
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.leadingAnchor.constraint(equalTo: barProgress.leadingAnchor,constant: 0).isActive = true
        progress.centerYAnchor.constraint(equalTo: barProgress.centerYAnchor,constant:0).isActive = true
        progress.heightAnchor.constraint(equalTo: barProgress.heightAnchor,constant: -6).isActive = true
        progress.widthAnchor.constraint(equalToConstant: barProgresPercent).isActive = true
        progress.layoutIfNeeded()
        
        let percent = String(format: "%.0f",item.percent)
        let textPrgress = UILabel()
            .addFontAndText(font: "Cartwheel", text: "\(percent)%", size: 20)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        shape.addSubview(textPrgress)
        
        textPrgress.translatesAutoresizingMaskIntoConstraints = false
        textPrgress.centerXAnchor.constraint(equalTo: barProgress.centerXAnchor,constant: 0).isActive = true
        textPrgress.centerYAnchor.constraint(equalTo: barProgress.centerYAnchor,constant:0).isActive = true

    }
    
    /// - Description: Main view where I add the partial views to sell the dragons
    private func partialViewSellIndividual(view:UIView,item: Dragons,gradient:UIImage,isFeedBtn:Bool) {
        
        partialViewHeader(view: view,item: item,isFeedBtn: isFeedBtn)
        
        let shape = view.retangleView(title: !isFeedBtn ? "SELL \(item.name)?" : "FEED \(item.name)?",gradient: gradient)
        
        let counter:UILabel = partialCounter(view: view, shape: shape) { button in
            
            let textValFruit = isFeedBtn ? item.calculateFruit() : item.rarity.valueFruitDragon
            
            let txtValueFruit = UILabel()
                .addFontAndText(font: "Cartwheel", text: textValFruit, size: button.frame.height/2)
                .shadowText(colorText: UIColor(patternImage: gradient), colorShadow: .black,aligment: .center)
            button.addSubview(txtValueFruit)
            
            txtValueFruit.translatesAutoresizingMaskIntoConstraints = false
            txtValueFruit.centerXAnchor.constraint(equalTo: button.centerXAnchor,constant: -5).isActive = true
            txtValueFruit.centerYAnchor.constraint(equalTo: button.centerYAnchor,constant: 0).isActive = true
            
            if !isFeedBtn {
                let txtUndone = UILabel()
                    .addTextWithFont(font: UIFont.systemFont(ofSize: view.frame.width*0.03, weight: .bold), text: "(This cannot be undone)", color: .white)
                shape.addSubview(txtUndone)
                
                txtUndone.translatesAutoresizingMaskIntoConstraints = false
                txtUndone.centerXAnchor.constraint(equalTo: shape.centerXAnchor,constant: 0).isActive = true
                txtUndone.topAnchor.constraint(equalTo: button.bottomAnchor,constant: 0).isActive = true
            }
            let btnSell = UIButton(frame: CGRect(x: 0, y: 0, width: button.frame.width, height: button.frame.height))
            btnSell.setBackgroundImage(img: UIImage(named: "GreenButton")!)
            btnSell.restorationIdentifier = isFeedBtn ? "\(item.getValueFruit())" : item.rarity.valueFruitDragon
            btnSell.addTarget(self, action: #selector(sellTapButton), for: .touchUpInside)
            shape.addSubview(btnSell)
            
            btnSell.translatesAutoresizingMaskIntoConstraints = false
            btnSell.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            btnSell.bottomAnchor.constraint(equalTo: shape.bottomAnchor,constant: -10).isActive = true
            btnSell.widthAnchor.constraint(equalToConstant: button.frame.width).isActive = true
            btnSell.heightAnchor.constraint(equalToConstant: button.frame.height).isActive = true
            
            if !isFeedBtn{
                let iconBag = UIImageView(image: UIImage(named: "iconExtra_2")!)
                view.addSubview(iconBag)
                
                iconBag.translatesAutoresizingMaskIntoConstraints = false
                iconBag.centerYAnchor.constraint(equalTo: btnSell.centerYAnchor).isActive = true
                iconBag.centerXAnchor.constraint(equalTo: btnSell.trailingAnchor).isActive = true
                iconBag.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
                iconBag.heightAnchor.constraint(equalTo: button.heightAnchor).isActive = true
            }
            let txtSell = UILabel()
                .addTextWithFont(font: UIFont.systemFont(ofSize: view.frame.width*0.05, weight: .bold), text: !isFeedBtn ? "SELL":"FEED", color: .white)
            btnSell.addSubview(txtSell)
            
            txtSell.translatesAutoresizingMaskIntoConstraints = false
            txtSell.centerXAnchor.constraint(equalTo: btnSell.centerXAnchor,constant: 0).isActive = true
            txtSell.centerYAnchor.constraint(equalTo: btnSell.centerYAnchor,constant: 0).isActive = true
            
            return txtValueFruit
        }
 
        if isFeedBtn {
            
            var btnLeft = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            var btnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            
            btnLeft = MyButton(frame: btnLeft.frame, item: item, view: shape, identifier: .Left) { _ in
                
                if item.lessPercent() {
                    self.partialViewHeader(view: view, item: item, isFeedBtn: true)
                    counter.text = "\(item.calculateFruit())"
                    btnRight.isEnabled = true
                }
            }
            
            btnRight = MyButton(frame: btnLeft.frame, item: item, view: shape, identifier: .Right) { _ in
                
                if item.addPercent() {
                    self.partialViewHeader(view: view, item: item, isFeedBtn: true)
                    counter.text = "\(item.calculateFruit())"
                    btnLeft.isEnabled = true
                    btnLeft.setImage(UIImage(named: "btnBlueLess"), for: .normal)
                }
            }
        }
    }
    
    
    /// - Description: Partial view for the view shared sell FEED dragons
    /// - Parameters: @view:  The view add components UIView
    ///               @gradient:  Gradient UImage for text effect
    
    private func partialCounter(view:UIView,shape:UIView,handler:(UIButton)->UILabel) -> UILabel {
        
        let val = view.frame.height - shape.frame.height
        
        let widthBtn  = val*0.25
        
        let heightBtn = widthBtn / 2.65
        
        let contador = UIButton(frame: CGRect(x: 0, y: 0, width: widthBtn, height: heightBtn))
        contador.isEnabled = false
        contador.setBackgroundImage(img: UIImage(named: "counter")!)
        shape.addSubview(contador)
        
        contador.translatesAutoresizingMaskIntoConstraints = false
        contador.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        contador.centerYAnchor.constraint(equalTo: shape.centerYAnchor).isActive = true
        contador.widthAnchor.constraint(equalToConstant: widthBtn).isActive = true
        contador.heightAnchor.constraint(equalToConstant: heightBtn).isActive = true
        contador.layoutIfNeeded()
        
        let fruit = UIImageView(image:UIImage(named: "fruit")!)
        contador.addSubview(fruit)
        
        fruit.translatesAutoresizingMaskIntoConstraints = false
        fruit.centerYAnchor.constraint(equalTo: contador.centerYAnchor,constant: 0).isActive = true
        fruit.centerXAnchor.constraint(equalTo: contador.trailingAnchor,constant: 0).isActive = true
        fruit.heightAnchor.constraint(equalTo: contador.heightAnchor).isActive = true
        fruit.widthAnchor.constraint(equalTo: contador.heightAnchor).isActive = true
        fruit.layoutIfNeeded()
        
        
        return handler(contador)
    }
    
    
    /// - Description: Partial view for the share view sell group dragons and sell individual dragon
    /// - Parameters: @view:  The view add components UIView
    ///               @gradient:  Gradient UImage for text effect
    private func partialViewBulkSell(view:UIView,gradient:UIImage) {
        
        let width = view.frame.width
        let height = view.frame.height
        
        var btnSell:UIButton =  UIButton()
        
        var textCount:UILabel?
        
        var dragonSelected:[Dragons] = []
        
         var textSeleted:Int = 0 {
            
            didSet {
                if textSeleted >  0 {
                    btnSell.setBackgroundImage(img: UIImage(named: "GreenButton")!)
                    btnSell.restorationIdentifier = textCount?.text
                    btnSell.isEnabled = true
                    textCount?.text = "+\(textSeleted)"
                    
                } else {
                    btnSell.setBackgroundImage(img: UIImage(named: "disableSell")!)
                    btnSell.isEnabled = false
                    textCount?.text = "+ 0"
                    
                }
            }
        }
        
        
        let title = UILabel()
            .addFontAndText(font: "Cartwheel", text: "BULK SELL", size: view.frame.width*0.1)
            .shadowText(colorText: UIColor(patternImage: gradient), colorShadow: .black,aligment: .center)
        view.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height*0.05).isActive = true
        
        let subtitle = UILabel()
            .addFontAndText(font: "Cartwheel", text: "CHOOSE DRAGONS TO SELL", size: view.frame.width*0.06)
            .shadowText(colorText: .brown, colorShadow: .black, aligment: .center)
        view.addSubview(subtitle)
        
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        
        
        let collection = ManagedCollectionInView(view: view,type: .sell) { dragon in
            textSeleted +=  dragon.getValueFruit()
            dragonSelected.append(dragon)
            
        } deSelect: { dragon in
            textSeleted -= dragon.getValueFruit()
            guard let index = dragonSelected.firstIndex(where: {$0.name == dragon.name}) else { return }
            dragonSelected.remove(at: index)
        }
        
        view.addSubview(collection)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collection.topAnchor.constraint(equalTo: subtitle.bottomAnchor,constant: 0).isActive = true
        collection.widthAnchor.constraint(equalToConstant: width*0.9).isActive = true
        collection.heightAnchor.constraint(equalToConstant: height*0.45).isActive = true
        
        let contador = UIButton(frame: CGRect(x: width*0.1, y: view.frame.height*0.65, width: view.frame.width*0.3, height: view.frame.width*0.1))
        contador.setBackgroundImage(img: UIImage(named: "counter")!)
        view.addSubview(contador)
        
        let fruit = UIImageView(image:UIImage(named: "fruit")!)
        contador.addSubview(fruit)
        
        fruit.translatesAutoresizingMaskIntoConstraints = false
        fruit.centerYAnchor.constraint(equalTo: contador.centerYAnchor,constant: 0).isActive = true
        fruit.trailingAnchor.constraint(equalTo: contador.trailingAnchor,constant: -5).isActive = true
        fruit.widthAnchor.constraint(equalToConstant: contador.frame.height*0.8).isActive = true
        fruit.heightAnchor.constraint(equalTo: fruit.widthAnchor,constant: 0).isActive = true
        
        
        textCount = UILabel()
            .addFontAndText(font: "Cartwheel", text: "+ \(textSeleted)", size: contador.frame.width*0.2)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
        contador.addSubview(textCount!)
        
        textCount?.translatesAutoresizingMaskIntoConstraints = false
        textCount?.centerYAnchor.constraint(equalTo: contador.centerYAnchor,constant: 0).isActive = true
        textCount?.centerXAnchor.constraint(equalTo: contador.centerXAnchor,constant: -5).isActive = true
        
        btnSell = UIButton(frame: contador.frame)
        btnSell.setBackgroundImage(img: UIImage(named: "disableSell")!)
        btnSell.addTarget(self, action: #selector(sellTapButton), for: .touchUpInside)
        view.addSubview(btnSell)
        
        btnSell.translatesAutoresizingMaskIntoConstraints = false
        btnSell.centerYAnchor.constraint(equalTo: contador.centerYAnchor,constant:  0).isActive = true
        btnSell.centerXAnchor.constraint(equalTo: view.trailingAnchor,constant:  -contador.frame.width).isActive = true
        btnSell.widthAnchor.constraint(equalTo: contador.widthAnchor,constant:  0).isActive = true
        btnSell.heightAnchor.constraint(equalTo: contador.heightAnchor,constant:  0).isActive = true
        
        let bag = UIImageView(image:UIImage(named: "iconExtra_2")!)
        btnSell.addSubview(bag)
        
        bag.translatesAutoresizingMaskIntoConstraints = false
        bag.centerYAnchor.constraint(equalTo: btnSell.centerYAnchor,constant: 0).isActive = true
        bag.trailingAnchor.constraint(equalTo: btnSell.trailingAnchor,constant: 10).isActive = true
        bag.widthAnchor.constraint(equalToConstant: btnSell.frame.height).isActive = true
        bag.heightAnchor.constraint(equalToConstant:  btnSell.frame.height).isActive = true
        
        let txtSell = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: btnSell.frame.width*0.15, weight: .bold),
                             text: "SELL",color: .brown)
        
        btnSell.addSubview(txtSell)
        txtSell.translatesAutoresizingMaskIntoConstraints = false
        txtSell.centerXAnchor.constraint(equalTo: btnSell.centerXAnchor,constant: 0).isActive = true
        txtSell.centerYAnchor.constraint(equalTo: btnSell.centerYAnchor,constant: 0).isActive = true
    
    
        let txtUndone = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: view.frame.width*0.03, weight: .bold),text: "(This cannot be undone)",color: .brown)
        view.addSubview(txtUndone)
        
        txtUndone.translatesAutoresizingMaskIntoConstraints = false
        txtUndone.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        txtUndone.topAnchor.constraint(equalTo: txtSell.bottomAnchor,constant: 15).isActive = true
    }
    
    /// - Description: Make animation fruits  when sell dragon for fruitst
    /// - Parameters: @typeObject:Icons  Create type icons for effect
    /// - Returns:     completion when finalice effect
    private func createAnimationFruitSell(typeObject:Icons,numberFruit:Int,completion:@escaping(Bool)->Void) {
     
        var index = 0
        
        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { t in
           
            if index > 10 {
                t.invalidate()
                self.run(self.gameinfo.mainAudio.getAction(type: .Result_Coin))
                completion(true)
            }
            index += 1
            
            self.coinAnimation(index:index,typeObject:typeObject ,t:t.timeInterval) { _  in }
        }
    }
    
    //MARK: ANIMATE SEVERAL FRUIT IN CENTER SCREEN WHEN SELL DRAGON FOR FRUIT
    private func coinAnimation(index:Int,typeObject:Icons,t:TimeInterval,handler:@escaping(Bool)->Void) {
        if index > 10 {
            handler(true)
        }
        let smallFruit = UIImage(named: typeObject.rawValue)!

        let imageView = UIImageView(image: smallFruit)

        let x =  random(min: screenSize.midX-50, max: screenSize.midX+50) + .pi/180  * t
        let y =  random(min: screenSize.midY-50 ,max: screenSize.midY+50) + .pi/180 * t
        
        imageView.frame = CGRect(x: x, y: y, width: 50, height: 50)
        imageView.contentMode = .scaleAspectFit
        let position = CGPoint(x: screenSize.minX, y: screenSize.minY)

        UIView.animate(withDuration: 0.2,delay: 0,options: .curveEaseOut) {
            imageView.center = position
            imageView.transform = CGAffineTransform(rotationAngle: 90)
            imageView.transform = CGAffineTransform(translationX: screenSize.minX, y: screenSize.minY)
            self.view!.addSubview(imageView)
        } completion: { _ in
            if index > 10 {
                handler(true)
            }
        }
    }
    
    /// Get object from userdata UIButton
    private func showTypeListObject(pos:SKNode) {
        
        if let a = (pos.userData!["typeCoin"]  as? Currency.CurrencyType) {
               
                switch a{
                    case .Coin:
                         genericTableView(items: BuyCoins.items)
                    case .Gem:
                         genericTableView(items: BuyGem.items)
                    case .Fruit:
                        genericTableView(items: BuyFruit.items)
                    default: break
                }
        }
        return
    }
    
    //MARK:  IF NOT HAVE COINS,SHOW LIST OBJECT TO BUY
    private func howDo(pos:SKNode) -> Bool  {
       
        guard let hasCoin  = pos.userData?["hasCoin"] as? Bool,
              let amount  = pos.userData?["amount"] as? Int,
              let typeCoin = pos.userData?["typeCoin"] as? Currency.CurrencyType else { fatalError() }
       
        
        if !hasCoin {
            print("HAS not COIN TO BUY")
            return false
        }
        createAnimationFruitSell(typeObject: .coin, numberFruit: 10, completion: { [self] _ in
            
            do {
                try ManagedDB.shared.lessAmount(typeCoin: typeCoin, amount: amount)
                removeBackgroundBlack(removeBlur: blurNode)
            } catch {}
        })
        
        return true
        
    }
    
    func doTask(gb: Global.Main) {
        switch gb {
        case .Character_Menu_BackArrow:
            removeUIViews()
            self.gameinfo.prepareToChangeScene()
            self.recursiveRemovingSKActions(sknodes: self.children)
            self.removeAllChildren()
            self.removeAllActions()
            run(gameinfo.mainAudio.getAction(type: .ChangeOption))

            let newScene = MainScene(size: self.size)
            self.view?.presentScene(newScene)
        default:
            print("Should not reach Here - doTask from CharacterMenuScene")
        }
    }
    
    //MARK: MAKE ANIMATION WHEN SELL DRAGON ANIMATE FRUITE TO SCORE
    private func AnimationSellDragonGetFruit() {
        
        guard let view = childNode(withName: ActionButton.CancelFruitSell.getNameView) ,
              let panelInfo = view.childNode(withName: "panelInfo"),
              let counter = panelInfo.childNode(withName: "counter"),
              let btnSell = panelInfo.childNode(withName: ActionButton.btnSellFruit.rawValue) as? SKSpriteNode,
              let scene = scene else { return  }
     

        let smallFruit = SKSpriteNode(imageNamed: "fruit")
            smallFruit.size = CGSize(width: counter.frame.size.height*0.5, height: counter.frame.size.height*0.5)
            smallFruit.position.x = counter.frame.size.width/2
            smallFruit.alpha = 0
        
            smallFruit.run(.sequence([
                .fadeIn(withDuration: 1),
                .move(to: CGPoint(x: -scene.frame.width/2 , y: scene.frame.height/2), duration: 1),
                self.gameinfo.mainAudio.getAction(type: .Buy_DragonFruit),
                .removeFromParent(),
                .run {
                    guard let txt = counter.childNode(withName: "txtCounter") as? SKLabelNode,
                          let shadow = txt.childNode(withName: "txtCounterShadow") as? SKLabelNode else { return}
                    shadow.text = "0"
                    txt.text = shadow.text
                    btnSell.texture = SKTexture(imageNamed: "PurpleButton")

                },
                ]))
        
             counter.addChild(smallFruit)
    }
    
    // Ask if player has coin for object buy
    func hasCoinForBuy<T>(item:T) -> Bool  where T:ProtocolTableViewGenericCell{
        
        do {
            guard let result = try ManagedDB.shared.context.fetch(PlayerDB.fetchRequest()).first else { fatalError() }
          
            switch item.icon {
                case .Coin:
                    return result.coin > item.amount
                case .Gem:
                    return result.gem > item.amount
                case .Fruit:
                    return result.fruit  > item.amount
                default :
                    return false
            }
        }catch {
             return false
        } 
    }
    
    private func genericTableView<T:ProtocolTableViewGenericCell>(items:[T])  {
        
        guard let scene = scene else { fatalError() }
    
        removeUIViews()
        
        scene.backgroundBlack(withSpinnerActive: false)
        
            switch [T].Element {
                case  is BuyFruit.Type:
                     gameinfo.showGenericViewTable(skScene:scene,items: T.items,title: "GET DRAGONFRUIT") { v in scene.view?.addSubview(v) }
                case  is BuyEggs.Type:
                     gameinfo.showGenericViewTable(skScene:scene,items: T.items,title: "BUY EGGS")  { v in scene.view?.addSubview(v) }
                case is BuyCoins.Type:
                     gameinfo.showGenericViewTable(skScene:scene,items: T.items,title: "BUY COINS") { v in scene.view?.addSubview(v) }
                case is BuyGem.Type:
                     gameinfo.showGenericViewTable(skScene:scene,items: T.items,title: "BUY GEM") { v in scene.view?.addSubview(v) }
                default: break
            }
    }
}



extension DragonsMenuScene {
    
    //MARK: SHOW VIEW PANEL DRAGON CIRCLE SELECTED
    private func showPanelDragonCircle(item:Dragons) {
        
        if let view = scene?.view?.subviews.filter({$0.tag == 1}).first {
            UIView.animate(withDuration: 0.05, animations:  {
                view.transform = CGAffineTransform(translationX: -screenSize.width, y:0 )
            })
        }
        
        let width = screenSize.width*0.95
        let height = screenSize.height*0.8
        let marginX = (screenSize.width-width)/2
        let marginY = (screenSize.height-height)/2
        let rect = CGRect(x: marginX, y: marginY, width: width, height: height)
        
        let view = templateMainGeneric(frame: rect, typeGrid: .sell, hasCancelBtn: true)
        self.view?.addSubview(view)
        
        partialViewHeader(view: view,item: item,isFeedBtn: false)
        
        let dmgView = UIImageView(image: UIImage(named: "bgDragonsIcons"))
        view.addSubview(dmgView)
        
        let isPhone  = UIDevice().isPhone() ? view.frame.height*0.35 : view.frame.height*0.4
        
        dmgView.translatesAutoresizingMaskIntoConstraints = false
        dmgView.topAnchor.constraint(equalTo: view.topAnchor,constant: isPhone).isActive = true
        dmgView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:10).isActive = true
        dmgView.widthAnchor.constraint(equalToConstant: view.frame.width*0.6).isActive = true
        dmgView.heightAnchor.constraint(equalToConstant: view.frame.height*0.1).isActive = true
        
        let iconWeakness = UIImageView(image: UIImage(named: "\(item.element)_Weakness"))
        dmgView.addSubview(iconWeakness)
        
        iconWeakness.translatesAutoresizingMaskIntoConstraints = false
        iconWeakness.centerYAnchor.constraint(equalTo: dmgView.centerYAnchor).isActive = true
        iconWeakness.leadingAnchor.constraint(equalTo: dmgView.leadingAnchor,constant: 10).isActive = true
        iconWeakness.heightAnchor.constraint(equalTo: dmgView.heightAnchor,constant: -30).isActive = true
        iconWeakness.widthAnchor.constraint(equalTo: iconWeakness.heightAnchor).isActive = true
        
        let txtDmgL = UILabel()
            .addFontAndText(font: "Cartwheel", text: "\(item.rarity.dmgVal)", size: view.frame.width*0.05)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
        dmgView.addSubview(txtDmgL)
        
        txtDmgL.translatesAutoresizingMaskIntoConstraints = false
        txtDmgL.centerYAnchor.constraint(equalTo: dmgView.centerYAnchor,constant: -10).isActive = true
        txtDmgL.leadingAnchor.constraint(equalTo: iconWeakness.trailingAnchor,constant: 5).isActive = true
        
        let txtDmg = UILabel()
            .addFontAndText(font: "Cartwheel", text: "DMG", size: view.frame.width*0.05)
            .shadowText(colorText: .darkText, colorShadow: .white, aligment: .center)
        dmgView.addSubview(txtDmg)
        
        txtDmg.translatesAutoresizingMaskIntoConstraints = false
        txtDmg.centerYAnchor.constraint(equalTo: dmgView.centerYAnchor,constant: view.frame.width*0.03).isActive = true
        txtDmg.centerXAnchor.constraint(equalTo: txtDmgL.centerXAnchor,constant: 0).isActive = true
        
        let txtDmgR = UILabel()
            .addFontAndText(font: "Cartwheel", text: "\(item.getDMG()+4)", size: view.frame.width*0.05)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
        dmgView.addSubview(txtDmgR)
        
        txtDmgR.translatesAutoresizingMaskIntoConstraints = false
        txtDmgR.centerYAnchor.constraint(equalTo: dmgView.centerYAnchor,constant: -10).isActive = true
        txtDmgR.trailingAnchor.constraint(equalTo: dmgView.trailingAnchor,constant: -15).isActive = true
        
        let dmgCopy = UILabel()
            .addFontAndText(font: "Cartwheel", text: "DMG", size: view.frame.width*0.05)
            .shadowText(colorText: .darkText, colorShadow: .white, aligment: .center)
        dmgView.addSubview(dmgCopy)
        
        dmgCopy.translatesAutoresizingMaskIntoConstraints = false
        dmgCopy.centerYAnchor.constraint(equalTo: dmgView.centerYAnchor,constant: view.frame.width*0.03).isActive = true
        dmgCopy.centerXAnchor.constraint(equalTo: txtDmgR.centerXAnchor,constant: 0).isActive = true
        
        let arrow = UIImageView(image: UIImage(named: "arrow"))
        view.addSubview(arrow)
        
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.centerYAnchor.constraint(equalTo: iconWeakness.centerYAnchor).isActive = true
        arrow.leadingAnchor.constraint(equalTo: txtDmgL.trailingAnchor,constant: 10).isActive = true
        arrow.trailingAnchor.constraint(equalTo: txtDmgR.leadingAnchor,constant: -10).isActive = true
        arrow.heightAnchor.constraint(equalTo: iconWeakness.widthAnchor,constant: -20).isActive = true
        arrow.widthAnchor.constraint(equalTo: arrow.heightAnchor).isActive = true
        
        
        let horoscopeView = UIImageView(image: UIImage(named: "bgDragonsIcons"))
        view.addSubview(horoscopeView)
        
        horoscopeView.translatesAutoresizingMaskIntoConstraints = false
        horoscopeView.topAnchor.constraint(equalTo: dmgView.topAnchor,constant: 0).isActive = true
        horoscopeView.leadingAnchor.constraint(equalTo: dmgView.trailingAnchor,constant:15).isActive = true
        horoscopeView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:-10).isActive = true
        horoscopeView.heightAnchor.constraint(equalTo: dmgView.heightAnchor).isActive = true
        
        let iconHoroscope = UIImageView(image: UIImage(named: "pisces"))
        horoscopeView.addSubview(iconHoroscope)
        
        iconHoroscope.translatesAutoresizingMaskIntoConstraints = false
        iconHoroscope.centerYAnchor.constraint(equalTo: iconWeakness.centerYAnchor,constant: 0).isActive = true
        iconHoroscope.leadingAnchor.constraint(equalTo: horoscopeView.leadingAnchor,constant:10).isActive = true
        iconHoroscope.widthAnchor.constraint(equalTo: iconWeakness.widthAnchor).isActive = true
        iconHoroscope.heightAnchor.constraint(equalTo: iconWeakness.heightAnchor).isActive = true
        
        let textHoroscope = UILabel()
            .addFontAndText(font: "Cartwheel", text: "1/3", size: view.frame.width*0.06)
            .shadowText(colorText: .brown, colorShadow: .white, aligment: .center)
        horoscopeView.addSubview(textHoroscope)
        
        textHoroscope.translatesAutoresizingMaskIntoConstraints = false
        textHoroscope.centerYAnchor.constraint(equalTo: iconHoroscope.centerYAnchor,constant: 0).isActive = true
        textHoroscope.trailingAnchor.constraint(equalTo: horoscopeView.trailingAnchor,constant:-10).isActive = true
        textHoroscope.widthAnchor.constraint(equalTo: txtDmgR.widthAnchor).isActive = true
        textHoroscope.heightAnchor.constraint(equalTo: textHoroscope.widthAnchor).isActive = true
        
        let txtSkill = UILabel()
            .addFontAndText(font: "Cartwheel", text: "SKILLS", size: view.frame.width*0.1)
            .shadowText(colorText: .brown, colorShadow: .white, aligment: .center)
        view.addSubview(txtSkill)
        
        txtSkill.translatesAutoresizingMaskIntoConstraints = false
        txtSkill.topAnchor.constraint(equalTo: dmgView.bottomAnchor,constant: 20).isActive = true
        txtSkill.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant:0).isActive = true
        
        let skillView = UIImageView(image: UIImage(named: "bgDragonsIcons"))
        view.addSubview(skillView)
        
        skillView.translatesAutoresizingMaskIntoConstraints = false
        skillView.topAnchor.constraint(equalTo: txtSkill.bottomAnchor,constant: 0).isActive = true
        skillView.leadingAnchor.constraint(equalTo: dmgView.leadingAnchor).isActive = true
        skillView.trailingAnchor.constraint(equalTo: horoscopeView.trailingAnchor).isActive = true
        skillView.heightAnchor.constraint(equalToConstant: view.frame.width/5*0.9).isActive = true
        skillView.widthAnchor.constraint(greaterThanOrEqualToConstant: view.frame.width*0.8).isActive = true
        
        for x in 0..<item.icons.count {
            
            let skills = MyButton(frame: .zero, item: item, view: skillView, index: x)  { _ in
                print("dentro button skills")
            }
            skills.setImage(UIImage(named: item.icons[x].rawValue),for: .normal)
            view.addSubview(skills)
            
            let width = (view.frame.width/5)*0.7
            skills.translatesAutoresizingMaskIntoConstraints = false
            skills.heightAnchor.constraint(equalToConstant: width).isActive = true
            skills.widthAnchor.constraint(equalToConstant: width).isActive = true
            skills.centerYAnchor.constraint(equalTo: skillView.centerYAnchor).isActive = true
            
            let marginX = (width+10) * CGFloat(x)+15
            
            skills.trailingAnchor.constraint(equalTo: skillView.trailingAnchor,constant:  -marginX).isActive = true
        }
        
        
        let _ = IconsExtra.items.getItems(item: item, remove: .iconExtra_3).enumerated().map { (idx,element) in
        
            let _ = MyButton(frame: .zero, item: element ,view: view,index:idx) { [self] _ in
                
                switch element {
                case .iconExtra_0: SellMainPage(isBulkSell:.Bulk, isFeedBtn: false,item: item)
                case .iconExtra_1: SellMainPage(isBulkSell:.Bulk, isFeedBtn: false,item: item)
                case .iconExtra_2: SellMainPage(isBulkSell:.Bulk, isFeedBtn: false,item: item)
                case .iconExtra_3: SellMainPage(isBulkSell:.Feed, isFeedBtn: true,item: item)
                case .iconExtra_4: SellMainPage(isBulkSell:.Evolve, isFeedBtn: true,item: item)
                }
            }
        }
    }
    
    //MARK: SHOW VIEW BUY T  ITEM
    private func viewBuyGem<T:ProtocolTableViewGenericCell>(item:[T]){
        
        self.view?.addSubview(templateMainGeneric(frame: .zero, typeGrid: .sell, hasCancelBtn: true))
    
        genericTableView(items: item)
       
    }
}

extension DragonsMenuScene {
    
    enum typeGenericView:String {
        case Bulk
        case Feed
        case Evolve
    }
}


extension Sequence  where Element == IconsExtra.BtnIcons{
    
    func getItems(item:Dragons,remove:Self.Element) -> [Element] {
            
        var data:[Self.Element] = IconsExtra.BtnIcons.allCases
    
        if item.level == 10 && item.percent == 100 {
          
             let index =  data.firstIndex { $0 == remove}
            
             data.remove(at: index!)

        } else {
            
            data.removeLast()
        }
        
        return data
    }
}
