//
//  ViewController.swift
//  cardDeck
//
//  Created by Marc Attinasi on 9/8/18.
//  Copyright © 2018 Marc Attinasi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = Deck() {
        didSet {
            updateDeckDisplay()
        }
    }
    
    var currentHand = Deck() {
        didSet {
            updateHandDisplay()
        }
    }
    
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var handLabel: UILabel!
    @IBOutlet weak var handScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deck = makeShuffledDeck()
        updateHandDisplay()
    }
    
    @IBAction func onDealHand(_ sender: Any) {
        if let dealtHand = try? dealHand(fromDeck: deck, count: 5) {
            currentHand = dealtHand.hand
            deck = dealtHand.deck
        } else {
            toast(message: "Could not deal a new hand")
        }
    }
    
    @IBAction func onNewDeck(_ sender: Any) {
        deck = makeShuffledDeck()
        currentHand = Deck()
    }
    
    func updateDeckDisplay() {
        deckLabel.text = "\(deck.count) Cards in deck\n"
        
        deck.forEach { (card) in
            deckLabel.text = "\(deckLabel.text!)\n\(cardRepresentation(card))"
        }
    }
    
    func updateHandDisplay() {
        handLabel.text = ""
        
        let sortedHand = currentHand.sorted { (l, r) -> Bool in
            l.rank.rawValue > r.rank.rawValue
        }
        
        sortedHand.forEach { (card) in
            handLabel.text = "\(handLabel.text!)\n\(cardRepresentation(card))"
        }
        
        updateHandScore()
    }
    
    func updateHandScore() {
        guard currentHand.count > 0 else {
            handScore.text = ""
            return
        }
        
        let pokerHand = PokerHand(hand: currentHand)
        
        let score = pokerHand.handRanking()
        switch score {
        case .royalFlush:
            handScore.text = "Royal Flush!"
        case .straightFlush(let rank):
            handScore.text = "Straight Flush with \(rank)"
        case .flush(let rank):
            handScore.text = "Flush with \(rank)"
        case .straight(let rank):
            handScore.text = "Straight with \(rank)"
        case .fourOfAKind(let rank):
            handScore.text = "Four of a Kind with \(rank)"
        case .fullHouse(let rank3, let rank2):
            handScore.text = "Full House with 3-\(rank3)'s and a 2-\(rank2)'s"
        case .threeOfAKind(let rank):
            handScore.text = "Three of a kind with \(rank)"
        case .twoPair(let pair1, let pair2):
            handScore.text = "Two pair with \(pair1)'s and \(pair2)'s"
        case .pair(let rank):
            handScore.text = "Pair of \(rank)'s"
        case .highCard(let rank):
            handScore.text = "High Card with \(rank)"
        }
    }
    
    func toast(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
}

