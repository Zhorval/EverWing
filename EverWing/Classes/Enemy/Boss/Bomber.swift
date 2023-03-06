//
//  Bomber.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import SpriteKit
import GameplayKit
import SwiftUI



protocol ProtocolAttackBoss {
    
    func attack(node:SKNode)
    func punch(node:SKNode,parent:SKNode)
    func getBallAttackHand() -> SKNode
    func showEffectFX()
    func effectSpike()
    
}


class Bomber:Enemy {
  
    
    private var typeBoss:BossType?
    
    private var isActiveBigBall = false
    
    convenience init(hp:CGFloat,typeBoss:BossType,scene:SKScene,gameInfo:GameInfoDelegate){

        self.init()
        
        self.delegate = gameInfo
        
        self.typeBoss =  typeBoss
        
        print(typeBoss.rawValue)

        self.hp = hp
       
        name = "Enemy_Boss"
        
        showEffectFX()
        
        self.addChild(getBossParts())
        
        size = CGSize(width: 180, height: 180)
        position = CGPoint(x: screenSize.midX, y: screenSize.height + 100)
        alpha = 0
        userData = NSMutableDictionary()
        self.hp = hp
        self.maxHp = hp
        
        currency  = Currency(type: Currency.CurrencyType.Coin)
        
        // Set initial alpha
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody!.isDynamic = true
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.category = [.Enemy]
        self.physicsBody!.collisionBitMask = PhysicsCategory.Wall.rawValue | PhysicsCategory.WallFX.rawValue
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Wall.rawValue
        self.physicsBody!.allowsRotation = false
    
        run(.group([
            .fadeAlpha(to: 1, duration: 3),
            .moveTo(y:  screenSize.height - 300, duration: 5),
            .run {
                self.setAnimation()
                self.addHealthBar()
            }
        ]))
    }
   
    //MARK: ADD BOSS TO NODE SCREEN
    private func getBossParts() -> SKNode {
                
        let node = Mildred()
        
        node.setScale(1.5)
        
        return node
    }
    
    // MARK: ANIMATION MONSTERS TYPE
    private func setAnimation(){
        
        switch typeBoss {
        default: //.Monster_King,.Mildred,.Ice_Queen:
            self.run(.sequence([
                
                .wait(forDuration: 4),
                .repeatForever(.sequence([
                SKAction.move(to: CGPoint(x: 100, y: screenSize.maxY - self.frame.height ), duration: 3),
                SKAction.move(to: CGPoint(x: screenSize.maxX - (self.frame.width/2), y: screenSize.maxY - self.frame.height), duration: 3),
                SKAction.move(to: CGPoint(x: screenSize.midX, y: screenSize.midY), duration: 3),
                .run {
                    self.attack(node: self)
                }
            ]))]))
    /*    default: break
            
            func randomPoint() -> CGPoint {
                
                let screenRect = UIScreen.main.bounds

                let xPos = arc4random() % UInt32(screenRect.size.width)
                let yPos = arc4random() % UInt32(screenRect.size.height)

                return CGPoint(x: CGFloat(xPos), y: CGFloat(yPos))
            }

            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: screenSize.maxY))
            for _ in 0...20 {
                
                path.addCurve(to: randomPoint(), controlPoint1: randomPoint(), controlPoint2: randomPoint())
            }
            
            self.run(.repeatForever(.follow(path.cgPath, asOffset: false, orientToPath: false, speed: 200)))*/
        }
    }
    
    //MARK:  JOIN BOSS PART
    private func Mildred() -> SKNode{
        
        let node = SKNode()
        node.name = "NodeBoss"
        
            
        if let body  = typeBoss?.body  {
            body.name = "body"
            node.addChild(body)
            
            if let head = typeBoss?.head?[0] {
                head.name = "head"
                head.constraints = typeBoss?.headContraint
                body.addChild(head)
                
                if let earL = typeBoss?.ear {
                    earL.constraints = [SKConstraint.positionX(SKRange(constantValue: -28), y: SKRange(constantValue: 10))]
                    head.addChild(earL)
                    let earR = (earL.copy() as! SKSpriteNode).mirrorSprite()
                        earR.constraints = [SKConstraint.positionX(SKRange(constantValue: 28), y: SKRange(constantValue: 10))]
                        head.addChild(earR)
                }
            }
            
            if let helmet = typeBoss?.helmet{
                helmet.constraints = typeBoss?.helmetContraint
                body.addChild(helmet)
                
                if let diadem = typeBoss?.diadem {
                    diadem.constraints = typeBoss?.diademContraint
                    helmet.addChild(diadem)
                }
            }
            
            if let nose = typeBoss?.nose {
                nose.constraints = typeBoss?.noseContraint
                body.addChild(nose)
            }
            
            if let hornL =  typeBoss!.hornL {
                hornL.constraints =  typeBoss?.hornLContraint
                node.addChild(hornL)
                
                let miniHornR = typeBoss!.miniHorn!
                miniHornR.xScale = -1
                miniHornR.constraints = typeBoss?.miniHornRContraint!
                node.addChild(miniHornR)
                
                let hornR =  typeBoss!.hornR!
                hornR.constraints =  typeBoss?.hornRContraint
                node.addChild(hornR)
                
                let miniHornL =  typeBoss!.miniHorn!
                miniHornL.constraints = typeBoss?.miniHornLContraint
                node.addChild(miniHornL)
            }
        
            if let textureEye =  typeBoss?.eye?.first {
                let eyeL =  SKSpriteNode(texture: textureEye)
                eyeL.name = "eyeL"
                eyeL.constraints =  typeBoss?.eyeLContraint
                eyeL.run(.repeatForever(.animate(with: typeBoss!.eye!, timePerFrame: 0.5)))
                body.addChild(eyeL)
                
                if let eyelidL = typeBoss?.eyelid {
                    eyelidL.name = "eyelidL"
                    eyelidL.constraints =  typeBoss?.eyelidLContraint!
                    body.insertChild(eyelidL, at: 1)
                }
                
                if let eyelashesL =  typeBoss?.eyelashes {
                    eyelashesL.constraints = [
                        SKConstraint.zRotation(SKRange(constantValue: CGFloat(10).toRadians())),
                        SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: 10))]
                    eyeL.addChild(eyelashesL)
                }
                
               let eyeR = (eyeL.copy() as! SKSpriteNode).mirrorSprite()
                eyeR.name = "eyeR"
                eyeR.constraints = typeBoss?.eyeRContraint
                body.addChild(eyeR)
              
            }
            
            if let textureMouth =  typeBoss?.mouth {
                let bgMouth = SKSpriteNode(texture: textureMouth[1])
                bgMouth.name = "bgMouth"
                bgMouth.constraints = typeBoss?.bgMouthContraing
                node.addChild(bgMouth)
            }
            
            if let skirt = typeBoss?.skirt {
                skirt.name = "skirt"
                skirt.constraints  = typeBoss?.skirtContraint
                node.addChild(skirt)
                
                if let tail = typeBoss?.tail {
                    tail.constraints = [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: -23))]
                    tail.run(.repeatForever(.sequence([.rotate(byAngle: CGFloat(10).toRadians(), duration: 0.5),
                                                       .rotate(byAngle: CGFloat(-10).toRadians(), duration: 0.5)])))
                    skirt.addChild(tail)
                    
                    let effectDownMouth = typeBoss!.mouthExtraEffect!
                        effectDownMouth.constraints = [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: -45))]
                        node.addChild(effectDownMouth)
                }
            }
                
                
            if let legL = typeBoss!.legL {
                legL.name = "legL"
                legL.constraints = typeBoss!.legLContraint
                node.addChild(legL)
                if let textFootL =  typeBoss?.footL?.first {
                    let footL = SKSpriteNode(texture: textFootL).mirrorSprite()
                    footL.run(.repeatForever(.sequence([.wait(forDuration: 0.5),.animate(with: typeBoss!.footL!, timePerFrame: 0.5)])))
                        footL.name = "footL"
                        footL.constraints = typeBoss!.footLContraint
                        node.addChild(footL)
                }
                
                if let legR = typeBoss!.legR {
                    legR.name = "legR"
                    legR.constraints = typeBoss?.legRContraint
                    node.addChild(legR)
                    if let textFootR = typeBoss?.footR?.first{
                        let footR = SKSpriteNode(texture: textFootR)
                        footR.run(.repeatForever(.sequence([.animate(with: typeBoss!.footR!, timePerFrame: 0.5),.wait(forDuration: 0.5)])))
                        footR.name = "footR"
                        footR.constraints = typeBoss!.footRContraint
                        node.addChild(footR)
                    }
                }
                
                if let extralegL = typeBoss!.extraLegL {
                    extralegL.constraints = [SKConstraint.positionX(SKRange(constantValue: -35), y: SKRange(constantValue: -80))]
                    node.addChild(extralegL)
                }
                
                if let extralegR = typeBoss!.extraLegR {
                    extralegR.constraints = [SKConstraint.positionX(SKRange(constantValue: 40), y: SKRange(constantValue: -75))]
                    node.addChild(extralegR)
                }
            }

            if let miniArmR = typeBoss!.miniArm {
                
                let rotateMini = SKAction.rotate(byAngle:  CGFloat.random(in: 10...20).toRadians(), duration: 1)

                miniArmR.name = "miniArmR"
                miniArmR.anchorPoint = CGPoint(x: 0, y: 1)
                miniArmR.zRotation = 0
                miniArmR.constraints = [SKConstraint.positionX(SKRange(constantValue: 50), y: SKRange(constantValue: -10))]
                miniArmR.run(.repeatForever(.sequence([rotateMini,rotateMini.reversed()])))
                
                let miniHandR = SKSpriteNode(texture: SKTexture(cgImage: typeBoss!.miniHand!))
                miniHandR.constraints = [SKConstraint.positionX(SKRange(constantValue: 40), y: SKRange(constantValue: -35))]
                miniArmR.addChild(miniHandR)
                node.addChild(miniArmR)
                
                let miniArmL = miniArmR.copy() as! SKSpriteNode
                miniArmL.name = "miniArmL"
                miniArmL.xScale = -1
                miniArmL.constraints = [SKConstraint.positionX(SKRange(constantValue: -50), y: SKRange(constantValue: 0))]
                node.addChild(miniArmL)
            }
                
                if  typeBoss?.arm != nil {
                    let nodeArmL = fullArm(parent:body,side:Direction.Left).mirrorSprite()
                    nodeArmL.name = "nodeArmL"
                    
                    if typeBoss == .Monster_King {
                        if let lance = nodeArmL.childNode(withName: "upperArm")?.childNode(withName: "lowerArm") {
                            lance.constraints = [ SKConstraint.zRotation(SKRange(constantValue: .pi)) ,
                                                  SKConstraint.positionX(SKRange(constantValue: -20), y: SKRange(constantValue: 0)) ]
                            lance.run(.repeatForever(.sequence([
                                .run { [unowned self] in
                                    self.shootLanceMonsterKing(parent: node, lance: lance)
                                },.wait(forDuration: 5)])))
                        }
                    }
                    
                    let nodeArmR = fullArm(parent:body,side:Direction.Right)
                    nodeArmR.name = "nodeArmR"
                    
                    node.addChild(nodeArmL)
                    node.addChild(nodeArmR)
                    
                     node.run(.repeatForever(.sequence([
                     .run { [unowned self] in
                         if !isActiveBigBall && isEnablePositionShoot()  {
                             punch(node:node, parent: node)
                             if typeBoss == .Mildred {
                                 self.leafMildredAction()
                             }
                         }
                     },SKAction.wait(forDuration: 2)])))
                    
                }
            
                if let padL = typeBoss?.pad {
                    padL.constraints = typeBoss?.padLContraint
                    node.addChild(padL)
                    
                    let padR = (padL.copy() as! SKSpriteNode).mirrorSprite()
                    padR.constraints = typeBoss?.padRContraint
                    node.addChild(padR)
                }
            
                if let wingL = typeBoss?.wing  {
                    wingL.constraints = typeBoss?.wingLContraint
                    wingL.zPosition = body.zPosition-1
                    wingL.zRotation =  typeBoss == .Spike ? CGFloat(-45).toRadians() : 0
                    node.insertChild(wingL, at: 1)
                    
                    let wingR = wingL.copy() as! SKSpriteNode
                    wingR.xScale = -1
                    wingR.constraints = typeBoss?.wingRContraint
                    node.insertChild(wingR, at: 1)
                }
        }
        
        return node
    }
    
    
   
    // MARK: IS ENABLE BOSS SHOOT
    private func isEnablePositionShoot(maxHeight:CGFloat = 300) -> Bool {
        
        guard let scene = delegate?.getScene() else { return false }
        
        if  self.position.y >  screenSize.height - maxHeight && position.y < screenSize.height - frame.height {
           
            let alert = SKSpriteNode(color: .red.withAlphaComponent(0.2), size: scene.size)
                alert.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
                alert.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            scene.addChild(alert)
            alert.run(.sequence([.playSoundFileNamed("boss_alarm.m4a", waitForCompletion: false), .wait(forDuration: 0.5),.removeFromParent()]))
            return true
        }
        
        return false
    }
   /*
    // MARK: ANIMATION FOR ICE_QUEEN JOIN PARTS
    private func MosterQueenAndIceQueen()->SKNode {
        
        let node = SKNode()
        node.name = "NodeBoss"
        
        if typeBoss?.body != nil {
            let body =  typeBoss!.body!
            body.name = "body"
            node.addChild(body)
            if let skirt = typeBoss?.skirt{
                skirt.constraints = [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: -body.frame.height*0.9))]
                body.addChild(skirt)
            }
            
            if  let head =  typeBoss!.head {
                //  head.constraints = [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: head.frame.height*0.6))]
                head.constraints = typeBoss?.headContraint
                node.addChild(head)
                
                if let eyelidL = typeBoss!.eyelid {
                    eyelidL.constraints = [SKConstraint.positionX(SKRange(constantValue: -15), y: SKRange(constantValue: 0))]
                    head.addChild(eyelidL)
                    
                    let eyelidR = eyelidL.copy() as! SKSpriteNode
                    eyelidR.xScale = -1
                    eyelidR.constraints = [SKConstraint.positionX(SKRange(constantValue: 15), y: SKRange(constantValue: 0))]
                    head.addChild(eyelidR)
                }
                
                if typeBoss?.eye != nil {
                    let eyeL = SKSpriteNode(texture: typeBoss!.eye?.first!)
                    eyeL.run(.repeatForever(.animate(with: typeBoss!.eye!, timePerFrame: 0.5)))
                    eyeL.constraints = [SKConstraint.positionX(SKRange(constantValue: -12), y: SKRange(constantValue: 0))]
                    head.addChild(eyeL)
                    
                    let eyeR = eyeL.copy() as! SKSpriteNode
                    eyeR.xScale = -1
                    eyeR.constraints = [SKConstraint.positionX(SKRange(constantValue: 12), y: SKRange(constantValue: 0))]
                    head.addChild(eyeR)
                }
                
                if typeBoss?.mouth != nil {
                    let mouth = SKSpriteNode(texture: typeBoss!.mouth?.first!)
                    mouth.run(.repeatForever(.animate(with: typeBoss!.mouth!, timePerFrame: 0.5)))
                    mouth.constraints = [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: -15))]
                    head.addChild(mouth)
                }
                
                if let helmet = typeBoss!.helmet {
                    helmet.constraints = [SKConstraint.positionX(SKRange(constantValue: 0), y: SKRange(constantValue: CGFloat(typeBoss!.head!.frame.height/2)))]
                    head.addChild(helmet)
                }
                
                if typeBoss?.ear != nil {
                    let earL = SKSpriteNode(texture: typeBoss!.ear!)
                    earL.constraints = [SKConstraint.positionX(SKRange(constantValue: -CGFloat(typeBoss!.head!.frame.width/2)), y: SKRange(constantValue: 0))]
                    head.addChild(earL)
                    
                    let earR = earL.copy() as! SKSpriteNode
                    earR.xScale = -1
                    earR.constraints = [SKConstraint.positionX(SKRange(constantValue: CGFloat(typeBoss!.head!.frame.width/2)), y: SKRange(constantValue: 0))]
                    head.addChild(earR)
                }
            }
            
            if typeBoss?.arm != nil {
                
                let nodeArmL = fullArm(parent:body,side:Direction.Left)
                nodeArmL.name = "nodeArmL"
            //    nodeArmL.zPosition = head.zPosition-1
                nodeArmL.xScale = -1
                
                let nodeArmR = fullArm(parent:body,side:Direction.Right)
                nodeArmR.name = "nodeArmR"
             //  nodeArmR.zPosition = head.zPosition-1
                
                node.addChild(nodeArmR)
                node.addChild(nodeArmL)
                
                self.run(.repeatForever(.sequence([
                    .run { [unowned self] in
                        punch(node:node, parent: node)
                    },
                    SKAction.wait(forDuration: 2)
                ])))
                
                
                if let wingL = typeBoss?.wing  {
               //     wingL.zPosition = head.zPosition-1
                    wingL.constraints = [SKConstraint.positionX(SKRange(constantValue: -80), y: SKRange(constantValue: body.frame.height))]
                    if let subWings =  typeBoss?.wingShort  {
                        subWings.constraints = [SKConstraint.positionX(SKRange(constantValue: 5), y: SKRange(constantValue: -12))]
                        wingL.addChild(subWings)
                    }
                    node.insertChild(wingL, at: 1)
                    
                    let wingR = wingL.copy() as! SKSpriteNode
                    wingR.xScale = -1
                    wingR.zPosition = wingL.zPosition-1
                    wingR.constraints = [SKConstraint.positionX(SKRange(constantValue: 80), y: SKRange(constantValue: body.frame.height))]
                    node.insertChild(wingR, at: 1)
                }
            }
        }
            
        return node
    }
     */
    func fullArm(parent:SKNode,side:Direction) -> SKNode {
        
        let nodeArm = SKNode()
            nodeArm.constraints = (side == .Left ? typeBoss!.armLContraint! :  typeBoss!.armRContraint!)
        
        let arm =  typeBoss!.arm!
            arm.anchorPoint = typeBoss == .Mildred ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 1)
            arm.zRotation = typeBoss == .Monster_King ? CGFloat(180).toRadians() : 0
            arm.name = "upperArm"
        
            if let pad = typeBoss?.padArm {
                pad.constraints = typeBoss?.padArmContraint
                arm.addChild(pad)
            }
        
            if let foreArmL = typeBoss?.forearm {
                foreArmL.name = "foreArm"
                foreArmL.constraints =   typeBoss!.forearmLContraint!
                arm.addChild(foreArmL)
            }
          
        let hand =  typeBoss != .Monster_King ? typeBoss!.handL![0] : side == .Left ? typeBoss!.handL![0] : typeBoss!.handR![0]
            hand.name = "lowerArm"
            hand.constraints = typeBoss?.handContraint
            arm.addChild(hand)
            nodeArm.addChild(arm)
        
        return nodeArm
        
    }
  /*
    private func fullArmMosterQueenAndIceQueen(parent:SKNode,side:Direction) -> SKNode {
        
        let lookContraint = [
            SKConstraint.orient(to: parent, offset: SKRange(lowerLimit: 0)) ,
            SKConstraint.positionX(SKRange(constantValue: side == .Left  ? -40 : 40), y: SKRange(constantValue: 30)),
            SKConstraint.zRotation(side == .Left ?
                                   SKRange(lowerLimit: 3 * .pi / 4, upperLimit:  4 * .pi / 3) :
                                   SKRange(lowerLimit: 7 * .pi / 6, upperLimit: 12 * .pi / 6))
        ]
        
        let nodeArmL = SKNode()
        nodeArmL.constraints = lookContraint
        
        let upperArm =  typeBoss!.arm!
        upperArm.name = "upperArm"
        upperArm.yScale = -1
        upperArm.anchorPoint = CGPoint(x: 0.5, y: 1)
        upperArm.zRotation =   CGFloat(-40).toRadians()

        let midArm = typeBoss!.forearm!
        midArm.name = "midArm"
        midArm.anchorPoint = CGPoint(x: 0.5, y: 1)
        midArm.constraints = [SKConstraint.positionX(SKRange(constantValue: -CGFloat(typeBoss!.forearm!.frame.width)*0.8),
                                                     y: SKRange(constantValue: -CGFloat(typeBoss!.arm!.frame.height/2))) ]
        upperArm.addChild(midArm)
        
        let lowerArm =  typeBoss!.handL!
        lowerArm.name = "lowerArm"
        lowerArm.anchorPoint = CGPoint(x: 0.5, y: 1)
        lowerArm.position = CGPoint(x: -10, y: -(typeBoss!.forearm!.frame.height - typeBoss!.handL!.frame.height/2))
        midArm.addChild(lowerArm)
        
        nodeArmL.addChild(upperArm)
        
        return nodeArmL
    }
    */
    
    
    
    private func getHandSecondTexture(_ index:Int) -> SKTexture?{
        
        if typeBoss!.handL!.count > 0 {
            return typeBoss!.handL![index].texture
        }
        return typeBoss!.handL![0].texture
    }
        
    
    private func actionArm(semaphore:Direction,node:SKNode) {
        
        guard let  nodeArm = (node.childNode(withName: semaphore == .Left ? "nodeArmL" : "nodeArmR")!.childNode(withName: "upperArm") as? SKSpriteNode),
              let hand = nodeArm.childNode(withName: "lowerArm") as? SKSpriteNode else {  return }
        
        let head = nodeArm.parent!.parent?.childNode(withName: "body")?.childNode(withName: "head")
        
        let rotateArm:[BossType:CGFloat] = [.Monster_Queen:30,.Ice_Queen:30,.Spike:30,.Mildred:160,.Monster_King:160]
        
        let actionRotate = { [unowned self] (index:Int) -> SKAction in
            
             SKAction.sequence([.rotate(byAngle: semaphore  == .Left ? -rotateArm[self.typeBoss!]!.toRadians(): rotateArm[self.typeBoss!]!.toRadians(), duration: 0.1),
                                .run { [unowned self] in
                                   
                                    hand.texture =  index > 0  && self.typeBoss!.handL!.count > 0 ? self.typeBoss!.handL![1].texture : self.typeBoss!.handL![0].texture
                                    
                                    if head != nil && self.typeBoss!.head!.count > 1 {
                                        head!.run(.animate(with: self.typeBoss!.head![1...1].map { $0.texture! }, timePerFrame: 0.5, resize: true, restore: true))
                                    }
                                }])
        }
        
        if let ball = typeBoss!.ballHand {
            ball.name = "Enemy_Ball_Hand_"
            nodeArm.parent!.run(.sequence([
                actionRotate(1),   // Index number index array hands
                .wait(forDuration: 2),
                actionRotate(0).reversed(),
                .run { [unowned self] in
                    self.shootSmallHandBoss(hand: hand, direction: semaphore, ball: ball)
                }
            ]))
        }
    }
    
    // MARK: PREPARE LANCE MONSTER KING FOR SHOOT BALL GREEN
    // params @parent:SKNode: main parent sknode
    //        @lance:SKNode: lance
    private func shootLanceMonsterKing(parent:SKNode,lance:SKNode) {
          
        guard let textureBall = typeBoss?.bigProjectile?.first,
              let toon = delegate?.getCurrentToonNode() else { return }
        
        func setupPhysics(node:SKNode) {
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.frame.size.width/2)
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.fieldBitMask = GravityCategory.Ball
            node.physicsBody?.category = [.Enemy]
            node.physicsBody?.collisionBitMask = PhysicsCategory.Player.rawValue
        }
        
        func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
            return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
        }

        func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
            return sqrt(CGPointDistanceSquared(from: from, to: to))
        }
            
        let effectFX = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: typeBoss!.pathTextures)!.cgImage!.cropImage(to: CGRect(x: 6, y: 335, width: 57, height: 58))))
        
        let effectInside = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: typeBoss!.pathTextures)!.cgImage!.cropImage(to: CGRect(x: 75, y: 337, width: 54, height: 54))))
        
        
        effectInside.run(.sequence([
            .rotate(byAngle: 2 * .pi, duration: 1),
            .run{[unowned self] in
                for x in 1...5 {
                    let ball = SKSpriteNode(texture: textureBall)
                    ball.name = "Enemy_SmallBall_\(UUID().uuidString)"
                    ball.setScale(1)
                    setupPhysics(node: ball)
                    
                    let side = toon.position.x  > frame.midX ? 1 : -1
                    
                    ball.addFields(field: .velocityField(withVector: vector_float3(Float(side), -4, 0)))
                    
                    let radius = frame.width/2
                    
                    let angle =  -.pi / 5 * CGFloat( x * 2)
                    
                    let circleX = radius * cos(angle)
                    let circleY = radius * sin(angle)
                    
                    ball.position =  position
                    
                    ball.run(.sequence([
                        .move(to: CGPoint(x: circleX  + toon.frame.midX, y: (circleY + toon.frame.midY) + 300), duration: 2),
                        .colorize(with: .green, colorBlendFactor: 2, duration: 0.5),
                        delegate!.mainAudio.getAction(type: .Mildred_Attack),
                        .removeFromParent()
                    ]))
                    delegate?.addChild(ball)
                   
                }
            }, SKAction.wait(forDuration: 1),.removeFromParent()
            ]))
    
        effectFX.addChild(effectInside)
    
        effectFX.constraints = [SKConstraint.positionX(SKRange(constantValue: -12), y: SKRange(constantValue: effectFX.frame.height/2 + effectFX.frame.height/2))]
        
        effectFX.run(.repeatForever(.sequence([.fadeAlpha(to: 0.5, duration: 0.5), .fadeAlpha(to: 1, duration: 0.5),.wait(forDuration: 3), .removeFromParent()])))
                      
            lance.addChild(effectFX)
    }
   
    // MARK: RUN ACTION COLORIZE EYES MILDRED
    // params: @parent:SKNode : parent node Mildred
    private func colorizeEyes(parent:SKNode,nodeArm:SKNode,direction:Direction) {
    
        parent.enumerateChildNodes(withName: "eye*") { node, obj in
            
            node.run(.sequence([
                .colorize(with: .green, colorBlendFactor: 2, duration: 1),
                .wait(forDuration: 2),
                .colorize(with: .yellow, colorBlendFactor: 2, duration: 1),
            ]))
    }
}

    
    private  func setupPhysics(node:SKNode,isDinamic:Bool? = true,mass:CGFloat? = 100) {
        node.physicsBody = SKPhysicsBody(circleOfRadius:  node.frame.size.width/2)
        node.physicsBody?.isDynamic = isDinamic!
        node.physicsBody?.restitution = 1
        node.physicsBody?.mass = mass!
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.category = [.BallFX]
        node.physicsBody?.contactTestBitMask = PhysicsCategory.WallFX.rawValue
        node.physicsBody?.collisionBitMask = PhysicsCategory.Player.rawValue
    }
    
    private func shootSmallHandBoss(hand:SKNode,direction:Direction?,ball:SKNode) {
        
        guard let scene = delegate?.getScene() else { return }
       
        isActiveBigBall = !isActiveBigBall
        
        if isActiveBigBall {
            setupPhysics(node: ball)
            
            if typeBoss == .Ice_Queen {
                ball.position = hand.position
            } else {
                ball.position = CGPoint(x: direction == .Left ?  self.frame.midX - size.width/2  : self.frame.midX + size.width/2  , y: self.frame.midY)
            }
            scene.addChild(ball)

            ball.run(.sequence([
                directionBallBoss(hand: hand,direction: direction!,ball:ball),
              //  .spiral(startRadius: 0, endRadius: 2 * .pi, angle: -.pi/2, centerPoint: self.position, duration: 5),
              //  .applyAngularImpulse(10, duration: 0.5),
              //  .applyForce(CGVector(dx: circleX, dy: -screenSize.height), at:CGPoint(x: screenSize.midX, y: screenSize.minY), duration: 1),
            ]))
            
            isActiveBigBall = !isActiveBigBall
            self.run(delegate!.mainAudio.getAction(type: .Mildred_Attack))
              
       /*  for i in 0...numberOfCircle {
            let circle =   ball.copy() as! SKNode // SKEmitterNode(fileNamed: "ballHand") {
                circle.name = "Enemy_SmallBall_\(i)"
              /*  circle.particleSize = CGSize(width: 50, height: 50)
                circle.emissionAngleRange = .pi*/
                setupPhysics(node: circle)
                
           /*     let flame = SKEmitterNode(fileNamed: "ballHand")!
                    flame.particleSize = CGSize(width: 25, height: 25)
                    flame.position.y = circle.position.y+24
                circle.addChild(flame)*/
                
                let angle =  -(.pi/2) / Double(numberOfCircle) * Double(i * 2)
                let circleX = radius  * cos(CGFloat(angle))
                let circleY = radius * sin(CGFloat(angle))
                
               // circle.addFields(field: .velocityField(withVector: vector_float3(direction == .Left ? 1 : 0, -3, 0)))
                circle.position = CGPoint(x:  circleX + frame.midX , y:circleY + frame.midY )
                circle.run(.sequence([
                    directionBallBoss(hand: hand),
                  //  .spiral(startRadius: 0, endRadius: 2 * .pi, angle: -.pi/2, centerPoint: self.position, duration: 5),
                  //  .applyAngularImpulse(10, duration: 0.5),
                   // .applyForce(CGVector(dx: circleX, dy: -screenSize.height), at:CGPoint(x: screenSize.midX, y: screenSize.minY), duration: 1),
                    .removeFromParent()
                ]))
                scene.addChild(circle)
                
                if i == numberOfCircle-1 {
                    isActiveBigBall = !isActiveBigBall
                    self.run(delegate!.mainAudio.getAction(type: .Mildred_Attack))
                  
                }
            }*/
        }
    }
    
    private func directionBallBoss(hand:SKNode,direction:Direction,ball:SKNode) -> SKAction {
        
        guard let toon = delegate?.getCurrentToonNode().position else { return SKAction()}
        
        
        switch typeBoss {
        case .Spike:
            ball.position = CGPoint(x: direction == .Left ?  self.frame.midX - size.width/2  : self.frame.midX + size.width/2  , y: self.frame.midY)

            return SKAction.repeat(
                .sequence([
                    .move(to: CGPoint(x: direction == .Left ? toon.x + screenSize.width/2 : toon.x - screenSize.width/2, y: toon.y + CGFloat.random(in: -400...200)), duration: 1),
                    .playSoundFileNamed(AVAudio.SoundType.Mildred_Attack.rawValue, waitForCompletion: false)
                ])
                ,count: 1)
            
        case .Ice_Queen:
            ball.position = CGPoint(x: direction == .Left ?  self.frame.midX - size.width/2  : self.frame.midX + size.width/2  , y: self.frame.midY)
            
            var radius:Double  = size.width*0.5
            
            return .run { [unowned self] in
                for x in 0...3 {
                    let ballCopy = ball.copy() as! SKSpriteNode
                    ballCopy.name = "Enemy_Ball_Hand_\(x)"
                    
                    setupPhysics(node: ballCopy,isDinamic: false,mass:1)
                    
                    let angle =  .pi  / 3 * CGFloat(x*10)

                    radius += ballCopy.size.width*0.1
                    let X = radius * cos(Double(angle))
                    let Y = radius * sin(Double(angle))
                    ballCopy.position =  CGPoint(x: frame.midX + X , y: frame.midY + Y)
                    
                    ballCopy.run(.sequence([
                        .rotate(toAngle: .pi, duration: 1, shortestUnitArc: true),
                        .move(by: CGVector(dx: direction == .Left ? 100 : -100, dy: -500), duration: 1),.removeFromParent()]
                    ))
                    self.delegate!.addChild(ballCopy)
                }
            }
        default: return SKAction()
            
        }
        
    }
    
    private func leafMildredAction() {
        
        for _ in 0..<5 {
            
            let leaf = self.typeBoss!.leaf!
            leaf.name = "leaf_" + UUID().uuidString
            leaf.physicsBody = SKPhysicsBody(circleOfRadius: 15)
            leaf.physicsBody?.collisionBitMask = PhysicsCategory.None.rawValue
            leaf.physicsBody?.affectedByGravity = true
            leaf.physicsBody?.allowsRotation = true
            leaf.position = .zero
            leaf.run(.sequence([
                .applyImpulse(CGVector(dx: CGFloat.random(in: -75...75), dy: CGFloat.random(in: 5...10)), duration: 0.5),
                .wait(forDuration: 3),
                .removeFromParent()]))
            self.addChild(leaf)
        }
    }
    
    private func shootBigBoss(boss:SKNode) {
        
        if typeBoss == .Mildred { return }
        
        let bigBall =  SKSpriteNode(texture: typeBoss!.bigProjectile!.first!, size: CGSize(width: 75, height: 75))
            bigBall.physicsBody = SKPhysicsBody(circleOfRadius: 75)
            bigBall.physicsBody?.category = [.Enemy]
          //  bigBall.physicsBody?.contactTestBitMask = PhysicsCategory.Player
            bigBall.physicsBody?.isDynamic = true
            bigBall.physicsBody?.affectedByGravity = false
            bigBall.name = "Enemy_Ball_Hand_\(UUID().uuidString)"
            bigBall.position = boss.position
        
        bigBall.run(.sequence([
            .animate(with: typeBoss!.bigProjectile!, timePerFrame: 0.1),
            .wait(forDuration: 2),
            .applyForce(CGVector(dx: delegate!.getCurrentToonNode().position.x, dy: -1000), duration: 1),
            .removeFromParent(),
           ]))
        boss.addChild(bigBall)
    }
        
}

extension Bomber:ProtocolAttackBoss {
    
    // MARK: CREATE LATERAL FX SPRITES
    internal func showEffectFX() {
        
        switch typeBoss {
            case .Spike: effectSpike()
            default: return
        }
    }
    
    func effectSpike() {
        
        guard let delegate = delegate else { return }
       
        func physicsIce(node:SKNode) {
            
            node.physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
            node.physicsBody?.category = [.BallFX]
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.isDynamic = false
            node.physicsBody?.allowsRotation = false
            node.physicsBody?.contactTestBitMask = PhysicsCategory.Player.rawValue
        }
        
        let iceBerg:SKSpriteNode =  SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: typeBoss!.pathTextures)!.cgImage!.cropImage(to: CGRect(x: 268, y: 214, width: 27, height: 68)))).mirrorSprite(isVertical: true)
            iceBerg.anchorPoint = CGPoint(x: 0.5, y: 1)
        
        let ice = { [unowned self] (time:TimeInterval) -> SKSpriteNode in
            let ice = SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: typeBoss!.pathTextures)!.cgImage!.cropImage(to: CGRect(x: 158, y: 361, width: 17, height: 47))))
            ice.name = "Ice_\(UUID().uuidString)"
            ice.anchorPoint = CGPoint(x: 0.5, y: 1)
            ice.run(.repeat(.sequence([.rotate(byAngle: CGFloat(2).toRadians(), duration: time),.rotate(byAngle: CGFloat(-2).toRadians(), duration: time)]), count: 10))
            return ice
        }
        
        let effect:SKSpriteNode =  SKSpriteNode(texture: SKTexture(cgImage: UIImage(named: typeBoss!.pathTextures)!.cgImage!.cropImage(to: CGRect(x: 2, y: 3, width: 79, height: 160))))
            effect.physicsBody = SKPhysicsBody(rectangleOf: effect.size)
            effect.physicsBody?.category = [ .WallFX]
            effect.physicsBody?.contactTestBitMask = PhysicsCategory.BallFX.rawValue
            effect.physicsBody?.isDynamic = false
            effect.physicsBody?.restitution = 0.5
        
        let totalCount = round(screenSize.height  / effect.size.height)
        
        for x in 0...Int(totalCount) {
            if x == Int(totalCount - 1) {
                for a in 0...Int(round((screenSize.width/2)/iceBerg.size.width)) {
                    let iceBerg = iceBerg.copy() as! SKSpriteNode
                    iceBerg.name = "FX\(x)"
                    iceBerg.position = CGPoint(x: screenSize.minX + (iceBerg.size.width * CGFloat(a * 2)), y: screenSize.maxY-iceBerg.size.height )
                    delegate.addChild(iceBerg)
                    
                    let ice = ice(TimeInterval(a))
                    ice.position = CGPoint(x: screenSize.minX + (iceBerg.size.width * CGFloat(a*2))-iceBerg.size.width, y: screenSize.maxY )
                    physicsIce(node: ice)
                    ice.run(.sequence([.wait(forDuration: TimeInterval(Int.random(in: 2...8))),.move(to: CGPoint(x: ice.position.x, y: -100), duration: 1.5),.removeFromParent()]))
                    delegate.addChild(ice)
                }
            }
            
            let iceL = effect.copy() as! SKSpriteNode
                iceL.name = "FXL_\(x)"
                iceL.position = CGPoint(x: -25, y: screenSize.minY + (CGFloat(x) * effect.size.height*0.9))
                iceL.run(action: .playSoundFileNamed(AVAudio.SoundType.Ice_Appear.rawValue, waitForCompletion: false), optionalCompletion: nil)
            
            let iceR = iceL.copy() as! SKSpriteNode
                iceR.name = "FXR_\(x)"
                iceR.position = CGPoint(x: screenSize.maxX+25, y: screenSize.minY + (CGFloat(x) * effect.size.height*0.9))

            delegate.addChild(iceL)
            delegate.addChild(iceR)
        }
    }
    
    
    func attack(node:SKNode) {
        
        switch typeBoss {
         
            case .Spike:
            
            let spriteLeg = SKTexture(cgImage: UIImage(named: typeBoss!.pathTextures)!.cgImage!.cropImage(to: CGRect(x: 251, y: 365, width: 41, height: 41)))
            
             node.enumerateChildNodes(withName: "*", using: { [unowned self] n, o in
                    guard  let footL = n.childNode(withName: "footL") as? SKSpriteNode,
                           let footR = n.childNode(withName: "footR") as? SKSpriteNode,
                           let mouth = n.childNode(withName: "bgMouth") as? SKSpriteNode,
                           let armL = n.childNode(withName: "nodeArmL") ,
                           let armR = n.childNode(withName: "nodeArmR"),
                           let delegate = delegate else { return }
                 
                 footL.texture = spriteLeg
                 
                 footR.texture = spriteLeg

                 let spriMount = UIImage(cgImage: mouth.texture!.cgImage())
                 
                 let bgmounth  = UIImage(cgImage:  self.typeBoss!.mouth![0].cgImage())
               
                 mouth.texture =  spriMount.mergeWith(topImage: bgmounth)
                 
                 armL.run(.sequence([.rotate(byAngle: CGFloat(-45).toRadians(), duration: 0.5),.wait(forDuration: 2),.rotate(byAngle: CGFloat(45).toRadians(), duration: 0.5)]))
                 
                 armR.run(.sequence([.rotate(byAngle: CGFloat(45).toRadians(), duration: 0.5),.wait(forDuration: 2),.rotate(byAngle: CGFloat(-45).toRadians(), duration: 0.5)]))
                 
                 delegate.mainAudio.pause()

                 mouth.run(.sequence([.move(to: CGPoint(x: 2, y: -15), duration: 0.1),
                                       delegate.mainAudio.getAction(type: .Snow_Roar),
                                      .wait(forDuration: 1),
                                      .run { [unowned self] in
                                          mouth.texture = self.typeBoss!.mouth![1]
                                          footL.texture = self.typeBoss!.footL![0]
                                          footR.texture = self.typeBoss!.footR![0]
                                          delegate.mainAudio.play(type: .Background_Start)
                                      },
                                      .move(to: CGPoint(x: 0, y: 0), duration: 0.1),]))
             })
        case .Ice_Queen,.Monster_Queen:
            
                enumerateChildNodes(withName: "*") { [unowned self] n, o in
                    if let skirt =  n.childNode(withName: "skirt") {
                        guard let textures = self.typeBoss?.bigProjectile else { fatalError() }
                        let ball = SKSpriteNode(texture: textures.first!, color: UIColor().randomColor(), size: textures.first!.size())
                            setupPhysics(node: ball,isDinamic: true,mass: 100)
                            ball.physicsBody?.affectedByGravity = false
                        ball.position =  delegate!.getScene()!.convertPoint(toView: position)
                        let animate = SKAction.repeatForever(.animate(with: textures, timePerFrame: 0.5))
                        ball.run(.sequence([animate,.wait(forDuration: 3),.move(to: delegate!.getCurrentToonNode().position, duration: 3),.removeFromParent() ]))
                            delegate!.addChild(ball)
                    }
                }
            
            default: break
        }
        
    }
    
    func punch(node:SKNode,parent:SKNode) {
        
        guard let toon = delegate?.getCurrentToonNode().position else { return }
      
        actionArm(semaphore: toon.x > self.position.x ? .Left : .Right,node: node)
    }
    
    func getBallAttackHand() -> SKNode {
        
        switch typeBoss {
            case .Monster_Queen: return typeBoss!.ballHand!
            default: return SKNode()
        }
    }
}

extension UIImage {
  func mergeWith(topImage: UIImage) -> SKTexture {
    
        let bottomImage = self

        UIGraphicsBeginImageContext(CGSize(width: 63, height: 76))

        let areaSize = CGRect(x: 0, y: 0, width: 63, height: 76)
      
        bottomImage.draw(in: areaSize)

        topImage.draw(in: CGRect(x: 2, y: 0, width: topImage.size.width, height: topImage.size.height), blendMode: .normal, alpha: 1.0)

        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return  SKTexture(image:  mergedImage)
  }
}

extension SKNode {
    
    func addFields(field:SKFieldNode) {
        
        let fieldNode = field
        fieldNode.name = "fieldNode"
        fieldNode.strength = 5
        fieldNode.falloff = 10
        fieldNode.region = SKRegion(radius: 50)
        fieldNode.categoryBitMask = GravityCategory.Ball
        fieldNode.position = self.position
        fieldNode.minimumRadius = Float(self.frame.midX)
        fieldNode.isExclusive = true
        self.addChild(fieldNode)
       
    }
}

extension CGPoint {
    
    static func pointOnCircle(angle: CGFloat, radius: CGFloat, center: CGPoint) -> CGPoint {
        return CGPoint(x: center.x + radius * cos(angle),
                       y: center.y + radius * sin(angle))
    }

}

extension SKAction {
    static func spiral(startRadius: CGFloat, endRadius: CGFloat, angle
                       totalAngle: CGFloat, centerPoint: CGPoint, duration: TimeInterval) -> SKAction {

        // The distance the node will travel away from/towards the
        // center point, per revolution.
        let radiusPerRevolution = (endRadius - startRadius) / totalAngle

        let action = SKAction.customAction(withDuration: duration) { node, time in
            // The current angle the node is at.
            let θ = totalAngle * time / CGFloat(duration)

            // The equation, r = a + bθ
            let radius = startRadius + radiusPerRevolution * θ

            node.position =  CGPoint.pointOnCircle(angle: θ, radius: radius, center: centerPoint)
        }

        return action
    }
}

extension Enemy {
    
    /// Clone element array SpriteNode
    func cloneEnemy(elements:[Enemy],anchor:CGPoint,position:CGPoint,name:String) -> Enemy? {
        
        guard let copy = elements.randomElement()?.copy() as? Enemy else { return nil  }
        
        copy.name = name + "\(UUID().uuidString)"
        copy.anchorPoint = anchor
        copy.position = position
      
        return copy
    }
}


extension UIBezierPath {
    
    // MARK: PATH THAT THE BALL FOLLOWS IN THE HAND OF ALL THE MONSTERS
    static var pathMoster = { (withCenter: CGPoint, radius: CGFloat, startAngle: CGFloat  , endAngle:  CGFloat, clockwise: Bool) -> (CGPath) in
     
        let path = UIBezierPath()
      
        let center = CGPoint(x: withCenter.x +  radius ,y: withCenter.y + radius)
        
        path.move(to: center)
        
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle.toRadians(), endAngle: endAngle.toRadians(), clockwise: clockwise)
        return path.cgPath
    }
                        
    static var pathLine = { (origin:CGPoint,to:CGPoint) -> (CGPath) in
        
        let path = UIBezierPath()
        
        path.move(to: origin)
        path.addLine(to: to)
        
        return path.cgPath
    }
    
    
}
