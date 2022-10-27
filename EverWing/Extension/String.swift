//
//  String.swift
//  EverWing
//
//  Created by Pablo  on 19/10/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import UIKit

extension String {
    
    /// Convert string number to decimal string number
    func convertDecimal() -> Self{
        
        guard let number = Int(self) else { return self}
        
        let nsNumber = NSNumber(value: number)
        
        let formatter = NumberFormatter()
       
        formatter.numberStyle = .decimal

        return formatter.string(from: nsNumber) ?? self
    }
}

