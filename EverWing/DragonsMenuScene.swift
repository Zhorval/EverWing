//
//  DragonsScene.swift
//  EverWing
//
//  Created by Pablo  on 28/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.


import Foundation
import SpriteKit
import CoreData

enum ActionButton:String,CaseIterable {
  
   case CancelInfoDragon   = "CancelInfoDragon"
   case CancelFruitSell    = "CancelFruitSell"
  
   case btnMainToSell      = "btnMainToSell"
  
   case btnSellFruit       = "btnSellFruit"
   case txtSellFruit       = "txtSellFruit"
   case btnCancelBuyGem    = "btnCancelBuyGem"
   case btnBuyCoin         = "btnBuyCoin"

   
   var getNameView:String {
       switch self {
       
       case .CancelInfoDragon:      return "viewInfoDragon"
       case .CancelFruitSell:       return "viewSellFruit"
     
       case .btnMainToSell:         return "viewBuyGem"
      
       case .btnSellFruit:          return "viewBuyGem"
       case .txtSellFruit:          return "viewBuyGem"
       case .btnCancelBuyGem:       return "viewBuyGem"
       case .btnBuyCoin: return ""
           
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
        view.addSubview(showMainPage())
    }
    
    private func loadBackground() {
        removeUIViews()
        let bg = UIImageView(frame: CGRect(origin: .zero, size: size))
        bg.image =  UIImage(named: "Dragons_Background")
        self.view?.addSubview(bg)
    }
    
    
    
    
    private func ManagedCollectionInView(view:UIView,type:TypeGridCollection,item:Dragons?,select:@escaping(Dragons)->Void,deSelect:@escaping(Dragons)->Void) -> UICollectionView{
        
        do {
            switch type {
                
            case .eggs,.menu: break
            case.evolve:
               
                Dragons.items  = try ManagedDB.findDragonsEvolve(item: item!)
                
            case .main,.sell:
              
                Dragons.items  =  try ManagedDB.shared.getAllDragonsBuy()
                
            case .index:
                Dragons.items  =  try ManagedDB.shared.context.fetch(DragonsDB.fetchRequest()).map { $0.dragons!}
            }
        } catch  {}
        
            return  CustomCollectionViewEggs(frame: view.frame, items: Dragons.items, view: view, typeGridCollection: type) { [self] dragon in
                
                switch type {
                    case .eggs,.menu: break
                    case .main:  showPanelDragonCircle(item: dragon)
                    case .index: DetailDragonSelectCollection(dragon:dragon)
                    case .sell:  select(dragon)
                    case .evolve: CreateEvolveDragons(dragon: dragon)
                }
            }  handlerDeselect: { dragon in
                switch type {
                    case .eggs,.main,.evolve,.index,.menu: break
                    case .sell:  deSelect(dragon)
                }
            }
            handlerTapAudio: { [self] in
                run(gameinfo.mainAudio.getAction(type: .ChangeOption))
            }
    }
 
    
  
    @objc func tapCounter() {
        self.viewBuyGem(item: BuyFruit.items)
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            guard let pos  = nodes(at: touch.location(in: self)).first,
                  let name =  pos.name,
                  let action = ActionButton(rawValue: name) else { return }
            
            run(gameinfo.mainAudio.getAction(type: .ChangeOption))

            switch action {
        
                
            case .btnMainToSell,.btnCancelBuyGem,
                 .CancelFruitSell,.CancelInfoDragon:        removeBackgroundBlack(removeBlur: blurNode)
                                                            let _ = showMainPage()
                
            case .btnSellFruit, .txtSellFruit:         AnimationSellDragonGetFruit()
            
                
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
        
        createAnimationFruitSell(typeObject: Icons.IconsFruit.fruit,numberFruit: total) {  _  in
          
            if ManagedDB.addFruitTotal(addFruit: total,arimethic: arimethic) {
                self.tapButtonCancel(sender:sender)
            }
        }
    }

    
    //MARK: SHOW VIEW DETAILDRAGON WHEN SELECT DRAGON COLLECTIONVIEW INDEX
    private func DetailDragonSelectCollection(dragon:Dragons) {
       
        let view = templateMainGeneric(typeGrid: .index, hasCancelBtn: true)
        let dragonIcon = UIImageView(image: UIImage(named: dragon.picture)!)
        view.addSubview(dragonIcon)
        dragonIcon.translatesAutoresizingMaskIntoConstraints = false
        dragonIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dragonIcon.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        dragonIcon.heightAnchor.constraint(equalTo: dragonIcon.widthAnchor).isActive = true
        dragonIcon.topAnchor.constraint(equalTo: view.topAnchor,constant: 25).isActive = true
        dragonIcon.layoutIfNeeded()
        
        ManagedDB.shared.isBuyDragon(name: dragon.name) { exist in
             if !exist {
                 dragonIcon.image = dragonIcon.image?.maskWithColor(color: .gray)
             }
        }
    
        let arrowL = UIButton()
            arrowL.setImage(UIImage(named:"iconExtra_0")!, for: .normal)
            arrowL.addTarget(self, action: #selector(tapArrowL(_:)), for: .touchUpInside)
            arrowL.restorationIdentifier = "\(dragon.picture)_Left"
        view.addSubview(arrowL)
        
        arrowL.translatesAutoresizingMaskIntoConstraints = false
        arrowL.centerYAnchor.constraint(equalTo: dragonIcon.centerYAnchor,constant: 0).isActive = true
        arrowL.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 25).isActive = true
        arrowL.widthAnchor.constraint(equalToConstant: dragonIcon.frame.width/6).isActive = true
        arrowL.heightAnchor.constraint(equalTo: arrowL.widthAnchor).isActive = true
        arrowL.layoutIfNeeded()
        
        let arrowR = UIButton()
            arrowR.setImage(UIImage(named:"iconExtra_1")!, for: .normal)
            arrowR.addTarget(self, action: #selector(tapArrowL(_:)), for: .touchUpInside)
            arrowR.restorationIdentifier = "\(dragon.picture)_Right"
            view.addSubview(arrowR)
        
        arrowR.translatesAutoresizingMaskIntoConstraints = false
        arrowR.centerYAnchor.constraint(equalTo: dragonIcon.centerYAnchor,constant: 0).isActive = true
        arrowR.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -25).isActive = true
        arrowR.widthAnchor.constraint(equalTo:arrowL.widthAnchor).isActive = true
        arrowR.heightAnchor.constraint(equalTo: arrowL.widthAnchor).isActive = true
        arrowR.layoutIfNeeded()
        
        let element = UIImageView(image: UIImage(named: dragon.element.rawValue + "_Weakness"))
            view.addSubview(element)
        
        element.translatesAutoresizingMaskIntoConstraints = false
        element.bottomAnchor.constraint(equalTo: dragonIcon.bottomAnchor,constant: 0).isActive = true
        element.leadingAnchor.constraint(equalTo: dragonIcon.trailingAnchor,constant: 15).isActive = true
        
        
        var star = UIImageView()
        let number = dragon.picture.getNumberStarName()
        for x in 0...2 {
            let image = x <= number ? "starB" : "starGray"
            star = UIImageView(image: UIImage(named: image))
            let x =  CGFloat(CGFloat(x) * star.image!.size.width) - star.frame.width
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
        shape.heightAnchor.constraint(equalToConstant: view.frame.height*0.3).isActive = true
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
            .shadowText(colorText: dragon.rarity.color, colorShadow: .black, aligment: .center)

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
       
        var date:String = ""
        if dragon.discover != nil {
            date = dragon.discover!.toString()
        }
        let txtDiscover = UILabel()
            .addTextWithFont(font: .systemFont(ofSize: 20, weight: .bold), text: "Discover\n\(date)", color: .white)
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
        
        for x in 0..<(dragon.icons.count){
            
            let valueSkills = MyButton(frame: .zero, item: dragon, view: viewTemp, index: x)  { _ in }
            valueSkills.setImage(UIImage(named: dragon.icons[x]),for: .normal)
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
                    return Dragons.items.filter { $0.picture == "\(name)_T\(number)_icon"}.first
                }
                
                case .Right:
                    number += 1
                  if number  < 4 {
                      return Dragons.items.filter { $0.picture == "\(name)_T\(number)_icon"}.first
                      
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
        
        if self.contains("T1") {
            return 0
        } else if self.contains("T2") {
            return 1
        } else if self.contains("T3") {
            return 2
        }
        return 0
    }
}

extension DragonsMenuScene {
    
    // MARK: SHOW MAIN PAGE SCREEN
    private func showMainPage() -> UIView {
        
        let mainView = templateMainGeneric(typeGrid: .main, hasCancelBtn: false)
        mainView.tag = 1
      
        do {
            if  let player = try ManagedDB.shared.getCharacterPlayer().name?.rawValue  {
                
                let atlas = SKTextureAtlas().loadAtlas(name: "\(player)_Idle", prefix: nil).map { UIImage(named: $0.description.components(separatedBy: "'")[1])!}
                
                let uiView = UIImageView()
                
                uiView.image =  UIImage.animatedImage(with: atlas, duration: 1)
                UIView.animate(withDuration: 0.5,delay: 0,options: [.repeat,.autoreverse,.curveEaseInOut]) {
                    uiView.transform = CGAffineTransform(translationX: 0, y: -screenSize.height*0.01)
                }
                view!.addSubview(uiView)
                uiView.translatesAutoresizingMaskIntoConstraints = false
                uiView.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
                uiView.centerYAnchor.constraint(equalTo: view!.topAnchor,constant:screenSize.height*0.35).isActive = true
                uiView.widthAnchor.constraint(equalToConstant: max(160,mainView.frame.width*0.3)).isActive = true
                uiView.heightAnchor.constraint(equalToConstant: max(160/1.37,mainView.frame.width*0.3)/1.37).isActive = true
            }
            
        }catch let error {
        
            print("Error not player found \(error.localizedDescription)")
        }
        
        let dragonRight = UIButton().getCircleDragons(mainView: view!,side:.Right)
            dragonRight.addAction(for: .touchUpInside) {
            guard let d = ManagedDB.getDragonSide(side: .Right)  else { return }
            self.showPanelDragonCircle(item: d)
        }
        
        let dragonLeft = UIButton().getCircleDragons(mainView: view!,side:.Left)
            dragonLeft.addAction(for: .touchUpInside) {
            guard let d = ManagedDB.getDragonSide(side: .Left)  else { return }
            self.showPanelDragonCircle(item: d)
        }
        
        do{
            let fetch = NSFetchRequest<DragonsBuy>(entityName: "DragonsBuy")
            let count = try ManagedDB.shared.context.fetch(fetch).count
           
            if count > 0 {
                
                let collection = ManagedCollectionInView(view: mainView, type: .main, item: nil) { _ in } deSelect: { _ in }

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
        } catch let error {
            print(error.localizedDescription)
        }
        return mainView
    }
    
    private func showIndexPageBook(){
       
        self.scene?.backgroundBlack(withSpinnerActive: false)
        
        let view = self.templateMainGeneric(typeGrid: .sell, hasCancelBtn: true)
        
        let gradient = UIImage.gradientImage(bounds: view.bounds, colors: [.yellow,.orange])
        
        let title = UILabel()
            .addFontAndText(font: "Family Guy", text: "YOUR COLLECTION:", size: view.frame.width*0.05)
            .shadowText(colorText: UIColor(patternImage: gradient), colorShadow: .black,aligment: .center)
        view.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: view.topAnchor,constant: 20).isActive = true
        title.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        title.layoutIfNeeded()
        
        let barProgress = UIImageView(image: UIImage(named: "barProgress"))
        view.addSubview(barProgress)
        barProgress.translatesAutoresizingMaskIntoConstraints = false
        barProgress.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        barProgress.topAnchor.constraint(equalTo: title.bottomAnchor,constant: 5).isActive = true
        barProgress.widthAnchor.constraint(equalTo: title.widthAnchor).isActive = true
        barProgress.heightAnchor.constraint(equalToConstant: title.frame.height*2).isActive = true
        barProgress.layoutIfNeeded()
       
       
        let progress = UIImageView(image:UIImage(named: "progress"))
        barProgress.addSubview(progress)

        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.heightAnchor.constraint(equalTo: barProgress.heightAnchor).isActive = true
        progress.leadingAnchor.constraint(equalTo: barProgress.leadingAnchor, constant: title.frame.height/2).isActive = true
        progress.centerYAnchor.constraint(equalTo: barProgress.centerYAnchor, constant: 0).isActive = true
        
       
        let percent = Double(ManagedDB.getNumberDragonBuy() &/ Dragons.items.count)/100
        progress.widthAnchor.constraint(equalToConstant: barProgress.frame.width * percent).isActive = true
        progress.layoutIfNeeded()
        
        let filterRarity = UIButton()
            filterRarity.addAction(for: .touchUpInside) {
            }
        
        let filterStar = UIButton()
        filterRarity.setBackgroundImage(UIImage(named: "BrownButton"), for: .normal)
        filterRarity.setBackgroundImage(UIImage(named: "DarkBrownButton"), for: .selected)
        filterRarity.addAction(for: .touchUpInside) {
            filterRarity.isSelected.toggle()
            filterRarity.imageView?.transform = CGAffineTransform(rotationAngle: filterRarity.isSelected ? .pi : .pi*2)
            filterStar.isSelected = false
        }

        filterRarity.setImage(UIImage(named: "arrowWhite"), for: .normal)
        filterRarity.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        filterRarity.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        filterRarity.setTitle("COMMON", for: .normal)
        view.addSubview(filterRarity)
        filterRarity.translatesAutoresizingMaskIntoConstraints = false
        filterRarity.trailingAnchor.constraint(equalTo: view.centerXAnchor,constant: 0).isActive = true
        filterRarity.topAnchor.constraint(equalTo: progress.bottomAnchor,constant: 5).isActive = true
        filterRarity.widthAnchor.constraint(equalToConstant: view.frame.width/3).isActive = true
        filterRarity.heightAnchor.constraint(equalToConstant: (view.frame.width/3)/2.69).isActive = true
        filterRarity.layoutIfNeeded()
        
        let filter = UIButton()
        filter.setBackgroundImage(UIImage(named: "btnAdd"), for: .normal)
        view.addSubview(filter)
        filter.translatesAutoresizingMaskIntoConstraints = false
        filter.trailingAnchor.constraint(equalTo: filterRarity.leadingAnchor,constant: -5).isActive = true
        filter.centerYAnchor.constraint(equalTo: filterRarity.centerYAnchor,constant: 0).isActive = true
        filter.widthAnchor.constraint(equalToConstant: filterRarity.frame.height/2).isActive = true
        filter.heightAnchor.constraint(equalTo: filter.widthAnchor).isActive = true
        filter.layoutIfNeeded()
        
        let collection =  self.ManagedCollectionInView(view: view,type: .index, item: nil) { _ in } deSelect: { _ in }
        
        view.addSubview(collection)
        
        filter.addAction(for: .touchUpInside) {
            let v = self.templateMainGeneric(typeGrid: .menu, hasCancelBtn: false)
                v.addSubview(v.buttonActionFilters(type: .menu) { (type:TypeOrder) in
                    v.removeFromSuperview()
                    if let collection = collection as? CustomCollectionViewEggs<Dragons, UICollectionViewCell> {
                        collection.orderDictionary(typeOrder:type)
                }
            })
            view.addSubview(v)
            
            v.translatesAutoresizingMaskIntoConstraints = false
            v.topAnchor.constraint(equalTo: filter.bottomAnchor).isActive = true
            v.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            v.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            v.heightAnchor.constraint(equalToConstant: view.frame.height*0.4).isActive = true
        }
        
        filterStar.setBackgroundImage(UIImage(named: "DarkBrownButton"), for: .normal)
        filterStar.setBackgroundImage(UIImage(named: "BrownButton"), for: .selected)
        filterStar.setImage(UIImage(named: "arrowWhite"), for: .normal)
        filterStar.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        filterStar.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        filterStar.setTitle("STARS", for: .normal)
        filterStar.addAction(for: .touchUpInside) {
            filterStar.isSelected.toggle()
            filterStar.imageView?.transform = CGAffineTransform(rotationAngle: filterStar.isSelected ? .pi : .pi*2)
            
            if let collection = collection as? CustomCollectionViewEggs<Dragons, UICollectionViewCell> {
                collection.orderDictionary(typeOrder:.Stars)
            }
        }

        view.addSubview(filterStar)
        filterStar.translatesAutoresizingMaskIntoConstraints = false
        filterStar.leadingAnchor.constraint(equalTo: filterRarity.trailingAnchor,constant: 10).isActive = true
        filterStar.topAnchor.constraint(equalTo: filterRarity.topAnchor,constant: 0).isActive = true
        filterStar.widthAnchor.constraint(equalTo: filterRarity.widthAnchor).isActive = true
        filterStar.heightAnchor.constraint(equalTo: filterRarity.heightAnchor).isActive = true
        filterStar.layoutIfNeeded()
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collection.widthAnchor.constraint(equalToConstant: view.frame.width*0.95).isActive = true
        collection.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant: -view.frame.height*0.05).isActive = true
        collection.topAnchor.constraint(equalTo: filterRarity.bottomAnchor,constant: 5).isActive = true
        
        let textProgress = UILabel()
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        textProgress.font =  UIFont.systemFont(ofSize: barProgress.frame.height*0.3, weight: .bold)
        textProgress.text = "COLLECTED \(ManagedDB.getNumberDragonBuy())/\(Dragons.items.count)"
        barProgress.addSubview(textProgress)
        
        textProgress.translatesAutoresizingMaskIntoConstraints = false
        textProgress.centerXAnchor.constraint(equalTo: barProgress.centerXAnchor, constant: 0).isActive = true
        textProgress.centerYAnchor.constraint(equalTo: barProgress.centerYAnchor, constant: 0).isActive = true
            
        
    }
    
    private func SellMainPage(isBulkSell:TypeGenericView,item: Dragons?) {
        
        let view = templateMainGeneric(typeGrid: .sell, hasCancelBtn: true)
        view.tag = 1
       
        let gradient = UIImage.gradientImage(bounds: view.bounds, colors: [.orange, .yellow])

        
        switch isBulkSell{
            
            case .Sell,.Feed:
            
                partialViewSellIndividual(view:view,item: item!,gradient:gradient, isFeedBtn: isBulkSell)

            case .Bulk:
                partialViewBulkSell(view: view,gradient:gradient)
          
            case .Evolve:
                partialViewEvolve(view:view,item: item!,gradient:gradient, isFeedBtn: isBulkSell)

        }
   
        if isBulkSell != .Evolve {
            let bagFruit = UIImageView(image:UIImage(named: "bagFruit"))
            view.addSubview(bagFruit)
            
            bagFruit.translatesAutoresizingMaskIntoConstraints = false
            bagFruit.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -40).isActive = true
            bagFruit.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 25).isActive = true
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
            getMoreFruit.layoutIfNeeded()
            
          
            let contadorMoreFruit =  UIButton()
            contadorMoreFruit.setBackgroundImage(UIImage(named: "counter"), for: .normal)
            contadorMoreFruit.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            contadorMoreFruit.setTitle("\(ManagedDB.getFruitTotal())".convertDecimal(), for: .normal)
            contadorMoreFruit.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            contadorMoreFruit.setTitleColor(.yellow, for: .normal)
            
            view.addSubview(contadorMoreFruit)
            contadorMoreFruit.translatesAutoresizingMaskIntoConstraints = false
            contadorMoreFruit.topAnchor.constraint(equalTo: getMoreFruit.bottomAnchor,constant: 10).isActive = true
            contadorMoreFruit.centerXAnchor.constraint(equalTo: getMoreFruit.centerXAnchor,constant: 0).isActive = true
            contadorMoreFruit.widthAnchor.constraint(equalToConstant: view.frame.width*0.3).isActive = true
            contadorMoreFruit.heightAnchor.constraint(equalToConstant: (view.frame.width*0.3)*0.3).isActive = true
            contadorMoreFruit.layoutIfNeeded()
            
            let iconPlus =  UIButton()
            iconPlus.setBackgroundImage(UIImage(named: "btnAdd"), for: .normal)
            iconPlus.addTarget(self, action: #selector(tapCounter), for: .touchUpInside)
            contadorMoreFruit.addSubview(iconPlus)
            
            iconPlus.translatesAutoresizingMaskIntoConstraints = false
            iconPlus.widthAnchor.constraint(equalTo: contadorMoreFruit.heightAnchor).isActive = true
            iconPlus.heightAnchor.constraint(equalTo: contadorMoreFruit.heightAnchor).isActive = true
            iconPlus.centerYAnchor.constraint(equalTo: contadorMoreFruit.centerYAnchor,constant:0).isActive = true
            iconPlus.centerXAnchor.constraint(equalTo: contadorMoreFruit.trailingAnchor,constant:0).isActive = true
            iconPlus.layoutIfNeeded()
        }

        scene?.view?.addSubview(view)
    }
    
    /// - Description: Partial view to evolve the dragons
    private func partialViewEvolve(view:UIView,item: Dragons,gradient:UIImage, isFeedBtn: TypeGenericView) {
        
        let header  = partialViewHeader(view:view,item:item,isFeedBtn:.Evolve)
        
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
        title.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 0).isActive = true
        title.widthAnchor.constraint(equalTo: view.widthAnchor,constant: -50).isActive = true

        let text = """
                      Choose a dragon to evolve together.
                      Only dragons of the same name and level can be used.
                  """
        
        let subtitle = UILabel(frame: header.bounds)
            .addFontAndText(font: "Cartwheel", text: text, size: view.frame.height*0.03)
            .shadowText(colorText: .black, colorShadow: .clear,aligment: .center)
        subtitle.numberOfLines = 0
        subtitle.adjustsFontSizeToFitWidth = false
        subtitle.textAlignment = .center
        subtitle.lineBreakMode = .byTruncatingHead
        view.addSubview(subtitle)
        
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.centerXAnchor.constraint(equalTo: title.centerXAnchor).isActive = true
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        subtitle.trailingAnchor.constraint(equalTo:header.trailingAnchor,constant: 0).isActive = true
        subtitle.leadingAnchor.constraint(equalTo:header.leadingAnchor,constant: 0).isActive = true
        subtitle.layoutIfNeeded()
        
        do {
            let data = try ManagedDB.findDragonsEvolve(item: item)
            if data.isEmpty {
                
                let message = UILabel()
                    .addFontAndText(font: "Cartwheel", text: "No eligible dragons!", size: view.frame.height*0.03)
                    .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
                view.addSubview(message)
                message.translatesAutoresizingMaskIntoConstraints = false
                message.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                message.centerYAnchor.constraint(equalTo: subtitle.bottomAnchor,constant: 50).isActive = true
            } else {
                
                let collection = ManagedCollectionInView(view: view, type: .evolve,item:item) { _ in
                } deSelect: { _ in }
                view.addSubview(collection)
                
                collection.translatesAutoresizingMaskIntoConstraints = false
                collection.topAnchor.constraint(equalTo: subtitle.bottomAnchor).isActive = true
                collection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                collection.heightAnchor.constraint(equalToConstant: view.frame.height*0.25).isActive = true
                collection.widthAnchor.constraint(equalToConstant: view.frame.width*0.8).isActive = true
            }
        }catch  {
            fatalError()
        }
    }
    
    /// #Description: Evolve the two dragons of the same rank and name
    /// #Parameters: Object Dragons
    private func CreateEvolveDragons(dragon:Dragons) {

        removeUIViews()
        
        let view = templateMainGeneric(typeGrid: .eggs, hasCancelBtn: true)
        self.view?.addSubview(view)
        
        let iconPlus = UIImageView(image: UIImage(named: "iconExtra_3")!)
        view.addSubview(iconPlus)
        iconPlus.translatesAutoresizingMaskIntoConstraints = false
        iconPlus.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0).isActive = true
        iconPlus.centerYAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.width*0.3).isActive = true
        iconPlus.widthAnchor.constraint(equalToConstant: view.frame.width/6).isActive = true
        iconPlus.heightAnchor.constraint(equalToConstant: view.frame.width/6).isActive = true

        let dragonLeft = UIImageView(image: UIImage(named: dragon.picture)!)
        view.addSubview(dragonLeft)
        dragonLeft.translatesAutoresizingMaskIntoConstraints = false
        dragonLeft.centerYAnchor.constraint(equalTo: iconPlus.centerYAnchor,constant: 0).isActive = true
        dragonLeft.trailingAnchor.constraint(equalTo: iconPlus.leadingAnchor,constant: -25).isActive = true
        dragonLeft.widthAnchor.constraint(equalToConstant: view.frame.width/4).isActive = true
        dragonLeft.heightAnchor.constraint(equalTo: dragonLeft.widthAnchor).isActive = true
        dragonLeft.drawStart(number: dragon.picture.getNumberStarName(), margin: .bottom,
                             size: CGSize(width: dragonLeft.frame.width*0.15, height: dragonLeft.frame.width*0.15))

        let dragonRight = UIImageView(image: UIImage(named: dragon.picture)!)
        view.addSubview(dragonRight)
        dragonRight.translatesAutoresizingMaskIntoConstraints = false
        dragonRight.leadingAnchor.constraint(equalTo: iconPlus.trailingAnchor,constant: 25).isActive = true
        dragonRight.centerYAnchor.constraint(equalTo: iconPlus.centerYAnchor,constant: 0).isActive = true
        dragonRight.widthAnchor.constraint(equalTo: dragonLeft.widthAnchor).isActive = true
        dragonRight.heightAnchor.constraint(equalTo: dragonLeft.heightAnchor).isActive = true
        dragonRight.drawStart(number: dragon.picture.getNumberStarName(),margin: .bottom,
                              size: CGSize(width: dragonRight.frame.width*0.15, height: dragonRight.frame.width*0.2))

        
        let txtResult = UILabel()
            .addFontAndText(font: "Cartwheel", text: "RESULT", size: view.frame.width*0.07)
            .shadowText(colorText: UIColor(patternImage: UIImage.gradientImage(bounds: view.bounds, colors: [.yellow,.orange])), colorShadow: .black, aligment: .center)
        view.addSubview(txtResult)
        txtResult.translatesAutoresizingMaskIntoConstraints = false
        txtResult.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0).isActive = true
        txtResult.topAnchor.constraint(equalTo: dragonLeft.bottomAnchor,constant: 0).isActive = true
        
        let subview = UIView()
        subview.layer.backgroundColor = UIColor.brown.withAlphaComponent(0.5).cgColor
        subview.layer.cornerRadius = 10
        subview.layer.borderColor =  UIColor.black.withAlphaComponent(0.7).cgColor
        subview.layer.borderWidth = 2
        subview.layer.shadowColor =  UIColor.black.cgColor
        subview.layer.shadowRadius = 10
        subview.layer.opacity = 1
        view.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subview.topAnchor.constraint(equalTo: txtResult.bottomAnchor,constant: 30).isActive = true
        subview.widthAnchor.constraint(equalToConstant: view.frame.width*0.8).isActive = true
        subview.heightAnchor.constraint(equalToConstant: view.frame.height*0.48).isActive = true
        subview.layoutIfNeeded()
        do {
            let objDragon = try ManagedDB.findNextDragonByNamePicture(dragon: dragon)
            
            let dragonEvolve = UIImageView(image: UIImage(named: objDragon.picture)!)
            subview.addSubview(dragonEvolve)
            dragonEvolve.translatesAutoresizingMaskIntoConstraints = false
            dragonEvolve.leadingAnchor.constraint(equalTo: subview.leadingAnchor,constant: 0).isActive = true
            dragonEvolve.topAnchor.constraint(equalTo: subview.topAnchor,constant: 0).isActive = true
            dragonEvolve.widthAnchor.constraint(equalToConstant: subview.frame.width*0.5).isActive = true
            dragonEvolve.heightAnchor.constraint(equalTo: dragonEvolve.widthAnchor).isActive = true
            dragonEvolve.drawStart(number: objDragon.picture.getNumberStarName(),margin: .bottom,
                                   size: CGSize(width: dragonEvolve.frame.width*0.2, height: dragonEvolve.frame.width*0.2))
            
            let txtName = UILabel()
                .addFontAndText(font: "Cartwheel", text: "\(objDragon.name)", size: view.frame.width*0.1)
                .shadowText(colorText: UIColor(patternImage: UIImage.gradientImage(bounds: subview.bounds, colors: [.orange,.yellow,.red])), colorShadow: .black, aligment: .center)
            subview.addSubview(txtName)
            txtName.translatesAutoresizingMaskIntoConstraints = false
            txtName.topAnchor.constraint(equalTo: subview.topAnchor,constant: 50).isActive = true
            txtName.leadingAnchor.constraint(equalTo: dragonEvolve.trailingAnchor,constant: 0).isActive = true
            
            
            let txtRarity = UILabel()
                .addFontAndText(font: "Cartwheel", text: dragon.rarity.rawValue, size: view.frame.width*0.05)
                .shadowText(colorText: dragon.rarity.color, colorShadow: .black, aligment: .center)
            view.addSubview(txtRarity)
            txtRarity.translatesAutoresizingMaskIntoConstraints = false
            txtRarity.leadingAnchor.constraint(equalTo: view.centerXAnchor,constant: 0).isActive = true
            txtRarity.topAnchor.constraint(equalTo: txtName.bottomAnchor,constant: 0).isActive = true
            
            let txtDMGL = UILabel()
                .addFontAndText(font: "Cartwheel", text: "50\nDMG", size: view.frame.width*0.07)
                .shadowText(colorText: UIColor(patternImage: UIImage.gradientImage(bounds: subview.bounds, colors: [.brown,.white,.gray])), colorShadow: .black, aligment: .center)
            txtDMGL.numberOfLines = 0
            subview.addSubview(txtDMGL)
            
            txtDMGL.translatesAutoresizingMaskIntoConstraints = false
            txtDMGL.leadingAnchor.constraint(equalTo: txtRarity.leadingAnchor,constant: 0).isActive = true
            txtDMGL.topAnchor.constraint(equalTo: txtRarity.bottomAnchor,constant: 0).isActive = true
            
            let txtDMGR = UILabel()
                .addFontAndText(font: "Cartwheel", text: "53\nDMG", size: view.frame.width*0.07)
                .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
            txtDMGR.numberOfLines = 0
            subview.addSubview(txtDMGR)
            
            txtDMGR.translatesAutoresizingMaskIntoConstraints = false
            txtDMGR.trailingAnchor.constraint(equalTo: subview.trailingAnchor,constant: -5).isActive = true
            txtDMGR.topAnchor.constraint(equalTo: txtRarity.bottomAnchor,constant: 0).isActive = true
            
            let txtBonus = UILabel()
            txtBonus.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            txtBonus.text = "No zodiac bonus"
            txtBonus.textColor = UIColor.black
            txtBonus.adjustsFontSizeToFitWidth = true
            txtBonus.minimumScaleFactor = 0.5
            
            subview.addSubview(txtBonus)
            txtBonus.translatesAutoresizingMaskIntoConstraints = false
            txtBonus.leadingAnchor.constraint(equalTo: txtDMGL.leadingAnchor,constant: 0).isActive = true
            txtBonus.topAnchor.constraint(equalTo: txtDMGL.bottomAnchor,constant: 0).isActive = true
            txtBonus.widthAnchor.constraint(equalToConstant: subview.frame.width*0.4).isActive = true
            
            let txtDescription = UILabel()
                .addFontAndText(font: "Cartwheel", text: "DESCRIPTION", size: view.frame.width*0.06)
                .shadowText(colorText: UIColor(patternImage: UIImage.gradientImage(bounds: subview.bounds, colors: [.brown,.white])), colorShadow: .black, aligment: .center)
            
            view.addSubview(txtDescription)
            txtDescription.translatesAutoresizingMaskIntoConstraints = false
            txtDescription.centerXAnchor.constraint(equalTo: dragonEvolve.centerXAnchor,constant: 0).isActive = true
            txtDescription.centerYAnchor.constraint(equalTo: subview.centerYAnchor,constant: 75).isActive = true
            
            let txtSubtile = UILabel()
                .addFontAndText(font: "Cartwheel", text: "Moster Killer", size: view.frame.width*0.05)
                .shadowText(colorText: dragon.rarity.color, colorShadow: .black, aligment: .center)
            
            subview.addSubview(txtSubtile)
            txtSubtile.translatesAutoresizingMaskIntoConstraints = false
            txtSubtile.leadingAnchor.constraint(equalTo: txtDescription.leadingAnchor,constant: 0).isActive = true
            txtSubtile.topAnchor.constraint(equalTo: txtDescription.bottomAnchor,constant: 0).isActive = true
            
            let txtUndone = UILabel()
            txtUndone.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            txtUndone.text = "Tap to evolve.This cannot be undone"
            txtUndone.textColor = UIColor.gray
            subview.addSubview(txtUndone)
            txtUndone.translatesAutoresizingMaskIntoConstraints = false
            txtUndone.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0).isActive = true
            txtUndone.topAnchor.constraint(equalTo: subview.bottomAnchor,constant: 0).isActive = true
            
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "BlueButton"), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            button.setTitle("EVOLVE", for: .normal)
            button.addAction(for: .touchUpInside) {
                self.viewFusionEvolve(view:view,dragon:dragon)
            }
            
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0).isActive = true
            button.topAnchor.constraint(equalTo: txtUndone.bottomAnchor,constant: 0).isActive = true
        } catch let error {
            print("Error create evolve Dragons \(error.localizedDescription)")
        }
        
        
    }
    
    /// #Description: Create animation fusion two dragons same level
    /// #Parameters:  @dragon:Dragons  The object type Dragons
    ///                                @view:UIView               The view
    private func viewFusionEvolve(view:UIView,dragon:Dragons) {
        
        
        let v = UIView(frame: screenSize)
        v.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.scene?.view?.addSubview(v)
        
        UIView.animate(withDuration: 0.1) {
            view.transform = CGAffineTransform(translationX: screenSize.width, y: 0)
            view.removeFromSuperview()

        } completion: { _ in
            self.createAnimationFusionEvolve(view:v,dragon: dragon) { newDragon in
                if newDragon != nil {
                    do {
                        guard let newDragon = newDragon  else { return }
                        if try ManagedDB.createActionFusionEvolve(newDragon: newDragon,oldDragon:dragon) {
                            self.didMove(to: self.view!)
                        }
                    }catch let error {
                        print("Error in the view fusion evolve dragons \(error.localizedDescription)")
                    }
                }
                v.removeFromSuperview()
            }
        }
       
    }
    
    /// - Description: View partial for header generic,  left show dragon  image and the dragon info to right
    private func partialViewHeader(view:UIView,item:Dragons,isFeedBtn:TypeGenericView) -> UIView {

        view.subviews.first {$0.tag == 1000}?.removeFromSuperview()
      
        let inset = UIDevice().isPhone() ? 25 : 50
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width-CGFloat(inset), height: view.frame.width/2))
        
        header.layer.borderColor = UIColor.black.withAlphaComponent(0.8).cgColor
        header.layer.borderWidth = 1
        header.layer.cornerRadius = 10
        header.layer.backgroundColor = UIColor.brown.withAlphaComponent(0.2).cgColor
        header.layer.shadowColor = UIColor.black.withAlphaComponent(1).cgColor
        header.layer.shadowOpacity = 1
        header.tag  = 1000
        view.addSubview(header)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        header.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        header.topAnchor.constraint(equalTo: view.topAnchor,constant: CGFloat(inset)).isActive = true
        header.widthAnchor.constraint(equalToConstant: header.frame.width).isActive = true
        header.heightAnchor.constraint(equalToConstant: header.frame.height).isActive = true
      
        let imgDragon = UIImageView(image: UIImage(named: item.picture))
        imgDragon.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        imgDragon.layer.borderWidth =  2
        imgDragon.layer.cornerRadius = 10
        imgDragon.layer.shadowOpacity = 0.5
        imgDragon.layer.shadowColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        imgDragon.layer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        header.addSubview(imgDragon)
        
        imgDragon.translatesAutoresizingMaskIntoConstraints  = false
        imgDragon.widthAnchor.constraint(equalToConstant: header.frame.width/2).isActive = true
        imgDragon.heightAnchor.constraint(equalTo: imgDragon.widthAnchor).isActive = true
        imgDragon.topAnchor.constraint(equalTo: header.topAnchor,constant: 5).isActive = true
        imgDragon.leadingAnchor.constraint(equalTo: header.leadingAnchor,constant: 5).isActive = true
     
        let shape = UIView(frame: imgDragon.frame)
        shape.backgroundColor = UIColor(red: 239 / 255, green: 204/255, blue: 151/255, alpha: 0.5)
        shape.layer.cornerRadius = 10
        shape.layer.borderColor = UIColor.black.withAlphaComponent(0.8).cgColor
        shape.layer.borderWidth = 1
        shape.layer.shadowColor = UIColor.gray.cgColor
        shape.layer.shadowOffset = CGSize(width: 10, height:  1)
        header.addSubview(shape)
       
        shape.translatesAutoresizingMaskIntoConstraints = false
        shape.topAnchor.constraint(equalTo: imgDragon.topAnchor,constant: 0).isActive = true
        shape.leadingAnchor.constraint(equalTo: header.centerXAnchor,constant: 10).isActive = true
        shape.trailingAnchor.constraint(equalTo: header.trailingAnchor,constant: -5).isActive = true
        shape.heightAnchor.constraint(equalTo: imgDragon.heightAnchor,constant: 0).isActive = true
        shape.layoutIfNeeded()

        shape.drawStart(number: item.picture.getNumberStarName(),margin: .left,
                        size: CGSize(width: shape.frame.width*0.2, height: shape.frame.width*0.2))

        if isFeedBtn == .Sell {
            let imgHeart = UIButton()
            
            imgHeart.isSelected = ManagedDB.getValDragonLike(item: item)
            imgHeart.setBackgroundImage(UIImage(named: "heartOff"), for: .normal)
            imgHeart.setBackgroundImage(UIImage(named: "heartOn"), for: .selected)
            header.addSubview(imgHeart)
            
            imgHeart.translatesAutoresizingMaskIntoConstraints = false
            imgHeart.widthAnchor.constraint(equalToConstant:header.frame.width*0.1).isActive = true
            imgHeart.heightAnchor.constraint(equalTo: imgHeart.widthAnchor).isActive = true
            imgHeart.bottomAnchor.constraint(equalTo: imgDragon.bottomAnchor,constant: 0).isActive = true
            imgHeart.trailingAnchor.constraint(equalTo: imgDragon.trailingAnchor,constant: 0).isActive = true
            imgHeart.layoutIfNeeded()
            imgHeart.addAction(for: .touchUpInside) {
                imgHeart.isSelected = ManagedDB.createDragonLike(item: item)
            }
        }

        let name = UILabel()
            .addFontAndText(font: "Cartwheel", text: item.name, size: shape.frame.width*0.15)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
        shape.addSubview(name)
    
        name.translatesAutoresizingMaskIntoConstraints = false
        name.leadingAnchor.constraint(equalTo: shape.leadingAnchor,constant: 10).isActive = true
        name.topAnchor.constraint(equalTo:header.topAnchor, constant: shape.frame.height*0.3).isActive = true
        
        let subtitle = UILabel()
            .addFontAndText(font: "Cartwheel", text: "\(item.rarity)", size: shape.frame.width*0.1)
            .shadowText(colorText: item.rarity.color, colorShadow: .black, aligment: .center)
        shape.addSubview(subtitle)
        
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.leadingAnchor.constraint(equalTo: shape.leadingAnchor,constant: 10).isActive = true
        subtitle.topAnchor.constraint(equalTo: name.bottomAnchor,constant:10).isActive = true
     
        if isFeedBtn == .Feed  && item.getLevel()  {
            
            item.setMaxLevel()
        }
        let level = UILabel()
            .addFontAndText(font: "Cartwheel", text: "LVL \(item.level) \(item.class_)", size: shape.frame.width*0.1)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        shape.addSubview(level)
        
        level.translatesAutoresizingMaskIntoConstraints = false
        level.leadingAnchor.constraint(equalTo: shape.leadingAnchor,constant: 10).isActive = true
        level.topAnchor.constraint(equalTo: subtitle.bottomAnchor,constant:10).isActive = true
        level.layoutIfNeeded()
        
        let barProgress = UIImageView(image: UIImage(named: "barProgress"))
        shape.addSubview(barProgress)
        
        barProgress.translatesAutoresizingMaskIntoConstraints = false
        barProgress.topAnchor.constraint(equalTo: level.bottomAnchor,constant:0).isActive = true
        barProgress.centerXAnchor.constraint(equalTo: shape.centerXAnchor).isActive = true
        barProgress.widthAnchor.constraint(equalTo: shape.widthAnchor,constant: -10).isActive = true
        barProgress.heightAnchor.constraint(equalToConstant: shape.frame.width/4.3).isActive = true
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

        return header
    }
    
    /// - Description: Main view where I add the partial views to sell the dragons
    private func partialViewSellIndividual(view:UIView,item: Dragons,gradient:UIImage,isFeedBtn:TypeGenericView) {
        
        let _ = partialViewHeader(view: view,item: item,isFeedBtn: isFeedBtn)
       
        let shape = view.retangleView(title: isFeedBtn == .Sell ? "SELL \(item.name)?" : "FEED \(item.name)?",gradient: gradient)
        
        let counter:UILabel = partialCounter(view: view, shape: shape) { button in
            
            let textValFruit = isFeedBtn == .Feed ? item.calculateFruit() : item.rarity.valueFruitDragon
            
            let txtValueFruit = UILabel()
                .addFontAndText(font: "Cartwheel", text: textValFruit, size: button.frame.height/2)
                .shadowText(colorText: UIColor(patternImage: gradient), colorShadow: .black,aligment: .center)
            button.addSubview(txtValueFruit)
            
            txtValueFruit.translatesAutoresizingMaskIntoConstraints = false
            txtValueFruit.centerXAnchor.constraint(equalTo: button.centerXAnchor,constant: -5).isActive = true
            txtValueFruit.centerYAnchor.constraint(equalTo: button.centerYAnchor,constant: 0).isActive = true
            
            if  isFeedBtn != .Feed {
                let txtUndone = UILabel()
                    .addTextWithFont(font: UIFont.systemFont(ofSize: view.frame.width*0.03, weight: .bold), text: "(This cannot be undone)", color: .white)
                shape.addSubview(txtUndone)
                
                txtUndone.translatesAutoresizingMaskIntoConstraints = false
                txtUndone.centerXAnchor.constraint(equalTo: shape.centerXAnchor,constant: 0).isActive = true
                txtUndone.topAnchor.constraint(equalTo: button.bottomAnchor,constant: 0).isActive = true
            }
            
            let btnSell = UIButton(frame: CGRect(x: 0, y: 0, width: button.frame.width, height: button.frame.height))
            btnSell.setBackgroundImage(img: UIImage(named: "GreenButton")!)
            btnSell.restorationIdentifier = isFeedBtn == .Feed ? "\(item.getValueFruit())" : item.rarity.valueFruitDragon
            btnSell.addAction(for: .touchUpInside) {
                if isFeedBtn == .Feed && (ManagedDB.SaveDragonByName(item:item) == true) {
                    self.tapButtonCancel(sender: btnSell)
                } else {
                    self.sellTapButton(sender: btnSell)
                    do{
                        try ManagedDB.removeDragonsDB(items: [item])
                    }catch let error{
                        fatalError(error.localizedDescription)
                    }
                }
            }
            shape.addSubview(btnSell)
            
            btnSell.translatesAutoresizingMaskIntoConstraints = false
            btnSell.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            btnSell.bottomAnchor.constraint(equalTo: shape.bottomAnchor,constant: -10).isActive = true
            btnSell.widthAnchor.constraint(equalToConstant: button.frame.width).isActive = true
            btnSell.heightAnchor.constraint(equalToConstant: button.frame.height).isActive = true
            
            if  isFeedBtn != .Feed{
                let iconBag = UIImageView(image: UIImage(named: "iconExtra_2")!)
                view.addSubview(iconBag)
                
                iconBag.translatesAutoresizingMaskIntoConstraints = false
                iconBag.centerYAnchor.constraint(equalTo: btnSell.centerYAnchor).isActive = true
                iconBag.centerXAnchor.constraint(equalTo: btnSell.trailingAnchor).isActive = true
                iconBag.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
                iconBag.heightAnchor.constraint(equalTo: button.heightAnchor).isActive = true
            }
            let txtSell = UILabel()
                .addTextWithFont(font: UIFont.systemFont(ofSize: view.frame.width*0.05, weight: .bold), text: isFeedBtn != .Feed ? "SELL":"FEED", color: .white)
            btnSell.addSubview(txtSell)
            
            txtSell.translatesAutoresizingMaskIntoConstraints = false
            txtSell.centerXAnchor.constraint(equalTo: btnSell.centerXAnchor,constant: 0).isActive = true
            txtSell.centerYAnchor.constraint(equalTo: btnSell.centerYAnchor,constant: 0).isActive = true
            
            return txtValueFruit
        }
 
        if isFeedBtn == .Feed {
            
            var btnLeft = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            var btnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            
            btnLeft = MyButton(frame: btnLeft.frame, item: item, view: shape, identifier: .Left) { _ in
                
                if item.lessPercent() {
                    let _ = self.partialViewHeader(view: view, item: item, isFeedBtn: isFeedBtn)
                    counter.text = "\(item.calculateFruit())"
                    btnRight.isEnabled = true
                }
            }
            
            btnRight = MyButton(frame: btnLeft.frame, item: item, view: shape, identifier: .Right) { _ in
                
                if item.addPercent() {
                    let _ = self.partialViewHeader(view: view, item: item, isFeedBtn: isFeedBtn)
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
                    btnSell.addAction(for: .touchUpInside) {
                        do {
                            try ManagedDB.removeDragonsDB(items: dragonSelected)
                           
                            if ManagedDB.addFruitTotal(addFruit: textSeleted, arimethic: "+") {
                                self.createAnimationFruitSell(typeObject: Icons.IconsFruit.fruit, numberFruit: textSeleted) { _ in}
                                self.tapButtonCancel(sender: btnSell)
                            } else {
                                print("Error grabar frutas")
                            }
                            
                        }catch { fatalError()}
                    }
                    
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
        title.topAnchor.constraint(equalTo: view.topAnchor,constant: view.frame.height*0.03).isActive = true
        
        let subtitle = UILabel()
            .addFontAndText(font: "Cartwheel", text: "CHOOSE DRAGONS TO SELL", size: view.frame.width*0.06)
            .shadowText(colorText: .brown, colorShadow: .black, aligment: .center)
        view.addSubview(subtitle)
        
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        subtitle.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
        
        
        let collection = ManagedCollectionInView(view: view,type: .sell, item: nil) { dragon in
            textSeleted +=  dragon.getValueFruit()
            dragonSelected.append(dragon)
            
        } deSelect: { dragon in
            textSeleted -= dragon.getValueFruit()
            guard let index = dragonSelected.firstIndex(where: {$0.name == dragon.name}) else { return }
            dragonSelected.remove(at: index)
        }
        collection.layer.borderWidth = 1
        collection.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        collection.layer.cornerRadius = 10
        collection.layer.shadowColor = UIColor.black.cgColor
        collection.layer.opacity = 1
        collection.layer.shadowRadius = 5
        collection.layer.shouldRasterize = true
        collection.layer.backgroundColor = UIColor.brown.withAlphaComponent(0.1).cgColor

        view.addSubview(collection)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collection.topAnchor.constraint(equalTo: subtitle.bottomAnchor,constant: 0).isActive = true
        collection.widthAnchor.constraint(equalToConstant: view.frame.width*0.9).isActive = true
        collection.heightAnchor.constraint(equalToConstant: view.frame.height*0.5).isActive = true
        
        let contador = UIButton(frame: CGRect(x: view.frame.width*0.1, y: view.frame.height*0.65, width: view.frame.width*0.3, height: view.frame.width*0.1))
        contador.setBackgroundImage(img: UIImage(named: "counter")!)
        view.addSubview(contador)
        contador.translatesAutoresizingMaskIntoConstraints = false
        contador.topAnchor.constraint(equalTo: collection.bottomAnchor,constant: 5).isActive = true
        contador.leadingAnchor.constraint(equalTo: collection.leadingAnchor,constant: 0).isActive = true
        contador.widthAnchor.constraint(equalToConstant: contador.frame.width).isActive = true
        contador.heightAnchor.constraint(equalToConstant: contador.frame.height).isActive = true


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
        btnSell.isEnabled = false
        btnSell.setBackgroundImage(UIImage(named: "disableSell")!, for: .disabled)
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
    private func createAnimationFruitSell<T:ProtocolIcons>(typeObject:T,numberFruit:Int,completion:@escaping(Bool)->Void) {
     
        var index = 0
        
        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { t in
           
            if index > 10 {
                t.invalidate()
                self.run(self.gameinfo.mainAudio.getAction(type: .Result_Coin))
                completion(true)
            }
            index += 1
            
            self.coinAnimation(index:index,typeObject:typeObject,t:t.timeInterval) { _  in }
        }
    }
    
    /// #Description: Create animation fusion two Dragons
    private func createAnimationFusionEvolve(view:UIView,dragon:Dragons,completion:@escaping(Dragons?)->Void) {
        
        let d1 = UIImageView(image: UIImage(named: dragon.picture )!)
        let d2 = UIImageView(image: UIImage(named: dragon.picture )!)

        view.addSubview(d1)
        view.addSubview(d2)
        
        d1.translatesAutoresizingMaskIntoConstraints = false
        d1.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        d1.centerXAnchor.constraint(equalTo: view.leadingAnchor,constant: 0).isActive = true
        d1.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        d1.heightAnchor.constraint(equalTo: d1.widthAnchor).isActive = true
        
        d2.translatesAutoresizingMaskIntoConstraints = false
        d2.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        d2.centerXAnchor.constraint(equalTo: view.trailingAnchor,constant: 0).isActive = true
        d2.widthAnchor.constraint(equalTo: d1.widthAnchor).isActive = true
        d2.heightAnchor.constraint(equalTo: d1.heightAnchor).isActive = true
      
        UIView.animate(withDuration: 0.5) {
            d1.transform = CGAffineTransform(translationX: screenSize.midX , y: 0)
            d2.transform = CGAffineTransform(translationX: -screenSize.midX, y: 0)

        } completion: { _ in
           
            let rayRotating = view.raySunRotating(view: view)
            view.addSubview(rayRotating)
            
            rayRotating.translatesAutoresizingMaskIntoConstraints = false
            rayRotating.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            rayRotating.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

            d1.removeFromSuperview()
            d2.removeFromSuperview()
            
            do {
                
                let newDragon = try ManagedDB.findNextDragonByNamePicture(dragon: dragon)
                let d1 = UIImageView(image: UIImage(named: newDragon.picture )!)
                d1.alpha = 0
                view.addSubview(d1)
                
                d1.translatesAutoresizingMaskIntoConstraints = false
                d1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                d1.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
                d1.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
                d1.heightAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
                UIView.animate(withDuration: 1) {
                    d1.transform  = CGAffineTransform(scaleX: 2, y: 2)
                    d1.alpha = 1
                    d1.layoutIfNeeded()
                    
                } completion: { _ in
                    
                    let button = UIButton()
                    button.setBackgroundImage(UIImage(named: "BlueButton"), for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
                    button.setTitle("OKAY", for: .normal)
                    view.addSubview(button)
                    
                    button.translatesAutoresizingMaskIntoConstraints = false
                    button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                    button.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -30).isActive = true
                    button.addAction(for: .touchUpInside) {
                        completion(newDragon)
                    }
                    
                    let label = UILabel()
                        .addFontAndText(font: "Cartwheel", text: "\(newDragon.name)", size: view.frame.width*0.2)
                        .shadowText(colorText: newDragon.rarity.color, colorShadow: .yellow, aligment: .center)
                    view.addSubview(label)
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                    label.bottomAnchor.constraint(equalTo: button.topAnchor,constant: -50).isActive = true
                }
            }catch let error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: ANIMATE SEVERAL FRUIT IN CENTER SCREEN WHEN SELL DRAGON FOR FRUIT
    private func coinAnimation<T:ProtocolIcons>(index:Int,typeObject:T,t:TimeInterval,handler:@escaping(Bool)->Void) {
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
            imageView.removeFromSuperview()
            if index > 10 {
                handler(true)
            }
        }
    }
    
    /// Get object from userdata UIButton
    func showTypeListObject(pos:SKNode) {
        
        if let a = (pos.userData!["typeCoin"]  as? Currency.CurrencyType) {
               
            switch a{
                case .Coin:
                
                genericTableView(items: BuyCoins.items, gameInfo: gameinfo)
                case .Gem:
                     genericTableView(items: BuyGem.items, gameInfo: gameinfo)
                case .Fruit:
                    genericTableView(items: BuyFruit.items, gameInfo: gameinfo)
                
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
        createAnimationFruitSell(typeObject: Icons.IconsCoin.coin, numberFruit: 10, completion: { [self] _ in
            
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
                case Currency.CurrencyType.Coin:
                   
                    return result.coin > item.amount
                
                case Currency.CurrencyType.Gem:
                
                    return result.gem > item.amount
                
                case Currency.CurrencyType.Fruit:
                
                    return result.fruit  > item.amount
            
                default :
                    return false
            }
        }catch { return false }
    }
}



extension DragonsMenuScene {
    
    /// #DESCRIPTION: LOAD UI SCREEN
    private func load(){
        
        let panelWood = UIImageView(image: UIImage(named: "panelWoodScreen"))
            view?.addSubview(panelWood)
            panelWood.translatesAutoresizingMaskIntoConstraints = false
            panelWood.centerXAnchor.constraint(equalTo: view!.centerXAnchor).isActive = true
            panelWood.widthAnchor.constraint(equalToConstant: max(250,screenSize.width/2)).isActive = true
            panelWood.heightAnchor.constraint(equalToConstant: max(250,screenSize.width/2)/3.6).isActive = true
            panelWood.topAnchor.constraint(equalTo: view!.topAnchor,constant: UIDevice().isPhone() ? screenSize.height*0.05 : 50).isActive = true
            panelWood.layoutIfNeeded()

        let title = UILabel()
            .addFontAndText(font: "Family Guy", text: "DRAGON ROOST", size: panelWood.frame.height*0.25)
            .shadowText(colorText: UIColor(patternImage: UIImage.gradientImage(bounds: panelWood.bounds, colors: [.yellow,.orange])), colorShadow: .black, aligment: .center)
            panelWood.addSubview(title)
            title.translatesAutoresizingMaskIntoConstraints = false
            title.centerXAnchor.constraint(equalTo: panelWood.centerXAnchor).isActive = true
            title.centerYAnchor.constraint(equalTo: panelWood.centerYAnchor,constant: -5).isActive = true

        let backarrow = UIButton()
            backarrow.setBackgroundImage(UIImage(named: "backArrow")!, for: .normal)
            backarrow.addAction(for: .touchUpInside) {
                self.doTask(gb: .Character_Menu_BackArrow)
            }
            view!.addSubview(backarrow)
            backarrow.translatesAutoresizingMaskIntoConstraints = false
            backarrow.widthAnchor.constraint(equalToConstant: panelWood.frame.height*0.7).isActive = true
            backarrow.heightAnchor.constraint(equalToConstant: panelWood.frame.height*0.6).isActive = true
            backarrow.centerYAnchor.constraint(equalTo: panelWood.centerYAnchor).isActive = true
            backarrow.leadingAnchor.constraint(equalTo: self.view!.leadingAnchor, constant: 0).isActive = true
       
        
        let bgIcons = UIImageView(image: UIImage(named: "bgSandDragonScene")!)
            bgIcons.tag = 0
            self.view?.addSubview(bgIcons)
            bgIcons.translatesAutoresizingMaskIntoConstraints = false
            bgIcons.bottomAnchor.constraint(equalTo: view!.bottomAnchor).isActive = true
            bgIcons.widthAnchor.constraint(equalTo: view!.widthAnchor,constant: -30).isActive = true
            bgIcons.heightAnchor.constraint(equalToConstant: view!.frame.height*0.05).isActive = true
        
        let btnSell = UIButton()
            btnSell.tag = 0
            btnSell.setBackgroundImage(UIImage(named: "GreenButton"), for: .normal)
            btnSell.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
            btnSell.setTitle("SELL", for: .normal)
            btnSell.addAction(for: .touchUpInside) {
                self.SellMainPage(isBulkSell: .Bulk,item: nil)
            }
            self.view?.addSubview(btnSell)
            btnSell.translatesAutoresizingMaskIntoConstraints = false
            btnSell.bottomAnchor.constraint(equalTo: bgIcons.centerYAnchor).isActive = true
            btnSell.centerXAnchor.constraint(equalTo: self.view!.centerXAnchor).isActive = true
            btnSell.widthAnchor.constraint(equalToConstant: max(100,screenSize.width/4)).isActive = true
            btnSell.heightAnchor.constraint(equalToConstant: max(60,(screenSize.width/4)/2)).isActive = true
        
        let Btneggs = UIButton()
            Btneggs.tag = 0
            Btneggs.setBackgroundImage(UIImage(named: "GreenButton"), for: .normal)
            Btneggs.titleLabel?.font = UIFont(name: "Cartwheel", size: 20)
            Btneggs.titleEdgeInsets = UIEdgeInsets(top: 0, left: -45, bottom: 0, right: 0)
            Btneggs.setTitle("GET EGGS", for: .normal)
            Btneggs.addAction(for: .touchUpInside) { [weak self] in
                self!.genericTableView(items:BuyEggs.items, gameInfo: self!.gameinfo)
            }
            self.view?.addSubview(Btneggs)
            Btneggs.translatesAutoresizingMaskIntoConstraints = false
            Btneggs.bottomAnchor.constraint(equalTo: btnSell.bottomAnchor).isActive = true
            Btneggs.trailingAnchor.constraint(equalTo: btnSell.leadingAnchor,constant: -10).isActive = true
            Btneggs.widthAnchor.constraint(equalToConstant: max(150,screenSize.width/4)).isActive = true
            Btneggs.heightAnchor.constraint(equalTo: btnSell.heightAnchor).isActive = true
        
         let iconShieldEgg = UIImageView(image: UIImage(named: "Ancient")!)
            iconShieldEgg.tag = 0
            Btneggs.addSubview(iconShieldEgg)
            iconShieldEgg.translatesAutoresizingMaskIntoConstraints = false
            iconShieldEgg.centerYAnchor.constraint(equalTo: Btneggs.centerYAnchor).isActive = true
            iconShieldEgg.trailingAnchor.constraint(equalTo: Btneggs.trailingAnchor,constant: 0).isActive = true
            iconShieldEgg.widthAnchor.constraint(equalToConstant: 60).isActive = true
            iconShieldEgg.heightAnchor.constraint(equalToConstant: 75).isActive = true
            
            UIView.animate(withDuration: 0.1, delay: 0,options: [.autoreverse,.repeat,.curveEaseInOut]) {
                iconShieldEgg.transform =  CGAffineTransform(rotationAngle: (15 / 180) * .pi)
            }
        
        let btnIndex = UIButton()
            btnIndex.tag = 0
            btnIndex.setBackgroundImage(UIImage(named: "GreenButton"), for: .normal)
            btnIndex.titleLabel?.font = UIFont(name: "Cartwheel", size: 20)
            btnIndex.setTitle("INDEX", for: .normal)
            btnIndex.addAction(for: .touchUpInside) {
                self.showIndexPageBook()
            }
            self.view?.addSubview(btnIndex)
            btnIndex.translatesAutoresizingMaskIntoConstraints = false
            btnIndex.bottomAnchor.constraint(equalTo: btnSell.bottomAnchor).isActive = true
            btnIndex.leadingAnchor.constraint(equalTo: btnSell.trailingAnchor,constant: 10).isActive = true
            btnIndex.widthAnchor.constraint(equalTo: Btneggs.widthAnchor).isActive = true
            btnIndex.heightAnchor.constraint(equalTo: Btneggs.heightAnchor).isActive = true
        
        let BtnBook = UIImageView(image: UIImage(named: "BookButton")!)
            BtnBook.tag = 0
            btnIndex.addSubview(BtnBook)
            BtnBook.translatesAutoresizingMaskIntoConstraints = false
            BtnBook.centerYAnchor.constraint(equalTo: btnIndex.centerYAnchor).isActive = true
            BtnBook.centerXAnchor.constraint(equalTo: btnIndex.trailingAnchor,constant: -20).isActive = true
            BtnBook.widthAnchor.constraint(equalTo: iconShieldEgg.widthAnchor).isActive = true
            BtnBook.heightAnchor.constraint(equalTo: iconShieldEgg.heightAnchor).isActive = true
    }
    
    //MARK: SHOW VIEW PANEL DRAGON CIRCLE SELECTED
    private func showPanelDragonCircle(item:Dragons) {
        
        if let view = scene?.view?.subviews.filter({$0.tag == 1}).first {
            UIView.animate(withDuration: 0.05, animations:  {
                view.transform = CGAffineTransform(translationX: -screenSize.width, y:0 )
                view.removeFromSuperview()
            })
        }
    
        let view = templateMainGeneric(typeGrid: .sell, hasCancelBtn: true)
        view.layoutIfNeeded()
        self.view?.addSubview(view)
        
        let header = partialViewHeader(view: view,item: item,isFeedBtn: .Sell)
        header.layoutIfNeeded()
        
        let dmgView = UIImageView(image: UIImage(named: "bgDragonsIcons"))
        header.addSubview(dmgView)
        
        dmgView.translatesAutoresizingMaskIntoConstraints = false
        dmgView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10).isActive = true
        dmgView.leadingAnchor.constraint(equalTo: header.leadingAnchor,constant:0).isActive = true
        dmgView.widthAnchor.constraint(equalToConstant: header.frame.width*0.6).isActive = true
        dmgView.heightAnchor.constraint(equalToConstant: header.frame.height*0.3).isActive = true
        dmgView.layoutIfNeeded()
        
        let iconWeakness = UIImageView(image: UIImage(named: "\(item.element)_Weakness"))
        dmgView.addSubview(iconWeakness)
        
        iconWeakness.translatesAutoresizingMaskIntoConstraints = false
        iconWeakness.centerYAnchor.constraint(equalTo: dmgView.centerYAnchor).isActive = true
        iconWeakness.leadingAnchor.constraint(equalTo: dmgView.leadingAnchor,constant: 10).isActive = true
        iconWeakness.heightAnchor.constraint(equalToConstant: dmgView.frame.height*0.6).isActive = true
        iconWeakness.widthAnchor.constraint(equalTo: iconWeakness.heightAnchor).isActive = true
        iconWeakness.layoutIfNeeded()
        
        let txtDmgL = UILabel()
            .addFontAndText(font: "Cartwheel", text: "\(item.rarity.dmgVal)", size: view.frame.width*0.05)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
        dmgView.addSubview(txtDmgL)
        
        txtDmgL.translatesAutoresizingMaskIntoConstraints = false
        txtDmgL.centerYAnchor.constraint(equalTo: dmgView.centerYAnchor,constant: -10).isActive = true
        txtDmgL.centerXAnchor.constraint(equalTo: dmgView.leadingAnchor,constant: dmgView.frame.width/5*2).isActive = true
        
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
        txtDmgR.centerXAnchor.constraint(equalTo: dmgView.leadingAnchor,constant: dmgView.frame.width/5*4).isActive = true
        
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
        arrow.centerXAnchor.constraint(equalTo: dmgView.leadingAnchor, constant: dmgView.frame.width/5*3).isActive = true
        arrow.heightAnchor.constraint(equalTo: iconWeakness.widthAnchor,constant: -5).isActive = true
        arrow.widthAnchor.constraint(equalTo: arrow.heightAnchor).isActive = true
        
        let horoscopeView = UIImageView(image: UIImage(named: "bgDragonsIcons"))
        view.addSubview(horoscopeView)
        horoscopeView.translatesAutoresizingMaskIntoConstraints = false
        horoscopeView.topAnchor.constraint(equalTo: dmgView.topAnchor,constant: 0).isActive = true
        horoscopeView.leadingAnchor.constraint(equalTo: dmgView.trailingAnchor,constant:15).isActive = true
        horoscopeView.trailingAnchor.constraint(equalTo: header.trailingAnchor,constant:-10).isActive = true
        horoscopeView.heightAnchor.constraint(equalTo: dmgView.heightAnchor).isActive = true
        
        let iconHoroscope = UIImageView(image: UIImage(named: "pisces"))
        horoscopeView.addSubview(iconHoroscope)
        iconHoroscope.translatesAutoresizingMaskIntoConstraints = false
        iconHoroscope.centerYAnchor.constraint(equalTo: iconWeakness.centerYAnchor,constant: 0).isActive = true
        iconHoroscope.leadingAnchor.constraint(equalTo: horoscopeView.leadingAnchor,constant:10).isActive = true
        iconHoroscope.widthAnchor.constraint(equalTo: iconWeakness.widthAnchor).isActive = true
        iconHoroscope.heightAnchor.constraint(equalTo: iconWeakness.heightAnchor).isActive = true
        
        let textHoroscope = UILabel()
            .addFontAndText(font: "Cartwheel", text: "\(item.getTypeTier())/3", size: view.frame.width*0.06)
            .shadowText(colorText: .brown, colorShadow: .white, aligment: .center)
        horoscopeView.addSubview(textHoroscope)
        textHoroscope.translatesAutoresizingMaskIntoConstraints = false
        textHoroscope.centerYAnchor.constraint(equalTo: iconHoroscope.centerYAnchor,constant: 0).isActive = true
        textHoroscope.centerXAnchor.constraint(equalTo: horoscopeView.centerXAnchor,constant:15).isActive = true
        textHoroscope.widthAnchor.constraint(equalTo: txtDmgR.widthAnchor).isActive = true
        textHoroscope.heightAnchor.constraint(equalTo: textHoroscope.widthAnchor).isActive = true
        
        let _ = IconsExtra.items.getItems(item: item, remove: .iconExtra_3).enumerated().map { (idx,element) in
        
            let _ = MyButton(frame: .zero, item: element ,view: view,index:idx) { [self] _ in
                
                switch element {
                case .iconExtra_0: tapArrowChangeDragon(dragon: item, side: .Left)
                case .iconExtra_1: tapArrowChangeDragon(dragon: item, side: .Right)
                case .iconExtra_2: SellMainPage(isBulkSell:.Sell,item: item)
                case .iconExtra_3: SellMainPage(isBulkSell:.Feed,item: item)
                case .iconExtra_4: SellMainPage(isBulkSell:.Evolve,item: item)
                }
            }
        }
        
        let txtSkill = UILabel()
            .addFontAndText(font: "Cartwheel", text: "SKILLS", size: view.frame.width*0.05)
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
            
        for x in 0..<(item.icons.count)  {
            
            let skills = MyButton(frame: .zero, item: item, view: skillView, index: x)  { _ in }
            skills.setImage(UIImage(named: item.icons[x]),for: .normal)
            view.addSubview(skills)
            
            let width = (view.frame.width/5)*0.7
            skills.translatesAutoresizingMaskIntoConstraints = false
            skills.heightAnchor.constraint(equalToConstant: width).isActive = true
            skills.widthAnchor.constraint(equalToConstant: width).isActive = true
            skills.centerYAnchor.constraint(equalTo: skillView.centerYAnchor).isActive = true
            
            let marginX = (width+10) * CGFloat(x)+15
            
            skills.trailingAnchor.constraint(equalTo: skillView.trailingAnchor,constant:  -marginX).isActive = true
        }
    }
    
    private func tapArrowChangeDragon(dragon:Dragons,side:Direction) {
        
        if ManagedDB.changeDragonsAction(dragon: dragon, side: side) {
           
            DispatchQueue.main.async { [self] in
               
                let _ = self.view?.subviews.map { $0.removeFromSuperview()}
                
                backgroundBlack(withSpinnerActive: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            
                    self.removeBackgroundBlack(removeBlur: nil)
                    
                    self.didMove(to: self.view!)
                }
            }
        }
    }
    
    //MARK: SHOW VIEW BUY T  ITEM
    private func viewBuyGem<T:ProtocolTableViewGenericCell>(item:[T]){
        
        self.view?.addSubview(templateMainGeneric(typeGrid: .sell, hasCancelBtn: true))
    
        genericTableView(items: item, gameInfo: gameinfo)
       
    }
}

extension DragonsMenuScene {
    
    enum TypeGenericView:String {
        case Sell
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

infix operator &/

extension Int {
    public static func &/(lhs:Int,rhs:Int) -> Int{
        if rhs == 0 {
             return 0
        }
        return lhs/rhs
    }
}
