//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Adwithya Magow on 18/08/20.
//  Copyright © 2020 Adwithya Magow. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card: Card?
    
    func configureCell(_ card:Card){
        
        //Keep track of card this cell represents
        self.card = card
        
        //Set the front image view to the image that represents the card
        frontImageView.image = UIImage(named: card.imageName)
        
        if card.isMatched{
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        }
        else{
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        //Reset state of the card
        if card.isFlipped{
            //Show Front Image View
            flipUp(0)
        }
        else{
            //Show Back Image View
            flipDown(0, 0)
        }
        
    }
    
    func flipUp(_ speed: TimeInterval = 0.3){
        
        //Flip Up animation
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        card?.isFlipped = true
        
    }
    
    func flipDown(_ speed: TimeInterval = 0.3, _ delay: TimeInterval = 0.5){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
        
    }
    
    func remove(_ speed: TimeInterval = 0.3){
        
        //Make image views invisible
        backImageView.alpha = 0
        
        UIView.animate(withDuration: speed, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
        
    }
    
}
