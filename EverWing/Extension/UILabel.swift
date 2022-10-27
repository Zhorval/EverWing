//
//  UILabel.swift
//  EverWing
//
//  Created by Pablo  on 16/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    
    /// Create un shadow text  
    func shadowText(colorText:UIColor,colorShadow:UIColor,aligment:NSTextAlignment) -> Self {
        
        textAlignment = aligment
        textColor = colorText
        shadowColor = colorShadow
        shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 5
        
        return self
    }
    
    
    /// add text and font return Self
    func addFontAndText(font:String,text:String,size:CGFloat)  -> Self{
        
        self.font = UIFont(name: font, size: size)
        self.text = text
        return self
    }
    
    
    /// add text with UIFont return Self
    func addTextWithFont(font:UIFont,text:String,color:UIColor)  -> Self{
        
        self.font = font
        self.text = text
        self.textAlignment = .center
        self.numberOfLines = 0
        self.textColor = color
        sizeThatFits(self.frame.size)
        return self
    }
}

