//
//  ViewController.swift
//  cardDeck
//
//  Created by Marc Attinasi on 9/8/18.
//  Copyright © 2018 Marc Attinasi. All rights reserved.
//

import UIKit

class PlayPokerViewController: UIViewController {

    var deck = Deck() {
        didSet {
            updateDeckDisplay()
            enableButtons()
        }
    }
    
    var currentHand = Deck() {
        didSet {
            updateHandDisplay()
            enableButtons()
        }
    }
    
    var currentSharedCards = Deck() {
        didSet {
            updateHandDisplay()
            enableButtons()
        }
    }
    
    func enableButtons() {
        dealSharedButton.isEnabled = currentSharedCards.isEmpty && !currentHand.isEmpty
    }
    
    @IBOutlet weak var deckLabel: UILabel!
    @IBOutlet weak var handLabel: UILabel!
    @IBOutlet weak var handScore: UILabel!
    @IBOutlet weak var dealSharedButton: UIButton!
    @IBOutlet weak var dealHandButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deck = makeShuffledDeck()
        
        updateHandDisplay()
    }
    
    @IBAction func onDealHand(_ sender: Any) {
        if let dealtHand = try? dealHand(fromDeck: deck, count: 2) {
            currentHand = dealtHand.cards
            currentSharedCards = Deck()
            deck = dealtHand.remainingDeck
        } else {
            toast(message: "Could not deal a new hand")
        }
    }
    
    @IBAction func onDealShared(_ sender: Any) {
        if let dealtHand = try? dealHand(fromDeck: deck, count: 5) {
            currentSharedCards = dealtHand.cards
            deck = dealtHand.remainingDeck
        } else {
            toast(message: "Could not deal shared cards")
        }
    }
    
    @IBAction func onNewDeck(_ sender: Any) {
        deck = makeShuffledDeck()
        currentHand = Deck()
        currentSharedCards = Deck()
    }
    
    func updateDeckDisplay() {
        deckLabel.text = "\(deck.count) Cards in deck\n"
        
        deck.forEach { (card) in
            deckLabel.text = "\(deckLabel.text!)\n\(cardRepresentation(card))"
        }
    }
    
    func displaySharedCards() {
        if !currentSharedCards.isEmpty {
            handLabel.text = "\(handLabel.text!)\n\nShared Cards\n"
            
            currentSharedCards.forEach { (sharedCard) in
                handLabel.text = "\(handLabel.text!)\n\(cardRepresentation(sharedCard))"
            }
        }
    }
    
    func updateHandDisplay() {
        handLabel.text = "Current Hand\n"
        
        let sortedHand = currentHand.sorted { (l, r) -> Bool in
            l.rank.rawValue > r.rank.rawValue
        }
        
        sortedHand.forEach { (card) in
            handLabel.text = "\(handLabel.text!)\n\(cardRepresentation(card))"
        }
        
        displaySharedCards()
        
        updateHandScore()
    }
        
    func updateHandScore() {
        guard currentHand.count > 0 else {
            handScore.text = ""
            return
        }
        
        let score = PokerHand(hand: currentHand + currentSharedCards).handRanking()
        
        let highCard = score.highCards.isEmpty ? Card.defaultCard() : score.highCards.first!
        
        switch score.highRank {
        case .royalFlush:
            handScore.text = "Royal Flush!"
        case .straightFlush(let rank):
            handScore.text = "Straight Flush with \(rank)"
        case .flush(let rank):
            handScore.text = "Flush with \(rank)"
        case .straight(let rank):
            handScore.text = "Straight with \(rank)"
        case .fourOfAKind(let rank):
            handScore.text = "Four of a Kind with \(rank) - High card is \(highCard.rank))"
        case .fullHouse(let rank3, let rank2):
            handScore.text = "Full House with 3-\(rank3)'s and a 2-\(rank2)'s"
        case .threeOfAKind(let rank):
            handScore.text = "Three of a kind with \(rank) - High card is \(highCard.rank)"
        case .twoPair(let pair1, let pair2):
            handScore.text = "Two pair with \(pair1)'s and \(pair2)'s - High card is \(highCard.rank)"
        case .pair(let rank):
            handScore.text = "Pair of \(rank)'s - High card is \(highCard.rank)"
        case .highCard(let rank):
            handScore.text = "High Card with \(rank)"
        case .none:
            handScore.text = "No Cards!"
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

