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
    
    
    // MARK: SCENE ADD CIGaussianBlur EFFECT
    // PARAMS:  @blurNode:SKEffectNode variable with contructor from protocol ProtocolEffectBlur
    
    func blurScene(blurNode:SKEffectNode) {
        
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
            let progressCircle = SKSpriteNode(imageNamed: "progressCircle")
            progressCircle.position = CGPoint(x: screenSize.midX, y: screenSize.midY)
            
            progressCircle.run(.sequence([.rotate(byAngle: .pi/2, duration: 2),.removeFromParent()]))
            bgBlack.addChild(progressCircle)
            
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
        
        removeUIViews()
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
        
        enumerateChildNodes(withName: "toon") { n, obj in
            n.removeFromParent()
        }
        
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
    
    func showViewBuyAditionalItem<T>(gameInfo:GameInfo,scene:SKScene,items:T) -> UIView  where T:ProtocolTableViewGenericCell{
        
        let bg = genericViewItem(title: items.title)
        
        let image =  UIImageView()
        image.image = UIImage(named: items.picture.rawValue)!
        bg.addSubview(image)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: bg.topAnchor,constant: 50).isActive = true
        image.widthAnchor.constraint(equalToConstant: bg.frame.width*0.25).isActive = true
        image.heightAnchor.constraint(equalToConstant: bg.frame.width*0.3).isActive = true
        
        let sun = bg.raySunRotating(view: image)
        bg.insertSubview(sun, aboveSubview: bg)
        
        if  T.self is BuyEggs.Type {
                bg.addSubview(rectDragonRarityChange(item: items, bg: bg))
        } else {
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
        
        let typeItem = UILabel()
            .addFontAndText(font: "Cartwheel", text: String(items.icon.rawValue+"s"), size: bg.frame.width*0.07)
            .shadowText(colorText: .brown, colorShadow: .black, aligment: .center)
        bg.addSubview(typeItem)
        
        typeItem.translatesAutoresizingMaskIntoConstraints = false
        typeItem.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        typeItem.bottomAnchor.constraint(equalTo: bg.bottomAnchor,constant: -bg.frame.height*0.2).isActive = true
        
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
        
        let iconTypePay =  UIImageView(image: UIImage(named: "gem")!)
        button.addSubview(iconTypePay)
        
        iconTypePay.translatesAutoresizingMaskIntoConstraints = false
        iconTypePay.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        iconTypePay.leadingAnchor.constraint(equalTo: button.trailingAnchor,constant: -iconTypePay.frame.width/2).isActive = true
        iconTypePay.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        iconTypePay.heightAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        
        return bg
    }
    
    @objc func tapButtonCancel(sender:UIButton) {
        
        view?.subviews.last?.removeFromSuperview()
        let _ = self.children.filter{$0.name == "backgroundBlack"}.map { $0.removeFromParent() }
    }
    
    func genericViewItem(title:String) -> UIView  {
      
        let width  = screenSize.size.width*0.8
        let height = screenSize.size.height*0.65
        
        let view = UIView(frame: CGRect(x: screenSize.width*0.1, y: screenSize.height/4, width: width,height: height))
            view.setBackgroundImage(img: UIImage(named: "bgSettings")!)
        
        let iconCancel = UIButton(frame: CGRect(x: (view.frame.width)-width/10, y: -width/10, width: width/5, height: width/5))
            iconCancel.setImage(UIImage(named: "CancelButton"), for: .normal)
        iconCancel.addTarget(self, action: #selector(self.tapButtonCancel), for: .touchUpInside)
            view.addSubview(iconCancel)
        
        let bgTie = UIImageView(image:UIImage(named: "bgGetDragonFruit")!)
        view.addSubview(bgTie)
    
        bgTie.translatesAutoresizingMaskIntoConstraints = false
        bgTie.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0).isActive = true
        bgTie.bottomAnchor.constraint(equalTo: view.topAnchor,constant: bgTie.frame.height).isActive = true
    
        bgTie.widthAnchor.constraint(equalToConstant: view.frame.width*0.8).isActive = true
        bgTie.heightAnchor.constraint(equalToConstant: view.frame.width*0.2).isActive = true
        
        let label = UILabel(frame: bgTie.bounds)
           
            label.font = UIFont(name: "Cartwheel", size: bgTie.frame.width*0.14)
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
    
        return view
    }
    
    func rectDragonRarityChange<T:ProtocolTableViewGenericCell>(item:T,bg:UIView) -> UIView {
    
        let infoEggs:[Icons:[(String,String)]] = [
        .Common:[("Common","100%")],
        .Bronze:[("Common","85%"),("Rare","13%"),("Epic","2%")],
        .Silver:[("Rare","82%"),("Epic","12%"),("Legendary","6%")],
        .Golden:[("Rare","70%"),("Epic","18%"),("Legendary","11%"),("Mythic","1%")],
        .Magical:[("Rare","53%"),("Epic","25%"),("Legendary","18%"),("Mythic","4%")],
        .Ancient:[("Legendary","86%"),("Mythic","14%")]
    ]
        
        let addColors =  {(idx:Int) -> UIColor in
            switch idx{
                case 0:  return UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1)
                case 1: return UIColor(red: 102/255, green: 178/255, blue: 102/255, alpha: 1)
                case 2: return UIColor(red: 0/255, green: 153/255, blue: 76/255, alpha: 1)
                case 3: return UIColor(red: 204/255, green: 0/255, blue: 204/255, alpha: 1)
                case 4: return UIColor(red: 204/255, green: 204/255, blue: 0/255, alpha: 1)
                case 5: return UIColor(red: 153/255, green: 76/255, blue: 0/255, alpha: 1)
                default: return UIColor(red: 153/255, green: 76/255, blue: 0/255, alpha: 1)
            }
        }
    
        let node = UIView(frame: CGRect(x: bg.frame.width*0.1, y: bg.frame.height*0.4, width: bg.frame.width*0.8, height: bg.frame.height*0.30)).cornerRadius(radius: 10)
        node.backgroundColor = .gray.withAlphaComponent(0.5)
    
        let titleHeader = "Dragon Rarity\t\t\t\tChance"
        let title = UILabel(frame: CGRect(x: 0, y:0, width: node.frame.width, height: node.frame.width*0.1))
                .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
                
                title.textAlignment = .center
                title.font = UIFont.systemFont(ofSize: node.frame.height*0.1, weight: .bold)
                title.text = titleHeader
                title.adjustsFontSizeToFitWidth = true
            
        node.addSubview(title)
    
        
    let _ = infoEggs[item.picture]?.enumerated().map { (idx,obj) in
            let positionY =  node.frame.height * CGFloat(idx+1)/CGFloat(infoEggs.count)
            let color = addColors(idx)
            
            let type = UILabel(frame: CGRect(x: node.frame.width*0.1, y: positionY, width: node.frame.width/2, height: node.frame.width*0.1))
            .addFontAndText(font: "Cartwheel", text: obj.0, size: node.frame.width*0.08)
            .shadowText(colorText: color, colorShadow: .black, aligment: .left)
        type.adjustsFontSizeToFitWidth = true

        let percent =  UILabel(frame: CGRect(x: node.frame.midX, y: positionY, width: node.frame.width*0.28, height: node.frame.width*0.1))
            .addFontAndText(font: "Cartwheel", text: obj.1, size: node.frame.width*0.08)
            .shadowText(colorText: color, colorShadow: .black, aligment: .right)
            percent.adjustsFontSizeToFitWidth = true
            node.addSubview(type)
            node.addSubview(percent)
        }
    
    return node
  }
    
    

}
