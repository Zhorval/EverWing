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


enum Icons:String,Hashable{
    case Common
    case Bronze
    case Silver
    case Golden
    case Magical
    case Ancient
    case fruit
    case doubleFruit
    case bagFruit
    case coin
    case Buycoin
    case Buytwocoin
    case Buythreecoin
    case Buyfourcoin
    case Buyfivecoin
    case Buysixcoin
    case gem
    
}


protocol ProtocolTableViewGenericCell {
    static var items:[Self]        { get }
    var picture:Icons              { get }
    var name:String                { get }
    var title:String               { get }
    var amount:Int                 { get }
    var gemAmount:Int?             { get }
    var icon:Currency.CurrencyType { get }
    var get:[Self]                 { get }
}


extension ProtocolTableViewGenericCell {
    
    func getType() -> Self {
        return self
    }
}

struct BuyFruit:ProtocolTableViewGenericCell {
    
    typealias A = BuyFruit
    
    var picture: Icons
    
    var name: String
    
    var title: String
    
    var amount: Int
    
    var icon: Currency.CurrencyType
    
    var gemAmount:Int?
    
    var get:[BuyFruit] {
        Self.items
    }
   
    
    static var items: [Self] = [
        BuyFruit(picture:.fruit,name: "", title: "", amount: 25,icon:.Gem,gemAmount:50),
        BuyFruit(picture:.doubleFruit,name: "", title: "125 + 25 BONUS", amount: 150,icon:.Gem,gemAmount:250),
        BuyFruit(picture:.bagFruit,name: "", title: "250 + 75 BONUS", amount: 325,icon:.Gem,gemAmount:500),
        BuyFruit(picture:.bagFruit,name: "", title: "500 + 200 BONUS", amount: 700,icon:.Gem,gemAmount:1000),
        BuyFruit(picture:.bagFruit,name: "",title: "1000 + 500 BONUS", amount: 1500,icon:.Gem,gemAmount:2000),
        BuyFruit(picture:.bagFruit,name: "",title: "2500 + 2000 BONUS", amount: 2500,icon:.Gem,gemAmount:5000)]
    
}

struct BuyGem:ProtocolTableViewGenericCell {
    
    typealias A = BuyGem
    
    var picture: Icons
    
    var name: String
    
    var title: String
    
    var amount: Int
    
    var icon: Currency.CurrencyType
    
    var gemAmount:Int?
    
    var get:[BuyGem] {
        Self.items
    }
   
    
    static var items: [Self] = [
        BuyGem(picture:.fruit,name: "", title: "", amount: 25,icon:.Gem,gemAmount:50),
        BuyGem(picture:.doubleFruit,name: "", title: "125 + 25 BONUS", amount: 150,icon:.Gem,gemAmount:250),
        BuyGem(picture:.bagFruit,name: "", title: "250 + 75 BONUS", amount: 325,icon:.Gem,gemAmount:500),
        BuyGem(picture:.bagFruit,name: "", title: "500 + 200 BONUS", amount: 700,icon:.Gem,gemAmount:1000),
        BuyGem(picture:.bagFruit,name: "",title: "1000 + 500 BONUS", amount: 1500,icon:.Gem,gemAmount:2000),
        BuyGem(picture:.bagFruit,name: "",title: "2500 + 2000 BONUS", amount: 2500,icon:.Gem,gemAmount:5000)]
    
}


struct BuyCoins:ProtocolTableViewGenericCell {
    
    typealias A = BuyCoins
    
    var picture: Icons
    
    var name: String
    
    var title: String
    
    var amount: Int
    
    var icon: Currency.CurrencyType
    
    var gemAmount:Int?
    
    var get:[BuyCoins] {
        Self.items
    }
    
    static var items: [Self] = [
        BuyCoins(picture:.Buycoin,name: "", title: "", amount: 2000,icon:.Gem,gemAmount:40),
        BuyCoins(picture:.Buytwocoin,name: "", title: "10000 + 1600 BONUS", amount: 11600,icon:.Gem,gemAmount:200),
        BuyCoins(picture:.Buythreecoin,name: "", title: "20000 + 4000 BONUS", amount: 24000,icon:.Gem,gemAmount:400),
        BuyCoins(picture:.Buyfourcoin,name: "", title: "40000 + 10000 BONUS", amount: 50000,icon:.Gem,gemAmount:800),
        BuyCoins(picture:.Buyfivecoin,name: "",title: "80000 + 26000 BONUS", amount: 106000,icon:.Gem,gemAmount:1600),
        BuyCoins(picture:.Buysixcoin,name: "",title: "200000 + 80000 BONUS", amount: 280000,icon:.Gem,gemAmount:4000)]
    
    
}

struct BuyEggs:ProtocolTableViewGenericCell {
    
    typealias A = BuyEggs
    
    var picture: Icons
    
    var name: String
    
    var title: String
    
    var amount: Int
    
    var icon: Currency.CurrencyType
    
    var gemAmount: Int?
    
    var get:[BuyEggs] {
        Self.items
    }
    
    static var items: [Self] = [
        BuyEggs(picture:.Common,name: "KING´S COURT", title: "GUARATEED\nKING´S COURT SIDEKIT", amount: 100,icon:.Gem),
        BuyEggs(picture:.Common,name: "TOXIC", title: "A TOXI AVENGER", amount: 100,icon:.Gem),
        BuyEggs(picture:.Bronze,name: "Bronze", title: "Dragon Egg", amount: 3200,icon:.Coin),
        BuyEggs(picture:.Common,name: "Common", title: "Dragon Egg", amount: 640,icon:.Coin),
        BuyEggs(picture:.Bronze,name: "Bronze", title: "Dragon Egg", amount: 3200,icon:.Coin),
        BuyEggs(picture:.Silver,name: "Silver", title: "Dragon Egg", amount: 16000,icon:.Coin),
        BuyEggs(picture:.Golden,name: "Golden", title: "Dragon Egg", amount: 32000,icon:.Coin),
        BuyEggs(picture:.Magical,name: "Magical",title: "Dragon Egg",amount: 200,icon:.Gem),
        BuyEggs(picture:.Ancient,name: "Ancient",title: "Dragon Egg",amount: 700,icon:.Gem)]
    
    
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
        
        self.translatesAutoresizingMaskIntoConstraints = true
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
             return tableView.contentSize.width*0.95/2
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell

         let view = configureCell(cell: cell, item: items[indexPath.row])
         
        cell.addSubview(view)
         
        return cell
    }
   
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        }
        
        
        return configureCellGem(cell:cell,item:item)
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
         
        image.transform = CGAffineTransformMakeRotation(-CGFloat(15.0).toRadians())

        view.addSubview(image)
        
        let name = UILabel(frame: CGRect(x: view.frame.width*0.48, y:view.frame.height * 0.15, width:  view.frame.width*0.8, height: view.frame.height*0.3))
            name.font = UIFont(name: "Cartwheel", size: view.frame.width*0.15)
            name.textColor = .yellow
            name.layer.shadowOffset = CGSize(width: 5, height: -1)
            name.layer.shadowColor = UIColor.black.cgColor
            name.layer.shadowOpacity = 1
            name.text = item.name
        
        view.addSubview(name)
        
        let title = UILabel(frame: CGRect(x: view.frame.width*0.7, y: view.frame.height * 0.40, width: view.frame.width*0.8, height: view.frame.height*0.2))
            title.font = UIFont(name: "Cartwheel", size: view.frame.width*0.05)
            title.textColor = .white
            title.layer.shadowOffset = CGSize(width: 2, height: 2.5)
            title.layer.shadowColor = UIColor.black.cgColor
            title.layer.shadowOpacity = 1;
            title.text = item.title
        view.addSubview(title)
        
        let amount = UILabel(frame: CGRect(x: view.frame.width*0.5, y: view.frame.height * 0.65, width: view.frame.width*0.4,
                                           height: view.frame.height*0.3))
         
            amount.font = UIFont(name: "Cartwheel", size: view.frame.width*0.1)
            amount.textColor = .yellow
            amount.layer.shadowOffset = CGSize(width: 2, height: 2.5)
            amount.layer.shadowColor = UIColor.black.cgColor
            amount.layer.shadowOpacity = 1;
            amount.text = String(item.amount).convertDecimal()
        view.addSubview(amount)
        
        let icon = UIImageView(frame: CGRect(x: view.frame.width*0.8,
                                             y: view.frame.height * 0.65,
                                             width: view.frame.width*0.15,
                                             height: view.frame.width*0.15))
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
            countBtn.text = String(item.gemAmount!).convertDecimal()
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
            countBtn.text = String(item.gemAmount!).convertDecimal()
            button.addSubview(countBtn)
        
        let iconGem = UIImageView(frame: CGRect(x: button.frame.width*0.65, y: button.frame.width*0.1, width: button.frame.width*0.25, height: button.frame.width*0.25))
            iconGem.image = UIImage(named: "gem")
            button.addSubview(iconGem)
        
        view.addSubview(button)
        view.addSubview(title)
        
        
        return view
    }
}




