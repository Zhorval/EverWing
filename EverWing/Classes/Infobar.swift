//
//  Infobar.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import SpriteKit
import UIKit


class Infobar:UIView {
    
    lazy var fruit = { [self]  (icon:(CGFloat,Currency.CurrencyType)) -> UIView in
        
        let width = screenSize.width*0.3
        let x = (width*0.01) + (width*icon.0 * 1.1)
        
        let view = UIView(frame: .zero)
            view.backgroundColor = .black.withAlphaComponent(0.8)
            view.layer.cornerRadius = screenSize.width*0.07/2
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant:x).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor,constant:screenSize.height*0.06).isActive = true
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.heightAnchor.constraint(equalToConstant: screenSize.width*0.07).isActive = true
        
        let text = String((icon.0 == 0 ? resultDB?.fruit : icon.0 == 1 ? resultDB?.coin : resultDB?.gem)!)

        let label = UILabel().addFontAndText(font: "Cartwheel", text: text.convertDecimal(), size: width*0.15)
            label.textColor = .white
            label.adjustsFontSizeToFitWidth = true
            view.addSubview(label)
        
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        let iconType =  UIImageView(image:UIImage(named: icon.1.rawValue.lowercased()))
            view.addSubview(iconType)
        
            iconType.translatesAutoresizingMaskIntoConstraints = false
            iconType.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            iconType.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            iconType.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            iconType.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let btnAdd =  UIButton().addImageButton(image: "btnAdd", position: .right)
            btnAdd.addTarget(self, action: #selector(Infobar.tapFruit(sender:)), for: .touchUpInside)
            btnAdd.tag = Int(icon.0)
            view.addSubview(btnAdd)
            
            btnAdd.translatesAutoresizingMaskIntoConstraints = false
            btnAdd.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            btnAdd.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            btnAdd.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            btnAdd.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }
    
    var scene:SKScene?
    
    var resultDB:PlayerDB?
    
    let button:[(CGFloat,Currency.CurrencyType)] = [(0,Currency.CurrencyType.Fruit),(1,Currency.CurrencyType.Coin),(2,Currency.CurrencyType.Gem)]
    
     init(frame: CGRect,scene:SKScene) {
         
        super.init(frame: frame)
         
        self.restorationIdentifier = "infobar"
         
         self.tag = 100
         
        self.scene = scene
         
         do {
             
             guard let data =  try ManagedDB.shared.context.fetch(PlayerDB.fetchRequest()).first else { return }
             resultDB = data
         } catch let error {
            print(error.localizedDescription)
         }
         
    
        let _ =  button.map { idx in
            addSubview(fruit(idx))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func remove() {
        self.removeFromSuperview()
    }
    
    func update() {
        
        print("dentro update infobar Infobar.swift" )
        let _ =  button.map { idx in
            addSubview(fruit(idx))
        }
        
    }
    
    @objc func tapFruit(sender:UIButton) {
        
        guard let scene = scene else { fatalError()}
      
        if sender.tag == 0 {
            scene.view?.addSubview(getTypeTable(item: BuyFruit.items,title: "BUY FRUIT"))
        } else if sender.tag == 1 {
            scene.view?.addSubview(getTypeTable(item: BuyCoins.items,title: "BUY COINS"))
        }else if sender.tag == 2 {
            scene.view?.addSubview(getTypeTable(item: BuyGem.items,title: "BUY GEM"))
        }
    }
    
    private func getTypeTable<T>(item:[T],title:String)-> UIView where T:ProtocolTableViewGenericCell {
        
        var v = UIView()
        
        GameInfo.shared.showGenericViewTable(skScene: scene!, items: T.items, title: title, handler: { view  in
                
                v = view
        })
       
        return v
    }
}

class EggsClaim:SKSpriteNode {
    
    deinit{
        print("eggclaim deinit")
    }
  
    private var infoGetClover:SKSpriteNode!
    private var infoEggsClaim:SKSpriteNode!
    private var btnSettings:SKSpriteNode!
    
    convenience init(name n:String){
        self.init()
        
        name = n
        color = .clear
        
        size = CGSize(width: screenSize.width, height: screenSize.height)
        anchorPoint = CGPoint(x: 0, y: 0)
        position = CGPoint(x: 0, y: 5)
        
        // BUTTON SETTINGS MAIN SCREEN
        btnSettings =  SKScene().createUIButton(bname: "icon_settings", offsetPosX: screenSize.maxX-50, offsetPosY: screenSize.maxY-150,typeButtom: .SettingsButton)
        btnSettings.size = CGSize(width: 75, height: 75)
        
        
        // PANEL MAIN EGGS CLAIM
        infoEggsClaim = showEggsClaim()
     
        addChild(infoEggsClaim)
        addChild(btnSettings)
    
    }
    
    // MARK: CREATE PANEL EGGSCLAIM DOWN SCREEN
    private func showEggsClaim() -> SKSpriteNode{
        
        let panelEggs = SKSpriteNode(texture: SKTexture(imageNamed: "eggsClaim"), size: CGSize(width: screenSize.width*0.8, height: screenSize.height*0.15))
        panelEggs.name = "panelEggs"
        panelEggs.anchorPoint = CGPoint(x: 0, y:0)
        panelEggs.position = CGPoint(x: screenSize.midX - screenSize.width*0.8/2, y: 0)
        
         let eggsTotal = getEggsTotal()
     
        for x in 0..<4 {
            if x > 3 { return panelEggs}
            drawTextSlotEgg(idx: x, panelEggs: panelEggs, eggsTotal: eggsTotal,drawSlot:x > eggsTotal.count-1)
        }
        
        return panelEggs
    }
    
    private func drawTextSlotEgg(idx:Int,panelEggs:SKSpriteNode,eggsTotal:[EggsDB],drawSlot:Bool) {
        
        let shape = SKShapeNode()
        shape.name = "slot\(idx)"
        shape.path = UIBezierPath(roundedRect: CGRect(x: 10, y:panelEggs.frame.height*0.1, width: (panelEggs.frame.width/4)-7, height: (panelEggs.frame.height*0.8)), cornerRadius: 10).cgPath
        
        shape.position = CGPoint(x: CGFloat(idx) * shape.frame.width, y: 0)
        shape.strokeColor = UIColor.brown
        shape.lineWidth = 2
        panelEggs.addChild(shape)

        if drawSlot {
            let text =  SKLabelNode(fontNamed: "Cartwheel", andText: "EGG\nSLOT", andSize: shape.frame.width/4 * 0.9, fontColor: .brown, withShadow: .white)
            text?.numberOfLines = 0
            text?.zPosition = +1
            
            text!.position = CGPoint(x: shape.frame.midX, y: shape.frame.midY )
            panelEggs.addChild(text!)
            
        } else {
     
            let buttonTap = SKSpriteNode(imageNamed: "tap_To_hatch")
            buttonTap.name = "tapToHatchSlot_\(idx)"
            buttonTap.size = CGSize(width: shape.frame.width * 0.8, height: shape.frame.height * 0.5)
            buttonTap.anchorPoint = CGPoint(x: 0.5, y: 0)
            buttonTap.position = CGPoint(x: shape.frame.midX, y: shape.frame.maxY)
            panelEggs.addChild(buttonTap)
            buttonTap.run(.upDown(3,0.5))
       
            let eggs = SKSpriteNode(imageNamed: eggsTotal[idx].priority.rawValue)
            eggs.position = CGPoint(x: shape.frame.midX, y: shape.frame.height*0.7)
            eggs.size  = CGSize(width: shape.frame.height*0.5, height: shape.frame.height*0.7)
            panelEggs.addChild(eggs)
            
            
            let buttonClaim = SKSpriteNode(texture: SKTexture(imageNamed: "BlueButton"), color: .clear, size: CGSize(width: shape.frame.width*0.8, height: shape.frame.width * 0.25))
            buttonClaim.anchorPoint = CGPoint(x: 0.5, y: 0)
            buttonClaim.position = CGPoint(x: shape.frame.midX, y: shape.frame.minY)
            
            let textClaim =  SKLabelNode(fontNamed: "Cartwheel", andText: "Claim", andSize: shape.frame.width/4*0.8, fontColor: .yellow, withShadow: .clear)
            textClaim?.position.y = shape.frame.height * 0.25 / 2 - 5
            buttonClaim.addChild(textClaim!)
            
            panelEggs.addChild(buttonClaim)
        }
    }
    
    
    // MARK: GET TOTAL EGGS DB
    private func getEggsTotal() -> [EggsDB] {
        
        
        do {
             let managedContext = ManagedDB.shared.context

             let eggCount = try managedContext.fetch(EggsDB.fetchRequest())
            
            return eggCount
            
        } catch {
            fatalError()
        }
    }
    
    //MARK: GENERATE VIEW WHEN PRESS BUTTOM TAP HATCH
    func viewTapToHatch()->SKSpriteNode {
        
        let view = SKSpriteNode(texture: SKTexture(imageNamed: "eggsClaim"), size: CGSize(width: screenSize.width*0.8, height: screenSize.width*0.55))
        view.name = "viewTapToHatch"
        view.anchorPoint = CGPoint(x: 0.5, y:0)
        view.position = CGPoint(x: screenSize.midX , y: screenSize.height*0.20)
        
        
        let imgEggs = SKSpriteNode(imageNamed: "Common")
            imgEggs.size = CGSize(width: view.size.width * 0.2, height: view.size.width * 0.25)
        imgEggs.position = CGPoint(x: 0, y: view.size.height + imgEggs.size.height * 0.2)
        view.addChild(imgEggs)
        
        let sun = SKSpriteNode(imageNamed: "bgSun")
            sun.size = CGSize(width: view.size.width, height: view.size.width)
            sun.position = CGPoint(x: 0, y: view.size.height)
            sun.zPosition = -1
        view.addChild(sun)
        
        let sunRotate = SKSpriteNode(imageNamed: "bgSunRotate")
            sunRotate.size = CGSize(width: view.size.width, height: view.size.width)
            sunRotate.position = CGPoint(x: 0, y: view.size.height)
            sunRotate.zPosition = -1
        sunRotate.blendMode = .add
        sun.run(.repeatForever(.rotate(byAngle: .pi/2, duration: 1)))
        view.addChild(sunRotate)
        
        let textCommon =  SKLabelNode(fontNamed: "Cartwheel", andText: "COMMON DRAGON EGG", andSize:view.size.height*0.14, fontColor: .brown, withShadow: .black)
            textCommon?.position = CGPoint(x: 0, y: view.size.height - view.size.height * 0.2 )
        view.addChild(textCommon!)
        
        let textRarity =  SKLabelNode(fontNamed: "Cartwheel", andText: "DRAGON RARITY    Change", andSize: view.size.width*0.07, fontColor: .white, withShadow: .black)
            textRarity?.position = CGPoint(x: 0, y: view.size.height - view.size.height * 0.35 )
        view.addChild(textRarity!)
        
        let rectangle = SKShapeNode()
        rectangle.path = UIBezierPath(roundedRect: CGRect(x: -view.size.width * 0.7/2, y: view.size.width * 0.22, width: view.size.width * 0.7, height: view.size.width * 0.22), cornerRadius: 15).cgPath
        rectangle.fillColor = UIColor(red: 110/255, green: 95/255, blue: 37/255, alpha: 0.3)
        rectangle.position = .zero
        rectangle.strokeColor = .clear
        view.addChild(rectangle)
        
        let textInsideRect =  SKLabelNode(fontNamed: "Cartwheel", andText: "Common    100%", andSize: view.size.width*0.08, fontColor: .green, withShadow: .black)
        textInsideRect?.position.y = rectangle.frame.midY
        rectangle.addChild(textInsideRect!)
        
        
        let button = SKScene().createUIButton(bname: "tapHatch", offsetPosX:0, offsetPosY: view.frame.height*0.2,typeButtom: .BlueButton)
            button.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            button.size = CGSize(width: view.size.width/4, height: view.size.width/8)
        
        button.run(.repeatForever(
            .sequence([
                .colorize(with: UIColor.white.withLuminosity(1), colorBlendFactor: 1, duration: 0.5),
                .colorize(with: UIColor.gray.withLuminosity(1), colorBlendFactor: 0, duration: 0.5),
                
            ])))
        
        let labelHatch =  SKLabelNode(fontNamed: "Cartwheel", andText: "HATCH", andSize: button.size.height/2, fontColor: .white, withShadow: .clear)

        labelHatch?.position = .zero
        button.addChild(labelHatch!)
        view.addChild(button)
        
        let arrowUp = SKSpriteNode(imageNamed: "arrowUpGreen")
        arrowUp.name = "tapArrowUpGreen"
        arrowUp.size = CGSize(width: button.frame.width/2, height: button.frame.height)
        arrowUp.position.y = -button.frame.midY
        
        arrowUp.run(.repeatForever(.sequence([
            .moveBy(x: 0, y: 10, duration: 1),
            .moveBy(x: 0, y: -10, duration: 1)
        ])))
        
        button.addChild(arrowUp)
        
        return view
    }
    
    //MARK: DISABLE ALPHA PANELS MAIN SCREEN
    func disableAlphaEggsAndSettings() {
        
        infoEggsClaim.alpha = 0
        btnSettings.alpha = 0
    }
    
    
}
