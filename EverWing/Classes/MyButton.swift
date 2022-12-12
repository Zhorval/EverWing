//
//  MyButton.swift
//  EverWing
//
//  Created by Pablo  on 13/11/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import UIKit

extension UIControl {
    func addAction(for controlEvents:UIControl.Event,_ clousure: @escaping()->()) {
        
        @objc class ClousureSleeve:NSObject {
            let clousure:()->()
            init(_ clousure: @escaping()->()) { self.clousure = clousure }
            @objc func invoke() { clousure() }
            
        }
        let sleeve = ClousureSleeve(clousure)
        addTarget(sleeve, action: #selector(ClousureSleeve.invoke), for: controlEvents)
        objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
}

class MyButton<T:BaseProtocol>:UIButton {
    
    let handler:(Bool)->Void
    
    var data:T?
    
    var view:UIView?
    
    var index:Int = 0
    
    var label:UILabel?
    
    var identifier:Direction?
    
    var dragonsSell:[T]?
    
    
    
    init(frame: CGRect,item:[T],handler:@escaping(Bool)->Void) where T == Dragons {
        
        print("Contador \(item.count)")
        self.handler = handler
        
        self.dragonsSell = item
       
        super.init(frame: frame)

        addTarget(self, action: #selector(tapSellDragonsSelected), for: .touchUpInside)
        
    }
    init(frame: CGRect,item:T?,view:UIView,identifier:Direction,handler:@escaping(Bool)->Void) where T == Dragons {
        
        self.data  = item
        self.handler = handler
        self.identifier = identifier
        self.view = view
        super.init(frame: frame)

        addTarget(self, action: #selector(lessOrPlusBtn), for: .touchUpInside)
        
        if identifier == .Left {
            setImage(UIImage(named: "btnBlueLess"), for: .normal)
        } else {
            isEnabled = ((40/10 * data!.level) + Int(data!.percent/100*4) - 4) < 40
            setImage(UIImage(named: "btnBluePlus"), for: .normal)
        }
        
        view.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: identifier == .Left ? -view.frame.width/3 : view.frame.width/3).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.height*0.2).isActive = true
        heightAnchor.constraint(equalTo: widthAnchor).isActive = true
        layoutIfNeeded()
    }
    
    /// - Description: This construct is to handle the skill buttons,
    /// - Parameters:
    ///     @ rect:CGRect always .zero
    ///       view:UIView  The view where to add the buttons
    ///       index: To locate the position of the button in the view
    init(frame: CGRect,item:T,view:UIView?,index:Int,handler:@escaping(Bool)->Void) where T == Dragons {
        
        self.view = view
        self.index = index
        self.handler = handler
        self.data = item
        super.init(frame: frame)
        
        if self.view != nil {
            addTarget(self, action: #selector(tapButtonskills), for: .touchUpInside)
            view?.addSubview(self)
        } else {
            addTarget(self, action: #selector(tapDragon), for: .touchUpInside)
        }
    }
    
    /// - Description: This construct is to handle the extra buttons,
    /// - Parameters:
    ///     @ rect:CGRect always .zero
    ///       item: Element IconsExtra.BtnIcons
    ///       view:UIView  The view where to add the buttons
    ///       index:Int      Index required to display the icon in a position on the screen
    init(frame: CGRect,item:T,view:UIView,index:Int,handler:@escaping(Bool)->Void) where T == IconsExtra.BtnIcons {
       
        self.view = view
        self.handler = handler
        self.data = item
        super.init(frame: frame)
        
        setImage(UIImage(named: "BulletButton"), for: .normal)
        addTarget(self, action: #selector(tapButtonBtnSell), for: .touchUpInside)
        
        let marginX_ = view.frame.width*0.9/4 * CGFloat(index) + view.frame.width/12
        view.addSubview(self)
        
        translatesAutoresizingMaskIntoConstraints = false
        bottomAnchor.constraint(equalTo: view.bottomAnchor,constant:-75).isActive =  true
        heightAnchor.constraint(equalToConstant: view.frame.width/6).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.width/6).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: marginX_).isActive = true
        layoutIfNeeded()
        
        
        let icon = UIImageView(image: UIImage(named:item.rawValue))
        addSubview(icon)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive =  true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive =  true
        icon.widthAnchor.constraint(equalToConstant: 35).isActive =  true
        icon.heightAnchor.constraint(equalToConstant: 35).isActive =  true
        icon.layoutIfNeeded()
        
        let textIcon = UILabel().shadowText(colorText:.white, colorShadow: .clear, aligment: .center)
        textIcon.text = IconsExtra.items[index].title.uppercased()
        textIcon.numberOfLines = 0
        textIcon.font = UIFont.systemFont(ofSize: icon.frame.width*0.5, weight: .bold)
        icon.addSubview(textIcon)
        
        textIcon.translatesAutoresizingMaskIntoConstraints = false
        textIcon.centerXAnchor.constraint(equalTo: icon.centerXAnchor).isActive =  true
        textIcon.topAnchor.constraint(equalTo: bottomAnchor,constant: 0).isActive =  true
        textIcon.layoutIfNeeded()
    }
    
    init(frame:CGRect,data:T,completion:@escaping(Bool)->Void)  where T:ProtocolTableViewGenericCell{
        
        self.data = data
        self.handler = completion

        super.init(frame: frame)
    
        self.setTitle(String(Int(data.gemAmount ?? CGFloat(data.amount))).convertDecimal(), for: .normal)
        self.setBackgroundImage(UIImage(named: "BlueButton")!, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        addTarget(self, action: #selector(mySelector), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    @objc func mySelector(sender:UIButton) {
        
        if let data = data as? ProtocolTableViewGenericCell {
            let amount:Int = data.gemAmount == nil ? data.amount : Int(data.gemAmount!)
            
            let payWithItem = data.icon
            
            if hasCoin(amount: Int32(amount), itemPay: payWithItem as! Currency.CurrencyType) {
                
                let action:Currency.ActionBuy = data.gemAmount == nil ? .Sell : .Buy
                
                handler(preparePay(data: data, action: action))
            } else {
                fatalError()
            }
        }
    }
    
    @objc func tapButtonskills(sender:UIButton) {
        
        guard let view = self.view else { fatalError() }
       
        view.subviews.filter {$0.tag == 100}.first?.removeFromSuperview()
        
        let popup = UIView()
        popup.tag = 100
        popup.layer.borderColor = UIColor.black.cgColor
        popup.layer.shadowOpacity = 1
        popup.layer.borderWidth = 2
        popup.layer.cornerRadius = 10
        popup.layer.shadowColor = UIColor.black.cgColor
        popup.layer.shadowRadius = 5
        popup.layer.backgroundColor = UIColor(red: 243/255, green: 203/255, blue: 162/255, alpha: 1).cgColor
        view.addSubview(popup)
        popup.translatesAutoresizingMaskIntoConstraints = false

        popup.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        popup.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        popup.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        popup.topAnchor.constraint(equalTo: view.bottomAnchor,constant: 5).isActive = true
        
        lazy var pointingArrow: PointingTriangleView = {
            let v = PointingTriangleView()
            v.translatesAutoresizingMaskIntoConstraints = false

            v.pointingShortUp = true 

            v.fillColorCGColor = UIColor.black.cgColor
            return v
        }()
        popup.addSubview(pointingArrow)
        
        pointingArrow.bottomAnchor.constraint(equalTo: popup.topAnchor).isActive = true
        pointingArrow.widthAnchor.constraint(equalToConstant: 20).isActive = true
        pointingArrow.heightAnchor.constraint(equalToConstant: 20).isActive = true

        pointingArrow.trailingAnchor.constraint(equalTo: popup.trailingAnchor,constant: -(CGFloat(index) * view.frame.width/10) - 35 ).isActive = true
        
        if let data = data as? Dragons {
            guard let txt = getTextPopupPlist(key: data.icons[index] ),
                  let name = txt["name"],
                  let description = txt["description"]  else { return }
            
            let txtSkill = UILabel()
                .addFontAndText(font: "Cartwheel", text: name, size: view.frame.width*0.05)
                .shadowText(colorText: .black, colorShadow: .white, aligment: .left)
            txtSkill.numberOfLines = 0
            popup.addSubview(txtSkill)
            
            txtSkill.translatesAutoresizingMaskIntoConstraints = false
            txtSkill.leadingAnchor.constraint(equalTo: popup.leadingAnchor,constant: 10).isActive = true
            txtSkill.topAnchor.constraint(equalTo: popup.topAnchor,constant: 10).isActive = true
            
            let percent = description.replacingOccurrences(of: "{percent}", with: "\(data.percent)")
          
            let txtDescription = UILabel()
                .addFontAndText(font: "Cartwheel", text: percent, size: view.frame.width*0.05)
                .shadowText(colorText: .black, colorShadow: .white, aligment: .left)
            
            txtSkill.numberOfLines = 0
            popup.addSubview(txtDescription)
            
            txtDescription.translatesAutoresizingMaskIntoConstraints = false
            txtDescription.leadingAnchor.constraint(equalTo: txtSkill.leadingAnchor,constant: 0).isActive = true
            txtDescription.topAnchor.constraint(equalTo: txtSkill.bottomAnchor,constant: 10).isActive = true
            txtDescription.contentScaleFactor = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) { popup.removeFromSuperview()}
    }
    
    @objc func tapButtonBtnSell(sender:UIButton) {
        
        handler(true)
    }
    
    @objc func tapDragon(sender:UIButton) {
        handler(true)
    }
    
    @objc func lessOrPlusBtn(sender:UIButton) {
        
        guard let data = data as? Dragons else { return }
        
        if (identifier == .Left && data.level == 1 && data.percent < 25) || (identifier == .Right) && (data.level == 10) && (data.percent == 100) {
            isEnabled = false
        } 
        handler(true)
        
    }
    
     @objc func tapSellDragonsSelected(sender:UIButton) {
        
        guard let dragons = dragonsSell as? [Dragons] else { fatalError() }
                  
        print(dragons)
        if  dragons.count > 0 {
            handler(true)
        }
    }
    private func getTextPopupPlist(key:String) -> Dictionary<String,String>? {
        
        let directory = Bundle.main.url(forResource: "property", withExtension: "plist")!

        guard let data = try? Data(contentsOf: directory) else { fatalError() }
        
        do {
            guard let json = try PropertyListSerialization.propertyList(from: data, options: [],format: nil) as? Dictionary<String,Any>,
                  let js =  json["skills"] as? Dictionary<String,Any>,
                  let value = js[key] as? Dictionary<String,String> else { fatalError()}
            
            return value
            
        }catch {}
        
        return  nil
    }
    
    private func hasCoin(amount:Int32,itemPay:Currency.CurrencyType)->Bool {
        
        let managed = ManagedDB.shared.context
        do {
            guard let m = try managed.fetch(PlayerDB.fetchRequest()).first else { return false}
            
            print("Has coin gameinfo",itemPay)
            switch itemPay {
                case .Fruit:
                    print("fruit pago \(m.fruit - amount > 0)")
                    return m.fruit - amount > 0
                case .Gem:
                    print("Gemas pago \(m.gem - amount > 0)")
                    return m.gem - amount > 0
                case .Eggs:
                    print("eggs pago \(m.coin - amount > 0)")
                    return m.coin - amount > 0
                case .Coin:
                    print("coin pago \(m.coin - amount > 0)")
                    return m.coin - amount > 0
                default:
                    print("Sin resultado")
                    return false
            }
            
        } catch let error {
            print("Error \(error.localizedDescription)")
            return false
        }
    }
    
    private func preparePay<T:ProtocolTableViewGenericCell>(data:T,action:Currency.ActionBuy?)->Bool {
        
        let managed = ManagedDB.shared.context

        do {
            guard let model = try managed.fetch(PlayerDB.fetchRequest()).first else { return false}

            switch data.icon {
                case Currency.CurrencyType.Gem:
                    
                    if action == .Buy {
                            model.fruit += Int32(data.amount)
                            guard let gemAmount = data.gemAmount else { return false }
                            model.gem -= Int32(gemAmount)
                        } else {
                            model.gem -= Int32(data.amount)
                        }
                case Currency.CurrencyType.Coin:
                    if action == .Sell {
                        model.coin -= Int32(data.amount)
                    }
                    
                case Currency.CurrencyType.Eggs:
                    model.coin -= Int32(data.gemAmount!)
            
                default:
                    fatalError()
            }
             try managed.save()
             print("Preparado el pago listo para handler MYButton class")
             return true
        }catch let error {
            print("Error pay item \(error.localizedDescription)")
            return false
        }
    }
}

/// - Description: This construct draw the triangle in the popup
/// - parameters: @pointingXXX:   Direction arrow
class PointingTriangleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clear
    }
    
    var fillColorCGColor = UIColor.brown.cgColor
    
    var pointingLongDown = false
    var pointingShortDown = false

    var pointingLongUp = false
    var pointingShortUp = false
    
    var pointingLongLeft = false
    var pointingShortLeft = false
    
    var pointingLongRight = false
    var pointingShortRight = false
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        
        if pointingLongDown {
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
        
        if pointingShortDown {
            context.move(to: CGPoint(x: rect.minX, y: rect.midY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            context.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
        
        if pointingLongUp {
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
        
        if pointingShortUp {
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        }
        
        if pointingLongLeft {
            context.move(to: CGPoint(x: rect.minX, y: rect.midY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
        
        if pointingShortLeft {
            context.move(to: CGPoint(x: rect.midX, y: rect.midY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
        
        if pointingLongRight {
            context.move(to: CGPoint(x: rect.maxX, y: rect.midY))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        }
        
        if pointingShortRight {
            context.move(to: CGPoint(x: rect.midX, y: rect.midY))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        }
        
        context.closePath()
        
        context.setFillColor(fillColorCGColor)
        context.fillPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
