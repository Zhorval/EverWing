//
//  UIColor.swift
//  Angelica Fighti
//
//  Created by Pablo  on 10/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    
    func randomColor()->UIColor {
        
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
           
    }
}
