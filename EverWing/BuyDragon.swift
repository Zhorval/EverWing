//
//  BuyDragon.swift
//  EverWing
//
//  Created by Pablo  on 5/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit
import CoreData


enum ExampleError: Error {
    case invalid
    case uncorrect
}

class BuyDragon:SKScene,ProtocolEffectBlur {
    
    lazy var blurNode: SKEffectNode = SKEffectNode()
    
    let gameInfo = GameInfo.shared
    
    var dragons:BuyEggs? = nil
    
    var dragonFind:DragonsDB? = nil
    
    init(size: CGSize,dragons:BuyEggs) {
        
        self.dragons = dragons

        super.init(size: size)
        
        do {
            self.dragonFind =  try findRandomDragon()
        }catch  ExampleError.invalid {
            print("Error buy dragon.")
        } catch  ExampleError.uncorrect {
            print("Incorrect buy dragon success")
        } catch let error {
            print("Error \(error.localizedDescription)")
        }   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        let _ = self.view?.subviews.filter{$0.restorationIdentifier == "infobar"}.map { $0.removeFromSuperview()}
        
        gameInfo.mainAudio.play(type: .DragonBuy)
        
        self.run(gameInfo.mainAudio.getAction(type: .Egg_Hatch_Start))
        
        loadBackground()
        
        loadEggsAnimation { val in
            self.run(.group([
               
                self.gameInfo.mainAudio.getAction(type: .Egg_Hatch_End_Common),
                .run { [self] in

                    guard let dragonFind = dragonFind else { fatalError()}
                    
                    do {
                        try ManagedDB.shared.saveFoundDragon(dragon: dragonFind)
                        
                        blurScene(blurNode: self.blurNode)
                        
                        loadUI()
                    } catch let error{
                        print("BuyDragon \(error.localizedDescription) ")
                        print(error)
                    }
                }]))
        }
    }
    

    
    
}

extension BuyDragon {
    
    //MARK: LOAD ANIMATION BEGIN SCREEN
    private func loadEggsAnimation(handle:@escaping(Bool)->Void)  {
        
        let node = SKNode()
            node.name = "rootSceneDragonsBuy"
            node.position = CGPoint(x: screenSize.width/2, y: screenSize.maxY)
      
        guard let typeEggs =  self.dragonFind?.dragons?.rarity.rawValue else { fatalError()}
        node.run(.sequence([
            .move(to: CGPoint(x: screenSize.width/2, y: screenSize.height * 0.35), duration: 0.5),
            .repeat(.sequence([
                .scaleY(to: 0.9, duration: 0.25),
                .scaleY(to: 0.8, duration: 0.25),
            ]),count: 8)
        ]),completion: {
            node.childNode(withName: typeEggs+"coverEgg")?.run(.group([
                .rotate(toAngle: -.pi/4, duration: 0.5, shortestUnitArc: true),
                ]), completion: {
                    handle(true)
            })
        })

        
        let eggsBase = SKSpriteNode(imageNamed: typeEggs + "baseEgg")
            eggsBase.size = CGSize(width: screenSize.width/2, height: screenSize.width/1.5)
            eggsBase.anchorPoint = CGPoint(x: 0.5, y: 0)
            eggsBase.position = .zero
            node.addChild(eggsBase)
        
        let sun = SKSpriteNode(imageNamed: "bgSun")
            sun.size = eggsBase.size
            sun.position.y = eggsBase.frame.maxY - 50
            node.addChild(sun)

        
        let sunRotate = SKSpriteNode(imageNamed: "bgSunRotate")
            sunRotate.position.y = eggsBase.frame.maxY - 50
            
            sunRotate.run(.repeatForever(.group([
            .rotate(byAngle: .pi, duration: 1),
            .scale(by: 1.5, duration: 0.5),
            .scale(by: 1, duration: 0.5),
           ])))
            node.addChild(sunRotate)
        
        let eggCover = SKSpriteNode(imageNamed: typeEggs + "CoverEgg")
            eggCover.name = typeEggs + "coverEgg"
            eggCover.anchorPoint = CGPoint(x: 1, y: 0)
            eggCover.size = CGSize(width: screenSize.width/2, height: screenSize.width/1.5)
            eggCover.position = CGPoint(x: eggCover.size.width/2, y: eggsBase.frame.height/3)
        
            node.addChild(eggCover)
        
            addChild(node)
    }
   
    
    //MARK: LOAD SCREEN WHEN FINISH ANIMATION AND MAKE BLUR SCREEN
    private func loadUI() {
        
        guard let dragons = dragonFind,
              let scene = scene ,
            let view = scene.view else { return}

        
        let txtGetDragon = UILabel(frame: .zero)
            .addFontAndText(font: "Cartwheel", text: "\(dragons.dragons!.rarity.rawValue)", size: screenSize.size.width * 0.15)
            .shadowText(colorText: (dragons.dragons?.rarity.color)!, colorShadow: .black, aligment: .center)
       
        view.addSubview(txtGetDragon)
        txtGetDragon.translatesAutoresizingMaskIntoConstraints = false
        txtGetDragon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        txtGetDragon.topAnchor.constraint(equalTo: view.topAnchor,constant: 50).isActive = true
        
        let txtGet = UILabel(frame: .zero)
            .addFontAndText(font: "Cartwheel", text: "GET", size: screenSize.size.width * 0.1)
            .shadowText(colorText: .green, colorShadow: .black, aligment: .center)
        
        view.addSubview(txtGet)
        txtGet.translatesAutoresizingMaskIntoConstraints = false
        txtGet.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        txtGet.topAnchor.constraint(equalTo: txtGetDragon.bottomAnchor,constant: 0).isActive = true
        
        let imgDragon = UIImageView(image:UIImage(named: dragonFind!.dragons!.picture)!)
        view.addSubview(imgDragon)
        
        imgDragon.translatesAutoresizingMaskIntoConstraints = false
        imgDragon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imgDragon.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imgDragon.widthAnchor.constraint(equalToConstant: screenSize.width/2).isActive = true
        imgDragon.heightAnchor.constraint(equalTo: imgDragon.widthAnchor).isActive = true
        imgDragon.layoutIfNeeded()
        
        let txtNameDragon =  UILabel()
            .addFontAndText(font: "Cartwheel", text: dragons.dragons!.name, size: screenSize.size.width * 0.15)
            .shadowText(colorText: .green, colorShadow: .black, aligment: .center)
        view.addSubview(txtNameDragon)
        
        txtNameDragon.translatesAutoresizingMaskIntoConstraints = false
        txtNameDragon.topAnchor.constraint(equalTo: imgDragon.bottomAnchor).isActive = true
        txtNameDragon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let txtDescriptionDragon =  UILabel()
            .addFontAndText(font: "Cartwheel", text: "Monster Killer",size: screenSize.size.width * 0.06)
            .shadowText(colorText: .green, colorShadow: .black, aligment: .center)
        view.addSubview(txtDescriptionDragon)
        
        txtDescriptionDragon.translatesAutoresizingMaskIntoConstraints = false
        txtDescriptionDragon.topAnchor.constraint(equalTo: txtNameDragon.bottomAnchor).isActive = true
        txtDescriptionDragon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       
        let iconSkill = UIImageView(image:UIImage(named:"\(dragons.dragons!.element)_Weakness"))
        view.addSubview(iconSkill)
        
        iconSkill.translatesAutoresizingMaskIntoConstraints = false
        iconSkill.trailingAnchor.constraint(equalTo: imgDragon.leadingAnchor,constant: -25).isActive = true
        iconSkill.centerYAnchor.constraint(equalTo: imgDragon.centerYAnchor).isActive = true
        iconSkill.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iconSkill.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iconSkill.layoutIfNeeded()
        
        let iconHoroscopo = UIImageView(image:UIImage(named:(Dragons.HoroscopeDragon.allCases.randomElement()?.rawValue.lowercased())!))
        iconHoroscopo.layer.backgroundColor = UIColor.white.cgColor
        iconHoroscopo.layer.cornerRadius = iconSkill.frame.width/2
        view.addSubview(iconHoroscopo)
        
        iconHoroscopo.translatesAutoresizingMaskIntoConstraints = false
        iconHoroscopo.leadingAnchor.constraint(equalTo: imgDragon.trailingAnchor,constant: 25).isActive = true
        iconHoroscopo.centerYAnchor.constraint(equalTo: imgDragon.centerYAnchor).isActive = true
        iconHoroscopo.widthAnchor.constraint(equalTo: iconSkill.widthAnchor).isActive = true
        iconHoroscopo.heightAnchor.constraint(equalTo: iconSkill.heightAnchor).isActive = true
        
                
        let btnBuyOneMore = UIButton()
        btnBuyOneMore.setBackgroundImage(UIImage(named: "GreenButton"), for: .normal)
        btnBuyOneMore.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        btnBuyOneMore.setTitle("BUY 1 MORE", for: .normal)
        btnBuyOneMore.titleEdgeInsets = UIEdgeInsets(top: -15, left: 0, bottom: 0, right: 0  )
        view.addSubview(btnBuyOneMore)
        
        btnBuyOneMore.translatesAutoresizingMaskIntoConstraints = false
        btnBuyOneMore.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnBuyOneMore.topAnchor.constraint(equalTo: txtDescriptionDragon.bottomAnchor,constant: 0).isActive = true
        btnBuyOneMore.widthAnchor.constraint(equalToConstant: max(150,screenSize.width*0.3)).isActive = true
        btnBuyOneMore.heightAnchor.constraint(equalToConstant: max(60,screenSize.width*0.3/2)).isActive = true
        btnBuyOneMore.layoutIfNeeded()
        btnBuyOneMore.addAction(for: .touchUpInside) {
            
            /**********************REVISAR ESTS DOS LINEAS DESBORDAMIENTO MEMRIA********************************/
            let _ = view.subviews.filter{$0.tag == 1000}.map { $0.removeFromSuperview()}
          
            self.removeBackgroundBlack(removeBlur: self.blurNode)
/**********************************************************************************/
            self.gameInfo.mainScene = self
            
            let random = BuyEggs.items.filter { $0.picture.rawValue == self.dragons!.picture.rawValue}.first!
            
            let viewAditional = self.showViewBuyAditionalItem(scene: self, items: random,gameInfo: self.gameInfo)
            viewAditional.tag = 1000
            view.addSubview(viewAditional)
        }
        
        let amount = self.dragons?.gemAmount ?? self.dragons?.amount 
    
        let labelPrice = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: 18, weight: .heavy), text: "\(amount)".convertDecimal(), color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        btnBuyOneMore.addSubview(labelPrice)
        
        labelPrice.translatesAutoresizingMaskIntoConstraints = false
        labelPrice.centerXAnchor.constraint(equalTo: btnBuyOneMore.centerXAnchor).isActive = true
        labelPrice.centerYAnchor.constraint(equalTo: btnBuyOneMore.titleLabel!.bottomAnchor,constant: 10).isActive = true
        labelPrice.layoutIfNeeded()

        let icon = self.dragons?.icon as! Currency.CurrencyType
        let iconCoin = UIImageView(image: UIImage(named:(icon.rawValue.lowercased())))
        btnBuyOneMore.addSubview(iconCoin)
        
        iconCoin.translatesAutoresizingMaskIntoConstraints = false
        iconCoin.leadingAnchor.constraint(equalTo: labelPrice.trailingAnchor,constant: 20).isActive = true
        iconCoin.centerYAnchor.constraint(equalTo: btnBuyOneMore.centerYAnchor,constant: 0).isActive = true
        iconCoin.widthAnchor.constraint(equalTo: iconHoroscopo.heightAnchor).isActive = true
        iconCoin.heightAnchor.constraint(equalTo: iconHoroscopo.widthAnchor,constant: 0).isActive = true
        
        
        let btnOk = UIButton()
        btnOk.setBackgroundImage(UIImage(named: "BlueButton"), for: .normal)
        btnOk.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        btnOk.setTitle("OKAY", for: .normal)
        view.addSubview(btnOk)
        
        btnOk.translatesAutoresizingMaskIntoConstraints = false
        btnOk.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnOk.topAnchor.constraint(equalTo: btnBuyOneMore.bottomAnchor,constant: 0).isActive = true
        btnOk.widthAnchor.constraint(equalToConstant: max(150,screenSize.width*0.3)).isActive = true
        btnOk.heightAnchor.constraint(equalToConstant: max(60,screenSize.width*0.3/2)).isActive = true
        
        btnOk.addAction(for: .touchUpInside) {
            let scene = MainScene(size: self.size)
            view.presentScene(scene)
        }
        addChild(self.raySunRotating(point: CGPoint(x: screenSize.midX, y: screenSize.midY),size: CGSize(width: screenSize.width, height: screenSize.width)))
    }
    
    //MARK: LOAD BACKGROUND SCREEN
    private func loadBackground() {
        
        let bg = SKSpriteNode(imageNamed: "gacha_common")
        bg.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
        bg.size = CGSize(width: screenSize.width, height: screenSize.height)
        bg.name = "buyDragonBg"
        addChild(bg)
    }
    
    
    //MARK: FIND RANDOM DRAGON
    private func findRandomDragon() throws -> DragonsDB? {
        
        
        do {
            guard let findTypeEggs = self.dragons?.picture as? Icons.IconsEggs else { return nil}
            
            let fetch = NSFetchRequest<DragonsDB>(entityName: "DragonsDB")
           
            return  try ManagedDB.shared.context.fetch(fetch).filter{($0.dragons?.rarity == Dragons.RarityDragon(rawValue: findTypeEggs.chooseDragon.rawValue)) && ($0.dragons!.picture.contains("T1") == true)}.randomElement()
            
        } catch  {
            throw ExampleError.invalid
        }
       
    }
    
    
    
}
