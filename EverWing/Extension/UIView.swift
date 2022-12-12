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
   
    
    
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
    
    func retangleView(title:String,gradient:UIImage) -> UIView{
        
    let shape = UIView()
        shape.layer.borderColor = UIColor.black.withAlphaComponent(0.8).cgColor
        shape.layer.borderWidth = 1
        shape.layer.cornerRadius = 10
        shape.layer.backgroundColor = UIColor.brown.withAlphaComponent(0.2).cgColor
        shape.layer.shadowColor = UIColor.black.withAlphaComponent(1).cgColor
        shape.layer.shadowOpacity = 1
        self.addSubview(shape)

        let isPhone  = UIDevice().isPhone() ? 0 :  self.frame.height*0.05
    
        shape.translatesAutoresizingMaskIntoConstraints = false
        shape.widthAnchor.constraint(equalToConstant: self.frame.width*0.9).isActive = true
        shape.centerXAnchor.constraint(equalTo:self.centerXAnchor).isActive = true
        shape.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: isPhone).isActive = true
        shape.heightAnchor.constraint(equalToConstant: self.frame.height*0.3).isActive = true
        shape.layoutIfNeeded()
        
        let title = UILabel()
            .addFontAndText(font: "Cartwheel", text: title, size: self.frame.width*0.1)
            .shadowText(colorText: UIColor(patternImage: gradient), colorShadow: .black,aligment: .center)
        title.numberOfLines = 0
        shape.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: shape.topAnchor,constant: 10).isActive = true
        title.centerXAnchor.constraint(equalTo: shape.centerXAnchor).isActive = true
        
        return shape
    }
    
    func buttonActionFilters(type:TypeGridCollection,completion:@escaping(TypeOrder)->Void) -> UIView {
       
        
        let generalView:UIView  = {
                let v = UIView(frame: type.frame)
                v.layer.backgroundColor =  UIColor.brown.withAlphaComponent(0.8).cgColor
                v.layer.cornerRadius = 10
                v.layer.borderColor = UIColor.black.cgColor
                v.layer.borderWidth = 1
                v.layer.shadowRadius = 5
                v.layer.shadowColor = UIColor.black.withAlphaComponent(1).cgColor
                v.layer.opacity = 1
                addSubview(v)
                return v
        }()
        let imageButton = {(image:String,type:TypeOrder) -> UIButton in
            
            let b = UIButton(type: .custom)
            b.setBackgroundImage( UIImage(named: image) ,for: .normal)
            b.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            b.setTitle(type.rawValue.uppercased(), for: .normal)
            b.addAction(for: .touchUpInside) {
                completion(type)
            }
           
            return b
        }
        
        let _:UIView = {
            
            let v = UIView()
            v.layer.backgroundColor =  UIColor.gray.withAlphaComponent(0.5).cgColor
            v.layer.cornerRadius = 10
            v.layer.borderColor = UIColor.black.cgColor
            v.layer.borderWidth = 1
            v.layer.shadowRadius = 5
            v.layer.shadowColor = UIColor.black.withAlphaComponent(1).cgColor
            v.layer.opacity = 1
            generalView.addSubview(v)
            
            v.translatesAutoresizingMaskIntoConstraints = false
            v.leadingAnchor.constraint(equalTo: generalView.leadingAnchor,constant: 5).isActive = true
            v.trailingAnchor.constraint(equalTo: generalView.centerXAnchor,constant: -5).isActive = true
            v.widthAnchor.constraint(equalToConstant: self.frame.width/2).isActive = true
            v.bottomAnchor.constraint(equalTo: generalView.bottomAnchor,constant:-5).isActive = true
            v.topAnchor.constraint(equalTo: generalView.topAnchor,constant: 5).isActive = true
            v.layoutIfNeeded()
            
            let allElement = imageButton("GreenB",.AllElements)
            v.addSubview(allElement)
            
            allElement.translatesAutoresizingMaskIntoConstraints = false
            allElement.topAnchor.constraint(equalTo: v.topAnchor,constant: 5).isActive = true
            allElement.trailingAnchor.constraint(equalTo: v.trailingAnchor,constant: 0).isActive = true
            allElement.leadingAnchor.constraint(equalTo: v.leadingAnchor,constant: 0).isActive = true
            allElement.heightAnchor.constraint(equalToConstant: v.frame.height/4).isActive = true

            allElement.layoutIfNeeded()
           
            let fire = imageButton("BrownButton",.Fire)
            v.addSubview(fire)
            fire.translatesAutoresizingMaskIntoConstraints = false
            fire.topAnchor.constraint(equalTo: allElement.bottomAnchor,constant: 0).isActive = true
            fire.leadingAnchor.constraint(equalTo: allElement.leadingAnchor,constant: 0).isActive = true
            fire.trailingAnchor.constraint(equalTo: allElement.centerXAnchor,constant: 0).isActive = true
            fire.heightAnchor.constraint(equalToConstant: v.frame.height/4.1).isActive = true

          
            let light = imageButton("BrownButton",.Light)
            v.addSubview(light)
            light.translatesAutoresizingMaskIntoConstraints = false
            light.topAnchor.constraint(equalTo: fire.topAnchor,constant: 0).isActive = true
            light.leadingAnchor.constraint(equalTo: fire.trailingAnchor,constant: 0).isActive = true
            light.trailingAnchor.constraint(equalTo: allElement.trailingAnchor,constant: 0).isActive = true
            light.heightAnchor.constraint(equalToConstant: v.frame.height/4.1).isActive = true

            let nature = imageButton("BrownButton",.Nature)
            v.addSubview(nature)
            nature.translatesAutoresizingMaskIntoConstraints = false
            nature.topAnchor.constraint(equalTo: fire.bottomAnchor,constant: 0).isActive = true
            nature.leadingAnchor.constraint(equalTo: fire.leadingAnchor,constant: 0).isActive = true
            nature.trailingAnchor.constraint(equalTo: allElement.centerXAnchor,constant: 0).isActive = true
            nature.heightAnchor.constraint(equalToConstant: generalView.frame.height/4.1).isActive = true

            let shadow = imageButton("BrownButton",.Shadow)
            v.addSubview(shadow)
            shadow.translatesAutoresizingMaskIntoConstraints = false
            shadow.topAnchor.constraint(equalTo: fire.bottomAnchor,constant: 0).isActive = true
            shadow.leadingAnchor.constraint(equalTo: fire.trailingAnchor,constant: 0).isActive = true
            shadow.trailingAnchor.constraint(equalTo: allElement.trailingAnchor,constant: 0).isActive = true
            shadow.heightAnchor.constraint(equalToConstant: v.frame.height/4.1).isActive = true

            let water = imageButton("BrownButton",.Water)
            v.addSubview(water)
            water.translatesAutoresizingMaskIntoConstraints = false
            water.topAnchor.constraint(equalTo: nature.bottomAnchor,constant: 0).isActive = true
            water.leadingAnchor.constraint(equalTo: allElement.leadingAnchor,constant: 0).isActive = true
            water.trailingAnchor.constraint(equalTo: allElement.centerXAnchor,constant: 0).isActive = true
            water.heightAnchor.constraint(equalToConstant: v.frame.height/4.1).isActive = true

            let prismatic = imageButton("BrownButton",.Prismatic)
            v.addSubview(prismatic)
            prismatic.translatesAutoresizingMaskIntoConstraints = false
            prismatic.topAnchor.constraint(equalTo: nature.bottomAnchor,constant: 0).isActive = true
            prismatic.leadingAnchor.constraint(equalTo: fire.trailingAnchor,constant:0).isActive = true
            prismatic.trailingAnchor.constraint(equalTo: allElement.trailingAnchor,constant: 0).isActive = true
            prismatic.heightAnchor.constraint(equalToConstant: v.frame.height/4.1).isActive = true
            return v
        }()
        
        let _:UIView = {
            
            let v = UIView()
            v.layer.backgroundColor =  UIColor.gray.withAlphaComponent(0.5).cgColor
            v.layer.cornerRadius = 10
            v.layer.borderColor = UIColor.black.cgColor
            v.layer.borderWidth = 1
            v.layer.shadowRadius = 5
            v.layer.shadowColor = UIColor.black.withAlphaComponent(1).cgColor
            v.layer.opacity = 1
            generalView.addSubview(v)
            
            v.translatesAutoresizingMaskIntoConstraints = false
            v.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -5).isActive = true
            v.leadingAnchor.constraint(equalTo: self.centerXAnchor,constant: 5).isActive = true
            v.bottomAnchor.constraint(equalTo: generalView.bottomAnchor,constant: -5).isActive = true
            v.topAnchor.constraint(equalTo: generalView.topAnchor,constant: 5).isActive = true
            v.layoutIfNeeded()
            
            let allCases = imageButton("GreenB",.AllCases)
            v.addSubview(allCases)
            
            allCases.translatesAutoresizingMaskIntoConstraints = false
            allCases.topAnchor.constraint(equalTo: v.topAnchor,constant: 5).isActive = true
            allCases.trailingAnchor.constraint(equalTo: v.trailingAnchor,constant: 0).isActive = true
            allCases.leadingAnchor.constraint(equalTo: v.leadingAnchor,constant: 0).isActive = true
            allCases.heightAnchor.constraint(equalToConstant: v.frame.height/4.1).isActive = true

            allCases.layoutIfNeeded()
           
            let charser = imageButton("BrownButton",.Charser)
            v.addSubview(charser)
            charser.translatesAutoresizingMaskIntoConstraints = false
            charser.topAnchor.constraint(equalTo: allCases.bottomAnchor,constant: 0).isActive = true
            charser.leadingAnchor.constraint(equalTo: allCases.leadingAnchor,constant: 0).isActive = true
            charser.trailingAnchor.constraint(equalTo: allCases.trailingAnchor,constant: 0).isActive = true
            charser.heightAnchor.constraint(equalToConstant: v.frame.height/4.1).isActive = true

            let seekers = imageButton("BrownButton",.Seekers)
            v.addSubview(seekers)
            seekers.translatesAutoresizingMaskIntoConstraints = false
            seekers.topAnchor.constraint(equalTo: charser.bottomAnchor,constant: 0).isActive = true
            seekers.leadingAnchor.constraint(equalTo: allCases.leadingAnchor,constant: 0).isActive = true
            seekers.trailingAnchor.constraint(equalTo: allCases.trailingAnchor,constant: 0).isActive = true
            seekers.heightAnchor.constraint(equalToConstant: v.frame.height/4.1).isActive = true

            let strikers = imageButton("BrownButton",.Strikers)
            v.addSubview(strikers)
            strikers.translatesAutoresizingMaskIntoConstraints = false
            strikers.topAnchor.constraint(equalTo: seekers.bottomAnchor,constant: 0).isActive = true
            strikers.leadingAnchor.constraint(equalTo: seekers.leadingAnchor,constant: 0).isActive = true
            strikers.trailingAnchor.constraint(equalTo: seekers.trailingAnchor,constant: 0).isActive = true
            strikers.heightAnchor.constraint(equalToConstant: v.frame.height/4.1).isActive = true

            return v
        }()
        
        
       return  generalView
     
    }
    
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
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset =  CGSize(width: 1, height: 1)
        layer.shadowRadius = 10
        return self
    }
    
    /// Drag number star for dragon
    /// Parameters: @number:Int   Numbers start yellow
    func drawStart(number:Int,margin:UIView.ContentMode,size:CGSize,totalStart:Int = 2 ) {
        
        for x in 0...totalStart {
            let picture = x <= number ? "starB" : "starGray"
            let star = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.width))
            star.image = UIImage(named:  picture)!
            self.addSubview(star)
            
            star.translatesAutoresizingMaskIntoConstraints = false
            star.widthAnchor.constraint(equalToConstant: star.frame.width).isActive = true
            star.heightAnchor.constraint(equalTo: star.widthAnchor).isActive = true
            
            
            if margin == .bottom {
                let marginX  = star.frame.width * CGFloat(x-1)
                star.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: marginX).isActive = true
                star.topAnchor.constraint(equalTo: self.bottomAnchor,constant: 5).isActive = true
            } else if margin == .left {
                let marginX  = star.frame.width * CGFloat(x)
                star.topAnchor.constraint(equalTo: self.topAnchor,constant: 5).isActive = true
                star.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: marginX).isActive = true
            } else if margin == .center {
                let marginX  = star.frame.width * CGFloat(x-1)
                star.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: marginX).isActive = true
                star.centerYAnchor.constraint(equalTo: self.centerYAnchor,constant: 0).isActive = true
            } else if margin == .top {
                let marginX  = star.frame.width * CGFloat(x-1)
                star.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: marginX).isActive = true
                star.topAnchor.constraint(equalTo: self.bottomAnchor,constant: 0).isActive = true
            } else if margin == .bottomLeft {
                let marginX  = star.frame.width * CGFloat(x)
                star.topAnchor.constraint(equalTo: self.bottomAnchor,constant: 0).isActive = true
                star.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: marginX).isActive = true
            } else if margin == .right {
                let marginX  = star.frame.width * CGFloat(x)
                star.topAnchor.constraint(equalTo: self.topAnchor,constant: 5).isActive = true
                star.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -marginX).isActive = true
            }
    }
       
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


