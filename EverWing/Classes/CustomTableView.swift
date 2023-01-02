//
//  CustomCollectionView.swift
//  Angelica Fighti
//
//  Created by Pablo  on 2/4/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit


protocol ProtocolIcons {
    var  rawValue:String { get }
}

enum Icons{
    
    enum IconsEggs:Hashable,ProtocolIcons {
        case Toxic(Int)
        case King(Int)
        case Common(Int)
        case Bronze(Int)
        case Silver(Int)
        case Golden(Int)
        case Magical(Int)
        case Ancient(Int)
        
        var rawValue:String {
            switch self {
            case .Toxic:   return "Toxic"
            case .King:    return "King"
            case .Common:  return "Common"
            case .Bronze:  return "Bronze"
            case .Silver:  return "Silver"
            case .Golden:  return "Golden"
            case .Magical: return "Magical"
            case .Ancient: return "Ancient"
            }
        }
        
        var chooseDragon:Dragons.RarityDragon {
            switch self {
                
            case .Toxic(_):
                return .Common
            case .King(_):
                return .Common
            case .Common(_):
                return .Common
                
            case .Bronze(let value):
                switch value {
                    case 0..<3:     return .Epic
                    case 3..<14:    return .Rare
                    case 14..<101:  return .Common
                    default:        return .Common
                }
            case .Silver(let value):
                switch value {
                    case 0..<7:     return .Legendary
                    case 7..<13:    return .Epic
                    case 13..<101:  return .Rare
                    default:        return .Rare
                }
            case .Golden(let value):
                switch value {
                    case 0..<2:     return .Mythic
                    case 2..<12:    return .Legendary
                    case 12..<19:   return .Epic
                    case 19..<101:  return .Rare
                    default:        return .Rare
                }
            case .Magical(let value):
                switch value {
                    case 0..<5:     return .Mythic
                    case 5..<19:    return .Legendary
                    case 19..<26:   return .Epic
                    case 26..<101:  return .Rare
                    default:        return .Rare
                }
            case .Ancient(let value):
                switch value {
                    case 0..<15:     return .Mythic
                    case 15..<101:   return .Legendary
                    default:        return .Legendary
                }
            }
        }
    }
    
    enum IconsFruit:String,ProtocolIcons {
        case fruit
        case doubleFruit
        case bagFruit
    }
   
    enum IconsCoin:String,ProtocolIcons {
        case coin
        case Buycoin
        case Buytwocoin
        case Buythreecoin
        case Buyfourcoin
        case Buyfivecoin
        case Buysixcoin
    }
    
    enum IconsSummons:String,ProtocolIcons{
        case silver
        case mega_silver
        case golden
        case mega_golden
      
    }
   
    enum IconsGem:String,ProtocolIcons {
        case gem
    }
}

enum Weakness:String{
   
    case monsterKiller
    case damage
    case bossHoming
    case bombs
    case coinSplit
    case rushFlowers
    case poison
    case itemSpawn
    case itemBoost
    case bossKiller
    case synergy
    case champion
    case sugarRush
    case charm
    case bestFriend
    case treasure
    case slowing
    case dualShot
    case bulletLevel
    case gems
    case magnet
    case toxicity
    case tithe
    case doubleShot
    case ice
    case spreadShot
}

protocol BaseProtocol {}

protocol ProtocolWeakness:BaseProtocol {
    var icons:[String] { get set }
}

protocol ProtocolIconsExtra:BaseProtocol {
    associatedtype A
    static var items: [A] { get set }
}


protocol ProtocolTableViewGenericCell:BaseProtocol {
  
    static var items:[Self]        { get }
    var picture:ProtocolIcons      { get }
    var name:String                { get }
    var title:String               { get }
    var amount:Int                 { get }
    var gemAmount:CGFloat?         { get }
    var icon:ProtocolCurrency      { get }
}

struct IconsExtra:Equatable {
    
    enum BtnIcons:String,CaseIterable,Equatable,BaseProtocol {
        case iconExtra_0
        case iconExtra_1
        case iconExtra_2
        case iconExtra_3
        case iconExtra_4
        
        static func == (lhs:BtnIcons,rhs:BtnIcons) -> Bool {
            return lhs.title  == rhs.title
        }
        
        var title: String {
            switch self {
            case .iconExtra_0: return "Equip\nLeft"
            case .iconExtra_1: return "Equip\nRight"
            case .iconExtra_2: return "Sell"
            case .iconExtra_3: return "Feed"
            case .iconExtra_4: return "Evolve"
            }
        }
    }
    
    static var items: [IconsExtra.BtnIcons] = BtnIcons.allCases
}


struct BuySummons:ProtocolTableViewGenericCell {
    
    typealias A = [BuySummons]
    
    var picture: ProtocolIcons
    
    var name: String
    
    var title: String
    
    var amount: Int
    
    var gemAmount: CGFloat?
    
    var icon: ProtocolCurrency
    
    static var items: [Self] = [
        BuySummons(picture: Icons.IconsSummons.silver,name: "SILVER SUMMON", title: "1x STAR SHARD", amount: 9600,icon:Currency.CurrencyType.Coin),
        BuySummons(picture: Icons.IconsSummons.mega_silver,name: "MEGA SILVER SUMMON", title: "11x STAR SHARD", amount: 96000, icon:Currency.CurrencyType.Coin),
        BuySummons(picture: Icons.IconsSummons.golden,name: "GOLDEN SUMMON", title: "1x STAR SHARD", amount: 175, icon:Currency.CurrencyType.Gem),
        BuySummons(picture: Icons.IconsSummons.mega_golden,name: "MEGA GOLDEN SUMMON", title: "11x STAR SHARD", amount: 1750, icon:Currency.CurrencyType.Gem)
    ]
}

struct BuyFruit:ProtocolTableViewGenericCell {
    
    typealias A = BuyFruit
    
    var picture: ProtocolIcons
    
    var name: String
    
    var title: String
    
    var amount: Int
    
    var icon: ProtocolCurrency
    
    var gemAmount:CGFloat?
    
    static var items: [Self] = [
        BuyFruit(picture: Icons.IconsFruit.fruit,name: "", title: "", amount: 25,icon:Currency.CurrencyType.Gem,gemAmount:50),
        BuyFruit(picture:Icons.IconsFruit.doubleFruit,name: "", title: "125 + 25 BONUS", amount: 150,icon:Currency.CurrencyType.Gem,gemAmount:250),
        BuyFruit(picture:Icons.IconsFruit.bagFruit,name: "", title: "250 + 75 BONUS", amount: 325,icon:Currency.CurrencyType.Gem,gemAmount:500),
        BuyFruit(picture:Icons.IconsFruit.bagFruit,name: "", title: "500 + 200 BONUS", amount: 700,icon:Currency.CurrencyType.Gem,gemAmount:1000),
        BuyFruit(picture:Icons.IconsFruit.bagFruit,name: "",title: "1000 + 500 BONUS", amount: 1500,icon:Currency.CurrencyType.Gem,gemAmount:2000),
        BuyFruit(picture:Icons.IconsFruit.bagFruit,name: "",title: "2500 + 2000 BONUS", amount: 2500,icon:Currency.CurrencyType.Gem,gemAmount:5000)]
}

struct BuyGem:ProtocolTableViewGenericCell {
    
    typealias A = BuyGem
    
    var picture: ProtocolIcons
    
    var name: String
    
    var title: String
    
    var amount: Int
    
    var icon: ProtocolCurrency
    
    var gemAmount:CGFloat?

    static var items: [Self] = [
        BuyGem(picture:Icons.IconsFruit.fruit,name: "", title: "", amount: 25,icon:Currency.CurrencyType.Gem,gemAmount:50),
        BuyGem(picture:Icons.IconsFruit.doubleFruit,name: "", title: "125 + 25 BONUS", amount: 150,icon:Currency.CurrencyType.Gem,gemAmount:250),
        BuyGem(picture:Icons.IconsFruit.bagFruit,name: "", title: "250 + 75 BONUS", amount: 325,icon:Currency.CurrencyType.Gem,gemAmount:500),
        BuyGem(picture:Icons.IconsFruit.bagFruit,name: "", title: "500 + 200 BONUS", amount: 700,icon:Currency.CurrencyType.Gem,gemAmount:1000),
        BuyGem(picture:Icons.IconsFruit.bagFruit,name: "",title: "1000 + 500 BONUS", amount: 1500,icon:Currency.CurrencyType.Gem,gemAmount:2000),
        BuyGem(picture:Icons.IconsFruit.bagFruit,name: "",title: "2500 + 2000 BONUS", amount: 2500,icon:Currency.CurrencyType.Gem,gemAmount:5000)]
}

struct BuyCoins:ProtocolTableViewGenericCell {
    
    typealias A = BuyCoins
    
    var picture: ProtocolIcons
    
    var name: String
    
    var title: String
    
    var amount: Int
    
    var icon: ProtocolCurrency
    
    var gemAmount:CGFloat?

    static var items: [Self] = [
        BuyCoins(picture: Icons.IconsCoin.Buycoin,name: "", title: "", amount: 2000,icon:Currency.CurrencyType.Gem,gemAmount:40),
        BuyCoins(picture: Icons.IconsCoin.Buytwocoin,name: "", title: "10000 + 1600 BONUS", amount: 11600,icon:Currency.CurrencyType.Gem,gemAmount:200),
        BuyCoins(picture: Icons.IconsCoin.Buythreecoin,name: "", title: "20000 + 4000 BONUS", amount: 24000,icon:Currency.CurrencyType.Gem,gemAmount:400),
        BuyCoins(picture: Icons.IconsCoin.Buyfourcoin,name: "", title: "40000 + 10000 BONUS", amount: 50000,icon:Currency.CurrencyType.Gem,gemAmount:800),
        BuyCoins(picture: Icons.IconsCoin.Buyfivecoin,name: "",title: "80000 + 26000 BONUS", amount: 106000,icon:Currency.CurrencyType.Gem,gemAmount:1600),
        BuyCoins(picture: Icons.IconsCoin.Buysixcoin,name: "",title: "200000 + 80000 BONUS", amount: 280000,icon:Currency.CurrencyType.Gem,gemAmount:4000)]
}

struct BuyEggs:ProtocolTableViewGenericCell,Equatable {
   
    static func == (lhs: BuyEggs, rhs: BuyEggs) -> Bool {
        return lhs.name == rhs.name && lhs.picture.rawValue ==  rhs.picture.rawValue && lhs.title == rhs.title && lhs.amount == rhs.amount && lhs.gemAmount == rhs.gemAmount
    }
    
    typealias A = BuyEggs
    
    var picture: ProtocolIcons
    
    var name: String
    
    var title: String
    
    var amount: Int
    
    var icon: ProtocolCurrency
    
    var gemAmount: CGFloat?
    
    static var items: [Self] = [
        BuyEggs(picture: Icons.IconsEggs.King(randomInt(min: 0, max: 100)),
                name: "KING´S COURT", title: "GUARATEED\nKING´S COURT SIDEKIT", amount: 100,icon:Currency.CurrencyType.Gem),
        BuyEggs(picture:Icons.IconsEggs.Toxic(randomInt(min: 0, max: 100)),
                name: "TOXIC",title: "A TOXIC AVENGER", amount: 100,icon:Currency.CurrencyType.Gem),
        BuyEggs(picture:Icons.IconsEggs.Common(randomInt(min: 0, max: 100)),
                name: "Common",title: "Common Dragon Egg", amount: 640,icon:Currency.CurrencyType.Coin),
        BuyEggs(picture:Icons.IconsEggs.Bronze(randomInt(min: 0, max: 100)),
                name: "Bronze",title: "Bronze Dragon Egg", amount: 3200,icon:Currency.CurrencyType.Coin),
        BuyEggs(picture:Icons.IconsEggs.Silver(randomInt(min: 0, max: 100)),
                name: "Silver",title: "Silver Dragon Egg", amount: 16000,icon:Currency.CurrencyType.Coin),
        BuyEggs(picture:Icons.IconsEggs.Golden(randomInt(min: 0, max: 100)),
                name: "Golden",title: "Golden Dragon Egg", amount: 32000,icon:Currency.CurrencyType.Coin),
        BuyEggs(picture:Icons.IconsEggs.Magical(randomInt(min: 0, max: 100)),
                name: "Magical",title: "Magical Dragon Egg",amount: 200,icon:Currency.CurrencyType.Coin),
        BuyEggs(picture:Icons.IconsEggs.Ancient(randomInt(min: 0, max: 100)),
                name: "Ancient",title: "Ancient Dragon Egg",amount: 700,icon:Currency.CurrencyType.Coin)]
}

class GenericTableView<T:ProtocolTableViewGenericCell,Cell:UITableViewCell>: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    
    var items:[T] {
        didSet {
             reloadData()
        }
    }
    
    var selectHandler:(T) -> Void
    
    
    init(frame:CGRect, items:[T],selectHandler:@escaping(T)->Void) {
        self.items = items
        self.selectHandler = selectHandler
        super.init(frame: frame, style: .grouped)
        self.register(Cell.self, forCellReuseIdentifier: "Cell")
        self.delegate = self
        self.dataSource = self
        backgroundColor = .clear
        self.bounces = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
         if T.self is Toon.Character.Table.Type {
              return 120
         }
         
         return tableView.contentSize.width*0.95/2
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell

         let view = configureCell(cell: cell, item: items[indexPath.row])
         
        cell.addSubview(view)
         
        return cell
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if T.self is Toon.Character.Table.Type {
           return configureHeader(item: items[section])
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if T.self is Toon.Character.Table.Type {
            return 200
        }
        return 0
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         if T.self is Toon.Character.Table.Type {
             return
         }
         selectHandler(items[indexPath.row])
    }
    
    @objc func tapBuyGem(_ sender:UIButton) {
        print("Pulsado tap")
    }
}

extension GenericTableView {
    
    func configureCell(cell:Cell,item:T) -> UIView  {
        
        self.separatorColor = .brown
        self.separatorStyle = .singleLine
        self.separatorInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        
        if item is BuyEggs {
            
            return configureCellEggs(cell: cell, item: item)
       
        } else if item is BuyCoins {
            
            return configureCellCoin(cell: cell, item: item)
            
        } else if item is BuySummons {
          
            return configureCellSummons(cell: cell, item: item)
            
        } else if item is Toon.Character.Table {
            
            return configureCellCharacterStar(cell:cell,item:item)
        }
        
        return configureCellGem(cell:cell,item:item)
    }
    
    func configureCellCharacterStar(cell:Cell,item:T) -> UIView {
        
        let width = contentSize.width*0.98
        
        let height = width/3
        
        cell.backgroundColor = .clear
        
        cell.selectionStyle = .none
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        let layer = CAGradientLayer()
            layer.frame = view.frame
            let colorTop = UIColor().randomColor().cgColor
            let colorBottom = UIColor().randomColor().cgColor
            layer.borderColor = UIColor.black.cgColor
            layer.borderWidth = 2
            layer.cornerRadius = 10
            layer.colors = [colorTop, colorBottom]
            layer.startPoint = CGPoint(x:0.5, y:1)
            layer.endPoint = CGPoint(x:0.4, y:0.5)
        
       
        view.layer.addSublayer(layer)
        
        let title = UILabel()
            .addTextWithFont(font: UIFont(name: "Cartwheel", size: view.frame.width*0.1)!, text: item.title, color: .yellow)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .right)
            view.addSubview(title)
            title.translatesAutoresizingMaskIntoConstraints = false
            title.topAnchor.constraint(equalTo: view.topAnchor,constant: 5).isActive = true
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5).isActive = true
        
        let nString = Int(item.title.components(separatedBy: " ")[0])
        view.drawStart(number: nString! , margin: .right, size: CGSize(width: view.frame.width*0.045, height: view.frame.width*0.045),totalStart: nString!-1)
        let imageL = UIImageView(image: UIImage(named:"BulletButton")!)
            view.addSubview(imageL)
            imageL.translatesAutoresizingMaskIntoConstraints = false
            imageL.leadingAnchor.constraint(equalTo: title.leadingAnchor).isActive = true
            imageL.topAnchor.constraint(equalTo: title.bottomAnchor).isActive = true
            imageL.widthAnchor.constraint(equalToConstant: view.frame.height*0.6).isActive = true
            imageL.heightAnchor.constraint(equalTo: imageL.widthAnchor).isActive = true
            imageL.layoutIfNeeded()
        
        let iconL = UIImageView(image: UIImage(named:"d1")!.resized(to: imageL.frame.insetBy(dx: 5, dy: 15).size))
            view.addSubview(iconL)
            iconL.translatesAutoresizingMaskIntoConstraints = false
            iconL.centerXAnchor.constraint(equalTo: imageL.centerXAnchor).isActive = true
            iconL.centerYAnchor.constraint(equalTo: imageL.centerYAnchor).isActive = true
        
        let arrowL = UIImageView(image: UIImage(named:"arrowUpYellow")!)
            view.addSubview(arrowL)
            arrowL.translatesAutoresizingMaskIntoConstraints = false
            arrowL.trailingAnchor.constraint(equalTo: imageL.trailingAnchor).isActive = true
            arrowL.bottomAnchor.constraint(equalTo: imageL.bottomAnchor).isActive = true
            arrowL.widthAnchor.constraint(equalToConstant: 30).isActive = true
            arrowL.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let damage = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: view.frame.width*0.035, weight: .heavy), text: "Damage Bonus", color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
            view.addSubview(damage)
            damage.translatesAutoresizingMaskIntoConstraints = false
            damage.topAnchor.constraint(equalTo: imageL.topAnchor,constant: 10).isActive = true
            damage.leadingAnchor.constraint(equalTo: imageL.trailingAnchor,constant:0).isActive = true
        
        let damageVal = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: 18, weight: .heavy), text: "+\(item.amount)%", color: .white)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
            view.addSubview(damageVal)
            damageVal.translatesAutoresizingMaskIntoConstraints = false
            damageVal.topAnchor.constraint(equalTo: damage.bottomAnchor,constant: 5).isActive = true
            damageVal.centerXAnchor.constraint(equalTo: damage.centerXAnchor,constant:0).isActive = true
        
        let imageR = UIImageView(image: UIImage(named:"BulletButton")!)
            view.addSubview(imageR)
            imageR.translatesAutoresizingMaskIntoConstraints = false
            imageR.leadingAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            imageR.topAnchor.constraint(equalTo: imageL.topAnchor).isActive = true
            imageR.widthAnchor.constraint(equalTo: imageL.widthAnchor).isActive = true
            imageR.heightAnchor.constraint(equalTo: imageL.heightAnchor).isActive = true
            imageR.layoutIfNeeded()
        
        let iconR = UIImageView(image: UIImage(named:item.icon.name)!.resized(to: imageR.frame.insetBy(dx: 5, dy: 5).size))
            view.addSubview(iconR)
            iconR.translatesAutoresizingMaskIntoConstraints = false
            iconR.centerXAnchor.constraint(equalTo: imageR.centerXAnchor).isActive = true
            iconR.centerYAnchor.constraint(equalTo: imageR.centerYAnchor).isActive = true
        
        let arrowR = UIImageView(image: UIImage(named:"arrowUpYellow")!)
            view.addSubview(arrowR)
            arrowR.translatesAutoresizingMaskIntoConstraints = false
            arrowR.trailingAnchor.constraint(equalTo: imageR.trailingAnchor).isActive = true
            arrowR.bottomAnchor.constraint(equalTo: imageR.bottomAnchor).isActive = true
            arrowR.widthAnchor.constraint(equalToConstant: 30).isActive = true
            arrowR.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let ability = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: view.frame.width*0.035, weight: .heavy), text: item.icon.name, color: .white)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
            view.addSubview(ability)
            ability.translatesAutoresizingMaskIntoConstraints = false
            ability.leadingAnchor.constraint(equalTo: imageR.trailingAnchor,constant:0).isActive = true
            ability.topAnchor.constraint(equalTo: imageR.topAnchor,constant: 10).isActive = true
            ability.leadingAnchor.constraint(equalTo: imageR.trailingAnchor,constant:0).isActive = true
        
        let abilityVal = UILabel()
            .addTextWithFont(font: UIFont.systemFont(ofSize: 18, weight: .heavy), text: String(format: "%0.f%%",item.gemAmount!), color: .white)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
            view.addSubview(abilityVal)
            abilityVal.translatesAutoresizingMaskIntoConstraints = false
            abilityVal.topAnchor.constraint(equalTo: ability.bottomAnchor,constant: 5).isActive = true
            abilityVal.centerXAnchor.constraint(equalTo: ability.centerXAnchor,constant:0).isActive = true
        
        return view
    }
    
    func configureCellEggs(cell:Cell,item:T) -> UIView {
        
        let margin = contentSize.width*0.15/4
        
        let width = contentSize.width*0.85
        
        let height = width/2
        
        let sizeEgg = CGSize(width: width * 0.25, height: width * 0.35)
        
        cell.backgroundColor = .clear
        
        cell.selectionStyle = .none
       
        let view = UIView(frame: CGRect(x: margin, y: 0, width: width, height: height))
        
        let layer = CAGradientLayer()
            layer.frame = view.frame
            let colorTop = UIColor().randomColor().cgColor
            let colorBottom = UIColor().randomColor().cgColor
        
            layer.borderColor = UIColor.black.cgColor
            layer.borderWidth = 2
            layer.cornerRadius = 10
        
        layer.colors = [colorTop, colorBottom]
            layer.startPoint = CGPoint(x:0.2, y:0.5)
            layer.endPoint = CGPoint(x:0.4, y:0.5);
        
        view.layer.addSublayer(layer)
        
        let image = UIImageView(frame: CGRect(origin: CGPoint(x: 20, y: height/4), size: sizeEgg))
        image.contentMode = .scaleAspectFit
        
        image.image = UIImage(named: item.picture.rawValue)
         
        image.transform = CGAffineTransformMakeRotation(-CGFloat(25).toRadians())

        view.addSubview(image)
        
        let name = UILabel(frame: CGRect(x: view.frame.width*0.3, y:view.frame.height * 0.15, width:  view.frame.width*0.7,height: view.frame.height*0.3))
            .addTextWithFont(font: UIFont(name: "Cartwheel", size: view.frame.width*0.1)!, text: item.name, color: .yellow)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .right)
        
        view.addSubview(name)
        
        let title = UILabel(frame: CGRect(x: view.frame.width*0.3, y: view.frame.height * 0.40, width: view.frame.width*0.7, height: view.frame.height*0.2))
            .addTextWithFont(font: UIFont(name: "Cartwheel", size: view.frame.width*0.07)!, text: item.title, color: .yellow)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        title.adjustsFontSizeToFitWidth = true
           
        view.addSubview(title)
        
        let amount = UILabel(frame: CGRect(x: view.frame.width*0.3, y: view.frame.height * 0.65, width: view.frame.width*0.55, height: view.frame.height*0.3))
            .addTextWithFont(font: UIFont(name: "Cartwheel", size: view.frame.width*0.1)!,text: String(item.amount).convertDecimal(), color: .yellow)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .right)
            view.addSubview(amount)
        
        let icon = UIImageView(frame: CGRect(x: view.frame.width*0.9,y: view.frame.height * 0.65, width: view.frame.width*0.15,height: view.frame.width*0.15))
            icon.contentMode = .scaleAspectFit
            icon.image = UIImage(named:item.icon.name)
        view.addSubview(icon)
        
        return view
        
    }
    
    func configureCellCoin(cell:Cell,item:T) -> UIView {
        
        let margin = contentSize.width*0.15/4
        
        let width = contentSize.width*0.8
        
        let height = width/2
        
        cell.backgroundColor = .clear
        
        cell.selectionStyle = .none
       
        let view = UIView(frame: CGRect(x: margin, y: 0, width: width, height: height))
        
        let image = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: height/2), size: CGSize(width: height*0.4, height: height*0.4)))
       
            image.contentMode = .scaleAspectFit
            
            image.image = UIImage(named: item.picture.rawValue)

        view.addSubview(image)
        
        let amount = UILabel(frame: CGRect(x: view.frame.width*0.25, y: view.frame.height/2, width: view.frame.width*0.4,
                                           height: view.frame.height*0.3))
            amount.adjustsFontSizeToFitWidth = true
            amount.textAlignment = .center
        
        let gradient = UIImage.gradientImage(bounds: amount.bounds, colors: [.orange, .yellow,.white])
            amount.font = UIFont(name: "Cartwheel", size: view.frame.width*0.13)
            amount.textColor = UIColor(patternImage: gradient)
            amount.shadowOffset = CGSize(width: 1, height: 1)
            amount.shadowColor = .black
            amount.layer.shadowRadius = 5
            amount.text = String(item.amount).convertDecimal()
        view.addSubview(amount)
        
        let title = UILabel(frame: CGRect(x: view.frame.width/4, y: view.frame.height*0.75, width: view.frame.width*0.8, height: view.frame.height*0.2))
            title.font = UIFont(name: "AvenirNext-Bold", size: view.frame.width*0.05)
            title.textColor = .brown
            title.text = item.title
            title.textAlignment = .center
        
        let button =  UIButton(frame: CGRect(x: view.frame.width*0.75, y: view.frame.width*0.2, width: view.frame.width*0.4, height: view.frame.width*0.2))

            button.contentHorizontalAlignment = .fill
            button.contentVerticalAlignment = .fill
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(tapBuyGem(_ :)), for: .touchUpInside)
        
        let imageBtn = UIImage(named: "BlueButton")
            button.setImage(imageBtn, for: .normal)
        
        let countBtn = UILabel(frame: CGRect(x: button.frame.width*0.1, y: 0, width: button.frame.width/2, height: button.frame.height))
      
        let gradientBtn = UIImage.gradientImage(bounds: countBtn.bounds, colors: [.white,.gray])
            countBtn.font = UIFont(name: "Cartwheel", size: view.frame.width*0.08)
            countBtn.textColor = UIColor(patternImage: gradientBtn)
            countBtn.shadowOffset = CGSize(width: 1, height: 1)
            countBtn.shadowColor = .black
            countBtn.layer.shadowRadius = 5
            countBtn.textAlignment = .right
            countBtn.text = String(Int(item.gemAmount!)).convertDecimal()
            button.addSubview(countBtn)
        
        let iconGem = UIImageView(frame: CGRect(x: button.frame.width*0.65, y: button.frame.width*0.1, width: button.frame.width*0.25, height: button.frame.width*0.25))
            iconGem.image = UIImage(named: "gem")
            button.addSubview(iconGem)
        
        view.addSubview(button)
        view.addSubview(title)
        
        
        return view
    }

    func configureCellGem(cell:Cell,item:T) -> UIView {
        
        let margin = contentSize.width*0.15/4
        
        let width = contentSize.width*0.8
        
        let height = width/2
        
        cell.backgroundColor = .clear
        
        cell.selectionStyle = .none
       
        let view = UIView(frame: CGRect(x: margin, y: 0, width: width, height: height))
        
        let image = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: height/2), size: CGSize(width: height*0.7, height: height*0.7)))
       
        image.contentMode = .scaleAspectFit
        
        image.image = UIImage(named: item.picture.rawValue)

        view.addSubview(image)
        
        let amount = UILabel(frame: CGRect(x: view.frame.width*0.3, y: view.frame.height/2, width: view.frame.width*0.4,
                                           height: view.frame.height*0.3))
        
        amount.adjustsFontSizeToFitWidth = true
        amount.textAlignment = .center
        
        let gradient = UIImage.gradientImage(bounds: amount.bounds, colors: [.orange, .yellow,.white])
        amount.font = UIFont(name: "Cartwheel", size: view.frame.width*0.13)
        amount.textColor = UIColor(patternImage: gradient)
        amount.shadowOffset = CGSize(width: 1, height: 1)
        amount.shadowColor = .black
        amount.layer.shadowRadius = 5
        amount.text = String(item.amount).convertDecimal()
        view.addSubview(amount)
        
        let title = UILabel(frame: CGRect(x: view.frame.width/4, y: view.frame.height*0.75, width: view.frame.width*0.8, height: view.frame.height*0.2))
            title.font = UIFont(name: "AvenirNext-Bold", size: view.frame.width*0.05)
            title.textColor = .brown
            title.text = item.title
            title.textAlignment = .center
        
            let button =  UIButton(frame: CGRect(x: view.frame.width*0.75, y: view.frame.width*0.2, width: view.frame.width*0.4, height: view.frame.width*0.2))

            button.contentHorizontalAlignment = .fill
            button.contentVerticalAlignment = .fill
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(tapBuyGem(_ :)), for: .touchUpInside)
        
            let imageBtn = UIImage(named: "BlueButton")
            button.setImage(imageBtn, for: .normal)
        
        let countBtn = UILabel(frame: CGRect(x: button.frame.width*0.1, y: 0, width: button.frame.width/2, height: button.frame.height))
      
        let gradientBtn = UIImage.gradientImage(bounds: countBtn.bounds, colors: [.white,.gray])
            countBtn.font = UIFont(name: "Cartwheel", size: view.frame.width*0.08)
            countBtn.textColor = UIColor(patternImage: gradientBtn)
            countBtn.shadowOffset = CGSize(width: 1, height: 1)
            countBtn.shadowColor = .black
            countBtn.layer.shadowRadius = 5
            countBtn.textAlignment = .right
            countBtn.text = String(Int(item.gemAmount ?? CGFloat(item.amount))).convertDecimal()
            button.addSubview(countBtn)
        
        let iconGem = UIImageView(frame: CGRect(x: button.frame.width*0.65, y: button.frame.width*0.1, width: button.frame.width*0.25, height: button.frame.width*0.25))
            iconGem.image = UIImage(named: "gem")
            button.addSubview(iconGem)
        
        view.addSubview(button)
        view.addSubview(title)
        
        
        return view
    }
    
    func configureCellSummons(cell:Cell,item:T) -> UIView {
        
        self.bounces = false
        
        let margin = contentSize.width*0.15/4
        
        let width = contentSize.width*0.9
        
        let height = width/2
        
        cell.backgroundColor = .clear
        
        cell.selectionStyle = .none
       
        let view = UIView(frame: CGRect(x: margin, y: 0, width: width, height: height))
        
        let image = UIImageView(frame: view.frame)
            image.image = UIImage(named: item.picture.rawValue)
        view.addSubview(image)
        
        let title = UILabel()
            .addTextWithFont(font: UIFont(name: "Cartwheel", size: 25)!, text: item.name,color: .clear)
            .shadowText(colorText: UIColor(patternImage: UIImage.gradientImage(bounds: image.bounds, colors: [.yellow,.orange])), colorShadow: .black, aligment: .center)
        image.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.trailingAnchor.constraint(equalTo: image.trailingAnchor,constant: -10).isActive = true
        title.topAnchor.constraint(equalTo: image.topAnchor,constant: 15).isActive = true
        
        let subTitle = UILabel()
            .addTextWithFont(font: UIFont(name: "Cartwheel", size: 24)!, text: item.title, color: .clear)
            .shadowText(colorText: UIColor(patternImage: UIImage.gradientImage(bounds: image.bounds, colors: [.white,.black])), colorShadow: .black, aligment: .center)
        view.addSubview(subTitle)
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.trailingAnchor.constraint(equalTo: title.trailingAnchor,constant: 0).isActive = true
        subTitle.topAnchor.constraint(equalTo: title.bottomAnchor,constant: 5).isActive = true
        
        let icons = UIImageView(image: UIImage(named: item.icon.name))
        view.addSubview(icons)
            icons.translatesAutoresizingMaskIntoConstraints = false
            icons.trailingAnchor.constraint(equalTo: subTitle.trailingAnchor,constant: 0).isActive = true
            icons.topAnchor.constraint(equalTo: subTitle.bottomAnchor,constant: 10).isActive = true
            icons.widthAnchor.constraint(equalToConstant: 50).isActive = true
            icons.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let price = UILabel()
            .addTextWithFont(font: UIFont(name: "Cartwheel", size: 30)!, text: "\(item.amount)".convertDecimal() , color: .clear)
            .shadowText(colorText: UIColor(patternImage: UIImage.gradientImage(bounds: image.bounds, colors: [.systemOrange,.systemYellow,.systemRed])), colorShadow: .black, aligment: .center)
        view.addSubview(price)
        price.translatesAutoresizingMaskIntoConstraints = false
        price.trailingAnchor.constraint(equalTo: icons.leadingAnchor,constant: -10).isActive = true
        price.centerYAnchor.constraint(equalTo: icons.centerYAnchor,constant: 0).isActive = true
        
        let iconCard = UIImageView(image: UIImage(named: item.picture.rawValue.contains("silver") ? "silver_Card_Star" : "golden_Card_Star"))
            iconCard.contentMode = .scaleToFill
            image.addSubview(iconCard)
            iconCard.translatesAutoresizingMaskIntoConstraints = false
            iconCard.heightAnchor.constraint(equalToConstant: image.frame.height*0.8).isActive = true
            iconCard.widthAnchor.constraint(equalToConstant: image.frame.width*0.25).isActive = true
            iconCard.centerYAnchor.constraint(equalTo:image.centerYAnchor).isActive = true
            iconCard.leadingAnchor.constraint(equalTo:image.leadingAnchor,constant: 10).isActive = true

        if item.picture.rawValue.contains("mega") {
            let txtX = UILabel()
                .addTextWithFont(font: UIFont.systemFont(ofSize: 30, weight: .heavy), text: "x11".convertDecimal() , color: .clear)
                .shadowText(colorText: UIColor(patternImage: UIImage.gradientImage(bounds: image.bounds, colors: [.yellow,.orange])), colorShadow: .black, aligment: .center)
            iconCard.addSubview(txtX)
            txtX.translatesAutoresizingMaskIntoConstraints = false
            txtX.centerXAnchor.constraint(equalTo: iconCard.trailingAnchor,constant: 0).isActive = true
            txtX.bottomAnchor.constraint(equalTo: iconCard.bottomAnchor,constant: 0).isActive = true
        }
        
        return view
    }
    
    func configureHeader(item:T) -> UIView? {
        
        if T.self is Toon.Character.Table.Type {
            
            var rectangleView:UIView {
                
                let view = UIView(frame: CGRect(x: 5, y: 0, width: contentSize.width*0.95, height: contentSize.width*0.2))
                    /*.addRect(size: CGRect(x: 5, y: 0, width: contentSize.width*0.95, height: contentSize.width*0.2), fillColor: .brown.withAlphaComponent(0.5), strokeColor: .brown.withAlphaComponent(0.5))
                */
                return view
            }
            
            do {
                
                let callDB = ManagedDB.shared
                let character = try callDB.getCharacterByName(name: Toon.Character(rawValue: item.name)!)
                
                let backRect = rectangleView
                    self.addSubview(backRect)
                    backRect.backgroundColor = .red
                    backRect.translatesAutoresizingMaskIntoConstraints = false
                    backRect.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant:0).isActive = true
                    backRect.topAnchor.constraint(equalTo: self.topAnchor,constant: 25).isActive = true
                    backRect.widthAnchor.constraint(equalToConstant: backRect.frame.width).isActive = true
                    backRect.heightAnchor.constraint(equalToConstant: backRect.frame.height).isActive = true
              
                let iconCharacter = UIImageView(image: UIImage(named: "character_cards_\(character.characters.name.rawValue)")!)
                    backRect.addSubview(iconCharacter)
                    iconCharacter.translatesAutoresizingMaskIntoConstraints = false
                    iconCharacter.leadingAnchor.constraint(equalTo: backRect.leadingAnchor,constant:15).isActive = true
                    iconCharacter.topAnchor.constraint(equalTo: backRect.topAnchor,constant: -10).isActive = true
                    iconCharacter.widthAnchor.constraint(equalToConstant: contentSize.width*0.2).isActive = true
                    iconCharacter.heightAnchor.constraint(equalToConstant: contentSize.width*0.25).isActive = true
                
                let txtName = UILabel()
                    .addTextWithFont(font: UIFont.systemFont(ofSize: 20, weight: .heavy), text: (character.characters.name.rawValue.uppercased()), color: .clear)
                    .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
                    backRect.addSubview(txtName)
                    txtName.translatesAutoresizingMaskIntoConstraints = false
                    txtName.leadingAnchor.constraint(equalTo: iconCharacter.trailingAnchor,constant:0).isActive = true
                    txtName.topAnchor.constraint(equalTo: backRect.topAnchor,constant: 10).isActive = true
                
                let txtDescription = UILabel()
                    .addTextWithFont(font: UIFont.systemFont(ofSize: 16, weight: .heavy), text: (character.characters.title!), color: .clear)
                    .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
                    backRect.addSubview(txtDescription)
                    txtDescription.translatesAutoresizingMaskIntoConstraints = false
                    txtDescription.leadingAnchor.constraint(equalTo: txtName.leadingAnchor,constant:0).isActive = true
                    txtDescription.topAnchor.constraint(equalTo: txtName.bottomAnchor,constant: 0).isActive = true
                    
                let backRectAbility = rectangleView
                    self.addSubview(backRectAbility)
                    backRectAbility.backgroundColor = .red
                    backRectAbility.translatesAutoresizingMaskIntoConstraints = false
                    backRectAbility.leadingAnchor.constraint(equalTo: backRect.leadingAnchor,constant:0).isActive = true
                    backRectAbility.topAnchor.constraint(equalTo: iconCharacter.bottomAnchor,constant: 5).isActive = true
                    backRectAbility.widthAnchor.constraint(equalTo: backRect.widthAnchor).isActive = true
                    backRectAbility.heightAnchor.constraint(equalTo:backRect.heightAnchor).isActive = true
              
                let iconAbility = UIImageView(image: UIImage(named: item.picture.rawValue)!)
                    backRectAbility.addSubview(iconAbility)
                    iconAbility.translatesAutoresizingMaskIntoConstraints = false
                    iconAbility.leadingAnchor.constraint(equalTo: iconCharacter.leadingAnchor,constant:0).isActive = true
                    iconAbility.centerYAnchor.constraint(equalTo: iconCharacter.bottomAnchor,constant: 40).isActive = true
                    iconAbility.widthAnchor.constraint(equalTo:iconCharacter.widthAnchor).isActive = true
                    iconAbility.heightAnchor.constraint(equalTo:iconCharacter.widthAnchor).isActive = true
                
                let txtAbility = UILabel()
                    .addTextWithFont(font: UIFont.systemFont(ofSize: 20, weight: .heavy), text: (character.characters.ability!.rawValue.uppercased()), color: .clear)
                    .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
                    backRectAbility.addSubview(txtAbility)
                    txtAbility.translatesAutoresizingMaskIntoConstraints = false
                    txtAbility.leadingAnchor.constraint(equalTo: txtName.leadingAnchor,constant:0).isActive = true
                    txtAbility.topAnchor.constraint(equalTo: backRectAbility.topAnchor,constant: 10).isActive = true
                
                let txtDesAbility = UILabel()
                    .addTextWithFont(font: UIFont.systemFont(ofSize: 16, weight: .heavy), text: (character.characters.shortDescription!), color: .clear)
                    .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
                    backRectAbility.addSubview(txtDesAbility)
                    txtDescription.numberOfLines = 0
                    txtDesAbility.translatesAutoresizingMaskIntoConstraints = false
                    txtDesAbility.leadingAnchor.constraint(equalTo: txtAbility.leadingAnchor,constant:0).isActive = true
                    txtDesAbility.topAnchor.constraint(equalTo: txtAbility.bottomAnchor,constant: 0).isActive = true
                
                return backRect
                
            } catch {
                fatalError()
            }
        }
        return nil
        
    }
}




