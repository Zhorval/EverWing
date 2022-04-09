//
//  CustomCollectionView.swift
//  Angelica Fighti
//
//  Created by Pablo  on 2/4/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import UIKit

struct Eggs {
    
    let picture:Icons
    let name:String
    let title:String
    let amount:Int
    let icon:Currency.CurrencyType
    
    enum Icons:String {
        case Common
        case Bronze
        case Silver
        case Golden
        case Magical
        case Ancient
    }
}


class CustomCollectionView: UITableView {
   
     let eggs = [
        Eggs(picture:.Common,name: "Common", title: "Dragon Egg", amount: 640,icon:.Coin),
        Eggs(picture:.Bronze,name: "Bronze", title: "Dragon Egg", amount: 3200,icon:.Coin),
        Eggs(picture:.Silver,name: "Silver", title: "Dragon Egg", amount: 16000,icon:.Coin),
        Eggs(picture:.Golden,name: "Golden", title: "Dragon Egg", amount: 32000,icon:.Coin),
        Eggs(picture:.Magical,name: "Magical",title: "Dragon Egg", amount: 200,icon:.Diamond),
        Eggs(picture:.Ancient,name: "Ancient",title: "Dragon Egg", amount: 700,icon:.Diamond)]

    // MARK: - Init
   
    override init(frame: CGRect, style: UITableView.Style) {
       
        super.init(frame: frame,style: UITableView.Style.grouped)
        
        delegate = self
        dataSource = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: "TableEggs")
        self.separatorStyle = .none
        backgroundColor = .clear
        self.bounces = false
        self.showsVerticalScrollIndicator = false
        
        self.translatesAutoresizingMaskIntoConstraints = false
      
        self.reloadData()
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
// MARK: - Delegates
extension CustomCollectionView: UITableViewDelegate,UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableEggs", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
       
        let view = UIView(frame: CGRect(x: 50, y: 30, width: tableView.contentSize.width-100, height: 100))
        view.backgroundColor = UIColor(patternImage: (UIImage(named: "bgDragonsIcons")?.resized(to: CGSize(width: tableView.contentSize.width-100, height: 100)))!)
        
        let image = UIImageView(image: UIImage(named: eggs[indexPath.row].picture.rawValue)?.resized(to: CGSize(width: 70, height: 90)))
        view.addSubview(image)
        
        let name = UILabel(frame: CGRect(x: view.frame.width-100, y:15, width: 100, height: 20))
        name.font = UIFont(name: "Cartwheel", size: 22)
        name.textColor = .yellow
        name.text = eggs[indexPath.row].name
        view.addSubview(name)
        
        let title = UILabel(frame: CGRect(x: view.frame.width-100, y: 45, width: 100, height: 20))
        title.font = UIFont(name: "Qebab Shadow FFP", size: 15)
        title.textColor = .black
        title.text = eggs[indexPath.row].title
        view.addSubview(title)
        
        let amount = UILabel(frame: CGRect(x: view.frame.width-100, y: 70, width: 100, height: 20))
        amount.font = UIFont(name: "Qebab Shadow FFP", size: 15)
        amount.textColor = .black
        amount.text = String(eggs[indexPath.row].amount)
        view.addSubview(amount)
        
        let icon = UIImageView(frame: CGRect(x: view.frame.width-50, y: 70, width: 50, height: 50))
        icon.image = UIImage(named: eggs[indexPath.row].icon.rawValue)
        view.addSubview(icon)
        
        cell.addSubview(view)
        return cell
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eggs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select",eggs[indexPath.row].name)
    }
}


class MyCustomCell:UITableViewCell {
    
     var picture:UIImageView?
     var name:UILabel?
}
