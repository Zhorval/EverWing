//
//  File.swift
//  EverWing
//
//  Created by Pablo  on 21/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import  UIKit

extension UIView {
    
    /// Add image background to Self UIView return Self
    func viewBG(image:String) -> Self {
        
        let viewImage = UIImageView(frame: frame)
        viewImage.contentMode = .scaleToFill
        viewImage.image = UIImage(named: "panelInfo")
        addSubview(viewImage)
        return self
    }
}
