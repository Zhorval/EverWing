//
//  UIImage.swift
//  Angelica Fighti
//
//  Created by Pablo  on 20/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    
    /// Slice image into array of tiles
    ///
    /// - Parameters:
    ///   - image: The original image.
    ///   - howMany: How many rows/columns to slice the image up into.
    ///
    /// - Returns: An array of images.
    ///
    /// - Note: The order of the images that are returned will correspond
    ///         to the `imageOrientation` of the image. If the image's
    ///         `imageOrientation` is not `.up`, take care interpreting
    ///         the order in which the tiled images are returned.

    func slice(into howMany: Int) -> [UIImage] {
        let width: CGFloat
        let height: CGFloat

        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = self.size.height
            height = self.size.width
        default:
            width = self.size.width
            height = self.size.height
        }

        let tileWidth = Int(width / CGFloat(howMany))
        let tileHeight = Int(height / CGFloat(howMany))

        let scale = Int(self.scale)
        var images = [UIImage]()

        let cgImage = self.cgImage!

        var adjustedHeight = tileHeight

        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                print(adjustedWidth*scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCgImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                images.append(UIImage(cgImage: tileCgImage, scale: self.scale, orientation: self.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return images
    }
    
    /// Resize image
    ///
    /// - Parameters:
    ///   - size: The size .
    ///
    /// - Returns:  New Uimageresize.
    
    
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
