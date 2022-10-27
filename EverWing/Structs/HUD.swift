//
//  Structs.swift
//  EverWing
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//


import Foundation
import SpriteKit

struct HUD{
    
    enum TextType {
        case Gold
        case Trophy
    }
    
    var root:SKSpriteNode
    private var width:CGFloat
    private var height:CGFloat
    private var pos:CGPoint
    private var textType:TextType
    private var validChar:Array = Array(0..<10).map { (i) -> Character in
        return Character(String(i))
    }
    
    init(width w:CGFloat, height h:CGFloat, position p:CGPoint, type:TextType){
        root = SKSpriteNode()
        width = w*0.9
        height = h*0.9
        pos = p
        textType = type
        validChar.append(Character(String(",")))
    }
    
    mutating func getNode(text:String) -> SKSpriteNode?{
        
        if !isValidString(text){
            return nil
        }
        
        let node = root
       // let node = SKSpriteNode()
    //    node.anchorPoint = self.anchorPoint
        node.size = CGSize(width: width, height: height)
        node.position = pos
        node.name = "hud"
       // node.color = UIColor.red
       // node.color = UIColor.black
        let textures = getTextures(text)
        
        var xTrack:CGFloat = 0.0
        
        for (i, t) in textures.enumerated(){
            
            if i == 0 {
                xTrack = 0
            }
            let hudtexture = SKSpriteNode()
            hudtexture.texture = t
            hudtexture.size = CGSize(width: t.size().width, height: t.size().height)
            let tw = hudtexture.size.width
            let th = hudtexture.size.height
            hudtexture.position = CGPoint(x: width/2 - tw*0.5 - xTrack, y: height/2 - th)
            node.addChild(hudtexture)
            xTrack += tw*0.8
        }
        
        return node
    }
    
    private func isValidString(_ str:String) -> Bool{
        for c in str{
            if !validChar.contains(c){
                print("\(str): IT IS INVALID")
                return false
            }
        }
        return true
    }
    
    private func getTextures(_ text:String) -> [SKTexture]{
        var pack:[SKTexture] = []
        for c in text.reversed(){
            pack.append(global.getHUDTexture(hudType: .Gold, text: String(c)))
        }
        return pack
    }
    
    private func stringParser(_ str:String){
        for c in str.reversed(){
            print(c)
        }
        
        
       // print("\(str): IT IS VALID")
    }
    
    
    
}
