//
//  CGPoint.swift
//  EverWing
//
//  Created by Pablo  on 30/5/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import UIKit


extension CGPoint {
    
    /// Get the distance between two points
    // @params to: Second point to get the distance
    // return CGFloat:  Distance between two points
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow((point.x - x), 2) + pow((point.y - y), 2))
    }
}
