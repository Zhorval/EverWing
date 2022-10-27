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
        contentMode = .scaleAspectFill
        
        let width = (imageView?.image?.size.width)!/2
        let height = (imageView?.image?.size.height)!/2

        switch position {
        case .topLeft:
            
            frame = frame.offsetBy(dx: self.frame.width/2 - width, dy: -self.frame.height/2 + height)
        case .topRight:
            frame  = frame.offsetBy(dx:  -width , dy: -height/2)
        case .left:
            
            frame = frame
        default:
            
            return self
        }
        
        return self
    }
}
