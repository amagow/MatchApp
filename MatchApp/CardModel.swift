//
//  CardModel.swift
//  MatchApp
//
//  Created by Adwithya Magow on 18/08/20.
//  Copyright © 2020 Adwithya Magow. All rights reserved.
//

import Foundation

class CardModel{
    func getCards() -> [Card] {
        
        //Declare an empty array
        var generatedCards = [Card]()
        
        //Randomly create 8 pairs of cards
        while generatedCards.count < 16{
            
            //Generate a random number
            let randNum = Int.random(in: 1...13)
            
            if !generatedCards.contains(where: {$0.imageName == "card\(randNum)"}){
                
                //Create two new card objects
                let cardOne = Card()
                let cardTwo = Card()
                
                //Set their image names
                cardOne.imageName = "card\(randNum)"
                cardTwo.imageName = "card\(randNum)"
                
                //Add them to an array
                generatedCards += [cardOne, cardTwo]
            }
            
        }
        
        //Randomise cards within the array
        generatedCards.shuffle()
        
        //Return an array
        return generatedCards
    }
}
