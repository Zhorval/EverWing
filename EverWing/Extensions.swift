//
//  Extensions.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//
import Foundation
import AVFoundation
import SpriteKit
import UIKit


enum GameState{
    case Spawning  // state which waves are incoming
    case BossEncounter // boss encounter
    case WaitingState // Need an state
    case Attack // state when pick magnet
    case Running
    case NoState
    case Start
}

enum ContactType{
    case HitByEnemy
    case BallEnemyByToon
    case ToonByClover
    case ToonByMagnet
    case ToonByFlower
    case ToonByMushroom
    case EnemyGotHit
    case PlayerGetCoin
    case PlayerGetGem
    case BallHitIce
    case HitByDragon
    case HitByEggs
    case Immune
    case None
}


extension SKNode {
    
    func destroy(){
        
        self.physicsBody?.category = [.None]
        self.removeAllActions()
        self.removeFromParent()
    }
    
    func shadowNode(nodeName:String) -> SKEffectNode{
        
        let myShader = SKShader(fileNamed: "monogradient")
        
        let effectNode = SKEffectNode()
        effectNode.shader = myShader
        effectNode.shouldEnableEffects = true
        effectNode.addChild(self)
        effectNode.name = nodeName
        return effectNode
    }
}

extension SKNode{
    var power:CGFloat!{
        get {
            
            if let v = userData?.value(forKey: "power") as? CGFloat{
                return v
            }
            else{
                print ("Extension SKNode Error for POWER Variable: ",  userData?.value(forKey: "power") ?? -1.0 )
                return -9999.0
            }
            
        }
        set(newValue) {
            userData?.setValue(newValue, forKey: "power")
        }
    }
    
    func run(action: SKAction, optionalCompletion: (() -> Void)?){
        guard let completion = optionalCompletion else {
            run(action)
            return
        }
        
        run(SKAction.sequence([action, SKAction.run(completion)]))
        
    }
}

extension CGFloat {
    
    func isDevice()->Self {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 25
        case .phone,.unspecified,.carPlay,.mac,.tv:
            return 12
        @unknown default:
            return 12
        }
    }
}

extension SKScene{
    
    
    
    func removeBlur(blurNode:SKEffectNode) {
        var blurredNodes = [SKNode]()

        for node in blurNode.children {
            blurredNodes.append(node)
            node.removeFromParent()
        }

        for node in blurredNodes {
            self.addChild(node as SKNode)
        }

        self.shouldEnableEffects = false
        self.childNode(withName: "blurNode")?.removeFromParent()
      //  blurNode.removeFromParent()
        scene?.isPaused = false
    }
    
    func removeBackgroundBlack(removeBlur:SKEffectNode) {
        
        removeUIViews()
        let actions = DragonsMenuScene.ActionButton.allCases.filter {$0.getNameView != "nodeMain"}
        
        actions.forEach { name in
           removeChildren(in: self.children.filter { $0.name == name.getNameView} )
        }
    
       
        self.removeBlur(blurNode: removeBlur)
        
        let _ = self.children.filter{$0.name == "backgroundBlack"}.map { $0.removeFromParent() }
        childNode(withName: "nodeMain")?.run(.move(to: .zero, duration: 1))
    }
    
    
    func removeUIViews(){
        for view in (view?.subviews)! {
            view.removeFromSuperview()
        }
            
    }
    
    func recursiveRemovingSKActions(sknodes:[SKNode]){
        
        for childNode in sknodes{
            childNode.removeAllActions()
            if childNode.children.count > 0 {
                recursiveRemovingSKActions(sknodes: childNode.children)
            }
            
        }
    }
    
    func createUIButton(bname: String, offsetPosX dx:CGFloat, offsetPosY dy:CGFloat,typeButtom:Global.GUIButtons,size:CGSize? = nil) -> SKSpriteNode{
        
        let button = SKSpriteNode()
        button.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        button.texture = SKTexture(imageNamed: typeButtom.rawValue)
        button.position = CGPoint(x: dx, y: dy)
        button.size = size ?? CGSize(width: screenSize.width/4, height: screenSize.height/16)
        button.name = bname
        
        return button
    }
}



extension Bool {
    mutating func toggle() {
        self = !self
    }
}

extension SKAction {
    
    static let blink = SKAction.repeatForever(sequence([.fadeOut(withDuration: 1),
                                                        .fadeIn(withDuration: 1),
                                                        .fadeAlpha(by: 0, duration: 1)]))
    
    static let upDown  = { (value:CGFloat,time:TimeInterval) -> (SKAction) in
        
        let action = SKAction.repeatForever(SKAction.sequence([
        SKAction.move(by: CGVector(dx: 0, dy: value), duration: time),
        SKAction.move(by: CGVector(dx: 0, dy: -value), duration: time)]))
        return action
    }
    
    static let wait = SKAction.wait(forDuration: 2)

    
    static let moveWings = SKAction.repeatForever(SKAction.sequence([SKAction.resize(toWidth: screenSize.width * 0.097, duration: 0.1), SKAction.resize(toWidth: screenSize.height * 0.105, duration: 0.15)]))
    
}

/*RANDOM FUNCTIONS */

func random() -> CGFloat {
    return CGFloat(CGFloat(Float(arc4random()) / Float(0xFFFFFFFF)))
}

func random( min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func randomInt( min: Int, max: Int) -> Int{
    //return randomInt() * (max - min ) + min
    return Int(arc4random_uniform(UInt32(max - min + 1))) + min
}


// Fantastic explanation of how it works
// http://www.niwa.nu/2013/05/math-behind-colorspace-conversions-rgb-hsl/
fileprivate extension CGFloat {
    /// clamp the supplied value between a min and max
    /// - Parameter min: The min value
    /// - Parameter max: The max value
    func clamp(min: CGFloat, max: CGFloat) -> CGFloat {
        if self < min {
            return min
        } else if self > max {
            return max
        } else {
            return self
        }
    }
        
    /// If colour value is less than 1, add 1 to it. If temp colour value is greater than 1, substract 1 from it
    func convertToColourChannel() -> CGFloat {
        let min: CGFloat = 0
        let max: CGFloat = 1
        let modifier: CGFloat = 1
        if self < min {
            return self + modifier
        } else if self > max {
            return self - max
        } else {
            return self
        }
    }
    
    /// Formula to convert the calculated colour from colour multipliers
    /// - Parameter temp1: Temp variable one (calculated from luminosity)
    /// - Parameter temp2: Temp variable two (calcualted from temp1 and luminosity)
    func convertToRGB(temp1: CGFloat, temp2: CGFloat) -> CGFloat {
       if 6 * self < 1 {
           return temp2 + (temp1 - temp2) * 6 * self
       } else if 2 * self < 1 {
           return temp1
       } else if 3 * self < 2 {
           return temp2 + (temp1 - temp2) * (0.666 - self) * 6
       } else {
           return temp2
       }
   }
}


extension UIColor {
    /// Return a UIColor with adjusted luminosity, returns self if unable to convert
    /// - Parameter newLuminosity: New luminosity, between 0 and 1 (percentage)
    func withLuminosity(_ newLuminosity: CGFloat) -> UIColor {
        // 1 - Convert the RGB values to the range 0-1
        let coreColour = CIColor(color: self)
        var red = coreColour.red
        var green = coreColour.green
        var blue = coreColour.blue
        let alpha = coreColour.alpha
        
        // 1a - Clamp these colours between 0 and 1 (combat sRGB colour space)
        red = red.clamp(min: 0, max: 1)
        green = green.clamp(min: 0, max: 1)
        blue = blue.clamp(min: 0, max: 1)
        
        // 2 - Find the minimum and maximum values of R, G and B.
        guard let minRGB = [red, green, blue].min(), let maxRGB = [red, green, blue].max() else {
            return self
        }
        
        // 3 - Now calculate the Luminace value by adding the max and min values and divide by 2.
        var luminosity = (minRGB + maxRGB) / 2
        
        // 4 - The next step is to find the Saturation.
        // 4a - if min and max RGB are the same, we have 0 saturation
        var saturation: CGFloat = 0
        
        // 5 - Now we know that there is Saturation we need to do check the level of the Luminance in order to select the correct formula.
        //     If Luminance is smaller then 0.5, then Saturation = (max-min)/(max+min)
        //     If Luminance is bigger then 0.5. then Saturation = ( max-min)/(2.0-max-min)
        if luminosity <= 0.5 {
            saturation = (maxRGB - minRGB)/(maxRGB + minRGB)
        } else if luminosity > 0.5 {
            saturation = (maxRGB - minRGB)/(2.0 - maxRGB - minRGB)
        } else {
            // 0 if we are equal RGBs
        }
        
        // 6 - The Hue formula is depending on what RGB color channel is the max value. The three different formulas are:
        var hue: CGFloat = 0
        // 6a - If Red is max, then Hue = (G-B)/(max-min)
        if red == maxRGB {
            hue = (green - blue) / (maxRGB - minRGB)
        }
        // 6b - If Green is max, then Hue = 2.0 + (B-R)/(max-min)
        else if green == maxRGB {
            hue = 2.0 + ((blue - red) / (maxRGB - minRGB))
        }
        // 6c - If Blue is max, then Hue = 4.0 + (R-G)/(max-min)
        else if blue == maxRGB {
            hue = 4.0 + ((red - green) / (maxRGB - minRGB))
        }
        
        // 7 - The Hue value you get needs to be multiplied by 60 to convert it to degrees on the color circle
        //     If Hue becomes negative you need to add 360 to, because a circle has 360 degrees.
        if hue < 0 {
            hue += 360
        } else {
            hue = hue * 60
        }
        
        // we want to convert the luminosity. So we will.
        luminosity = newLuminosity
        
        // Now we need to convert back to RGB
        
        // 1 - If there is no Saturation it means that it’s a shade of grey. So in that case we just need to convert the Luminance and set R,G and B to that level.
        if saturation == 0 {
            return UIColor(red: 1.0 * luminosity, green: 1.0 * luminosity, blue: 1.0 * luminosity, alpha: alpha)
        }
        
        // 2 - If Luminance is smaller then 0.5 (50%) then temporary_1 = Luminance x (1.0+Saturation)
        //     If Luminance is equal or larger then 0.5 (50%) then temporary_1 = Luminance + Saturation – Luminance x Saturation
        var temporaryVariableOne: CGFloat = 0
        if luminosity < 0.5 {
            temporaryVariableOne = luminosity * (1 + saturation)
        } else {
            temporaryVariableOne = luminosity + saturation - luminosity * saturation
        }
        
        // 3 - Final calculated temporary variable
        let temporaryVariableTwo = 2 * luminosity - temporaryVariableOne
        
        // 4 - The next step is to convert the 360 degrees in a circle to 1 by dividing the angle by 360
        let convertedHue = hue / 360
        
        // 5 - Now we need a temporary variable for each colour channel
        let tempRed = (convertedHue + 0.333).convertToColourChannel()
        let tempGreen = convertedHue.convertToColourChannel()
        let tempBlue = (convertedHue - 0.333).convertToColourChannel()

        // 6 we must run up to 3 tests to select the correct formula for each colour channel, converting to RGB
        let newRed = tempRed.convertToRGB(temp1: temporaryVariableOne, temp2: temporaryVariableTwo)
        let newGreen = tempGreen.convertToRGB(temp1: temporaryVariableOne, temp2: temporaryVariableTwo)
        let newBlue = tempBlue.convertToRGB(temp1: temporaryVariableOne, temp2: temporaryVariableTwo)
        
        return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
    }
}
