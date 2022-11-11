//
//  UIDevide+isPhone.swift
//  EverWing
//
//  Created by Pablo  on 1/11/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    
    func isPhone() ->Bool{
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}
