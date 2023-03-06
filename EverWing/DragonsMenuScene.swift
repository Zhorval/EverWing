//
//  DragonsScene.swift
//  EverWing
//
//  Created by Pablo  on 28/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.


import Foundation
import SpriteKit


class DragonsMenuScene:SKScene,ProtocolTaskScenes,ProtocolEffectBlur {
    
    enum ActionButton:String,CaseIterable {
        case BackArrow          = "backArrow"
        case GetEggs            = "GetEggs"
        case Sell               = "SellDragon"
        case Index              = "Index"
        case CancelInfoDragon   = "CancelInfoDragon"
        case CancelFruitSell    = "CancelFruitSell"
        case btnRight           = "btnRight"
        case btnLeft            = "btnLeft"
        case btnMainToSell      = "btnMainToSell"
        case btnInfoDragonSell  = "btnInfoDragonSell"
        case btnFeed            = "btnFeed"
        case btnCircleL         = "btnCircleL"
        case btnCircleR         = "btnCircleR"
        case btnSellFruit       = "btnSellFruit"
        case txtSellFruit       = "txtSellFruit"
        case btnBuyAddFuit      = "btnBuyAddFruit"
        case btnCancelBuyGem    = "btnCancelBuyGem"
        case btnBuyCoin         = "btnBuyCoin"

        
        var getNameView:String {
            switch self {
            
            case .GetEggs:               return "nodeMain"
            case .Sell:                  return "sellMainPage"
            case .Index:                 return  "indexMainPage"
            case .CancelInfoDragon:      return "viewInfoDragon"
            case .CancelFruitSell:       return "viewSellFruit"
            case .btnRight:              return "viewBuyGem"
            case .btnLeft:               return "viewBuyGem"
            case .btnMainToSell:         return "viewBuyGem"
            case .btnInfoDragonSell:     return "viewInfoDragon"
            case .btnFeed:               return "viewBuyGem"
            case .btnCircleL:            return "viewBuyGem"
            case .btnCircleR:            return "viewBuyGem"
            case .btnSellFruit:          return "viewBuyGem"
            case .txtSellFruit:          return "viewBuyGem"
            case .btnBuyAddFuit:         return "viewSellFruit"
            case .btnCancelBuyGem:       return "viewBuyGem"
            case .BackArrow,.btnBuyCoin: return ""
                
            }
        }
    }
    
    private var gameinfo:GameInfo = GameInfo()
    
    private var eggsPage:UIView? = nil
    
    var blurNode: SKEffectNode = SKEffectNode()
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: screenSize.width, height: screenSize.height)
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
        title.position = CGPoint(x:screenSize.midX,y:screenSize.height-150)
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
        bgIcons.position = CGPoint(x: screenSize.midX, y: screenSize.minY+25)
        addChild(bgIcons)
        
        let Btneggs = self.createUIButton(bname: ActionButton.GetEggs.rawValue,
                                          offsetPosX: screenSize.minX + screenSize.width*0.2,
                                          offsetPosY: screenSize.height*0.07,
                                          typeButtom: .GreenButton)
        
        Btneggs.size  = CGSize(width: screenSize.width*0.25, height: screenSize.width*0.1)
        addChild(Btneggs)
        
        let labelEggs = SKLabelNode(fontNamed: "Cartwheel", andText: "GET EGGS", andSize: Btneggs.size.width*0.15, fontColor: .white, withShadow: .black,name: "labelEggsShadow")
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
                                          offsetPosY: screenSize.height*0.07,
                                          typeButtom: .GreenButton)
        Btnsell.size  = CGSize(width: screenSize.width*0.25, height: screenSize.width*0.1)
        addChild(Btnsell)
        
        let labelSell = SKLabelNode(fontNamed: "Cartwheel", andText: "SELL",
                                    andSize: Btneggs.size.width*0.15, fontColor: .white,
                                    withShadow: .black)
        labelSell?.name = ActionButton.Sell.rawValue
        Btnsell.addChild(labelSell!)
        
        let BtnIndex = self.createUIButton(bname: ActionButton.Index.rawValue,
                                           offsetPosX: screenSize.maxX - screenSize.width*0.2,
                                           offsetPosY: screenSize.height*0.07,
                                           typeButtom: .GreenButton)
        BtnIndex.size  = CGSize(width: screenSize.width*0.25, height: screenSize.width*0.1)
        addChild(BtnIndex)
        
        let labelIndex = SKLabelNode(fontNamed: "Cartwheel",
                                     andText: "INDEX",
                                     andSize: Btneggs.size.width*0.15, fontColor: .white,
                                     withShadow: .black)
        BtnIndex.addChild(labelIndex!)
        
        let BtnBook = SKSpriteNode(texture: SKTexture(imageNamed: Global.GUIButtons.BookButton.rawValue),
                                   size: CGSize(width: BtnIndex.size.width * 0.4, height: BtnIndex.size.width * 0.5))
        BtnBook.position = CGPoint(x:BtnIndex.frame.width*0.4,y:0)
        BtnIndex.addChild(BtnBook)
    }
    
    // MARK: SHOW MAIN PAGE SCREEN
    private func showMainPage() {
        
        
        let node = SKNode()
        node.name = "nodeMain"
        
        let circleL = SKShapeNode(circleOfRadius: screenSize.width*0.1)
        circleL.fillColor = .black.withAlphaComponent(0.5)
        circleL.position = CGPoint(x: screenSize.width*0.2, y: screenSize.height*0.7)
        node.addChild(circleL)
        
        let dragonCircleL = SKSpriteNode(imageNamed: "NC01_T1_icon")
        dragonCircleL.name = "btnCircleL"
        dragonCircleL.size = CGSize(width: circleL.frame.size.width*0.8, height: circleL.frame.size.width*0.8)
        circleL.addChild(dragonCircleL)
        
        guard let circleR = circleL.copy() as? SKShapeNode else  { return }
        circleR.name = "btnCircleR"
        circleR.position = CGPoint(x: screenSize.width*0.8, y: screenSize.height*0.7)
        node.addChild(circleR)
        
        
        let bgTable = SKSpriteNode(imageNamed: "tableDragonsScene")
        bgTable.name = "tableDragonsScene"
        bgTable.size = CGSize(width: screenSize.width*0.95, height: screenSize.height*0.5)
        bgTable.position = CGPoint(x: screenSize.width/2, y: screenSize.height*0.1+bgTable.size.height/2)
        
        node.addChild(bgTable)
        
        let counterTable = SKSpriteNode(imageNamed: "counter")
        counterTable.name = "counterTable"
        counterTable.size = CGSize(width: bgTable.size.width*0.2, height: bgTable.size.width*0.08)
        counterTable.position = CGPoint(x: bgTable.size.width*0.2 ,
                                        y: bgTable.size.height/2 - counterTable.size.height/2)
        
        let txtCounter = SKLabelNode(fontNamed: "Cartwheel",
                                     andText: "1 / 2",
                                     andSize: counterTable.size.height/2, fontColor: .white,
                                     withShadow: .black)!
        
        counterTable.addChild(txtCounter)
        
        let txtInsideTable = SKLabelNode(fontNamed: "Cartwheel",
                                         andText: "EARN GOLD TO\nBUY DRAGONS",
                                         andSize: bgTable.size.width/8, fontColor: .brown,
                                         withShadow: .black)!
        txtInsideTable.numberOfLines = 0
        txtInsideTable.position = .zero
        bgTable.addChild(txtInsideTable)
        bgTable.addChild(counterTable)
        addChild(node)
        
    }
    
    /******************************************************** START FUNCTIONS MENU INDEX MAIN PAGE ******************************************************************************************/

    private func showIndexPageBook(){
        
        
        let width = screenSize.width*0.95
        let height = screenSize.height*0.8
        let marginX = (screenSize.width-width)/2
        let marginY = (screenSize.height-height)/2
     
        let rect = CGRect(x: marginX/2, y: marginY, width: width, height: height)
        let rectDragons = CGRect(x: width*0.1/2, y: height*0.3, width: width*0.9, height: height*0.8)
      
        
         scene?.backgroundBlack(withSpinnerActive: false)
         self.childNode(withName: "nodeMain")?.run(.move(by: CGVector(dx: -screenSize.width, dy: 0), duration: 0.3))

        
         let view = UIView(frame: rect).viewBG(image: "panelInfo")
         view.accessibilityIdentifier = "sellDragon"
         
         let btnCancel = UIButton(frame: CGRect(x: view.frame.maxX ,
                                                y: view.frame.minY  ,
                                                width: view.frame.size.width*0.1,
                                                height: view.frame.size.width*0.1))
                                    .addImageButton(image: "CancelButton",position:.topRight)
         
         btnCancel.addTarget(self, action: #selector(tapButtonCancel(_:)), for: .touchUpInside)
         view.addSubview(btnCancel)
         
        let gradient = UIImage.gradientImage(bounds: view.bounds, colors: [.white,.white])

         let title = UILabel(frame: CGRect(x: 0, y: view.frame.height*0.15, width: view.frame.width,height: view.frame.height*0.1))
             .addFontAndText(font: "Cartwheel", text: "YOUR COLLECTION:", size: view.frame.width*0.05)
             .shadowText(colorText: UIColor(patternImage: gradient), colorShadow: .black,aligment: .center)
         view.addSubview(title)
         
        let collection = CustomCollectionViewEggs(frame: rectDragons,items: Dragons.items,view:view, typeGridCollection: .index)
        { (select: Dragons) in
            self.DetailDragonSelectCollection(dragon:select)
        } handlerDeselect:   { _ in
                              } handlerTapAudio:  { [self] in
                                  run(gameinfo.mainAudio.getAction(type: .ChangeOption))
                              }
         view.addSubview(collection)
        
        scene?.view?.addSubview(view)
    }
        
    /******************************************************** END FUNCTIONS MENU INDEX MAIN PAGE ******************************************************************************************/

    
    ///******************************************************** START FUNCTIONS MENU SELL MAIN PAGE ************************************************************************************
    
    private func SellMainPage() {
        
       let width = screenSize.width*0.95
       let height = screenSize.height*0.8
       let marginX = (screenSize.width-width)/2
       let marginY = (screenSize.height-height)/2
    
       let rect = CGRect(x: marginX/2, y: marginY, width: width, height: height)
       let rectDragons = CGRect(x: width*0.2/2, y: height*0.3, width: width*0.8, height: height*0.3)
     
        var textCount:UILabel?
        var btnSell:UIButton?
        
         var textSeleted:Int = 0 {
            didSet {
                textCount?.text = "+ \(textSeleted)"
                if textSeleted >  0 {
                    btnSell = btnSell?.addImageButton(image: "GreenButton", position: .left)
                } else {
                    btnSell = btnSell?.addImageButton(image: "disableSell", position: .right)
                }
            }
        }
       
        scene?.backgroundBlack(withSpinnerActive: false)
        self.childNode(withName: "nodeMain")?.run(.move(by: CGVector(dx: -screenSize.width, dy: 0), duration: 0.3))

        let view = UIView(frame: rect).viewBG(image: "panelInfo")
        view.accessibilityIdentifier = "sellDragon"
        
        let btnCancel = UIButton(frame: CGRect(x: view.frame.maxX - view.frame.size.width*0.1,
                                               y: view.frame.minY ,
                                               width: view.frame.size.width*0.1,
                                               height: view.frame.size.width*0.1))
                                                .addImageButton(image: "CancelButton",position:.topRight)
        
        btnCancel.addTarget(self, action: #selector(tapButtonCancel(_:)), for: .touchUpInside)
        view.addSubview(btnCancel)
        
        let gradient = UIImage.gradientImage(bounds: view.bounds, colors: [.orange, .yellow])

        let title = UILabel(frame: CGRect(x: 0, y: view.frame.height*0.15, width: view.frame.width,height: view.frame.height*0.1))
            .addFontAndText(font: "Cartwheel", text: "BULK SELL", size: view.frame.width*0.1)
            .shadowText(colorText: UIColor(patternImage: gradient), colorShadow: .black,aligment: .center)
        view.addSubview(title)
        
        let subtitle = UILabel(frame: CGRect(x: 0, y: view.frame.height*0.2, width: view.frame.width,height: view.frame.height*0.1))
            .addFontAndText(font: "Cartwheel", text: "CHOOSE DRAGONS TO SELL", size: view.frame.width*0.05)
            .shadowText(colorText: .brown, colorShadow: .black, aligment: .center)
        
        view.addSubview(subtitle)
        
        let collection = CustomCollectionViewEggs(frame: rectDragons,items: Dragons.items,view:view, typeGridCollection: .sell) { _ in
                                textSeleted += 9
                             } handlerDeselect:   { _ in
                                 textSeleted -= 9
                             } handlerTapAudio:  { [self] in
                                 run(gameinfo.mainAudio.getAction(type: .ChangeOption))
                             }
        view.addSubview(collection)
        
        let contador = UIImageView(frame: CGRect(x: width*0.1, y: view.frame.height*0.65, width: view.frame.width*0.4, height: view.frame.width*0.3/2))
        contador.image = UIImage(named: "counter")
        view.addSubview(contador)
        
        let fruite = UIImageView(frame: CGRect(x: contador.frame.width*0.6, y: contador.frame.height/10, width: contador.frame.height*0.7, height: contador.frame.height*0.7))
            fruite.image = UIImage(named: "fruit")
        contador.addSubview(fruite)
        
        
        textCount = UILabel(frame: CGRect(x: 0, y: 0, width: contador.frame.width*0.7, height: contador.frame.height))
            .addFontAndText(font: "Cartwheel", text: "+ \(textSeleted)", size: contador.frame.width*0.2)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
        contador.addSubview(textCount!)
        
        btnSell = UIButton(frame:CGRect(x:  contador.frame.maxX, y:  contador.frame.origin.y, width: contador.frame.width, height: contador.frame.height))
            .addImageButton(image: "disableSell",position: .right)
        btnSell?.addTarget(self, action: #selector(sellTapButton(_:)), for: .touchUpInside)
        
        let bag = UIImageView(frame: CGRect(x: btnSell!.frame.width - btnSell!.frame.width*0.3, y: 0, width: contador.frame.height*1.2, height: contador.frame.height*1.2))
            bag.image = UIImage(named: "iconExtra_2")
        btnSell?.addSubview(bag)
       
        let txtSell = UILabel(frame: btnSell!.bounds)
            .addTextWithFont(font: UIFont.systemFont(ofSize: btnSell!.frame.width*0.15, weight: .bold),text: "SELL",color: .brown)
            btnSell?.addSubview(txtSell)
        view.addSubview(btnSell!)
       
        let txtUndone = UILabel(frame: CGRect(x: 0, y:  view.frame.height*0.75, width: view.frame.width,height: height*0.1))
            .addTextWithFont(font: UIFont.systemFont(ofSize: view.frame.width*0.03, weight: .bold),text: "(This cannot be undone)",color: .brown)
            view.addSubview(txtUndone)
        
        let bagFruit = UIImageView(frame: CGRect(x: view.frame.width*0.1, y: view.frame.height*0.85,width: view.frame.width/4, height: view.frame.width/4))
            bagFruit.image = UIImage(named: "bagFruit")
        view.addSubview(bagFruit)
        
        let getMoreFruit = UILabel(frame: CGRect(x: width*0.1, y:  view.frame.height*0.8, width: view.frame.width,height: height*0.2))
            .addTextWithFont(font: UIFont.systemFont(ofSize: view.frame.width*0.05, weight: .bold), text: "GET MORE\nDRAGONFRUIT",color: .brown)
            .shadowText(colorText: UIColor(patternImage: gradient), colorShadow: .black,aligment: .center)
            view.addSubview(getMoreFruit)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCounter))
        let contadorMoreFruit = UIImageView(frame: CGRect(x: width*0.5, y: view.frame.height*0.95, width: view.frame.width*0.3,height: view.frame.width*0.1))
            contadorMoreFruit.image = UIImage(named: "counter")
            contadorMoreFruit.isUserInteractionEnabled = true
            contadorMoreFruit.addGestureRecognizer(tapGesture)
        view.addSubview(contadorMoreFruit)


        let iconPlus =  UIImageView(image: UIImage(named: "btnAdd")!)
                iconPlus.isUserInteractionEnabled = true
                iconPlus.frame = CGRect(x: contadorMoreFruit.bounds.maxX - iconPlus.image!.size.width/2, y: 0, width: contadorMoreFruit.frame.height,
                                height: contadorMoreFruit.frame.height)
                contadorMoreFruit.addSubview(iconPlus)

        scene?.view?.addSubview(view)
    }
    
    @objc func tapCounter() {
        childNode(withName:"viewBuyGem")?.removeFromParent()
        self.viewBuyGem(item: BuyFruit.items)
    }
    
    /****************************************************   END FUNCTIONS MENU SELL MAIN PAGE  *************************************************************/
    
    //MARK: SHOW TABLEVIEW FOR ITEM BUY GEM OR COINS
    private func showGenericViewTable<T:ProtocolTableViewGenericCell>(items:[T],title:String) throws   {
        
        
        guard let node = self.childNode(withName: "nodeMain") else { throw NSError(domain: "Not found node", code: 13)}
        
        node.run(.move(by: CGVector(dx: -screenSize.width, dy: 0), duration: 0.5),completion: { [self] in
            
            let width  = screenSize.size.width*0.8
            let height = screenSize.size.height*0.65
            let margin = screenSize.size.width * 0.1
            
            let eggsPage = UIView(frame: CGRect(x: screenSize.width*0.1, y: screenSize.height/4, width: width,height: height))
            eggsPage.accessibilityIdentifier = title
            let inset = eggsPage.bounds.inset(by: .init(top: margin, left: margin/2, bottom: margin, right: margin/2))
            
            eggsPage.contentMode = .scaleAspectFill
            
            let viewCol = UIView(frame: inset)
            
            let tableViewEggs = GenericTableView(frame: viewCol.bounds, items: T.items) { (item:T) in
                
                UIView.animate(withDuration: 0.1) { [self] in
                    scene!.backgroundBlack(withSpinnerActive: false)
                    eggsPage.transform = CGAffineTransform(translationX: screenSize.width, y: 0)
                
                    showGenericViewBuyItem(items: item)
                }
            }
            
            viewCol.addSubview(tableViewEggs)
            eggsPage.addSubview(viewCol)
            
            
            let bg = UIImageView(frame: eggsPage.bounds)
            let image = UIImage(named: "bgSettings")
            bg.image = image!
            eggsPage.addSubview(bg)
            
            let iconCancel = UIButton(frame: CGRect(x: (eggsPage.frame.width)-width/20, y: -width/20, width: width/10, height: width/10))
            iconCancel.setImage(UIImage(named: "CancelButton"), for: .normal)
            iconCancel.addTarget(self, action: #selector(tapButtonCancel), for: .touchUpInside)
            eggsPage.addSubview(iconCancel)
            
            let bgTie = UIImageView(frame: CGRect(origin: CGPoint(x: eggsPage.frame.width*0.15 , y: -eggsPage.frame.width*0.1), size: CGSize(width: eggsPage.frame.width*0.7, height: eggsPage.frame.width*0.2)))
            
            let image1 = UIImage(named: "bgGetDragonFruit")!
            bgTie.image = image1
            
            let label = UILabel(frame: bgTie.bounds)
               
                label.font = UIFont(name: "Cartwheel", size: bgTie.frame.width*0.08)
                label.text = title
            
                let gradient = UIImage.gradientImage(bounds: label.bounds, colors: [.orange, .yellow])
                label.textColor = UIColor(patternImage: gradient)
              
                label.shadowColor = UIColor.black
                label.shadowOffset = CGSize(width: 2, height: 2)
                label.textAlignment = .center
                label.layer.shadowRadius = 5
                bgTie.addSubview(label)
            
            eggsPage.addSubview(bgTie)
            
            eggsPage.addSubview(viewCol)
            self.view?.addSubview(eggsPage)
            
        })
    }
    
    @objc func tapButtonCancel(_ sender:UIButton) {

        removeBackgroundBlack(removeBlur: blurNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            guard let pos  = nodes(at: touch.location(in: self)).first,
                  let name =  pos.name,
                  let action = ActionButton(rawValue: name) else { return }
            
            run(gameinfo.mainAudio.getAction(type: .ChangeOption))

            print("Name",name)
            switch action {
                
            case .GetEggs:                              genericTableView(items:BuyEggs.items)
             
            case .Sell:                                 SellMainPage()
            
            case .Index:                                showIndexPageBook()
                
            case .btnLeft,.btnRight:break
           
            case .btnFeed:
                break
                
            case .btnCircleL,.btnCircleR:
                
           //     blurScene(blurNode: blurNode)
                showPanelDragonCircle(node_: pos)
                
            case .btnMainToSell,.btnCancelBuyGem,
                 .CancelFruitSell,.CancelInfoDragon:   removeBackgroundBlack(removeBlur: blurNode)
            
            case .btnInfoDragonSell:                   SellFromPanelDragonCircle()
                
            case .btnSellFruit, .txtSellFruit:         AnimationSellDragonGetFruit()
                
            case  .btnBuyAddFuit:                      viewBuyGem(item: BuyFruit.items)
            
            case .BackArrow:                           doTask(gb: .Character_Menu_BackArrow)
                
            case .btnBuyCoin:
                if !howDo(pos:pos) {
                    showTypeListObject(pos:pos)
                }
                
            }
        }
    }
    
    //MARK: ACTION WHEN TAP BUTTON GREEN SELL DRAGON FOR FRUIT
    @objc private func sellTapButton(_ sender: UIButton) {
        
        guard let image  = sender.image(for: .normal) else { return }
        
        if image.isEqual(UIImage(named: "GreenButton")) {
            sender.isEnabled = false
            run(gameinfo.mainAudio.getAction(type: .ChangeOption))
            createAnimationFruitSell(typeObject: Icons.fruit) {  _  in
                self.tapButtonCancel(sender)
            }
        }
    }

    
    //MARK: SHOW VIEW WHEN SELECT DRAGON COLLECTIONVIEW INDEX
    private func DetailDragonSelectCollection(dragon:Dragons) {
        
        
        if let lastView = scene?.view?.subviews.last {
            UIView.animate(withDuration: 0.05) {
                lastView.transform = CGAffineTransform(translationX: screenSize.width, y: 0)
            
            } completion: { _ in
                lastView.removeFromSuperview()
            }
        }
        
        let node = SKNode()
        node.name = ActionButton.CancelInfoDragon.rawValue
        addChild(node)
        
        
        let view = UIView(frame:CGRect(x: screenSize.width*0.05, y: screenSize.height*0.15, width: screenSize.width*0.9, height: screenSize.height*0.7))
        let image = UIImageView(image:UIImage(named: "panelInfo")!)
        image.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        image.contentMode = .scaleToFill
        view.addSubview(image)
        
        let iconCancel = UIButton(frame: CGRect(x: view.frame.maxX-25, y: 0, width: 50, height: 50))
            .addImageButton(image: "CancelButton", position: .topRight)
            iconCancel.addTarget(self, action: #selector(tapButtonCancel(_:)), for: .touchUpInside)
        view.addSubview(iconCancel)
        
        let dragonIcon = UIImageView(image: UIImage(named: dragon.name + "_icon")!)
        dragonIcon.frame = CGRect(x:  view.frame.width/2 - dragonIcon.image!.size.width/4, y: screenSize.width*0.05, width: view.frame.width*0.5, height: view.frame.width*0.5)
        dragonIcon.image = dragonIcon.image?.maskWithColor(color: .black)
        view.addSubview(dragonIcon)

    
        let arrowL = UIButton(frame: CGRect(x: view.frame.width*0.05, y: dragonIcon.frame.height/2, width: view.frame.width*0.1, height: view.frame.width*0.1))
            arrowL.setImage(UIImage(named:"iconExtra_0")!, for: .normal)
            arrowL.addTarget(self, action: #selector(tapArrowL(_:)), for: .touchUpInside)
            arrowL.restorationIdentifier = "\(dragon.name)_Left"
        view.addSubview(arrowL)
        
        let arrowR = UIButton(frame:CGRect(x: view.frame.width*0.85, y: dragonIcon.frame.height/2, width: view.frame.width*0.1, height: view.frame.width*0.1))
            arrowR.setImage(UIImage(named:"iconExtra_1")!, for: .normal)
            arrowR.addTarget(self, action: #selector(tapArrowL(_:)), for: .touchUpInside)
        arrowR.restorationIdentifier = "\(dragon.name)_Right"
            view.addSubview(arrowR)
        
        
        
        let number = dragon.name.getNumberStarName()
        for x in 0...2 {
            let image = x <= number ? "starB" : "startGray"
            let star = UIImageView(image: UIImage(named: image))
            star.frame = CGRect(x: view.frame.width/2 + CGFloat(CGFloat(x) * 30) - star.image!.size.width , y: dragonIcon.frame.height*1.2, width: star.frame.width, height: star.frame.height)
            view.addSubview(star)
        }
        
        let shape = UIView(frame: CGRect(x: view.frame.width*0.05, y: view.frame.height/2, width: view.frame.width*0.9, height: view.frame.height*0.3))
        shape.backgroundColor = .brown
        view.addSubview(shape)
        
        let name = UILabel(frame: CGRect(x: shape.frame.width*0.02, y: -shape.frame.height*0.35, width: shape.frame.width/2, height: shape.frame.width/2))
            .addTextWithFont(font: .systemFont(ofSize: 18, weight: .bold), text: "Name:", color: .white)
        name.textAlignment = .left
        shape.addSubview(name)
        
        let valueName = UILabel(frame: CGRect(x: shape.frame.width*0.5, y: -shape.frame.height*0.35, width: shape.frame.width/2, height: shape.frame.width/2))
            .addTextWithFont(font: .systemFont(ofSize: 18, weight: .bold), text: dragon.picture, color: .white)
        valueName.textAlignment = .right
        shape.addSubview(valueName)
        
        
        let rarity = UILabel(frame: CGRect(x: shape.frame.width*0.02, y: -shape.frame.height*0.15, width: shape.frame.width/2, height: shape.frame.width/2))
            .addTextWithFont(font: .systemFont(ofSize: 18, weight: .bold), text: "Rarity:", color: .white)
        rarity.textAlignment = .left

        shape.addSubview(rarity)
        
        let valueRarity = UILabel(frame: CGRect(x: shape.frame.width*0.5, y: -shape.frame.height*0.15, width: shape.frame.width/2, height: shape.frame.width/2))
            .addTextWithFont(font: .systemFont(ofSize: 18, weight: .bold), text: "Common", color: .white)
        valueRarity.textAlignment = .right

        shape.addSubview(valueRarity)
        
        let type = UILabel(frame: CGRect(x: shape.frame.width*0.02, y: 0, width: shape.frame.width/2, height: shape.frame.width/2))
            .addTextWithFont(font: .systemFont(ofSize: 18, weight: .bold), text: "Type:", color: .white)
        type.textAlignment = .left

        shape.addSubview(type)
        
        let valueType = UILabel(frame: CGRect(x: shape.frame.width*0.5, y: 0, width: shape.frame.width/2, height: shape.frame.width/2))
            .addTextWithFont(font: .systemFont(ofSize: 18, weight: .bold), text: "Permanent", color: .white)
        valueType.textAlignment = .right
        shape.addSubview(valueType)
        
        let class_ = UILabel(frame: CGRect(x: shape.frame.width*0.02, y: shape.frame.height*0.15, width: shape.frame.width/2, height: shape.frame.width/2))
            .addTextWithFont(font: .systemFont(ofSize: 18, weight: .bold), text: "Class:", color: .white)
        class_.textAlignment = .left

        shape.addSubview(class_)
        
        let valueClass = UILabel(frame: CGRect(x: shape.frame.width*0.5, y: shape.frame.height*0.15, width: shape.frame.width/2, height: shape.frame.width/2))
            .addTextWithFont(font: .systemFont(ofSize: 18, weight: .bold), text: "Chaser", color: .white)
        valueClass.textAlignment = .right

        shape.addSubview(valueClass)
        
        let skills = UILabel(frame: CGRect(x: shape.frame.width*0.02, y: shape.frame.height*0.35, width: shape.frame.width/2, height: shape.frame.width/2))
            .addTextWithFont(font: .systemFont(ofSize: 18, weight: .bold), text: "Skills:", color: .white)
        skills.textAlignment = .left

        shape.addSubview(skills)
        
        for x in 0...3{
            let width = shape.frame.width*0.15
            let valueSkills = UIImageView(image: UIImage(named: "sidekick_skills1_0")!)
            valueSkills.frame = CGRect(x: shape.frame.width*0.3 + CGFloat(x) * width, y: shape.frame.height*0.65,
                                       width: width, height: width)
            
            shape.addSubview(valueSkills)
        }
        
        
        
        view.addSubview(shape)
        node.scene?.view?.addSubview(view)
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
                    if number  > 0 {  return Dragons.items.filter { $0.name == "\(name)_T\(number)"}.first }
                
                case .Right:
                    number += 1
                    if number  < 4 {  return Dragons.items.filter { $0.name == "\(name)_T\(number)"}.first }
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
    
    
    // MARK: ADD ANIMATION FRUITS WHEN SELL DRAGONS FOR BY FRUIT
    private func createAnimationFruitSell(typeObject:Icons,completion:@escaping(Bool)->Void) {
     
        var index = 0
      
        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { t in
            
            if index > 20 {
                t.invalidate()
            }
            self.coinAnimation(index:index,typeObject:typeObject ,t:t.timeInterval) { _  in
                self.run(self.gameinfo.mainAudio.getAction(type: .Result_Coin))
                completion(true)
            }
            index += 1
        }
    }
    
    //MARK: ANIMATE SEVERAL FRUIT IN CENTER SCREEN WHEN SELL DRAGON FOR FRUIT
    private func coinAnimation(index:Int,typeObject:Icons,t:TimeInterval,handler:@escaping(Bool)->Void) {

        let smallFruit = UIImage(named: typeObject.rawValue)!

        let imageView = UIImageView(image: smallFruit)

        let x =  random(min: screenSize.midX-50, max: screenSize.midX+50) + .pi/180  * t
        let y =  random(min: screenSize.midY-50 ,max: screenSize.midY+50) + .pi/180 * t
        
        imageView.frame = CGRect(x: x, y: y, width: 30, height: 30)
        imageView.contentMode = .scaleAspectFit
        let position = CGPoint(x: screenSize.minX, y: screenSize.minY)

        UIView.animate(withDuration: 0.2) {
            imageView.center = position
            imageView.transform = CGAffineTransform(rotationAngle: 90)
            imageView.transform = CGAffineTransform(translationX: screenSize.minX, y: screenSize.minY)
            self.view!.addSubview(imageView)
        } completion: { _ in
            if index > 20 {
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
        createAnimationFruitSell(typeObject: .coin, completion: { [self] _ in
            
            
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
    
    private func headerPanel(node:SKSpriteNode,actionButton:ActionButton)  -> SKSpriteNode{
       
        
        /// Background view
        let bg = SKSpriteNode(imageNamed: "panelInfo")
        
        bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bg.name = "panelInfo"
        bg.size = CGSize(width: screenSize.width*0.9, height: screenSize.height*0.7)
        bg.position = CGPoint(x: screenSize.midX, y: screenSize.midY)
        
        
        let iconCancel = SKSpriteNode(imageNamed: "CancelButton")
        iconCancel.name = actionButton.rawValue
        iconCancel.size = CGSize(width: 50, height: 50)
        iconCancel.position = CGPoint(x: bg.size.width/2, y: bg.size.height/2)
        bg.addChild(iconCancel)
        
        
        
        /// Dragon image
        let imgDragon = SKSpriteNode(texture:node.texture)
        imgDragon.color = .red
        imgDragon.name = "dragonNode"
        imgDragon.size = CGSize(width: bg.size.height * 0.25, height: bg.size.height * 0.3)
        imgDragon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        imgDragon.position =  CGPoint(x: -bg.size.width/2 + imgDragon.size.width/2,
                                      y: bg.size.height/2 - imgDragon.size.height/2)
        
        let heart = SKSpriteNode(imageNamed: "heartOff")
        heart.name = "iconHeart"
        heart.size = CGSize(width: imgDragon.size.width/4, height: imgDragon.size.width/4)
        heart.position = CGPoint(x: imgDragon.size.width/2, y: -imgDragon.size.height/2)
        imgDragon.addChild(heart)
        
        bg.addChild(imgDragon)
        /// Background info dragon selected
        
        let bgInfoDragon = SKShapeNode(rect: CGRect(x: 0,
                                                    y: -bg.size.height*0.35,
                                                    width: bg.size.width*0.45,
                                                    height: bg.size.height*0.3),
                                       cornerRadius: bg.size.width*0.03)
        bgInfoDragon.fillColor = UIColor(red: 239 / 255, green: 204/255, blue: 151/255, alpha: 0.5)
        bgInfoDragon.strokeColor = .clear
        bgInfoDragon.position =  CGPoint(x: 0, y: bg.frame.height/2 )
        
        
        bg.addChild(bgInfoDragon)
        
        /// Icons Stars
        for x in 0...2 {
            let start = SKSpriteNode(imageNamed: "starB")
            start.size = CGSize(width: bgInfoDragon.frame.size.width/5, height: bgInfoDragon.frame.size.width/5)
            start.name = "star_\(x)"
            start.position = CGPoint(x: start.size.width/2 + CGFloat(x) * start.size.width, y: -bgInfoDragon.frame.size.height*0.3)
            bgInfoDragon.addChild(start)
        }
        
        /// Name Dragon text
        let nameDragon = SKLabelNode(fontNamed: "Family Guy",
                                     andText: "Flo",
                                     andSize: bgInfoDragon.frame.size.width*0.14, fontColor: .white,
                                     withShadow: .black)!
        nameDragon.name = "nameDragon"
        nameDragon.position = CGPoint(x: bgInfoDragon.frame.width * 0.15 , y: -bgInfoDragon.frame.size.height*0.55)
        bgInfoDragon.addChild(nameDragon)
        
        /// Type Dragons text
        let typeDragon = SKLabelNode(fontNamed: "Cartwheel",
                                     andText: "Common",
                                     andSize: bgInfoDragon.frame.size.width*0.1, fontColor: .green,
                                     withShadow: .black)!
        typeDragon.name = "typeDragon"
        typeDragon.position = CGPoint(x: bgInfoDragon.frame.width * 0.15, y: -bgInfoDragon.frame.size.height*0.75)
        bgInfoDragon.addChild(typeDragon)
        
        /// Text level charser
        let levelCharser = SKLabelNode(fontNamed: "Cartwheel",
                                       andText: "LVL 5 CHARSER",
                                       andSize: bgInfoDragon.frame.size.width*0.1, fontColor: .white,
                                       withShadow: .black)!
        levelCharser.name = "typeDragon"
        levelCharser.position = CGPoint(x: bgInfoDragon.frame.width * 0.30, y: -bgInfoDragon.frame.size.height*0.85)
        bgInfoDragon.addChild(levelCharser)
        
        /// Background bar progress
        let bgProgress = SKSpriteNode(imageNamed: "barProgress")
        bgProgress.size = CGSize(width: bgInfoDragon.frame.size.width*0.9, height: bgInfoDragon.frame.size.width*0.15)
        bgProgress.name = "bgProgress"
        bgProgress.position = CGPoint(x:  bgInfoDragon.frame.width*0.85/2, y: -bgInfoDragon.frame.size.height)
        bgInfoDragon.addChild(bgProgress)
        
        /// Bar progress
        let barProgress = SKSpriteNode(imageNamed: "progress")
        barProgress.anchorPoint = CGPoint(x: 0, y: 0.5)
        barProgress.size = CGSize(width: bgProgress.size.width*0.8, height: bgProgress.size.height*0.8)
        barProgress.name = "progress"
        barProgress.position.x = -bgProgress.size.width*0.48
        barProgress.run(.resize(toWidth: bgProgress.size.width*0.96, duration: 1))
        bgProgress.addChild(barProgress)
        
        // Text percent center barProgress
        let textPercent = SKLabelNode(fontNamed: "Cartwheel",
                                      andText: "23%",
                                      andSize: bgProgress.frame.size.width*0.1, fontColor: .white,
                                      withShadow: .black)!
        textPercent.name = "txtPercent"
        bgProgress.addChild(textPercent)
        
        return bg
        
    }
    
    //MARK: SHOW VIEW PANEL DRAGON CIRCLE SELECTED
    private func showPanelDragonCircle(node_:SKNode?) {
        
        let arrayNameIconExtra = [(text:"EQUIP\nLEFT",value:ActionButton.btnLeft),
                                  (text:"EQUIP\nRIGHT",value:ActionButton.btnRight),
                                  (text:"SELL",value:ActionButton.btnInfoDragonSell),
                                  (text:"FEED",value:ActionButton.btnFeed)]
        
        
        guard let node_ = node_ as? SKSpriteNode else { return}
        
        let node:SKNode = SKNode()
        node.name = ActionButton.CancelInfoDragon.getNameView
        
        
        let bg = headerPanel(node: node_, actionButton: .CancelInfoDragon)
        
        
        /// View DMG
        let dmg = SKSpriteNode(imageNamed: "bgDragonsIcons")
        dmg.size = CGSize(width: bg.size.width*0.6, height: bg.size.height*0.1)
        dmg.name = "dmgView"
        dmg.position =  CGPoint(x: -dmg.size.width*0.3,y:dmg.size.height/2)
        
        let iconNature = SKSpriteNode(imageNamed: "Green_Weakness")
        iconNature.size = CGSize(width: dmg.size.height*0.8, height: dmg.size.height*0.8)
        iconNature.position.x = -dmg.size.width*0.35
        dmg.addChild(iconNature)
        
        // Text level DMG
        let text1DMG = SKLabelNode(fontNamed: "Cartwheel",
                                   andText: "14",
                                   andSize: dmg.frame.size.width*0.1, fontColor: .yellow,
                                   withShadow: .black)!
        text1DMG.name = "txt1DMG"
        text1DMG.numberOfLines = 0
        text1DMG.position = CGPoint(x: -dmg.size.width * 0.10, y:  0)
        dmg.addChild(text1DMG)
        
        // Text percent center barProgress
        let textDMG = SKLabelNode(fontNamed: "Cartwheel",
                                  andText: "DMG",
                                  andSize: dmg.frame.size.width*0.07, fontColor: .brown,
                                  withShadow: .clear)!
        
        textDMG.name = "DMGtxt"
        textDMG.numberOfLines = 0
        textDMG.position = CGPoint(x: -dmg.size.width * 0.10, y:  -dmg.size.height*0.35)
        dmg.addChild(textDMG)
        
        
        /// Icon arrow brown
        let iconArrow = SKSpriteNode(imageNamed: "arrow")
        iconArrow.size = CGSize(width: dmg.size.height*0.6, height: dmg.size.height*0.6)
        iconArrow.position.x = dmg.size.width*0.15
        dmg.addChild(iconArrow)
        
        // Text two level DMG
        let text2DMG = SKLabelNode(fontNamed: "Cartwheel",
                                   andText: "19",
                                   andSize: dmg.frame.size.width*0.1, fontColor: .yellow,
                                   withShadow: .black)!
        text2DMG.name = "txt2DMG"
        text2DMG.numberOfLines = 0
        text2DMG.position = CGPoint(x: dmg.size.width * 0.35, y:  0)
        dmg.addChild(text2DMG)
        
        let copyTextDMG  = textDMG.copy() as! SKLabelNode
        copyTextDMG.position = CGPoint(x: dmg.size.width * 0.35, y:  -dmg.size.height*0.35)
        dmg.addChild(copyTextDMG)
        
        bg.addChild(dmg)
        
        /// View   Horoscope
        let horoscopeView = SKSpriteNode(imageNamed: "bgDragonsIcons")
        horoscopeView.size = CGSize(width: bg.size.width*0.3, height: bg.size.height*0.1)
        horoscopeView.name = "horoscopeView"
        horoscopeView.position = CGPoint(x: horoscopeView.size.width,y:horoscopeView.size.height/2)
        bg.addChild(horoscopeView)
        
        /// Icon horoscope
        let iconHoroscope = SKSpriteNode(imageNamed: "pisces")
        iconHoroscope.size = CGSize(width: horoscopeView.size.height * 0.6, height: horoscopeView.size.height*0.7)
        iconHoroscope.position.x = -horoscopeView.size.width*0.3
        horoscopeView.addChild(iconHoroscope)
        
        /// counter page view horoscope
        let counter = SKLabelNode(fontNamed: "Cartwheel",
                                  andText: "1/3",
                                  andSize: horoscopeView.frame.size.height/2, fontColor: .brown,
                                  withShadow: .darkGray)!
        counter.name = "counterTxt"
        counter.numberOfLines = 0
        counter.position = CGPoint(x: horoscopeView.size.width * 0.25, y: 0)
        horoscopeView.addChild(counter)
        
        /// Text skills
        let txtSkills = SKLabelNode(fontNamed: "Cartwheel",
                                    andText: "SKILLS",
                                    andSize: bg.size.width * 0.05,fontColor: .brown,
                                    withShadow: .white)!
        txtSkills.name = "txtSkills"
        txtSkills.numberOfLines = 0
        txtSkills.position = CGPoint(x: 0, y: -bg.size.height*0.04)
        bg.addChild(txtSkills)
        
        /// View   Skills
        let skillsView = SKSpriteNode(imageNamed: "bgDragonsIcons")
        skillsView.size = CGSize(width: bg.size.width*0.95, height: bg.size.height*0.2)
        skillsView.name = "skillsView"
        skillsView.position = CGPoint(x: 0,y:-bg.size.height*0.17)
        bg.addChild(skillsView)
        
        /// Icons skills
        for x in 0...4 {
            let skills = SKSpriteNode(imageNamed: "sidekick_skills1_\(x)")
            skills.name = "sidekick_skills1_0"
            skills.size = CGSize(width: (bg.size.width/5)*0.9, height: (bg.size.width/5)*0.9)
            skills.position = CGPoint(x: -bg.size.width*0.35 + CGFloat(x) * skills.size.width, y: 0)
            skillsView.addChild(skills)
        }
        
        /// Icons  actions extra
        for x in 0...3 {
            let iconsExtra = SKSpriteNode(imageNamed: "BulletButton")
            iconsExtra.name = "iconExtra_\(x)"
            iconsExtra.size = CGSize(width: (bg.size.width/5)*0.6, height: (bg.size.width/5)*0.6)
            iconsExtra.position = CGPoint(x: -bg.size.width*0.35 + CGFloat(x) * iconsExtra.size.width*2, y: -bg.size.height*0.34)
            
            let icon = SKSpriteNode(imageNamed: iconsExtra.name!)
            icon.name = arrayNameIconExtra[x].value.rawValue
            icon.size = CGSize(width: iconsExtra.size.width/2, height: iconsExtra.size.width/2)
            iconsExtra.addChild(icon)
            
            let actionIconExtra = SKLabelNode(fontNamed: "Cartwheel",
                                              andText: arrayNameIconExtra[x].text,
                                              andSize: bg.size.width * 0.04,fontColor: .white,
                                              withShadow: .black)!
            
            actionIconExtra.name = arrayNameIconExtra[x].text
            actionIconExtra.numberOfLines = 0
            actionIconExtra.position.y = -icon.frame.size.height*1.6
            iconsExtra.addChild(actionIconExtra)
            
            bg.addChild(iconsExtra)
        }
        
        node.addChild(bg)
        self.addChild(node)
    }
    
    //MARK: SHOW VIEW BUY T  ITEM
    private func viewBuyGem<T:ProtocolTableViewGenericCell>(item:[T]){
        
        if  let node =  self.childNode(withName: "viewSellFruit")  {
            node.run(.move(by: CGVector(dx: screenSize.width, dy: 0), duration: 0.1))
        } else if let view = scene?.view?.subviews.last {
            UIView.animate(withDuration: 0.1) {
                view.transform = CGAffineTransform(translationX: screenSize.width, y: 0)
            }
        }
        

        let sknode = SKNode()
            sknode.name = "viewBuyGem"
        
        let bgPanel = SKSpriteNode(imageNamed: "bgSettings")
            bgPanel.position  = CGPoint(x: screenSize.midX, y: screenSize.midY)
            bgPanel.size  = CGSize(width: screenSize.width*0.8, height: screenSize.height*0.7)
       
        let btnCancel = SKSpriteNode(imageNamed: "CancelButton")
            btnCancel.name = ActionButton.btnCancelBuyGem.rawValue
            btnCancel.size = CGSize(width: bgPanel.size.width*0.1, height: bgPanel.size.width*0.1)
            btnCancel.position = CGPoint(x: bgPanel.size.width/2, y: bgPanel.size.height/2)
            bgPanel.addChild(btnCancel)
        
        
        genericTableView(items: item)
       
    }
    
    // Show view Sell from view showPanelDragonCircle
    private func SellFromPanelDragonCircle() {
        
        if let nodeChild = childNode(withName: "viewInfoDragon")  {
            
            let nodeView = SKNode()
            nodeView.name = ActionButton.CancelFruitSell.getNameView
            
            guard let dragonNode =  nodeChild.children.map({ $0.childNode(withName: "dragonNode")}).first as? SKSpriteNode  else { return}
            
            backgroundBlack(withSpinnerActive: true)

            let bg = headerPanel(node: dragonNode,actionButton: .CancelFruitSell)
           
            let shape = SKShapeNode(rect: CGRect(x: -bg.size.width*0.45,
                                                 y: -bg.size.height*0.25,
                                                        width: bg.size.width*0.9,
                                                        height: bg.size.height*0.4),
                                            cornerRadius: bg.size.width*0.03)
            shape.fillColor = UIColor(red: 239 / 255, green: 204/255, blue: 151/255, alpha: 0.5)
            shape.strokeColor = .darkGray
            shape.strokeShader = SKShader(fileNamed: "monogradient")
            bg.addChild(shape)
            
            let txtSellName = SKLabelNode(fontNamed: "Cartwheel", andText: "Sell Ilco?",
                                          andSize: bg.size.width * 0.1,fontColor: .white,
                                          withShadow: .black,name: "txtSellName")!
            
            txtSellName.name = "txtSellName"
            txtSellName.position.y = bg.frame.size.height * 0.1
            shape.addChild(txtSellName)
            
            let bgUnitFruit = SKSpriteNode(imageNamed: "counter")
                bgUnitFruit.name = "counter"
                bgUnitFruit.size = CGSize(width: shape.frame.width*0.5, height: shape.frame.width*0.15)
                bg.addChild(bgUnitFruit)
            
            let textCounter = SKLabelNode(fontNamed: "Cartwheel", andText: "+ 1",
                                          andSize: bgUnitFruit.size.width * 0.2,fontColor: .yellow,
                                          withShadow: .white,name: "txtCounterShadow")!
            textCounter.name = "txtCounter"
            bgUnitFruit.addChild(textCounter)
            
            let fruit = SKSpriteNode(imageNamed: "fruit")
                fruit.name =  "sellFruitIcon"
                fruit.size = CGSize(width: bgUnitFruit.frame.height*0.7, height: bgUnitFruit.frame.height*0.7)
                fruit.position.x = bgUnitFruit.size.width*0.3
                bgUnitFruit.addChild(fruit)
            
            
            let txtUndone = SKLabelNode(fontNamed: "Arial", andText: "(This cannot be undone)",
                                        andSize: bg.size.width * 0.05, fontColor: .brown,withShadow: .black)!
            
            txtUndone.name = "txtBeUndone"
            txtUndone.position = CGPoint(x: shape.frame.midX, y: -bg.size.height * 0.1)
            shape.addChild(txtUndone)
            
            
            let button =   createUIButton(bname: ActionButton.btnSellFruit.rawValue, offsetPosX: shape.frame.midX, offsetPosY: -bg.frame.height*0.2, typeButtom: .GreenButton)
            
            bg.addChild(button)
            
            let txtSell =  SKLabelNode(fontNamed: "Cartwheel", andText: "SELL",
                                       andSize: bg.frame.width * 0.07, fontColor: .white,withShadow: .black)!
            txtSell.name = ActionButton.txtSellFruit.rawValue
            button.addChild(txtSell)
            
            let iconbag = SKSpriteNode(imageNamed: "iconExtra_2")
            
            iconbag.size = CGSize(width: button.frame.width*0.4, height: button.frame.height)
            iconbag.position = CGPoint(x: button.frame.maxX,y: 0)
            button.addChild(iconbag)
            
            
            let bagFruit = SKSpriteNode(imageNamed: "bagFruit")
            bagFruit.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            bagFruit.name = "bagFruit"
            bagFruit.size = CGSize(width: bg.size.width*0.2, height: bg.size.width*0.2)
            bagFruit.position = CGPoint(x: -bg.size.width*0.3, y: -bg.size.height*0.37)
            
            let sun = raySunRotating(point: CGPoint(x: 0, y: 0),size: CGSize(width: bagFruit.size.width*2, height:  bagFruit.size.width*2))
            sun.zPosition = -1
            sun.blendMode = .add
            bagFruit.addChild(sun)
            bg.addChild(bagFruit)
            
            let txtMoreDragonFruit =  SKLabelNode(fontNamed: "Cartwheel", andText: "GET MORE\nDRAGON FRUIT",
                                                  andSize: bg.frame.size.width*0.05, fontColor: .yellow,withShadow: .black)!
            txtMoreDragonFruit.position = CGPoint(x: bg.frame.width*0.1, y: -bg.size.height*0.3)
            bg.addChild(txtMoreDragonFruit)
            
            let bgCounterMoreFruit = SKSpriteNode(imageNamed: "counter")
            bgCounterMoreFruit.name = "bgCounterMoreFruit"
            bgCounterMoreFruit.size = CGSize(width: bg.size.width*0.3, height:  bg.size.width*0.3/3)
            bgCounterMoreFruit.position = CGPoint(x: bgCounterMoreFruit.size.width/2, y: -bg.size.height*0.4)
            bg.addChild(bgCounterMoreFruit)
            
            let btnAdd = SKSpriteNode(imageNamed: "btnAdd")
            btnAdd.name = ActionButton.btnBuyAddFuit.rawValue
            btnAdd.size = CGSize(width: bgCounterMoreFruit.size.height, height:  bgCounterMoreFruit.size.height)
            btnAdd.position = CGPoint(x: bgCounterMoreFruit.size.width/2-btnAdd.size.width/2, y: 0)
            bgCounterMoreFruit.addChild(btnAdd)
            
            nodeView.addChild(bg)
            
            addChild(nodeView)
        }
        
    }
    
    //MARK: MAKE ANIMATION WHEN SELL DRAGON ANIMATE FRUITE TO SCORE
    private func AnimationSellDragonGetFruit() {
        
        guard let view = childNode(withName: ActionButton.CancelFruitSell.getNameView) ,
              let panelInfo = view.childNode(withName: "panelInfo"),
              let counter = panelInfo.childNode(withName: "counter"),
              let btnSell = panelInfo.childNode(withName: ActionButton.btnSellFruit.rawValue) as? SKSpriteNode,
              let scene = scene else { return  }
     
        scene.isUserInteractionEnabled = false

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

                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        scene.isUserInteractionEnabled = true
                    }
                },
                ]))
        
             counter.addChild(smallFruit)
    }
    
    // Ask if player has coin for object buy
    private func hasCoinForBuy<T:ProtocolTableViewGenericCell>(item:T)->Bool {
        
        do {
            guard let result = try ManagedDB.shared.context.fetch(Score.fetchRequest()).first else { return false }
            switch item.icon {
                case .Coin:
                    return result.coin > item.amount
                case .Gem:
                    return result.gem > item.amount
                default :
                    return false
            }
        }catch {
             return false
        }
          
    }
    
    //MARK: SHOW GENERIC VIEW FOR TYPE OBJECT TO BUY
    private func  showGenericViewBuyItem<T:ProtocolTableViewGenericCell>(items:T) {
        
        showViewBuyAdittionalItem(items: items)
    }
    
    //MARK: SHOW TABLEVIEW WHEN PLAYER DON`T HAVE COIN OR GEM FOR BUY
    private func showViewBuyAdittionalItem<T:ProtocolTableViewGenericCell>(items:T) {
    
        let node = SKNode()
            node.name = ActionButton.btnCancelBuyGem.getNameView
            node.position = CGPoint(x: screenSize.midX, y: screenSize.midY)
            
            let bg =  SKSpriteNode(imageNamed: "bgSettings")
                bg.name = "bgSettingsBuyItem"
                bg.size = CGSize(width: screenSize.width*0.8, height: screenSize.height*0.7)
            node.addChild(bg)

            let iconCancel =  SKSpriteNode(imageNamed: "CancelButton")
            iconCancel.name = ActionButton.btnCancelBuyGem.rawValue
            iconCancel.size = CGSize(width: bg.frame.width*0.1, height: bg.frame.width*0.1)
            iconCancel.position = CGPoint(x: bg.frame.width/2 + iconCancel.size.width/4, y: bg.frame.height/2 + iconCancel.size.width/4)
            bg.addChild(iconCancel)
            
            
            let titleHeader = items.name + " " + items.title
            let title = SKLabelNode(fontNamed: "Cartwheel", andText: titleHeader, andSize: bg.size.width*0.07, fontColor: .white, withShadow: .black)!
            title.position = CGPoint(x: 0, y: bg.size.height*0.43)
            bg.addChild(title)
            
            
            let sun = raySunRotating(point: CGPoint(x: 0, y: bg.size.height*0.25),size: CGSize(width: bg.size.width*0.7, height:bg.size.width*0.7))
            
            let image =  SKSpriteNode(imageNamed: items.picture.rawValue)
            image.size = CGSize(width: bg.frame.width*0.2, height: bg.frame.width*0.25)
            image.position = .zero
            sun.addChild(image)
            bg.addChild(sun)

            
            if  T.self is BuyEggs.Type {
                bg.addChild(rectDragonRarityChange(item: items, bg: bg))
            } else {
                let value = "Buy \(String(items.amount).convertDecimal()) Dragonfruits?"
                let text = SKLabelNode(fontNamed: "Cartwheel", andText: value, andSize: bg.size.width*0.06, fontColor: .brown, withShadow: .black)!
                text.position.y = -bg.size.height * 0.25
                    bg.addChild(text)
            }
            
            let typeItem = SKLabelNode(fontNamed: "Cartwheel", andText: String(items.icon.rawValue+"s"), andSize: bg.size.width*0.05, fontColor: .brown, withShadow: .black)!
                typeItem.position = CGPoint(x: 0, y: -bg.size.height*0.33)
            bg.addChild(typeItem)

            let amount = T.self is BuyEggs.Type ? items.amount : items.gemAmount
           
            let button =  createUIButton(bname: "btnBuyCoin", offsetPosX: 0, offsetPosY: -bg.size.height*0.4,typeButtom: .BlueButton, size:CGSize(width: bg.size.width*0.4, height: bg.size.width/6))
            button.userData = ["hasCoin":hasCoinForBuy(item: items),"typeCoin": items.icon,"amount":items.amount]
        
            
            let label = SKLabelNode(fontNamed: "Cartwheel", andText: String(amount!).convertDecimal(), andSize: button.size.height*0.5, fontColor: .white, withShadow: .black)!
            button.addChild(label)
           
            let iconTypePay =  SKSpriteNode(imageNamed: items.icon.rawValue.lowercased())
                iconTypePay.size = CGSize(width: button.size.height*0.5, height: button.size.height*0.5)
                iconTypePay.position = CGPoint(x: button.size.width*0.3, y: 0)
                button.addChild(iconTypePay)
            bg.addChild(button)

        
            addChild(node)
    }
    
    private func rectDragonRarityChange<T:ProtocolTableViewGenericCell>(item:T,bg:SKSpriteNode) -> SKNode {
        
        let infoEggs:[Icons:[(String,String)]] = [
            .Common:[("Common","100%")],
            .Bronze:[("Common","85%"),("Rare","13%"),("Epic","2%")],
            .Silver:[("Rare","82%"),("Epic","12%"),("Legendary","6%")],
            .Golden:[("Rare","70%"),("Epic","18%"),("Legendary","11%"),("Mythic","1%")],
            .Magical:[("Rare","53%"),("Epic","25%"),("Legendary","18%"),("Mythic","4%")],
            .Ancient:[("Legendary","86%"),("Mythic","14%")]
        ]
        
         let bgGray = { (row:Int) ->SKShapeNode in
            
            let width = bg.frame.width*0.85
            let height = bg.frame.width*0.1 * CGFloat(row)
            let shape = SKShapeNode(rect: CGRect(x: -width/2, y: -height + bg.frame.width*0.1/2 , width: width, height: height), cornerRadius: width*0.02)
             shape.fillColor =  UIColor(red: 235/255, green: 216/255, blue: 156/255, alpha: 0.7)
             shape.strokeColor = UIColor(red: 135/255, green: 128/255, blue: 107/255, alpha: 0.7)
            return shape
        }
        
        let node = SKNode()
        
        let titleHeader = "Dragon Rarity\t\tChance"
        let title = SKLabelNode(fontNamed: "Cartwheel", andText: titleHeader, andSize: bg.size.width*0.07, fontColor: .white, withShadow: .black)!
        title.position = CGPoint(x: 0, y: bg.size.width*0.1)
        node.addChild(title)
        
        let _ = infoEggs[item.picture].map { obj in
            
            node.addChild(bgGray(obj.count))
            
            let _ = obj.enumerated().map { (index,item) in
                
                let positionY = title.position.y - CGFloat(CGFloat(index+1) * bg.size.width*0.1)
                let color = UIColor().randomColor()
                
                let type = SKLabelNode(fontNamed: "Cartwheel", andText: item.0, andSize: bg.size.width*0.07, fontColor: color, withShadow: .black)!
                type.position = CGPoint(x: -bg.size.width/4, y: positionY)

                let percent = SKLabelNode(fontNamed: "Cartwheel", andText: item.1, andSize: bg.size.width*0.07,fontColor: color, withShadow: .black)!
                percent.position = CGPoint(x: bg.size.width/4, y: positionY)

                node.addChild(type)
                node.addChild(percent)
            }
        }
        
        return node
    }
    
    private func genericTableView<T:ProtocolTableViewGenericCell>(items:[T])  {
        
        guard let scene = scene else { return }
    
        scene.backgroundBlack(withSpinnerActive: false)
        
        do {
            switch [T].Element {
                case  is BuyFruit.Type:
                    try showGenericViewTable(items: T.items,title: "GET DRAGONFRUIT")
                case  is BuyEggs.Type:
                    try showGenericViewTable(items: T.items,title: "BUY COINS")
                case is BuyCoins.Type:
                    try showGenericViewTable(items: T.items,title: "BUY GEM")
                case is BuyGem.Type:
                    try showGenericViewTable(items: T.items,title: "BUY GEM")
                default: break
            }
        } catch let error {
            print("Error  generic Table \(error.localizedDescription)")
        }
    }
}


