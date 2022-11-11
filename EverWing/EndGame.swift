//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit
import StoreKit

class EndGame: SKScene {
    deinit{
        print ("ENDGAME CLEANED")
    }
    
    let managed = ManagedDB.shared.context
    
    var collectedCoins:Int = 0
    
    var infobar:Infobar?
    
    let currentToon = AccountInfo().getCurrentToon()
    
    override func didMove(to view: SKView) {
        
        
        scene?.name = "EndGame"
        guard let path = Bundle.main.path(forResource: "userinfo", ofType: "plist") else {
            fatalError("plist is nil - Check AccountInfo.swift")
        }

        
        guard let virtualPlist = NSMutableDictionary(contentsOfFile: path) else {
            fatalError("plist is nil - Check AccountInfo.swift")
        }
      
     
        guard let dataCoin:Int = virtualPlist.value(forKey: "Coin") as? Int else{
            print ("ERROR001: EndGame error")
            return
        }
        
        
       
        let newCoinAmount = collectedCoins + dataCoin
        
        virtualPlist.setValue(newCoinAmount, forKey: "Coin")
        
        /****************   SAVE DB DATA ***/
        
        if !ManagedDB.saveDbCoin(newCoinAmount: newCoinAmount) { fatalError() }
         
         /* ********************* */
        
        if !virtualPlist.write(toFile: path, atomically: true){
            print("Error002: FILE FAILED TO SAVE THE CHANGES ---- PLEASE FIX IT IN EndGame")
        }
        
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        bg.setBackgroundImage(img: UIImage(named:"clouds")!)
        bg.layoutSubviews()
        view.addSubview(bg)
        
        
        bg.translatesAutoresizingMaskIntoConstraints = false
        bg.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        bg.heightAnchor.constraint(equalToConstant: screenSize.height).isActive = true
        bg.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bg.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
       
        infobar = Infobar(frame: .zero,scene: self)
        view.addSubview(infobar!)
        infobar!.translatesAutoresizingMaskIntoConstraints = false
        
        infobar!.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        infobar!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infobar!.centerYAnchor.constraint(equalTo: view.topAnchor,constant: 10).isActive = true
       
           
        let player = UIImageView(image: UIImage(named: "Alice")!)
        view.addSubview(player)
        
        player.translatesAutoresizingMaskIntoConstraints = false
        player.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        player.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: -view.frame.height*0.2).isActive = true
        player.widthAnchor.constraint(equalToConstant: view.frame.width*0.5).isActive = true
        player.heightAnchor.constraint(equalTo: player.widthAnchor).isActive = true

        UIView.animate(withDuration: 2, delay: 0,options: [.autoreverse,.repeat,.curveLinear]) {
            player.transform = CGAffineTransform(translationX: 0, y: -50)
        }

        let txtGameOver = UILabel()
            .addFontAndText(font: "Cartwheel", text: "Game Over", size: view.frame.width*0.1)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
        view.addSubview(txtGameOver)
        
        
        txtGameOver.translatesAutoresizingMaskIntoConstraints = false
        txtGameOver.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: 0).isActive = true
        txtGameOver.centerXAnchor.constraint(equalTo:view.centerXAnchor,constant: 0).isActive = true
       
        UIView.animate(withDuration: 1, delay: 0,options: [.autoreverse,.repeat,.curveLinear]) {
            txtGameOver.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
        /*-----------------------------------------------------------------------------------------------*/
      
        let txtCoins = UILabel()
            .addFontAndText(font: "Cartwheel", text: "Coins", size: view.frame.width*0.07)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        view.addSubview(txtCoins)
        
        txtCoins.translatesAutoresizingMaskIntoConstraints = false
        txtCoins.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: screenSize.height*0.07).isActive = true
        txtCoins.trailingAnchor.constraint(equalTo: view.centerXAnchor,constant: -20).isActive = true
        
        let valueCoins = UILabel()
            .addFontAndText(font: "Cartwheel", text: "\(collectedCoins)", size: view.frame.width*0.07)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
        view.addSubview(valueCoins)
        
        valueCoins.translatesAutoresizingMaskIntoConstraints = false
        valueCoins.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: screenSize.height*0.07).isActive = true
        valueCoins.leadingAnchor.constraint(equalTo: view.centerXAnchor,constant: 20).isActive = true
        
        let coin = UIImageView(image: UIImage(named: "coin")!)
        view.addSubview(coin)
        
        coin.translatesAutoresizingMaskIntoConstraints = false
        coin.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: screenSize.height*0.07).isActive = true
        coin.leadingAnchor.constraint(equalTo: valueCoins.trailingAnchor,constant: 30).isActive = true
        coin.widthAnchor.constraint(equalToConstant: UIDevice().isPhone() ? 35 : 50).isActive = true
        coin.heightAnchor.constraint(equalToConstant: UIDevice().isPhone() ? 35 : 50).isActive = true
        /*-----------------------------------------------------------------------------------------------*/

        
        /*-----------------------------------------------------------------------------------------------*/

        let txtScore = UILabel()
            .addFontAndText(font: "Cartwheel", text: "Score", size: view.frame.width*0.07)
            .shadowText(colorText: .white, colorShadow: .black, aligment: .center)
        view.addSubview(txtScore)
        
        txtScore.translatesAutoresizingMaskIntoConstraints = false
        txtScore.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: screenSize.height*0.14).isActive = true
        txtScore.trailingAnchor.constraint(equalTo: view.centerXAnchor,constant: -20).isActive = true
       
        
        let valueScore = UILabel()
            .addFontAndText(font: "Cartwheel", text: "\(collectedCoins)", size: view.frame.width*0.07)
            .shadowText(colorText: .yellow, colorShadow: .black, aligment: .center)
        view.addSubview(valueScore)
        
        valueScore.translatesAutoresizingMaskIntoConstraints = false
        valueScore.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: screenSize.height*0.14).isActive = true
        valueScore.leadingAnchor.constraint(equalTo: view.centerXAnchor,constant: 20).isActive = true
        
        let star = UIImageView(image: UIImage(named: "star")!)
        view.addSubview(star)
        
        star.translatesAutoresizingMaskIntoConstraints = false
        star.translatesAutoresizingMaskIntoConstraints = false
        star.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: screenSize.height*0.14).isActive = true
        star.leadingAnchor.constraint(equalTo: valueScore.trailingAnchor,constant: 30).isActive = true
        star.widthAnchor.constraint(equalToConstant: UIDevice().isPhone() ? 35 : 50).isActive = true
        star.heightAnchor.constraint(equalToConstant: UIDevice().isPhone() ? 35 : 50).isActive = true
        
        /*-----------------------------------------------------------------------------------------------*/
        
        let txtEggFound = UILabel()
            .addFontAndText(font: "Cartwheel", text: "COMMON EGG FOUND!", size: view.frame.width*0.05)
            .shadowText(colorText: .orange, colorShadow: .black, aligment: .center)
        view.addSubview(txtEggFound)
        
        txtEggFound.translatesAutoresizingMaskIntoConstraints = false
        txtEggFound.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: screenSize.height*0.2).isActive = true
        txtEggFound.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let eggNode = UIImageView(image: UIImage(named: "Common")!)
        view.addSubview(eggNode)
        
        eggNode.translatesAutoresizingMaskIntoConstraints = false
        eggNode.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: screenSize.height*0.32).isActive = true
        eggNode.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        eggNode.widthAnchor.constraint(equalToConstant: view.frame.width*0.15).isActive = true
        eggNode.heightAnchor.constraint(equalToConstant: view.frame.width*0.2).isActive = true
        
        
        let play = UIButton()
            play.setBackgroundImage(UIImage(named: "PlayButton"), for: .normal)
            play.addTarget(self, action: #selector(playButton), for: .touchUpInside)
        view.addSubview(play)
        
        play.translatesAutoresizingMaskIntoConstraints = false
        play.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: screenSize.height*0.45).isActive = true
        play.trailingAnchor.constraint(equalTo:view.centerXAnchor,constant: -20).isActive = true
        play.widthAnchor.constraint(equalToConstant: 150).isActive = true
        play.heightAnchor.constraint(equalToConstant: 75).isActive = true

        
        let store = UIButton()
            store.setBackgroundImage(UIImage(named: "StoreButton"), for: .normal)
            store.addTarget(self, action: #selector(storeButton), for: .touchUpInside)
        view.addSubview(store)
        
        store.translatesAutoresizingMaskIntoConstraints = false
        store.centerYAnchor.constraint(equalTo:view.centerYAnchor,constant: screenSize.height*0.45).isActive = true
        store.leadingAnchor.constraint(equalTo:view.centerXAnchor,constant: 20).isActive = true
        store.widthAnchor.constraint(equalToConstant: 150).isActive = true
        store.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
   
        
    }
    
    @objc func playButton(sender:UIButton) {
        
        let scene = MainScene(size: self.size)
           self.view?.presentScene(scene)
    }
    
    @objc func storeButton(sender:UIButton) {
        
        presentReviewRequest()
    }
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = self.nodes(at: location)
            if node.first?.name == "playBtn" {
            
                 let scene = MainScene(size: self.size)
                    self.view?.presentScene(scene)
            }
            else if node.first?.name == "storeBtn" {
                presentReviewRequest()
                
            }
        }
    }
    */
    /// Present review App Store
    private func presentReviewRequest() {
        let twoSecondsFromNow = DispatchTime.now() + 1.0
        DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) {
                SKStoreReviewController.requestReview()
        }
    }
}


