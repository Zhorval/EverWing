//
//  Infobar.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import SpriteKit

class Infobar:SKSpriteNode{
    deinit{
        print("infobar deinit")
        timer?.invalidate()
    }
    private enum Template{
        case First  // Display Level&Exp
        case Second // Display account's money
        case Third  // Display trophy currency
        case Fourth // For settings - Not implemented yet
        case Fifth  // Above the 'Fourth' Label. Visible once game state == .Start
    }
    
    private let enableDebug:Bool = false
    private let mainRootWidth:CGFloat = screenSize.width
    private let mainRootHeight:CGFloat = 100
    private var firstTemplate:SKSpriteNode!
    private var secondTemplate:SKSpriteNode!
    private var thirdTemplate:SKSpriteNode!
    private var fourthTemplate:SKSpriteNode!
    private var fifthTemplate:SKSpriteNode!
    private var sixTemplate:SKSpriteNode!
    private var infoGetClover:SKSpriteNode!
    private var infoEggsClaim:SKSpriteNode!
    
    // MARK: LABEL TIMER
    private var timer:Timer?                            // Timer count screen
    private var timerCount:TimeInterval = 0             // Count timer screen
    private var labelTimer:SKLabelNode = SKLabelNode()      // Label timer screen
    
    
    // MARK: LABEL TIMER PROJECTILE TEMP
    private var timerProjectile:Timer?                            // Timer count screen
    private var timerCountProjectile:TimeInterval = 10            // Count timer screen
    private var labelTimerProjectile:SKLabelNode = SKLabelNode()      // Label timer screen
    private var iconProjectile:SKSpriteNode = SKSpriteNode()
    
    
    // MARK: BUTTON SETTINGS
    private var btnSettings:SKSpriteNode = SKSpriteNode()
    

    convenience init(name n:String){
        self.init()
        
        let rootItemSize:CGSize = CGSize(width: screenSize.width/4, height: screenSize.height*0.05)
        
        name = n
        color = .clear
        
        size = CGSize(width: screenSize.width, height: screenSize.height)
        anchorPoint = CGPoint(x: 0, y: 0)
        position = CGPoint(x: 0, y: 5)
       // Main_Menu_Currency_Bar
        firstTemplate = generateTemplate(templateStyle: .First, itemSize: rootItemSize, name: "topbar_first_item", barSprite:.Main_Menu_Level_Bar, iconSprite: .Main_Menu_Level_Badge, previousPos: nil)
        
        secondTemplate = generateTemplate(templateStyle: .Second, itemSize: rootItemSize, name: "topbar_second_item", barSprite: nil, iconSprite: .Main_Menu_Coin, previousPos: firstTemplate.position)
        
        thirdTemplate = generateTemplate(templateStyle: .Third, itemSize: rootItemSize, name: "topbar_third_item", barSprite: nil, iconSprite: .Main_Menu_Trophy, previousPos: secondTemplate.position)
        
        fourthTemplate = generateTemplate(templateStyle: .Fourth, itemSize: rootItemSize, name: "topbar_fourth_item", barSprite: nil, iconSprite: .Main_Menu_Trophy, previousPos: thirdTemplate.position)
        
        fifthTemplate = customFifthLabel(itemSize: rootItemSize, prevNodePosition: thirdTemplate.position)
        
        
        // BUTTON SETTINGS MAIN SCREEN
        btnSettings =  SKScene().createUIButton(bname: "icon_settings", offsetPosX: screenSize.maxX-50, offsetPosY: screenSize.maxY-50,typeButtom: .SettingsButton)
            btnSettings.size = CGSize(width: 50, height: 50)
        
        
        // PANEL MAIN EGGS CLAIM
        infoEggsClaim = showEggsClaim()
        
        
        addChild(firstTemplate)
        addChild(secondTemplate)
        addChild(thirdTemplate)
        addChild(fourthTemplate)
        addChild(fifthTemplate)
        addChild(infoEggsClaim)
        addChild(btnSettings)
        
        // Note: It will show debug view only if debug is enabled.
        debug()
    }
    
    /// Create panel info get clover
    func panelInfoGetClover(level:Int) -> SKSpriteNode {
        
        let infoGetClover = SKSpriteNode(color: .black.withAlphaComponent(0.5), size: CGSize(width: 120, height: 60))
        infoGetClover.position = CGPoint(x: screenSize.maxX - infoGetClover.frame.width/2 - 10, y: screenSize.height - screenSize.height/3)
        infoGetClover.name = "DMG"
        
        let iconClover = SKSpriteNode(texture: SKTexture(imageNamed: "Clover"), size: CGSize(width: 30, height: 30))
        iconClover.position = CGPoint(x: -40, y: 10)
        infoGetClover.addChild(iconClover)
        
        let labelLevel = SKLabelNode(fontNamed: "Cartwheel", andText: "", andSize: 20, withShadow: .red,name: "infoLevelShadow")
        labelLevel?.name = "infoLevel"
        labelLevel?.text = "LV \(level)"
        labelLevel?.fontColor = .white
        labelLevel?.position = CGPoint(x: 15, y: 0)
        infoGetClover.addChild(labelLevel!)
        
        let labelDMG = SKLabelNode(fontNamed: "Cartwheel", andText: "25 DMG", andSize: 20, withShadow: .red)
        labelDMG?.fontColor = .orange
        labelDMG?.text = "LV \(level)"
        labelDMG?.text = "\(10 +  level * 10) DMG"
        labelDMG?.position = CGPoint(x: 0, y: -25)
        infoGetClover.addChild(labelDMG!)
        
        infoGetClover.run(.sequence([
            .wait(forDuration: 2),
            SKAction.run {infoGetClover.removeFromParent()},
            
        ]))
        
   
       return infoGetClover
    }
    /// Add timer screen
      func addTime() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(running), userInfo: nil, repeats: true)
    }
    
 
    /// Print label time
    @objc func running() {
        timerCount += 1
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        let formattedString = formatter.string(from: TimeInterval(timerCount))!
        
        labelTimer.removeFromParent()
        labelTimer = SKLabelNode(fontNamed: "Cartwheel", andText: formattedString, andSize: 30, withShadow: .black)!
        labelTimer.fontColor = .yellow
        labelTimer.blendMode = .add
        labelTimer.position = CGPoint(x: 50, y: fourthTemplate.position.y)
        
        addChild(labelTimer)
        
    }
    
    // Add timer  by projectile temp
    func addTimeProjectileTemp() {
        timerProjectile = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ProjectileTemp), userInfo: nil, repeats: true)
   }
    
    @objc func ProjectileTemp() {
        timerCountProjectile -= 1
        
        if timerCountProjectile <= 1 {
            timerProjectile?.invalidate()
            iconProjectile.removeFromParent()
            timerCountProjectile = 10
            return
        } else {
        
            if timerCountProjectile < 4 {
                self.run(AVAudio().getAction(type: .TicTack))
            }
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            let formattedString = formatter.string(from: TimeInterval(timerCountProjectile))!
            
            labelTimerProjectile.removeFromParent()
            iconProjectile.removeFromParent()
        
            iconProjectile = SKSpriteNode(imageNamed: "main_menu_level_2")
            iconProjectile.size  = CGSize(width: 100 , height: 50)
            iconProjectile.position = CGPoint(x: screenSize.midX , y: 50)
        
            let frame = SKSpriteNode(imageNamed: "main_menu_level_1")
                frame.setScale(2)
                frame.anchorPoint = CGPoint(x: 1, y: 0.5)
                iconProjectile.addChild(frame)
        
                let projectile = SKSpriteNode(imageNamed: "FireRed")
                projectile.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                projectile.position = CGPoint(x: -15, y: 0)
                projectile.setScale(0.5)
                frame.addChild(projectile)
        
        
            labelTimerProjectile = SKLabelNode(fontNamed: "Cartwheel", andText: formattedString, andSize: 30, withShadow: .white)!
            labelTimerProjectile.fontColor = .yellow
            labelTimerProjectile.position = CGPoint(x: projectile.position.x + 40,y:-15)
            iconProjectile.addChild(labelTimerProjectile)
            addChild(iconProjectile)
        }
    }
    
    private func makeTemplateNode(width w:CGFloat, height h:CGFloat, dx:CGFloat, name n:String) -> SKSpriteNode{
        
        let node = SKSpriteNode()
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.color = .clear
        node.name = n
        node.size = CGSize(width: w, height: h)
        node.position = CGPoint(x: dx, y: self.size.height - h)
        
        return node
    }    

    private func generateTemplate(templateStyle:Template, itemSize: CGSize, name n:String, barSprite: Global.Main?, iconSprite: Global.Main, previousPos prev:CGPoint?) -> SKSpriteNode{
        
        var px:CGFloat!
        
        let (w, h) = (itemSize.width, itemSize.height)
        
        px = (prev == nil) ? 0.0 : prev!.x + w
        
        let node = makeTemplateNode(width: w, height: h, dx: px,  name: n)
        
        // Filling the template -->
        
        // Bar Default Values
        let barWidth:CGFloat = node.size.width*0.8
        let barHeight:CGFloat = node.size.height*0.55
        let barXpos:CGFloat = node.size.width
        let barYpos:CGFloat = 0
        
        // Icon Default Values
        let icon = SKSpriteNode()
        let iconWidth:CGFloat = node.size.height * 0.94
        let iconHeight:CGFloat = node.size.height * 0.94
        let iconXpos:CGFloat = node.size.width -  barWidth
        let iconYpos:CGFloat = -3
        
        icon.anchorPoint = CGPoint(x: 0.5, y: 0.1)
        icon.zPosition = 1
        icon.name = iconSprite.rawValue
        icon.size = CGSize(width: iconWidth, height: iconHeight)
        icon.position = CGPoint(x: iconXpos, y: iconYpos)
        icon.texture = global.getMainTexture(main: iconSprite)
        node.addChild(icon)
        
        // icon position might be changed with the if condition below:
        
        if templateStyle == .First{
            
            let newWidth:CGFloat = node.size.width*0.5
            let newHeight:CGFloat = node.size.height*0.65
            
            let bar = SKSpriteNode()
            bar.anchorPoint = CGPoint(x: 1.0, y: 0)
            bar.name = "bar"
            bar.size = CGSize(width: newWidth, height: newHeight)
            bar.texture = global.getMainTexture(main: barSprite!)
            bar.position = CGPoint(x: barXpos*0.8, y: barYpos)
            node.addChild(bar)
            
            // Adjusting Icon
            icon.position.x = node.size.width - newWidth - barXpos*0.2
            icon.position.y = 0
        }
        else if templateStyle == .Second || templateStyle == .Third{
            let rect = CGRect(x: self.size.width*0.038, y: 0, width: barWidth, height: barHeight)
            let bar = SKShapeNode(rect: rect, cornerRadius: screenSize.height * 0.01)
            bar.alpha = 0.65
            bar.fillColor = .black
            bar.strokeColor = .black
            bar.name = "bar"
            node.addChild(bar)
            
            let label = SKLabelNode(fontNamed: "CartWheel")
            label.zPosition = 1
            label.fontSize = barWidth/5
            label.horizontalAlignmentMode = .right
            label.verticalAlignmentMode = .center
            label.position.x += node.size.width * 0.9
            label.position.y += barHeight/2.8
            label.name = "label"
            
            if templateStyle == .Second{
                label.text = "123"
                label.fontColor = SKColor(red: 254/255, green: 189/255, blue: 62/255, alpha: 1)
                bar.addChild(label.shadowNode(nodeName: "labelCoinEffect"))
            }
            else{
                label.text = "0"
                label.fontColor = .green
               bar.addChild(label.shadowNode(nodeName: "labelTrophyEffect"))
            }
            
        }
        else if templateStyle == .Fourth{
            // This place will be the settings. Still not available
            icon.isHidden = true
        }
        
        return node
    }
    
    // fourth item
    private func customFifthLabel(itemSize:CGSize, prevNodePosition prev:CGPoint) -> SKSpriteNode{
        
        let width = itemSize.width
        let height = itemSize.height
        let node = makeTemplateNode(width: width, height: height, dx: prev.x + itemSize.width, name: "topbar_right_corner")
        node.position.y += 100 // decrease 100 to show to user
        
        // gold
        var curr = Currency(type: .Coin)
        let coinWidth:CGFloat = height*0.9
        let coinHeight:CGFloat = height*0.9
        let coinXpos:CGFloat = width - coinWidth/2
        let coinYpos:CGFloat = coinHeight/2 //+ 100 // decrease 50 to show on screen
        
        
        let goldIcon = curr.createCoin(posX: coinXpos, posY: coinYpos, width: coinWidth, height: coinHeight, createPhysicalBody: false, animation: true)
        
        
        goldIcon.name = "top_coin_tracker"
        node.addChild(goldIcon)
        
        // text
        let labelXPos:CGFloat = goldIcon.position.x - coinWidth/2 - (coinWidth*0.1)
        let labelYpos:CGFloat = goldIcon.position.y/2 - 2
        let labelText = SKLabelNode(fontNamed: "Cartwheel")
        labelText.text = "0"
        labelText.fontSize = 26
        labelText.fontColor = SKColor(red: 253/255, green: 188/255, blue: 0/255, alpha: 1)
        labelText.horizontalAlignmentMode = .right
        labelText.position = CGPoint(x: labelXPos, y:labelYpos)
        labelText.name = "coinText"
        node.addChild(labelText.shadowNode(nodeName: "coinLabelName"))
        
        
        node.alpha = 0.0
        return node
    }
    
    
    /// Update label number coin topnav
     func updateGoldLabel(coinCount:Int){
        
        guard let coinShadowLabel = fifthTemplate.childNode(withName: "coinLabelName") as? SKEffectNode else{
            print ("ERROR A01: Check updateGoldLabel method from Class Infobar")
            return
        }
        guard let coinLabel = coinShadowLabel.childNode(withName: "coinText") as? SKLabelNode else{
            print ("ERROR A02: Check updateGoldLabel method from Class Infobar")
            return
        }
        
        
        coinLabel.text = String(coinCount)
    }
    
    // MARK: CREATE PANEL EGGSCLAIM DOWN SCREEN
    private func showEggsClaim() -> SKSpriteNode{
        
        let panelEggs = SKSpriteNode(texture: SKTexture(imageNamed: "eggsClaim"), size: CGSize(width: screenSize.width-50, height: 150))
        panelEggs.size = CGSize(width: screenSize.width-50, height: 150)
        panelEggs.anchorPoint = CGPoint(x: 0, y:0)
        panelEggs.position = CGPoint(x: 25, y: 0)
        
        for x in 0..<4 {
           
            
            let shape = SKShapeNode()
            shape.name = "slot\(x)"
            shape.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: (panelEggs.frame.width-70)/4, height: 120), cornerRadius: 10).cgPath
            
            shape.position = CGPoint(x: (Int((panelEggs.frame.width-70)/4) * x) + ((x+1) * 14), y: 15)
            shape.strokeColor = UIColor.brown
            shape.lineWidth = 2
            panelEggs.addChild(shape)

            
            let text =  SKLabelNode(fontNamed: "Cartwheel", andText: "EGG\nSLOT", andSize: 20, withShadow: .clear)
            text?.fontColor = .brown
            text?.numberOfLines = 0
            text!.position = CGPoint(x: shape.frame.midX, y: shape.frame.midY)
            panelEggs.addChild(text!)
            
            let buttonTap = SKSpriteNode(imageNamed: "tap_To_hach")
            buttonTap.size.width = (panelEggs.frame.width-70)/4
            buttonTap.xScale = 0.9
            buttonTap.position = CGPoint(x: shape.frame.midX, y: panelEggs.frame.height - buttonTap.frame.height/2)
            panelEggs.addChild(buttonTap)
            buttonTap.run(.upDown(3,0.5))
            
            let eggs = SKSpriteNode(imageNamed: "Common")
            eggs.position = CGPoint(x: shape.frame.midX, y: shape.frame.midY - 10)
            eggs.size  = CGSize(width: 40, height: 50)
            panelEggs.addChild(eggs)
            
            let buttonClaim = SKSpriteNode(texture: SKTexture(imageNamed: "BlueButton"), color: .clear, size: CGSize(width: shape.frame.width, height: shape.frame.width * 0.3))
            buttonClaim.position = CGPoint(x: shape.frame.midX, y: 20)
           
            let textClaim =  SKLabelNode(fontNamed: "Cartwheel", andText: "Claim", andSize: 15, withShadow: .clear)
            textClaim?.fontColor = .yellow
            textClaim?.position.y = -5
            buttonClaim.addChild(textClaim!)
            
            panelEggs.addChild(buttonClaim)
        }
        
        return panelEggs
    }
    
     
     func updateGoldBalanceLabel(balance:Int){

        
        guard let coinBarLabel = secondTemplate.childNode(withName: "bar") else{
            print ("ERROR A00: Check updateGoldLabel method from Class Infobar")
            return
        }
        guard let coinShadowLabel = coinBarLabel.childNode(withName: "labelCoinEffect") as? SKEffectNode else{
            print ("ERROR A01: Check updateGoldLabel method from Class Infobar")
            return
        }
        guard let coinLabel = coinShadowLabel.childNode(withName: "label") as? SKLabelNode else{
            print ("ERROR A02: Check updateGoldLabel method from Class Infobar")
            return
        }

        let userPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
       
        let fullPath = userPath.appendingPathComponent("userinfo.plist")
        
         print("El full path \(fullPath)")
        guard let virtualPlist = NSDictionary(contentsOfFile: fullPath) else{
            print ("ERROR000: EndGame failed to load virtualPlist")
            return
        }
        
        guard let dataCoin:Int = virtualPlist.value(forKey: "Coin") as? Int else{
            print ("ERROR001: EndGame error")
            return
        }
        
        coinLabel.text = String(dataCoin)
    }
    
    
    
     func fadeAway(){
        
        let fadeAwayAction = SKAction.fadeAlpha(to: 0, duration: 0.2)
        
        let showCoinLabelAction = SKAction.group([SKAction.moveBy(x: 0, y: -100, duration: 0.3), SKAction.fadeAlpha(to: 1.0, duration: 0.3)])
        
        firstTemplate.run(fadeAwayAction)
        secondTemplate.run(fadeAwayAction)
        thirdTemplate.run(fadeAwayAction)
        fourthTemplate.run(fadeAwayAction)
        fifthTemplate.run(showCoinLabelAction)
        btnSettings.run(fadeAwayAction)
        infoEggsClaim.run(fadeAwayAction)
    }
    
   
    private func debug(){
        if !enableDebug{
            return
        }
        
        self.color = .red
        firstTemplate.color = .yellow
        secondTemplate.color = .blue
        thirdTemplate.color = .brown
        fourthTemplate.color = .purple
        fifthTemplate.color = .black
        
        return
    }
    
    
}
