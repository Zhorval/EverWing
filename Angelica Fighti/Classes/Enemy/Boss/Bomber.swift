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


class Bomber:Enemy {
    
    
    
    private var currency:Currency = Currency(type: .Coin)
    
    private var typeBoss:BossType?
    
    private var timer:Timer?
    
    private var emitter:SKEmitterNode?
    
   
    private var mainScene:SKScene?
    
    // Main type ball fire BossType
    private var mainBallBoster:SKSpriteNode?
    
    // Hand type ball fire BossType
    private var handBallBoster:SKSpriteNode?
    
    private var actionsStandBy:[SKTexture] {
    
        return  typeBoss!.getTextures(type:  typeBoss!, prefix: nil)

    }
   
    private var gameToon = GameInfo()
    
    convenience init(hp:CGFloat,typeBoss:BossType,scene:SKScene){

        self.init()
        
        self.mainScene = scene
        
        self.typeBoss =   .Spike
        gameToon.showEffectFxBossAppears(typeBoss:self.typeBoss!,scene:scene)

        self.hp = 10000
        name = "Enemy_Boss"
       
        getAllBallHand()

        self.addChild(getBossParts())
        size = CGSize(width: 180, height: 180)
        position = CGPoint(x: screenSize.size.width/2, y: screenSize.size.height - size.height)
        alpha = 0
        userData = NSMutableDictionary()
        self.hp = hp
        self.maxHp = hp
        
        currency  = Currency(type: .Coin)

        
        // Set initial alpha
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody!.isDynamic = true
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.categoryBitMask = PhysicsCategory.Imune
        self.physicsBody!.friction = 0
        self.physicsBody!.collisionBitMask = PhysicsCategory.Wall
        self.physicsBody!.contactTestBitMask = PhysicsCategory.Wall
        self.physicsBody!.restitution = 1
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.linearDamping = 1
        self.physicsBody!.fieldBitMask = GravityCategory.None
        
       
        // adding healthbar
        self.addHealthBar()
        self.initialSetup(category: PhysicsCategory.Enemy)
        setAnimation()
    }
    
    deinit {
        guard let timer = timer else {
            return
        }
        timer.invalidate()
       
    }
    
    
    //MARK: GET BALL FIRE BY HAND TYPEBOSS
    private func getAllBallHand() {
        
        switch typeBoss {
            case .Ice_Queen:
                self.handBallBoster = SKSpriteNode(imageNamed: "Bubbles")
            case .Monster_King:
                self.handBallBoster = SKSpriteNode(imageNamed: "Bubbles")
                self.mainBallBoster = SKSpriteNode(imageNamed: self.typeBoss!.rawValue + "_Projectile")
            case .Mildred:
                self.handBallBoster = SKSpriteNode(imageNamed: "ballMildred")
            case .Spike:
                self.handBallBoster = SKSpriteNode(imageNamed: self.typeBoss!.rawValue + "_Projectile_Hand")
            default:
                self.handBallBoster =  SKSpriteNode(imageNamed: "Bubbles")
        }
    }
    
    
    //MARK: ADD BOSS TO NODE SCREEN
    private func getBossParts() -> SKNode {
        
        if self.typeBoss == .Monster_King {
            return MonsterKingParts()
        
        } else if self.typeBoss == .Mildred {
            return MildredParts()
            
        } else if self.typeBoss == .Ice_Queen {
            return IceQueenParts()
            
        }  else if self.typeBoss == .Spike {
            return SpikeParts()
            
        } else if self.typeBoss == .Monster_Queen {
            return IceQueenParts()
            
        } else {
            return SKSpriteNode(texture: actionsStandBy.first ??  global.getMainTexture(main: .Boss_1))
        }
    }
    
    // MARK: ANIMATION MONSTERS TYPE
    private func setAnimation(){
        
        switch typeBoss {
        case .Monster_King,.Mildred,.Ice_Queen,.Spike:
            self.run(.repeatForever(.sequence([
                SKAction.move(to: CGPoint(x: 100, y: screenSize.maxY - self.frame.height), duration: 3),
                SKAction.move(to: CGPoint(x: screenSize.maxX - (self.frame.width/2), y: screenSize.maxY - self.frame.height), duration: 3),
                SKAction.move(to: CGPoint(x: screenSize.midX, y: screenSize.midY), duration: 3)
            ])))
            
        default: break
            
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
            
            self.run(.repeatForever(.follow(path.cgPath, asOffset: false, orientToPath: false, speed: 200)))
        }
    }
    
    // MARK: GET EMITTER TYPEBOSS
    private func getEmitter(nodePosition:SKNode?) -> SKEmitterNode {
        
        switch typeBoss {
            case .Ice_Queen:
                emitter =  SKEmitterNode.getBallHandIceQueen
            case .Monster_King:
                emitter =  SKEmitterNode().addBallMosterKing(node: nodePosition! as! SKSpriteNode)
            case .Spike:
                emitter =  SKEmitterNode(fileNamed: "SpikeArm")!
            case .Monster_Queen:
                emitter =  SKEmitterNode(fileNamed: "SpikeArm")!
            
            default: break
        }
        emitter?.run(.sequence([.wait(forDuration: 3),.removeFromParent()]))
        return emitter!
    }
    
    // MARK: SEQUENCE LEAF ARM MILFRED
    private func addPhysicsBall(node:[SKSpriteNode],gravity:Bool = true,velocity:CGVector? = nil) {
       
        for x in 0..<node.count {
            node[x].physicsBody = SKPhysicsBody(circleOfRadius: node[x].size.width/2)
            node[x].physicsBody!.isDynamic = true
            node[x].physicsBody!.affectedByGravity = gravity
            node[x].physicsBody!.categoryBitMask = PhysicsCategory.Enemy
            node[x].physicsBody!.contactTestBitMask = PhysicsCategory.Player
          //  node[x].physicsBody!.fieldBitMask = GravityCategory.Player
            node[x].physicsBody!.collisionBitMask = 0
            node[x].physicsBody?.allowsRotation = false
           
            if velocity != nil {
                node[x].physicsBody?.velocity = velocity!
            }
        }
    }
    
    // MARK: SEQUENCE BALL ARM MILFRED AND PATH
    private func addBallMoster(nodePosition:SKSpriteNode,path:CGPath) ->SKSpriteNode {
        
        guard let handBallBoster = handBallBoster else {
            return SKSpriteNode()
        }

        let copy = handBallBoster.copy() as! SKSpriteNode
        
         copy.blendMode = .screen
         copy.texture = handBallBoster.texture
         copy.name = "Enemy_Ball_Clone_\(UUID().uuidString)"
         copy.position.x = nodePosition.position.x - 60
         copy.position.y = nodePosition.position.y - 5
         copy.run(SKAction.repeatForever( SKAction.sequence([
            SKAction.follow(path, duration: 5),
            SKAction.wait(forDuration: 2),
            SKAction.removeFromParent()
         ])))
        return copy
    }
    
    // MARK: SEQUENCE BALL ARM SPIKE AND PATH
    private func addBallMosterSpike(nodeHand:SKSpriteNode,nodePlayer:CGPoint) ->SKSpriteNode {
        
        var path:SKSpriteNode = SKSpriteNode()
        
        guard let handBallBoster = handBallBoster else {
            return SKSpriteNode()
        }
       
            path = handBallBoster.copy() as! SKSpriteNode
            path.name = "Enemy_Ball_Clone_\(UUID().uuidString)"
            path.texture = handBallBoster.texture
            path.position = CGPoint(x: nodeHand.position.x , y: nodeHand.position.y - 50)
        
        return path
    }
    
    // MARK: ANIMATION FOR MONSTER_KING JOIN PART
    private func SpikeParts() ->SKNode {
        
        let node = SKNode()
        node.name = "Node"
        
        let atlasIdle = SKTextureAtlas().loadAtlas(name: typeBoss!.rawValue + "_Body_Animation", prefix: nil)
        let atlasHead = SKTextureAtlas().loadAtlas(name: self.typeBoss!.rawValue + "_Head_Animation", prefix: nil)
        
        let body = SKSpriteNode(texture: atlasIdle.first!)
            body.run(.repeatForever(.animate(with: atlasIdle, timePerFrame: 0.8)))
            node.addChild(body)
        
        let wingsL = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Wing")
            wingsL.name = typeBoss!.rawValue + "_WingL"
            wingsL.position = CGPoint(x: -20, y: body.frame.height/2)
            wingsL.zPosition = -1
            wingsL.run(.moveWings)
            node.addChild(wingsL)
       
        let wingsR = wingsL.copy() as! SKSpriteNode
            wingsR.name = typeBoss!.rawValue + "_WingR"
            wingsR.xScale = -1
            wingsR.position = CGPoint(x: 20, y: body.frame.height/2)
            wingsR.zPosition = -1
            wingsL.run(.moveWings)
            node.addChild(wingsR)
        
        let armR = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Arm")
            armR.anchorPoint = CGPoint(x: 0, y: 1)
            armR.xScale = -1
            armR.zPosition = -1
            armR.name = typeBoss!.rawValue + "_ArmR"
            armR.position = CGPoint(x: -40, y: 50)
            node.addChild(armR)
       
        let armL = armR.copy() as! SKSpriteNode
            armL.xScale = 1
            armL.position = CGPoint(x: 40, y: 50)
            armL.name = typeBoss!.rawValue + "_ArmL"
            node.addChild(armL)
        
        let head = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Head")
            head.position = CGPoint(x: 0, y: head.frame.height/2.2)
            node.addChild(head)
        
        
        let actionRotateArm = { (node:SKSpriteNode) -> (SKAction) in
            
            let isArmR =  node.name?.contains("_ArmR")
            let count:CGFloat = 6
            var index:CGFloat = 0.0
            var dx:CGFloat = 0.0
            var dy:CGFloat = 0.0
            
            let action =
            SKAction.sequence([
                .rotate(toAngle: CGFloat(isArmR! ? -Int.random(in: 45...90) : Int.random(in: 45...90)).toRadians(), duration: 0.05, shortestUnitArc: true),
                .wait(forDuration: 1),
                .rotate(toAngle: isArmR! ? -CGFloat.random(in: 0...30).toRadians() : CGFloat.random(in: 0...30).toRadians(), duration: 0.05, shortestUnitArc: true),
                .run {
                    head.run(.animate(with: atlasHead, timePerFrame: 0.3))

                    node.run(SKAction.repeat(.sequence([
                        .run {
                            let copy = self.handBallBoster?.copy() as! SKSpriteNode
                            copy.name = "Enemy_\(UUID().uuidString)"
                            copy.setScale(0.5)
                            let emitter = self.getEmitter(nodePosition: copy)
                            emitter.targetNode = copy
                            
                            copy.addChild(emitter)
                            dx = screenSize.midX/count * index
                            dy =  screenSize.height/2
                            index += 1
                            self.addPhysicsBall(node: [copy],gravity: false,velocity: isArmR! ?  CGVector(dx: dx, dy: -dy) : CGVector(dx: dx, dy: -dy))
                            node.addChild(copy)
                        },
                        .wait(forDuration: 0.05)
                    ]), count: Int(count)))
                    
                },
                GameInfo().mainAudio.getAction(type: .Boss_Tree_Attack),
                .wait(forDuration: 2)
                
            ])
            
            return action
        }
        
        // First cry animation
        
        armR.run(.sequence([
            .wait(forDuration: 3),
            .run {
                node.run(.sequence([
                    .scale(to: 1.3, duration: 0.3)
                ]))
            },
            .rotate(toAngle: CGFloat(-90).toRadians(), duration: 0.1),
            .run {
                head.run(.animate(with: atlasHead, timePerFrame: 0.3))
                body.removeAllActions()
                body.run(.setTexture(SKTexture(imageNamed: self.typeBoss!.rawValue + "_Body_Crazy")))
                armL.run(.sequence([
                    .rotate(toAngle: CGFloat(90).toRadians(), duration: 0.1),
                    .wait(forDuration: 5),
                    .rotate(toAngle: CGFloat(-10).toRadians(), duration: 0.5)
                ]))
                node.run(.sequence([
                    .scale(to: 1, duration: 0.3)
                ]))
                
            },
            .wait(forDuration: 5),
            .rotate(toAngle: CGFloat(10).toRadians(), duration: 0.5),
            .run {
                body.run(.repeatForever(.animate(with: atlasIdle, timePerFrame: 0.8)))
                self.effectFxBossSpike()
            }
        ]))
       
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { time in
            switch Int.random(in: 0..<3) {
             case 0:
                  armR.run(actionRotateArm(armR))
                case 1:
                    armL.run(actionRotateArm(armL))
                default  :
                armR.run(actionRotateArm(armR))
                armL.run(actionRotateArm(armL))
                
            }
        }
        return node
    }
    
    // MARK: ANIMATION FOR MONSTER_KING JOIN PART
    private func MonsterKingParts() ->SKNode {
        
       
       /* let pathToFollow = UIBezierPath()
        pathToFollow.move(to: .zero)
        pathToFollow.addArc(withCenter: CGPoint(x: 300, y: 0), radius: 300, startAngle: .pi  , endAngle: .pi/180, clockwise: true)*/
      
        let node = SKNode()
        node.name = "Node"
        
        let head = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Head")
        let wingsL = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Wing")
            wingsL.name = typeBoss!.rawValue + "_WingL"
            wingsL.position = CGPoint(x: -head.frame.width/2, y: 0)
            wingsL.zPosition = -1
            wingsL.run(.moveWings)
            head.addChild(wingsL)

       
        let wingsR = wingsL.copy() as! SKSpriteNode
            wingsR.name = typeBoss!.rawValue + "_WingR"
            wingsR.xScale = -1
            wingsR.position = CGPoint(x: head.frame.width/2, y: 0)
            wingsR.zPosition = -1
            head.addChild(wingsR)
            wingsR.run(.moveWings)
        
       

        let mouth = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Mouth")
            mouth.name = typeBoss!.rawValue + "_Mouth"
            mouth.alpha = 0
            head.addChild(mouth)
        
        let breathR = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Breath")
            breathR.name = typeBoss!.rawValue + "_BreathR"
            breathR.alpha = 0
            breathR.position.x = -10
            breathR.run(.sequence([.fadeIn(withDuration: 0.3),.moveBy(x: 0, y: -50, duration: 0.5),.removeFromParent()]))
       
        
        let lance = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Lance")
            lance.name = typeBoss!.rawValue + "_Lance"
            lance.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            lance.position = CGPoint(x: -head.frame.width/2, y: 0)
            lance.zPosition = -1
            head.addChild(lance)

   
        let actionLance = SKAction.run {
                lance.run(SKAction.sequence([
                    .wait(forDuration: 5),
                    .run {
                        let copy =  SKEmitterNode().addBallMosterKing(node: lance).copy() as! SKEmitterNode
                //        self.addPhysicsBall(node: [copy])
                        copy.position = CGPoint(x: lance.position.x+25, y: lance.frame.height/2-20)
                        copy.targetNode = lance
                        copy.run(.sequence([
                            .wait(forDuration: 0.1),
                            .move(by: CGVector(dx: GameInfo.currentPlayerPosition.x, dy: -screenSize.height), duration: 0.8),
                            .wait(forDuration: 10),
                             .removeFromParent()]))
                       
                        lance.addChild(copy)
                    }]))}
            
        
        
        lance.run(.repeatForever(.group([
                actionLance,
                .run {
                    let copy =  self.mainBallBoster?.copy() as! SKSpriteNode
                    copy.position = .zero
                    mouth.alpha = 1
                    copy.name = "Enemy_\(UUID().uuidString)"
                    self.addPhysicsBall(node: [copy])
                    copy.run(.repeat(.sequence([
                        .move(by: CGVector(dx: CGFloat.random(in: -screenSize.width/2...screenSize.width/2) ,
                                           dy: -800), duration: 2),
                        .wait(forDuration: 0.1),
                        .fadeOut(withDuration: 0.5),
                        .removeFromParent(),
                    ]),count: 3))
                            
                            let breath = breathR.copy() as! SKSpriteNode
                            let breathL = breath.copy() as! SKSpriteNode
                                breathL.xScale  = -1
                                breathL.position.x = breath.position.x + 20
                                mouth.addChild(breath)
                                mouth.addChild(breathL)
                                mouth.addChild(copy)
                    },
                GameInfo().mainAudio.getAction(type: .Boss_King_Burp),
               
        ])))
      
       
        node.addChild(head)
        return node
    }
    
    // MARK: ANIMATION FOR MILDRED JOIN PARTS
    private func MildredParts()->SKNode {
        
        guard let handBallBoster = handBallBoster else {

            return SKNode()
        }
        
        let spritNodeLeaf = SKSpriteNode(imageNamed: "leaf")


        // MARK: SEQUENCE BALL ARM MILFRED
        func addBallMoster(nodePosition:SKSpriteNode) ->SKSpriteNode {
            
             let copy = handBallBoster.copy() as! SKSpriteNode
             let valueRotation:Bool = nodePosition.name?.contains("_ArmL") ?? false
            
             copy.blendMode = .screen
             copy.texture = SKTexture(imageNamed: "ballMildred")
             copy.name = "Enemy_Ball_Clone_\(UUID().uuidString)"
             copy.position = nodePosition.position
             copy.run(SKAction.repeatForever( SKAction.sequence([
                SKAction.follow(pathToFollow(valueRotation), duration: 1),
                SKAction.wait(forDuration: 2),
                SKAction.removeFromParent()
             ])))
            return copy
        }
        
        // MARK: SEQUENCE LEAF ARM MILFRED
        func addLeafMoster() ->SKSpriteNode {
            
            let emiterLeaf = spritNodeLeaf.copy() as! SKSpriteNode
                emiterLeaf.position.y = -self.frame.height/2
                emiterLeaf.run(SKAction.repeatForever( SKAction.sequence([
                    .rotate(byAngle: CGFloat.random(in: -100...100) > 0 ? .pi : .pi/3, duration: 0.1),
                    SKAction.move(by: CGVector(dx: -Int.random(in: -300...300), dy: -Int.random(in: 50...500)), duration: 1),
                         SKAction.removeFromParent()
                 ])))
            return emiterLeaf
        }
        
        let node = SKNode()
            node.name = "Node"
            node.run(.upDown(10,1))
        
        let head = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Body")
            head.name = typeBoss!.rawValue + "_Body"
            head.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let pathToFollow   = { (node:Bool) -> (CGPath) in
            
            let path = UIBezierPath(arcCenter: .zero,
                                    radius: 50,
                                    startAngle: .pi ,
                                    endAngle: .pi*2,
                                    clockwise: node)
            
            let transform = CGAffineTransform(scaleX: 1.1, y: 2)
            path.apply(transform)
            return path.cgPath
        }
        
        let wingsL = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Wing")
            wingsL.anchorPoint = CGPoint(x: 1, y: 0.5)
            wingsL.name = typeBoss!.rawValue + "_WingL"
            wingsL.position = CGPoint(x: -head.frame.width/3, y: 0)
            wingsL.zPosition = -1
       
        let wingsR = wingsL.copy() as! SKSpriteNode
            wingsR.name = typeBoss!.rawValue + "_WingR"
            wingsR.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            wingsR.xScale = -1
            wingsR.position = CGPoint(x: head.frame.width/3, y: 0)
            wingsR.zPosition = -1
        
        let legL = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Leg")
            legL.name = typeBoss!.rawValue + "_LegL"
            legL.position = CGPoint(x: 10, y: -head.frame.height/2)
            legL.zPosition = 1
       
        let legR = legL.copy() as! SKSpriteNode
            legR.name = typeBoss!.rawValue + "_LegR"
            legR.xScale = -1
            legR.position = CGPoint(x: -30, y: -head.frame.height/2)
            legR.zPosition = 1
        
        let armR = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Arm_R")
            armR.anchorPoint = CGPoint(x: 0, y: 1)
            armR.name = typeBoss!.rawValue + "_ArmR"
            armR.position = CGPoint(x: 25, y: -50)
            armR.zPosition = 1
       
        let armL = armR.copy() as! SKSpriteNode
            armL.name = typeBoss!.rawValue + "_ArmL"
            armL.xScale = -1
            armL.position = CGPoint(x: -50, y: -50)
            armL.zPosition = 1
        
        let handR = SKSpriteNode(imageNamed: typeBoss!.rawValue + "_Hand_R")
            handR.anchorPoint = CGPoint(x: 1, y: 1)
            handR.name = typeBoss!.rawValue + "_HandR"
            handR.position = CGPoint(x: -60, y: -10)
            handR.zPosition = -1
            
       
        let handL = handR.copy() as! SKSpriteNode
            handL.name = typeBoss!.rawValue + "_HandL"
            handL.xScale = -1
            handL.zPosition = -1
            handL.position = CGPoint(x: 30, y: 0)
           
        
        wingsL.run(.moveWings)
        wingsR.run(.moveWings)
        
        
        let actionRotateArm = { (node:SKSpriteNode) -> (SKAction) in
            
            let action =
            SKAction.repeatForever(.sequence([
                .rotate(toAngle: (node.name?.contains("_ArmL"))! ? -.pi/2 : .pi/2, duration: 0.5),
                .run {
                    handR.run(
                    SKAction.repeatForever(.sequence([
                        .rotate(toAngle:  0, duration: 0.75),
                        .wait(forDuration: 2.5),
                        .rotate(toAngle:  .pi/2, duration: 0.5),
                        ])))
                   
                    handL.run(
                    SKAction.repeatForever(.sequence([
                        .rotate(toAngle:  0, duration: 0.75),
                        .wait(forDuration: 2.5),
                        .rotate(toAngle:  -.pi/2, duration: 0.5),
                        ])))
                },
                .wait(forDuration: 1),
                .rotate(toAngle: (node.name?.contains("_ArmL"))! ? Double.pi/2 : -.pi/2, duration: 0.01),
                
                .run {
                    
                    let fx =  SKSpriteNode(imageNamed: node.name! + "_FX")
                    fx.position = CGPoint(x: (node.name?.contains("ArmL"))! ? -75 : 100, y: -head.frame.height/2)
                    fx.run(.sequence([
                        GameInfo().mainAudio.getAction(type: .Boss_Tree_Attack),
                        .fadeOut(withDuration: 1),
                        .removeFromParent()
                    ]))
                    head.addChild(fx)
                    
                    armL.run(SKAction.repeat(SKAction.sequence([
                        .run {
                            
                            let copy = addBallMoster(nodePosition: node)
                            let emitterLeaf = addLeafMoster()
                            self.addPhysicsBall(node: [copy])
                            armR.addChild(copy)
                            head.addChild(emitterLeaf)
                        },.wait(forDuration: 0.1)]),count: 5))
            },
            .wait(forDuration: 3)]))
            return action
        }
       
        armR.run(actionRotateArm(armR))
        armL.run((actionRotateArm(armL)))
       
        
        head.addChild(wingsL)
        head.addChild(wingsR)
        head.addChild(legL)
        head.addChild(legR)
        head.addChild(armL)
        head.addChild(armR)
        head.addChild(handL)
        head.addChild(handR)
        node.addChild(head)
        return node
    }
    
    // MARK: ANIMATION FOR ICE_QUEEN JOIN PARTS
    private func IceQueenParts()->SKNode {
       
      
        let node = SKNode()
        node.name = "Node"
        
        
        let head = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Head")
        node.addChild(head)
        let eyeAtlas = SKTextureAtlas().loadAtlas(name: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Eye_Animation", prefix: nil)
        
        let eyeL = SKSpriteNode(texture: eyeAtlas.first!)
            eyeL.name = typeBoss!.rawValue + "_EyeL"
            eyeL.position =  CGPoint(x: -13, y: -20)
            eyeL.run(.repeatForever(.animate(with: eyeAtlas, timePerFrame: 0.3)))
            head.addChild(eyeL)
            
        let eyeR = eyeL.copy() as! SKSpriteNode
            eyeR.name = typeBoss!.rawValue + "_EyeR"
            eyeR.position =  CGPoint(x: 13, y: -20)
            eyeR.xScale = -1
            head.addChild(eyeR)
        
        let wingsL = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Wing")
            wingsL.anchorPoint = CGPoint(x: 1, y: 0.5)
            wingsL.name = typeBoss!.rawValue + "_WingL"
            wingsL.position = CGPoint(x: -head.frame.width * 0.25, y: head.frame.height*0.4)
            wingsL.zPosition = -3
            wingsL.run(.repeatForever(.sequence([
                .resize(toWidth: wingsL.frame.width * 0.85, duration: 0.8),
                .resize(toWidth: wingsL.frame.width, duration: 0.8),
            ])))
            node.addChild(wingsL)
        
        let wingsR = wingsL.copy() as! SKSpriteNode
            wingsR.name = typeBoss!.rawValue + "_WingR"
            wingsR.xScale = -1
            wingsR.position = CGPoint(x: head.frame.width*0.25, y: head.frame.height*0.4)
            wingsR.zPosition = -1
            node.addChild(wingsR)
      
        
        let body = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Body")
            body.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Body"
            body.position = CGPoint(x: head.position.x, y: -head.frame.height/2)
            body.zPosition = -1
        
        
        let limitLookAt = SKConstraint.zRotation(SKRange(lowerLimit:   -3 * .pi / 4,
                                                         upperLimit:   2 * .pi / 3))
        
        let armR = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Arm")
            armR.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_ArmR"
            armR.position = CGPoint(x: -10, y: -25)
            armR.zPosition = -2
            armR.anchorPoint = CGPoint(x: 1, y: 1)
            armR.constraints = [limitLookAt]
        
        let hand = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Hand")
            hand.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_HandR"
            hand.position.y = -armR.frame.height+10
            hand.position.x = -armR.frame.width
            armR.addChild(hand)
            node.addChild(armR)
        
        let actionRotateArm = { (node:SKSpriteNode) -> (SKAction) in
            
            let isArmR =  node.name?.contains("_ArmR")
            
            let action =
            SKAction.sequence([
                
                .run {
                    let nodeBallHand = SKNode()
                     nodeBallHand.name = "nodeBall"
                     nodeBallHand.name = self.typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_ballHandR"
                     nodeBallHand.position =  CGPoint(x: hand.position.x ,y: hand.position.y-15)
                     nodeBallHand.zPosition = -2
                     nodeBallHand.addChild(self.getEmitter(nodePosition: hand).copy() as! SKEmitterNode)
                     node.addChild(nodeBallHand)
                },
                .rotate(toAngle: CGFloat(isArmR! ? -45 : 45).toRadians(), duration: 0.5, shortestUnitArc: true),
                .rotate(toAngle: CGFloat(isArmR! ? 10 : -10).toRadians(), duration: 0.1, shortestUnitArc: false),
                .run {
              
                    node.run(SKAction.repeat(SKAction.sequence([
                    .run {
                        
                                                           
                        let copy = self.addBallMoster(nodePosition: node,
                                                      path: UIBezierPath.pathMoster(CGPoint(x: screenSize.height*2, y: 0), screenSize.height*2, .pi,
                                                        .pi / 180, true))
                        self.addPhysicsBall(node: [copy])
                        node.addChild(copy)
                    },
                    .wait(forDuration: 0.1)]),count: 4))
                  },
                GameInfo().mainAudio.getAction(type: .Boss_Tree_Attack),
                .wait(forDuration: 2)
                ])
            
            return action
        }
        
        let armL = armR.copy() as! SKSpriteNode
            armL.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_ArmL"
            armL.xScale = -1
            armL.constraints = [limitLookAt]
            
        
      
        
        let move = SKAction.repeatForever(.sequence([.resize(byWidth: 0, height: 4, duration: 0.5),
                                                     .rotate(byAngle: 0.05, duration: 0.5),
                                                     .resize(byWidth: 0, height: -4, duration: 0.5),
                                                     .rotate(byAngle: -0.05, duration: 0.5)]))
        
        let skirt0 = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Skirt_0")
            skirt0.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Skirt_0"
            skirt0.position = CGPoint(x: -body.frame.width*0.45, y: -18)
            skirt0.zPosition = -1
            skirt0.anchorPoint = CGPoint(x: 0.5, y: 1)
            skirt0.run(move)
            body.addChild(skirt0)
        
        let skirt1 = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Skirt_1")
            skirt1.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Skirt_1"
            skirt1.position = CGPoint(x: -body.frame.width*0.30, y: -22)
            skirt1.zPosition = -2
            skirt1.anchorPoint = CGPoint(x: 0.5, y: 1)
            skirt1.run(move)
            body.addChild(skirt1)
        
        let skirt2 = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Skirt_2")
            skirt2.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Skirt_2"
            skirt2.position = CGPoint(x: -body.frame.width*0.28, y: -25)
            skirt2.zPosition = -1
            skirt2.anchorPoint = CGPoint(x: 0.5, y: 1)
            skirt2.run(move)
            body.addChild(skirt2)
        
        let skirt3 = SKSpriteNode(imageNamed: typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Skirt_3")
            skirt3.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Skirt_3"
            skirt3.position = CGPoint(x: -body.frame.width*0.15, y: -25)
            skirt3.zPosition = -1
            skirt3.anchorPoint = CGPoint(x: 0.5, y: 1)
            skirt3.run(move)
            body.addChild(skirt3)
        
        let skirt4 = skirt3.copy() as! SKSpriteNode
            skirt4.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Skirt_4"
            skirt4.xScale = -1
            skirt4.position = CGPoint(x: 0, y: -25)
            skirt4.zPosition = -1
            skirt4.anchorPoint = CGPoint(x: 0.5, y: 1)
            skirt4.run(move)
            body.addChild(skirt4)
        
        let skirt5 = skirt1.copy() as! SKSpriteNode
            skirt5.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Skirt_5"
            skirt5.xScale = -1
            skirt5.position = CGPoint(x: body.frame.width*0.28, y: -25)
            skirt5.zPosition = -1
            skirt5.anchorPoint = CGPoint(x: 0.5, y: 1)
            skirt5.run(move)
            body.addChild(skirt5)
        
        let skirt6 = skirt2.copy() as! SKSpriteNode
            skirt6.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Skirt_6"
            skirt6.xScale = -1
            skirt6.position = CGPoint(x: body.frame.width*0.30, y: -22)
            skirt6.zPosition = -1
            skirt6.anchorPoint = CGPoint(x: 0.5, y: 1)
            skirt6.run(move)
            body.addChild(skirt6)
        
        let skirt7 = skirt0.copy() as! SKSpriteNode
            skirt7.name = typeBoss!.rawValue.replacingOccurrences(of: " ", with: "_") + "_Skirt_7"
            skirt7.xScale = -1
            skirt7.position = CGPoint(x: body.frame.width*0.40, y: -15)
            skirt7.zPosition = -1
            skirt7.anchorPoint = CGPoint(x: 0.5, y: 1)
            skirt7.run(move)
            body.addChild(skirt7)

       
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { time in
            switch Int.random(in: 0..<3) {
                case 0:
                    armR.run(actionRotateArm(armR))
                case 1:
                    armL.run(actionRotateArm(armL))
                default  :
                    armR.run(actionRotateArm(armR))
                    armL.run(actionRotateArm(armL))
            }
        }
        
        node.addChild(body)
        node.addChild(armR)
        node.addChild(armL)

        
        
        return node
    }
    
    //MARK: ANIMATION FX BOSS
    private func effectFxBossSpike() {

        guard let mainScene = mainScene else {
            return
        }

        let glaciars:[Enemy] =  [ Enemy(imageNamed: "glaciar"),Enemy(imageNamed: "glaciar1")]
        
        let unitX = Int(round(CGFloat(Float(screenSize.width - 50)) / 20))
        
        for x in 0...20 {
            
            guard let copyGlaciar = cloneEnemy(elements: glaciars, anchor: CGPoint(x: 0.5, y: 1), position: CGPoint(x: CGFloat(x * unitX), y: screenSize.height) ,emitter: "trail") else { return }
         
        
            if x %  Int.random(in: 6...9)  == 0 {
                copyGlaciar.run(.repeatForever(.sequence([
                    .rotate(byAngle: CGFloat(10).toRadians(), duration: 0.5),
                    .rotate(byAngle: CGFloat(-10).toRadians(), duration: 0.4),
                    .run {
                        SKAction.wait(forDuration: 2)
                        copyGlaciar.removeAllActions()
                        SKAction.wait(forDuration: 3)
                        
                        let emitter = SKEmitterNode(fileNamed: "trail")!
                        emitter.targetNode = copyGlaciar
                        copyGlaciar.Physics(speed: CGVector(dx: 0, dy: -700))
                        copyGlaciar.addChild(emitter)
                    }
                ])))
            }

            mainScene.addChild(copyGlaciar)
         }
      }
}

extension Enemy {
    
    /// Clone element array SpriteNode and add effect SKEmitter
    ///
    func cloneEnemy(elements:[Enemy],anchor:CGPoint,position:CGPoint,emitter:String) -> Enemy? {
        
        guard let copy = elements.randomElement()?.copy() as? Enemy else {
            fatalError()
            return nil
            
        }
        
        copy.name = "Enemy_Glaciar_\(UUID().uuidString)"
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
    
    
}
