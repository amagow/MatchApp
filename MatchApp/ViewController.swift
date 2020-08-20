//
//  ViewController.swift
//  MatchApp
//
//  Created by Adwithya Magow on 18/08/20.
//  Copyright © 2020 Adwithya Magow. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = CardModel()
    
    var cardsArray = [Card]()
    var firstFlippedCardIndex: IndexPath?
    var timer: Timer?
    var milliseconds: Int = 120 * 1000
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        //Set the view controller as the DataSource and Delegate of the Collection View
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //Initialise time
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        soundPlayer.playSound(.shuffle)
    }
    
    //MARK: - Timer methods
    
    @objc func timerFired(){
        
        //Decremen counter
        milliseconds -= 1
        
        //Update Label
        let seconds: Double = Double(milliseconds)/1000.0
        
        timerLabel.text = String(format: "Time remaining: %.2f", seconds)
        
        //Stop timer if it reaches zero
        if milliseconds == 0 {
            
            timerLabel.textColor = .red
            timer?.invalidate()
            
        }
        
        checkForGameEnd()
        
    }
    
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //Return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //Configure the cell based on the properties in represents
        
        let cardCell = cell as? CardCollectionViewCell
        
        let card = cardsArray[indexPath.row]
        
        cardCell?.configureCell(card)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Get a reference to the cell
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        //Do not let user interact with the game if the time is over
        if milliseconds <= 0 {
            return
        }
        
        if cell?.card?.isMatched == true {
            
            return
            
        }
        
        //check status to determine how to flip it
        if cell?.card?.isFlipped == false{
            
            //Flip the card
            cell?.flipUp()
            
            //play sound
            soundPlayer.playSound(.flip)
            
            if firstFlippedCardIndex == nil {
                
                //First card flipped over
                firstFlippedCardIndex = indexPath
                
            }
            else{
                
                //Second card flipped over
                
                //Run Comparison Logic
                checkForMatches(indexPath)
                
            }
            
        }
        
    }
    
    // MARK: - Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndexPath: IndexPath){
        
        //Get the cells that represent card one and two
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndexPath) as? CardCollectionViewCell
        
        if  cardsArray[firstFlippedCardIndex!.row].imageName == cardsArray[secondFlippedCardIndexPath.row].imageName{
            
            //It's a match
            
            //Play match sound
            soundPlayer.playSound(.match)
            
            cardsArray[firstFlippedCardIndex!.row].isMatched = true
            cardsArray[secondFlippedCardIndexPath.row].isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            checkForGameEnd()
            
        }
        else{
            
            //It's not a match
            
            //Play no match sound
            soundPlayer.playSound(.nomatch)
            
            cardsArray[firstFlippedCardIndex!.row].isFlipped = false
            cardsArray[secondFlippedCardIndexPath.row].isFlipped = false
            
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
            
        }
        
        firstFlippedCardIndex = nil
        
    }
    
    func checkForGameEnd(){
        
        //check if all cards are matched
        var hasWon = true
        
        for card in cardsArray{
            if card.isMatched == false{
                hasWon = false
                break
            }
        }
        
        if hasWon{
            
            //User won show alert
            showAlert("Congratulations!", "You've Won The Game")
            milliseconds = 0
             timerLabel.text = String(format: "Time remaining: %.2f", milliseconds)
            timer?.invalidate()
            
        }
        else{
            
            //Check if any time is left
            if milliseconds <= 0 {
                showAlert("Sorry", "Better Luck Next Time")
            }
        }
        
    }
    
    func showAlert(_ title: String, _ message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) {
            UIAlertAction in self.restartApp()
        }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func restartApp(){
        milliseconds = 120 * 1000
        firstFlippedCardIndex = nil
        timerLabel.textColor = .black
        
        viewDidLoad()
        
    }
    
}

