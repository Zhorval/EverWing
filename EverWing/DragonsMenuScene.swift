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
   case btnRight           = "btnRight"
   case btnLeft            = "btnLeft"
   case btnMainToSell      = "btnMainToSell"
   case btnFeed            = "btnFeed"
  
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
       case .btnRight:              return "viewBuyGem"
       case .btnLeft:               return "viewBuyGem"
       case .btnMainToSell:         return "viewBuyGem"
       case .btnFeed:               return "viewBuyGem"
      
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
    private func createViewForCollection(frame:CGRect,typeGrid:TypeGridCollection,hasCancelBtn:Bool) -> UIView {
        
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
                case .sell:  select(dragon)
            }
         }
           handlerTapAudio: { [self] in
                run(gameinfo.mainAudio.getAction(type: .ChangeOption))
        }
    }
    
    @objc private func tapCircleDragon(_ sender:UIButton) {

        if let nameImage = sender.restorationIdentifier {
                
            guard let dragon =  Dragons.items.filter({ $0.picture.name == nameImage }).first else { return }
        
            showPanelDragonCircle(item: dragon)        }
    }
    
    // Search for purchased dragons in the database
    private func SearchDragonBuyInDB() -> Bool{
        
        let managed = ManagedDB.shared.context
        
        do {
            let fetch = try managed.fetch(DragonsBuyDB.fetchRequest())
            
            Dragons.items = fetch.map { Dragons(name: $0.name!, picture: Dragons.dragons(name:  $0.picture!))}
            
            
            return Dragons.items.count > 0
            
        }catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: SHOW MAIN PAGE SCREEN
    private func showMainPage() {
    
        let width =  min(screenSize.width,screenSize.height) > 500 ? 600 : min(screenSize.width,screenSize.height)
        let frame = CGRect(x: 0, y: 0, width: width, height: width)
        
        let mainView = createViewForCollection(frame:frame, typeGrid: .main, hasCancelBtn: false)

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
            
            let view = self.createViewForCollection(frame: rect, typeGrid: .sell, hasCancelBtn: true)
            
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
            title.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height*0.05).isActive = true
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            
            let getPercent = Double(300)/Double(Dragons.items.count)
            let totalWidth = (view.frame.width*0.8)*getPercent
            
            let barProgress = UIImageView()
            barProgress.image = UIImage(named: "barProgress")
            barProgress.contentMode = .scaleAspectFill

            view.addSubview(barProgress)
            
            barProgress.translatesAutoresizingMaskIntoConstraints = false
            barProgress.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            barProgress.topAnchor.constraint(equalTo: title.bottomAnchor,constant: 20).isActive = true
            barProgress.widthAnchor.constraint(equalToConstant: view.frame.width*0.8).isActive = true
            let height_ = barProgress.heightAnchor.constraint(equalToConstant: (view.frame.width*0.8)/5)
            height_.isActive = true
            
            let progress = UIView(frame: .zero)
            progress.layer.cornerRadius = height_.constant/2
            progress.backgroundColor = UIColor(red: 179/255, green: 71/255, blue: 154/255, alpha: 1)
            barProgress.addSubview(progress)
        
            progress.translatesAutoresizingMaskIntoConstraints = false
            progress.heightAnchor.constraint(equalTo:barProgress.heightAnchor,constant: -10).isActive = true
            progress.leadingAnchor.constraint(equalTo: barProgress.leadingAnchor, constant: 5).isActive = true
            progress.centerYAnchor.constraint(equalTo: barProgress.centerYAnchor, constant: 0).isActive = true
            let contrait = progress.widthAnchor.constraint(equalToConstant: 10)

            NSLayoutConstraint.activate([contrait,height_])
            
            UIView.animate(withDuration: 0.3) {
                contrait.constant = totalWidth
                progress.layoutIfNeeded()
            }
            
            let textProgress = UILabel()
                textProgress.textColor = .white
            textProgress.font =  UIFont.systemFont(ofSize: height_.constant/4, weight: .bold)
            textProgress.text = "COLLECTED \(ManagedDB.getDragonBuy())/\(Dragons.items.count)"
            
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
    private func SellMainPage() {
        
       let width = screenSize.width*0.9
       let height = screenSize.height*0.8
       let marginX = (screenSize.width-width)/2
       let marginY = (screenSize.height-height)/2
    
       var dragonSelected:[Dragons] = []
        
       let rect = CGRect(x: marginX, y: marginY, width: width, height: height)
       
       var btnSell:UIButton =  UIButton()
        
       var textCount:UILabel?
        
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
        
        removeUIViews()

        let view = createViewForCollection(frame: rect, typeGrid: .sell, hasCancelBtn: true)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: (scene?.view!.leadingAnchor)!,constant: marginX).isActive = true
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.topAnchor.constraint(equalTo: (scene?.view!.topAnchor)!,constant: marginY).isActive = true
        
        let gradient = UIImage.gradientImage(bounds: view.bounds, colors: [.orange, .yellow])

        let title = UILabel()
            .addFontAndText(font: "Cartwheel", text: "BULK SELL", size: view.frame.width*0.1)
            .shadowText(colorText: UIColor(patternImage: gradient), colorShadow: .black,aligment: .center)
        view.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height*0.05).isActive = true
        
        let subtitle = UILabel()
            .addFontAndText(font: "Cartwheel", text: "CHOOSE DRAGONS TO SELL", size: view.frame.width*0.08)
            .shadowText(colorText: .brown, colorShadow: .black, aligment: .center)
        view.addSubview(subtitle)
        
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitle.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height*0.1).isActive = true
        
        
        let collection = ManagedCollectionInView(view: view,type: .sell) { dragon in
            textSeleted +=  dragon.hasValue()
            dragonSelected.append(dragon)
            
        } deSelect: { dragon in
            textSeleted -= dragon.hasValue()
            guard let index = dragonSelected.firstIndex(where: {$0.name == dragon.name}) else { return }
            dragonSelected.remove(at: index)
        }
        
        view.addSubview(collection)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collection.topAnchor.constraint(equalTo: subtitle.bottomAnchor,constant: 20).isActive = true
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

       
        let txtUndone = UILabel(frame: CGRect(x: 0, y:  view.frame.height*0.7, width: view.frame.width,height: height*0.1))
            .addTextWithFont(font: UIFont.systemFont(ofSize: view.frame.width*0.03, weight: .bold),text: "(This cannot be undone)",color: .brown)
            view.addSubview(txtUndone)
        
        let bagFruit = UIImageView(frame: CGRect(x: view.frame.width*0.1, y: view.frame.height*0.75,width: view.frame.width/4, height: view.frame.width/4))
            bagFruit.image = UIImage(named: "bagFruit")
        view.addSubview(bagFruit)
      
        
        let getMoreFruit = UILabel(frame: CGRect(x: width*0.1, y:  view.frame.height*0.72, width: view.frame.width,height: height*0.2))
            .addTextWithFont(font: UIFont.systemFont(ofSize: view.frame.width*0.05, weight: .bold), text: "GET MORE\nDRAGONFRUIT",color: .brown)
            .shadowText(colorText: UIColor(patternImage: gradient), colorShadow: .black,aligment: .center)
            view.addSubview(getMoreFruit)
        
        
        let contadorMoreFruit = UIImageView(frame: CGRect(x: width*0.5, y: view.frame.height*0.87,
                                                          width: view.frame.width*0.4,
                                                          height: view.frame.width*0.1))
            contadorMoreFruit.image = UIImage(named: "counter")
            contadorMoreFruit.isUserInteractionEnabled = true
            
        let totalFruit = UILabel()
                .addFontAndText(font: "Cartwheel", text: "\(ManagedDB.getFruitTotal())"
                .convertDecimal(), size: contador.frame.width*0.2)
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
             
            case .Sell:                                 SellMainPage()
            
            case .Index:                                showIndexPageBook()
                
            case .btnLeft,.btnRight:break
           
            case .btnFeed:break
                
            case .btnMainToSell,.btnCancelBuyGem,
                 .CancelFruitSell,.CancelInfoDragon:
                                                            removeBackgroundBlack(removeBlur: blurNode)
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
        
        guard let strTotal = sender.restorationIdentifier?.components(separatedBy: " ").last,
              let total = Int(strTotal) else { return }
        
        run(gameinfo.mainAudio.getAction(type: .ChangeOption))
        
        createAnimationFruitSell(typeObject: Icons.fruit) {  _  in
            if ManagedDB.addFruitTotal(addFruit: total) {
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
        
        
        let view = createViewForCollection(frame: rect, typeGrid: .index, hasCancelBtn: true)
        
        let dragonIcon = UIImageView(image: UIImage(named: dragon.picture.name)!)
        view.addSubview(dragonIcon)
        dragonIcon.translatesAutoresizingMaskIntoConstraints = false
        dragonIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dragonIcon.widthAnchor.constraint(equalToConstant: view.frame.width*0.5).isActive = true
        dragonIcon.heightAnchor.constraint(equalToConstant: view.frame.width*0.5).isActive = true
        dragonIcon.topAnchor.constraint(equalTo: view.topAnchor,constant: 10).isActive = true
        
        ManagedDB.shared.isBuyDragon(name: dragon.picture.name) { exist in
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
        
        
        let number = dragon.picture.name.getNumberStarName()
        for x in 0...2 {
            let image = x <= number ? "starB" : "startGray"
            let star = UIImageView(image: UIImage(named: image))
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
        shape.layer.cornerRadius = view.frame.width * 0.05
        shape.layer.backgroundColor = UIColor.orange.withLuminosity(0.5).cgColor
        shape.backgroundColor = .brown
        view.addSubview(shape)
       
        shape.translatesAutoresizingMaskIntoConstraints = false
        shape.topAnchor.constraint(equalTo: dragonIcon.bottomAnchor,constant: 70).isActive = true
        shape.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shape.widthAnchor.constraint(equalToConstant: view.frame.width*0.9).isActive = true
        shape.heightAnchor.constraint(equalToConstant: view.frame.height*0.4).isActive = true
        
        let name = UILabel()
            .addTextWithFont(font: .systemFont(ofSize: sizeFont, weight: .bold), text: "Name:", color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        
        shape.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.leadingAnchor.constraint(equalTo: shape.leadingAnchor,constant: 20).isActive = true
        name.topAnchor.constraint(equalTo: shape.topAnchor,constant: 10).isActive = true
        
        let valueName = UILabel()
            .addTextWithFont(font: .systemFont(ofSize: sizeFont, weight: .bold), text: dragon.picture.name, color: .white)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)

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
            .addTextWithFont(font: .systemFont(ofSize: sizeFont, weight: .bold), text: "Common", color: .white)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)

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
            .addTextWithFont(font: .systemFont(ofSize: sizeFont, weight: .bold), text: "Permanent", color: .white)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
        
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
            .addTextWithFont(font: .systemFont(ofSize: sizeFont, weight: .bold), text: "Chaser", color: .white)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)

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
        
                
        for x in 0...3{
            
            let valueSkills = UIImageView(image: UIImage(named: "sidekick_skills1_0")!)
            shape.addSubview(valueSkills)
            
            let width = view.frame.width/6
            let marginX = width  - (CGFloat(x+1) * width)
            
            valueSkills.translatesAutoresizingMaskIntoConstraints = false
            valueSkills.heightAnchor.constraint(equalToConstant: width).isActive = true
            valueSkills.widthAnchor.constraint(equalToConstant: width).isActive = true
            valueSkills.topAnchor.constraint(equalTo: class_.bottomAnchor,constant: 10).isActive = true
            valueSkills.trailingAnchor.constraint(equalTo: shape.trailingAnchor,constant: marginX).isActive = true
        }
        
        let txtDiscover = UILabel()
            .addTextWithFont(font: .systemFont(ofSize: 20, weight: .bold), text: "Discover", color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)

        txtDiscover.numberOfLines = 0
        view.addSubview(txtDiscover)
        txtDiscover.translatesAutoresizingMaskIntoConstraints = false
        txtDiscover.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        txtDiscover.centerYAnchor.constraint(equalTo: view.bottomAnchor,constant: -view.frame.height*0.07).isActive = true
  
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
                if number  > 0 {  return Dragons.items.filter { $0.picture.name == "\(name)_T\(number)_icon"}.first }
                
                case .Right:
                    number += 1
                  if number  < 4 {  return Dragons.items.filter { $0.picture.name == "\(name)_T\(number)_icon"}.first }
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
            
            if index > 10 {
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
        
        imageView.frame = CGRect(x: x, y: y, width: 50, height: 50)
        imageView.contentMode = .scaleAspectFit
        let position = CGPoint(x: screenSize.minX, y: screenSize.minY)

        UIView.animate(withDuration: 0.2) {
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
    
    private func headerPanel(item:Dragons,actionButton:ActionButton)  -> SKSpriteNode{
       
        
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
        let imgDragon = SKSpriteNode(texture:SKTexture(imageNamed: item.picture.name))
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
        let nameDragon = SKLabelNode(fontNamed: "Cartwheel",
                                     andText: item.name,
                                     andSize: bgInfoDragon.frame.size.width*0.14, fontColor: .purple,
                                     withShadow: .white)!
        nameDragon.name = "nameDragon"
        nameDragon.horizontalAlignmentMode = .left
        nameDragon.verticalAlignmentMode = .center
        
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
    private func showPanelDragonCircle(item:Dragons) {
        
        if let view = scene?.view?.subviews.filter({$0.tag == 1}).first {
            UIView.animate(withDuration: 0.05, animations:  {
                view.transform = CGAffineTransform(translationX: -screenSize.width, y:0 )
            })
        }
        let arrayNameIconExtra = [(text:"EQUIP\nLEFT",value:ActionButton.btnLeft),
                                  (text:"EQUIP\nRIGHT",value:ActionButton.btnRight),
                                  (text:"SELL",value:ActionButton.btnFeed),
                                  (text:"FEED",value:ActionButton.btnFeed)]
        
        
        let width = screenSize.width*0.9
        let height = screenSize.height*0.8
        let marginX = (screenSize.width-width)/2
        let marginY = (screenSize.height-height)/2
        let rect = CGRect(x: marginX, y: marginY, width: width, height: height)
        
        let view = createViewForCollection(frame: rect, typeGrid: .sell, hasCancelBtn: true)
        self.view?.addSubview(view)
        
        let imgDragon = UIImageView(image: UIImage(named: item.picture.name))
        view.addSubview(imgDragon)
        
        imgDragon.translatesAutoresizingMaskIntoConstraints  = false
        imgDragon.widthAnchor.constraint(equalToConstant: view.frame.height*0.25).isActive = true
        imgDragon.heightAnchor.constraint(equalToConstant: view.frame.height*0.3).isActive = true
        imgDragon.topAnchor.constraint(equalTo: view.topAnchor,constant: 10).isActive = true
        imgDragon.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -view.frame.width/4 ).isActive = true


        let imgHeart = UIImageView(image: UIImage(named: "heartOff"))
        view.addSubview(imgHeart)
        
        imgHeart.translatesAutoresizingMaskIntoConstraints = false
        imgHeart.widthAnchor.constraint(equalToConstant: imgDragon.frame.width/4).isActive = true
        imgHeart.heightAnchor.constraint(equalToConstant: imgDragon.frame.width/4).isActive = true
        imgHeart.bottomAnchor.constraint(equalTo: imgDragon.bottomAnchor).isActive = true
        imgHeart.trailingAnchor.constraint(equalTo: view.centerXAnchor,constant: -10).isActive = true

        let shape = UIView()
        shape.backgroundColor = UIColor(red: 239 / 255, green: 204/255, blue: 151/255, alpha: 0.5)
        shape.layer.cornerRadius = view.frame.width * 0.05
        view.addSubview(shape)
        
        shape.translatesAutoresizingMaskIntoConstraints = false
        shape.topAnchor.constraint(equalTo: imgDragon.topAnchor).isActive = true
        shape.leadingAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shape.widthAnchor.constraint(equalToConstant: view.frame.width*0.45).isActive = true
        shape.heightAnchor.constraint(equalTo: imgDragon.heightAnchor).isActive = true
        

        /// Icons Stars
        for x in 0...2 {
            let star = UIImageView(image: UIImage(named:  "starB")!)
            shape.addSubview(star)
            
            star.translatesAutoresizingMaskIntoConstraints = false
            let constWidth = star.widthAnchor.constraint(equalToConstant: 50)
            star.heightAnchor.constraint(equalTo: star.widthAnchor).isActive = true
            star.topAnchor.constraint(equalTo: shape.topAnchor,constant: 10).isActive = true
            let marginX = Double((view.frame.width/8)  * CGFloat(x + 1))/2
            star.leadingAnchor.constraint(equalTo: shape.leadingAnchor, constant: marginX).isActive = true
        }
        
        let name = UILabel()
            .addFontAndText(font: "Cartwheel", text: item.name, size: 18)
        shape.addSubview(name)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        name.leadingAnchor.constraint(equalTo: shape.leadingAnchor,constant: 10).isActive = true
        name.topAnchor.constraint(equalTo: shape.topAnchor,constant: 50).isActive = true
        
      /*
        let node:SKNode = SKNode()
        node.name = ActionButton.CancelInfoDragon.getNameView
        
        
        let bg = headerPanel(item:item as! Dragons, actionButton: .CancelInfoDragon)
        
       
        /// View DMG
        let dmg = SKSpriteNode(imageNamed: "bgDragonsIcons")
        dmg.size = CGSize(width: bg.size.width*0.6, height: bg.size.height*0.1)
        dmg.name = "dmgView"
        dmg.position =  CGPoint(x: -dmg.size.width*0.3,y:dmg.size.height/2)
        
        let iconNature = SKSpriteNode(imageNamed: "Nature_Weakness")
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
         */
    }
    
    //MARK: SHOW VIEW BUY T  ITEM
    private func viewBuyGem<T:ProtocolTableViewGenericCell>(item:[T]){
        
        
        self.view?.addSubview(createViewForCollection(frame: .zero, typeGrid: .sell, hasCancelBtn: true))
    
        genericTableView(items: item)
       
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



