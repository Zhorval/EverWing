//
//  SKScene.swift
//  EverWing
//
//  Created by Pablo  on 6/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit


protocol ProtocolEffectBlur {
    var blurNode:SKEffectNode { get set }
}




extension SKScene {
    
    
    /// - Description: Create the generic view for displaying all collections
    /// - Parameters : @width: CGFloat   width for view
    ///               @typeGrid: Enum TypeGridCollection Only display toon in th view main
    /// - Returns:    The view created
     func templateMainGeneric(typeGrid:TypeGridCollection,hasCancelBtn:Bool) -> UIView {
        
        let mainView = UIView(frame: typeGrid.frame)
        
        mainView.backgroundColor = .red
        
        mainView.setBackgroundImage(img: UIImage(named: typeGrid.picture)!)
        
        mainView.tag = (view?.subviews.last?.tag ?? 1) + 1
        
        self.view?.addSubview(mainView)
        
        if hasCancelBtn {
            
            let btnCancel = UIButton(frame: CGRect(x: mainView.frame.width - mainView.frame.width*0.1,
                                                   y: -mainView.frame.width*0.07 ,
                                                   width: mainView.frame.width*0.15,
                                                   height: mainView.frame.width*0.15))
            
            btnCancel.setImage(UIImage(named: "CancelButton"), for: .normal)
            btnCancel.addTarget(self, action: #selector(tapButtonCancel), for: .touchUpInside)
            mainView.addSubview(btnCancel)
        }
     
        return mainView
    }
    
    // MARK: SCENE ADD CIGaussianBlur EFFECT
    // PARAMS:  @blurNode:SKEffectNode variable with contructor from protocol ProtocolEffectBlur
    
    func blurScene(blurNode:SKEffectNode) {
        
        if let  blur = childNode(withName: "blurNode") {
            blur.removeAllActions()
            blur.removeAllChildren()
            blur.removeFromParent()
        }
        
        blurNode.name = "blurNode"
        let blur = CIFilter(name: "CIGaussianBlur",    parameters: ["inputRadius": 50])
        blurNode.filter = blur
        self.shouldEnableEffects = true
        scene?.isPaused = true
        for node in self.children {
            node.removeFromParent()
            blurNode.addChild(node )
        }
        self.addChild(blurNode)
    }
    
    // MARK: SCENE REMOVE CIGaussianBlur EFFECT
    // PARAMS:  @blurNode:SKEffectNode variable with contructor from protocol ProtocolEffectBlur
    
    
    // MARK: CREATE EFFECT RAY SUN ROTATING
    // @params   point: Center point effect
    //           size:  Size effect
    func raySunRotating(point:CGPoint,size:CGSize) -> SKSpriteNode{
        
        
        let sun = SKSpriteNode(imageNamed: "bgSun")
        sun.blendMode = .add
        sun.name = "bgSun"
        sun.position = point
        sun.size = size
        
        
        let sunRotate = SKSpriteNode(imageNamed: "bgSunRotate")
        sunRotate.blendMode = .add
        sunRotate.name = "bgSunRotating"
        sunRotate.position = .zero
        sunRotate.size = size
        sunRotate.run(.repeatForever(.rotate(byAngle: .pi, duration: 0.01)))
        sun.addChild(sunRotate)
        
        return sun
    }
    
    
    // MARK: CREATE BG BLACK INTO SCENE
    func backgroundBlack(withSpinnerActive spinner:Bool)  {
        
        if childNode(withName: "backgroundBlack") != nil {
            return
        }
        
        let bgBlack = SKSpriteNode(color: .black.withAlphaComponent(0.8), size: CGSize(width: screenSize.width, height: screenSize.height))
        bgBlack.anchorPoint = CGPoint(x: 0, y: 0)
        bgBlack.name = "backgroundBlack"
        
        if spinner {
            let shape = SKShapeNode()
            shape.path = UIBezierPath(roundedRect: CGRect(x: -75, y: -75, width: 150, height: 150), cornerRadius: 64).cgPath
            shape.position = CGPoint(x: frame.midX, y: frame.midY)
            shape.fillColor = UIColor.black
            shape.strokeColor = UIColor.white
            shape.lineWidth = 10
            bgBlack.addChild(shape)
            
            let progressCircle = SKSpriteNode(imageNamed: "progressCircle")
            progressCircle.size = CGSize(width: shape.frame.width*0.8, height: shape.frame.width*0.8)
            progressCircle.position = .zero
            progressCircle.run(.sequence([.repeatForever(.rotate(byAngle: .pi/2, duration: 5)),.removeFromParent()]))
            shape.addChild(progressCircle)
            
            let label = SKLabelNode(fontNamed: "Cartwheel", andText: "PLEASE WAIT...", andSize: 30, fontColor: .white, withShadow: .white)!
            label.position = CGPoint(x: frame.midX, y: frame.height * 0.1)
            bgBlack.addChild(label)
        }
        
        self.addChild(bgBlack)
    }
    
    func removeBlur(blurNode:SKEffectNode) {
        var blurredNodes = [SKNode]()
        
        for node in blurNode.children {
            blurredNodes.append(node)
            node.removeFromParent()
        }
        
        for node in blurredNodes {
            self.addChild(node as SKNode)
        }
        
        self.shouldEnableEffects = false
        self.childNode(withName: "blurNode")?.removeFromParent()
        blurNode.removeFromParent()
        scene?.isPaused = false
    }
    
    func removeBackgroundBlack(removeBlur:SKEffectNode?) {
        
      //  removeUIViews()
        let actions = ActionButton.allCases.filter {$0.getNameView != "nodeMain"}
        
        actions.forEach { name in
            removeChildren(in: self.children.filter { $0.name == name.getNameView} )
        }
        
        let _ = self.children.filter{$0.name == "backgroundBlack"}.map { $0.removeFromParent() }
        childNode(withName: "nodeMain")?.run(.move(to: .zero, duration: 1))
        
        guard let removeBlur = removeBlur else{ return }
        
        self.removeBlur(blurNode: removeBlur)
        
    }
    
    func removeUIViews(){
        
        guard let views = view?.subviews else { return }
        
        for view in views {
            
            view.removeFromSuperview()
        }
    }
    
    func recursiveRemovingSKActions(sknodes:[SKNode]){
        
        for childNode in sknodes{
            childNode.removeAllActions()
            if childNode.children.count > 0 {
                if childNode.name != "toon" {
                    recursiveRemovingSKActions(sknodes: childNode.children)
                }
            }
        }
    }
    
    func createUIButton(bname: String, offsetPosX dx:CGFloat, offsetPosY dy:CGFloat,typeButtom:Global.GUIButtons,size:CGSize? = nil) -> SKSpriteNode{
        
        let button = SKSpriteNode()
        button.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        button.texture = SKTexture(imageNamed: typeButtom.rawValue)
        button.position = CGPoint(x: dx, y: dy)
        button.size = size ?? CGSize(width: screenSize.width/4, height: screenSize.height/16)
        button.name = bname
        
        return button
    }
   
    func showViewBuyAditionalItem<T>(scene:SKScene,items:T,gameInfo:GameInfo) -> UIView  where T:ProtocolTableViewGenericCell{
        
        let bg = genericViewItem(title: items.title)
        
        let image =  UIImageView()
        
        if T.self != BuySummons.self {
            image.image = UIImage(named: items.picture.rawValue)!
        } else {
            let name = items.picture.rawValue + "_Card"
            image.image = UIImage(named: name)!
        }
        
        bg.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: bg.topAnchor,constant: 50).isActive = true

        if T.self != BuySummons.self {
            image.widthAnchor.constraint(equalToConstant: bg.frame.width*0.25).isActive = true
            image.heightAnchor.constraint(equalToConstant: bg.frame.width*0.3).isActive = true
        } else {
            image.widthAnchor.constraint(equalToConstant: bg.frame.width*0.8).isActive = true
            image.heightAnchor.constraint(equalToConstant: bg.frame.height*0.85).isActive = true
        }
        
        image.layoutIfNeeded()
        
        if T.self != BuySummons.self {
            let sun = bg.raySunRotating(view: image)
            bg.insertSubview(sun, aboveSubview: bg)
        }
        
        if  T.self is BuyEggs.Type {
                bg.addSubview(rectDragonRarityChange(item: items, bg: bg))
            
        } else if T.self is BuySummons.Type {
                bg.addSubview(addTextInsideCard(item: items, bg: bg))
              
        }  else {
            let value = "Buy \(String(items.amount).convertDecimal()) Dragonfruits?"
            let text = UILabel()
                .addFontAndText(font: "Cartwheel", text: value, size: bg.frame.width*0.08)
                .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
            text.adjustsFontSizeToFitWidth = true
            bg.addSubview(text)
            text.translatesAutoresizingMaskIntoConstraints = false
            text.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
            text.centerYAnchor.constraint(equalTo: bg.centerYAnchor).isActive = true
        }
        
        let  frame =  CGRect(x: 0, y: 0, width: 500, height: 100)
        let button = MyButton(frame: frame,data: items) { successPay in
            
            if successPay {
                gameInfo.infobar = Infobar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.width*0.2),scene: gameInfo.mainScene!)
                gameInfo.mainScene?.view?.addSubview(gameInfo.infobar!)
                gameInfo.mainScene?.run(gameInfo.mainAudio.getAction(type: .Result_Coin))
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                   
                    if  items is BuyEggs {
                        gameInfo.prepareToDragonBuyChangeScene(scene: .BuyDragon, skscene: gameInfo.mainScene!, data: items)
                    } else if items is BuyFruit {
                        let route:MainScene.Scene = gameInfo.mainScene?.name == "MainScene" ? .MainScene : .DragonsMenuScene
                        gameInfo.prepareToDragonBuyChangeScene(scene: route, skscene: gameInfo.mainScene!, data: items)
                    } else if items is BuySummons  {
                        gameInfo.prepareToDragonBuyChangeScene(scene: .StarUpgrade, skscene: gameInfo.mainScene!, data: items)
                    }
                }
            
            }
        }
        bg.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bg.bottomAnchor,constant: -50).isActive = true
        button.widthAnchor.constraint(equalToConstant: bg.frame.width*0.4).isActive = true
        button.heightAnchor.constraint(equalToConstant: (bg.frame.width*0.4)/3).isActive = true
        
        let icon = (items.icon) as! Currency.CurrencyType
        
        let iconTypePay =  UIImageView(image: UIImage(named: icon.rawValue.lowercased())!)
        button.addSubview(iconTypePay)
        
        iconTypePay.translatesAutoresizingMaskIntoConstraints = false
        iconTypePay.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        iconTypePay.leadingAnchor.constraint(equalTo: button.trailingAnchor,constant: -iconTypePay.frame.width/2).isActive = true
        iconTypePay.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        iconTypePay.heightAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        
        
        let typeItem = UILabel()
            .addFontAndText(font: "Cartwheel", text: String(icon.rawValue+"s"), size: bg.frame.width*0.07)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
        bg.addSubview(typeItem)
        
        typeItem.translatesAutoresizingMaskIntoConstraints = false
        typeItem.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        typeItem.bottomAnchor.constraint(equalTo: button.topAnchor).isActive = true
        
        return bg
    }
    
    @objc func tapButtonCancel(sender:UIButton) {
        
        view?.subviews.last?.removeFromSuperview()
        let _ = self.children.filter{$0.name == "backgroundBlack"}.map { $0.removeFromParent() }
    }
    
    func genericTableView<T:ProtocolTableViewGenericCell>(items:[T],gameInfo:GameInfo)  {
    
    guard let scene = scene else { fatalError() }

    //   removeUIViews()
    
    scene.backgroundBlack(withSpinnerActive: false)
    
        switch [T].Element {
            case  is BuyFruit.Type:
                    showGenericViewTable(skScene:scene,items: items,title: "GET DRAGONFRUIT",gameInfo:gameInfo) { v in scene.view?.addSubview(v) }
            case  is BuyEggs.Type:
                    showGenericViewTable(skScene:scene,items: items,title: "BUY EGGS",gameInfo:gameInfo)  { v in scene.view?.addSubview(v) }
            case is BuyCoins.Type:
                    showGenericViewTable(skScene:scene,items: items,title: "BUY COINS",gameInfo:gameInfo) { v in scene.view?.addSubview(v) }
            case is BuyGem.Type:
                    showGenericViewTable(skScene:scene,items: items,title: "BUY GEM",gameInfo:gameInfo) { v in scene.view?.addSubview(v) }
            case  is Toon.Character.Table.Type:
                    showGenericViewTable(skScene:scene,items: items,title: "START RANK",gameInfo:gameInfo) { v in scene.view?.addSubview(v) }
            default: break
        }
}
    
    //MARK: SHOW TABLEVIEW FOR ITEM BUY GEM OR COINS
    func showGenericViewTable<T>(skScene: SKScene, items: [T], title: String,gameInfo:GameInfo,handler: @escaping (UIView) -> Void)  where T : ProtocolTableViewGenericCell {
        
                
        let margin = screenSize.size.width * 0.1
        
        let v = self.genericViewItem(title: title)
          
        let inset = v.bounds.inset(by: .init(top: margin, left: margin/2, bottom: margin, right: margin/2))
            
        let viewCol = UIView(frame: inset)
            
        let tableViewEggs = GenericTableView(frame: viewCol.bounds, items: items) { (item:T) in
                
                UIView.animate(withDuration: 0.1) { 
                    v.transform = CGAffineTransform(translationX: screenSize.width, y: 0)
                } completion: { _ in
                    self.view?.addSubview(self.showViewBuyAditionalItem(scene: skScene, items: item , gameInfo: gameInfo))
                }
            }
            
        viewCol.addSubview(tableViewEggs)
        v.addSubview(viewCol)
        handler(v)
            
    }
    
    func genericViewItem(title:String) -> UIView  {

        let width  = screenSize.size.width*0.9
        let height = screenSize.size.height*0.65

        let view = UIView(frame: CGRect(x: screenSize.width*0.05, y: screenSize.height/4, width: width,height: height))
            view.setBackgroundImage(img: UIImage(named: "bgSettings")!)
        
        let iconCancel = UIButton(frame: CGRect(x: (view.frame.width)-width/10, y: -width/10, width: width/5, height: width/5))
            iconCancel.setImage(UIImage(named: "CancelButton"), for: .normal)
            iconCancel.addTarget(self, action: #selector(self.tapButtonCancel), for: .touchUpInside)
            view.addSubview(iconCancel)
        
        let bgTie = UIImageView(image:UIImage(named: "bgGetDragonFruit")!)
        view.addSubview(bgTie)
    
        bgTie.translatesAutoresizingMaskIntoConstraints = false
        bgTie.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0).isActive = true
        bgTie.centerYAnchor.constraint(equalTo: view.topAnchor,constant: 0).isActive = true
        bgTie.widthAnchor.constraint(equalToConstant: view.frame.width*0.7).isActive = true
        bgTie.heightAnchor.constraint(equalToConstant: view.frame.width*0.2).isActive = true
        bgTie.layoutIfNeeded()
        
        let label = UILabel(frame: bgTie.frame)
           
            label.font = UIFont(name: "Cartwheel", size: bgTie.frame.width*0.1)
            label.text = title
        
            let gradient = UIImage.gradientImage(bounds: label.bounds, colors: [.orange, .yellow])
            label.textColor = UIColor(patternImage: gradient)
          
            label.shadowColor = UIColor.black
            label.shadowOffset = CGSize(width: 2, height: 2)
            label.textAlignment = .center
            label.layer.shadowRadius = 5
            bgTie.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: bgTie.centerXAnchor,constant: 0).isActive = true
        label.centerYAnchor.constraint(equalTo: bgTie.centerYAnchor,constant: -10).isActive = true
        label.widthAnchor.constraint(equalToConstant: bgTie.frame.width*0.65).isActive = true
        label.layoutIfNeeded()
        label.adjustsFontSizeToFitWidth = true

        return view
    }
    
    func addTextInsideCard<T:ProtocolTableViewGenericCell>(item:T,bg:UIView) -> UIView{
        
        let infoCard:[String:[(String,String)]] = [
            Icons.IconsSummons.silver.rawValue:[("Chance for Common:","85%"),("Chance for Rare:","13%"),("Chance for Epic:","2%")],
            Icons.IconsSummons.mega_silver.rawValue:[("Chance for Common: ","85%"),("Chance for Rare:","13%"),("Chance for Epic:","2%")],
            Icons.IconsSummons.golden.rawValue:[("Chance for Common:","0%"),("Chance for Rare:","94%"),("Chance for Epic:","6%")],
            Icons.IconsSummons.mega_golden.rawValue:[("Chance for Common:","0%"),("Chance for Rare:","94%"),("Chance for Epic:","6%")]
        ]
        let title = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: 24, weight: .heavy), text: item.name, color: .clear)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        bg.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: bg.topAnchor,constant: 50).isActive = true
        title.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        
        let subTitle = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: 20, weight: .heavy), text: item.title, color: .clear)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        bg.addSubview(subTitle)
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.topAnchor.constraint(equalTo: title.bottomAnchor,constant: 10).isActive = true
        subTitle.centerXAnchor.constraint(equalTo: title.centerXAnchor).isActive = true

        let card = item.picture.rawValue.contains("silver") ? "silver_Card_Star" : "golden_Card_Star"
        let iconCard =  UIImageView(image: UIImage(named: card))
        bg.addSubview(iconCard)
        
        iconCard.translatesAutoresizingMaskIntoConstraints = false
        iconCard.topAnchor.constraint(equalTo: subTitle.bottomAnchor,constant: 50).isActive = true
        iconCard.centerXAnchor.constraint(equalTo: subTitle.centerXAnchor).isActive = true
        iconCard.widthAnchor.constraint(equalToConstant: bg.frame.width*0.2).isActive = true
        iconCard.heightAnchor.constraint(equalToConstant: bg.frame.width*0.25).isActive = true

        for x in 0..<infoCard[item.picture.rawValue]!.count {
            let title = infoCard[item.picture.rawValue]![x].0
            let value = infoCard[item.picture.rawValue]![x].1
            
            let t = UILabel()
                .addTextWithFont(font: UIFont.systemFont(ofSize: 20, weight: .thin), text: title, color: .clear)
                .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
            bg.addSubview(t)
            t.translatesAutoresizingMaskIntoConstraints = false
            t.topAnchor.constraint(equalTo: bg.centerYAnchor,constant: CGFloat(x * 40)).isActive = true
            t.trailingAnchor .constraint(equalTo: bg.centerXAnchor,constant: 60).isActive = true
            
            let v = UILabel()
                .addTextWithFont(font: UIFont.systemFont(ofSize: 20, weight: .heavy), text: value, color: .clear)
                .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
            bg.addSubview(v)
            v.translatesAutoresizingMaskIntoConstraints = false
            v.centerYAnchor.constraint(equalTo: t.centerYAnchor).isActive = true
            v.leadingAnchor .constraint(equalTo: t.trailingAnchor,constant: 10).isActive = true
        }
        
        return title
    }
    
    func rectDragonRarityChange<T:ProtocolTableViewGenericCell>(item:T,bg:UIView) -> UIView {
    
        let randomNumber = Int(random(min: 0, max: 100))
      
        let infoEggs:[String:[(String,String)]] = [
            Icons.IconsEggs.Common(randomNumber).rawValue:[("Common","100%")],
            Icons.IconsEggs.Bronze(randomNumber).rawValue:[("Common","85%"),("Rare","13%"),("Epic","2%")],
            Icons.IconsEggs.Silver(randomNumber).rawValue:[("Rare","82%"),("Epic","12%"),("Legendary","6%")],
            Icons.IconsEggs.Golden(randomNumber).rawValue:[("Rare","70%"),("Epic","18%"),("Legendary","11%"),("Mythic","1%")],
            Icons.IconsEggs.Magical(randomNumber).rawValue:[("Rare","53%"),("Epic","25%"),("Legendary","18%"),("Mythic","4%")],
            Icons.IconsEggs.Ancient(randomNumber).rawValue:[("Legendary","86%"),("Mythic","14%")]
    ]
        
        let addColors =  {(idx:Int) -> UIColor in
            switch idx{
                case 0: return .green
                case 1: return .cyan
                case 2: return UIColor(red: 214/255, green: 163/255, blue: 245/255, alpha: 1)
                case 3: return UIColor(red: 191/255, green: 202/255, blue: 93/255, alpha: 1)
                case 4: return .orange
                case 5: return .purple
                default: return .clear
            }
        }
    
        let node = UIView(frame: CGRect(x: bg.frame.width*0.1, y: bg.frame.height*0.4, width: bg.frame.width*0.8, height: bg.frame.height*0.30)).cornerRadius(radius: 10)
        node.backgroundColor = .gray.withAlphaComponent(0.5)
        bg.addSubview(node)
        
        let title = UILabel(frame: CGRect(x: 0, y:0, width: node.frame.width, height: node.frame.width*0.1))
                .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
                .addFontAndText(font: "Cartwheel", text: "Dragon Rarity", size: node.frame.height*0.15)
        node.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.bottomAnchor.constraint(equalTo: node.topAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: node.leadingAnchor).isActive = true
        title.layoutIfNeeded()
        
        let subTitle = UILabel(frame: CGRect(x: 0, y:0, width: node.frame.width, height: node.frame.width*0.1))
                .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
                .addFontAndText(font: "Cartwheel", text: "Chance", size: node.frame.height*0.15)
        node.addSubview(subTitle)
        
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.bottomAnchor.constraint(equalTo: node.topAnchor).isActive = true
        subTitle.trailingAnchor.constraint(equalTo: node.trailingAnchor).isActive = true
       
        if let idx = (item as? BuyEggs)?.picture.rawValue {
            
            let _ = infoEggs[idx]?.enumerated().map { (idx,obj) in
                let color =  addColors(idx)
                let type = UILabel()
                    .addFontAndText(font: "Cartwheel", text: obj.0 , size: node.frame.width*0.1)
                    .shadowText(colorText: color, colorShadow: .black, aligment: .left)
                type.adjustsFontSizeToFitWidth = true
                node.addSubview(type)
                
                type.translatesAutoresizingMaskIntoConstraints = false
                type.leadingAnchor.constraint(equalTo: node.leadingAnchor,constant: 10).isActive = true
                type.topAnchor.constraint(equalTo: node.topAnchor,constant: node.frame.height/5*CGFloat(idx)+10).isActive = true
                type.widthAnchor.constraint(equalToConstant: node.frame.width/2).isActive = true
                type.layoutIfNeeded()
                
                 let percent =  UILabel()
                 .addFontAndText(font: "Cartwheel", text: obj.1, size: node.frame.width*0.1)
                 .shadowText(colorText: color, colorShadow: .black, aligment: .right)
                 percent.adjustsFontSizeToFitWidth = true
                 node.addSubview(percent)
                 
                 percent.translatesAutoresizingMaskIntoConstraints = false
                 percent.trailingAnchor.constraint(equalTo: node.trailingAnchor,constant: -10).isActive = true
                 percent.topAnchor.constraint(equalTo: node.topAnchor,constant: node.frame.height/5*CGFloat(idx)+10).isActive = true
                 percent.widthAnchor.constraint(equalToConstant: node.frame.width/2).isActive = true
                 percent.layoutIfNeeded()
            }
        } else {
            return bg
        }
    
    return node
  }

}
