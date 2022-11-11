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
    func viewBG(image:String,scale:ContentMode? = .scaleToFill) -> Self {
        
        let viewImage = UIImageView(frame: bounds)
        viewImage.image = UIImage(named: image)
        viewImage.contentMode = .scaleToFill
        viewImage.clipsToBounds = true
        addSubview(viewImage)
        return self
    }
    
    
    /// - Description: Setter image to background UIView
    /// - Params: img : UIImage

    func setBackgroundImage(img: UIImage){

       UIGraphicsBeginImageContext(self.frame.size)
        img.draw(in: self.bounds)
        guard let patternImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return }
       UIGraphicsEndImageContext()
       self.backgroundColor = UIColor(patternImage: patternImage)
   }

    /// # Description: CornerRadius  UIView
    /// # Parameters: radius : CGFloat for radius

    func cornerRadius(radius:CGFloat) -> Self{

        layer.cornerRadius = radius
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
        layer.shadowColor = UIColor.red.cgColor
        layer.shadowOffset.width =  1
        return self
    }
    
    
    
    func raySunRotating(view:UIView) -> UIView{
        
        
        let sun = UIImageView(image: UIImage(named:  "bgSun"))
        insertSubview(sun, belowSubview: view)
        
        sun.translatesAutoresizingMaskIntoConstraints = false
        sun.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 0).isActive = true
        sun.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 0).isActive = true
        sun.widthAnchor.constraint(equalToConstant: self.frame.width*0.7).isActive = true
        sun.heightAnchor.constraint(equalToConstant: self.frame.height*0.3).isActive = true
        
        let sunRotate = UIImageView(image: UIImage(named:  "bgSunRotate"))
        self.insertSubview(sunRotate, aboveSubview: sun)
        
        sunRotate.layer.backgroundFilters = [CIFilter(name:"CIRandomGenerator")!]
        sunRotate.layer.setValue(10, forKeyPath: "backgroundFilters.myFilter.inputRadius")
        
        sunRotate.translatesAutoresizingMaskIntoConstraints = false
        sunRotate.centerXAnchor.constraint(equalTo: sun.centerXAnchor,constant: 0).isActive = true
        sunRotate.centerYAnchor.constraint(equalTo: sun.centerYAnchor,constant: 0).isActive = true
        sunRotate.widthAnchor.constraint(equalToConstant: self.frame.width*0.7).isActive = true
        sunRotate.heightAnchor.constraint(equalToConstant: self.frame.height*0.5).isActive = true
        
        
        UIView.animate(withDuration: 1, delay: 0,options: [.repeat,.curveEaseOut]) {
            sunRotate.transform = CGAffineTransform(rotationAngle: 2 * .pi)
            sunRotate.transform = CGAffineTransform(scaleX: 2, y: 2)
            sun.transform = CGAffineTransform(rotationAngle:  .pi/2)
            sun.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        
     
        return sun
    }
}


