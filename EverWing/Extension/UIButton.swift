//
//  UIButton.swift
//  EverWing
//
//  Created by Pablo  on 21/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import UIKit


extension UIButton {
    
    ///  Add image button
    func addImageButton(image:String,position:UIView.ContentMode) -> Self{
        
        setImage(UIImage(named: image), for: .normal)
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFit
        
        let width = (imageView?.image?.size.width)!/2
        let height = (imageView?.image?.size.height)!/2

        switch position {
            case .topLeft:
                frame = frame.offsetBy(dx: self.frame.width/2 - width, dy: -self.frame.height/2 + height)
            case .topRight:
                frame  = frame.offsetBy(dx:  -width , dy: -height/2)
            case .left:
                frame = frame
            case .right:
                frame = frame.offsetBy(dx: 10, dy: 0)
            default:
                return self
        }
        return self
    }
    
    func getCircleDragons(mainView:UIView,side:Direction) -> Self {
        
        let dragonHigh = ManagedDB.getDragonSide(side: side)
        mainView.addSubview(self)
        
        self.setBackgroundImage(UIImage(named: "bgDragonsCircle")!, for: .normal)
        self.setImage(UIImage(named: dragonHigh?.picture ?? ""),for: .normal)
        self.translatesAutoresizingMaskIntoConstraints = false
     
        if side == .Right {
            self.leadingAnchor.constraint(equalTo: mainView.centerXAnchor,constant: mainView.frame.width*0.2).isActive = true
        } else {
            self.trailingAnchor.constraint(equalTo: mainView.centerXAnchor,constant: -mainView.frame.width*0.2).isActive = true

        }
        self.centerYAnchor.constraint(equalTo: mainView.topAnchor,constant: screenSize.height*0.25).isActive = true
        self.widthAnchor.constraint(equalToConstant: max(120,mainView.frame.width*0.2)).isActive = true
        self.heightAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.layoutIfNeeded()
     
        if dragonHigh?.level != nil {
            let txtLevel = UILabel()
                .addTextWithFont(font: UIFont.systemFont(ofSize: 24, weight: .bold), text: "\(dragonHigh!.level)", color: .white)
            self.addSubview(txtLevel)
            txtLevel.translatesAutoresizingMaskIntoConstraints = false
            txtLevel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            txtLevel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
       
        if let picture = dragonHigh?.picture {
            
            let ocurrencies = picture.replacingOccurrences(of: "_icon", with: "")
            let dragonSmall = "sidekicks_\(ocurrencies)"
           
            if let imageSmall = UIImage(named: dragonSmall)?.topHalf,
               let wings =  UIImage(named: dragonSmall)?.wings   {
                
                let dragonSmall = UIImageView(image:  UIImage(cgImage: imageSmall))
                let viewWingsL = UIImageView(image: UIImage(cgImage: wings))
                let viewWingsR = UIImageView(image: UIImage(cgImage: wings,scale: 1,orientation: .upMirrored))
                
                self.addSubview(dragonSmall)
                dragonSmall.addSubview(viewWingsL)
                dragonSmall.addSubview(viewWingsR)
                
                dragonSmall.translatesAutoresizingMaskIntoConstraints = false
                dragonSmall.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: self.frame.height).isActive = true
                dragonSmall.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                dragonSmall.layoutIfNeeded()
                
                viewWingsL.translatesAutoresizingMaskIntoConstraints = false
                viewWingsL.centerYAnchor.constraint(equalTo: dragonSmall.centerYAnchor).isActive = true
                viewWingsL.centerXAnchor.constraint(equalTo: dragonSmall.centerXAnchor).isActive = true
                viewWingsL.setAnchorPoint(CGPoint(x: 1, y: 0.5))
                
                viewWingsR.translatesAutoresizingMaskIntoConstraints = false
                viewWingsR.centerYAnchor.constraint(equalTo: viewWingsL.centerYAnchor,constant: 0).isActive = true
                viewWingsR.centerXAnchor.constraint(equalTo: dragonSmall.centerXAnchor,constant: 0).isActive = true
                viewWingsR.setAnchorPoint(CGPoint(x: 0, y: 0.5))

                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2, delay: 0,options: [.repeat,.autoreverse,.curveEaseOut]) {
                        viewWingsL.transform = CGAffineTransform(rotationAngle: 15 * .pi/180)
                        viewWingsR.transform = CGAffineTransform(rotationAngle: -15 * .pi/180)
                    }
                }
                 
            }
        } else {
            
            let icon = UILabel()
                .addFontAndText(font: "Cartwheel", text: "?", size: self.bounds.width/1.5)
               .shadowText(colorText: UIColor(patternImage: UIImage.gradientImage(bounds: self.bounds, colors: [.yellow,.orange,.red])), colorShadow: .black, aligment: .center)
           self.addSubview(icon)
           icon.translatesAutoresizingMaskIntoConstraints = false
           icon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
           icon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
         
        return self
        
    }
}


extension UIImage {
    var topHalf: CGImage? {
        cgImage?.cropping(to: CGRect(origin: .zero,size: CGSize(width: size.width, height: size.height*2)))
    }
    
    var wings: CGImage? {
        cgImage?.cropping(to: CGRect(origin: CGPoint(x: size.width*1.1, y: 0),size: CGSize(width: size.width, height: size.height)))
    }
   
}
