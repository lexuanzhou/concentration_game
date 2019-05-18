//
//  ViewController.swift
//  Concentration
//
//  Created by Lexuan Zhou on 2019-05-14.
//  Copyright © 2019 Lexuan Zhou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Initializes the game
    //Uses lazy to avoid "Cannot use instance member 'cardButtons' within property initializer; property initializers run before 'self' is available"
    //game has to be initialized
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2 )
    // didSet does not work here, move the count and view update to touch card
    var flipCount = 0
    var scoreCount = 0
    var emojis : [String] = []
    var themeFlag = false

    // Ininitialize a dictionary
    var emoji = [Int : String]()
    
    func emoji(for card: Card) -> String
    {
        if emoji[card.identifier] == nil
        {
            if emojis.count > 0
            {
                let randomIndex = Int(arc4random_uniform(UInt32(emojis.count)))
                emoji[card.identifier] = emojis.remove(at : randomIndex)
            }
        }
        return emoji[card.identifier] ?? "?"
    }
    
    @IBOutlet var backgroundColor: UIView!
    
    //Rep  resents an array of cards
    @IBOutlet var cardButtons: [UIButton]!
    
    //Connects the flip count label in the UI to the controller
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    //Connects the
    
    @IBAction func touchCard(_ sender: UIButton)
    {
        backgroundColor.backgroundColor = game.backgroundColorDict[game.emojis]![0]
        if themeFlag == false{
            themeFlag = true
            emojis = game.emojis
        }
        if let cardNumber = cardButtons.firstIndex(of: sender)
        {
            game.chooseCard(at : cardNumber)
            flipCount = game.flipCount
            flipCountLabel.text = "Flips: \(flipCount)"
            scoreCount = game.score
            scoreLabel .text = "Scores: \(scoreCount)"
            updateViewFromModel()
        }
        else
        {
            print("chosen card was not in cardButtons.")
        }
    }
    
    @IBOutlet weak var restartButton: UIButton!
    
    @IBAction func touchRestartButton(_ sender: UIButton) {
        
        // Reinitializes the parameters in the viewcontroller
        flipCount = 0
        flipCountLabel.text = "Flips: \(flipCount)"
        themeFlag = false
        emojis = []
        emoji = [Int : String]()
        scoreCount = 0
        scoreLabel .text = "Scores: \(scoreCount)"
        // Reinitializes the game
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2 )
        backgroundColor.backgroundColor = game.backgroundColorDict[game.emojis]![0]
        updateViewFromModel()
    }
    
    func updateViewFromModel()
    {
        // Equivalent to for index in 0 ..< cardButtons.count
        // for index in CountableRange
        for index in cardButtons.indices
        {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUP
            {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            else
            {
                button.setTitle("", for: UIControl.State.normal)
                
                //The following syntax does not work anymore
                //button.backgroundColor = card.isMatched? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
                if card.isMatched{
                    button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
                }
                else{
                    button.backgroundColor = game.backgroundColorDict[game.emojis]![1]
                }
            }
        }
    }
}

