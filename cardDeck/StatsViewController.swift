//
//  StatsViewController.swift
//  cardDeck
//
//  Created by Marc Attinasi on 10/5/19.
//  Copyright © 2019 Marc Attinasi. All rights reserved.
//

import Foundation
import UIKit

protocol UpdateDisplayDelegate: AnyObject {
    func updateDisplay(value: String)
}

class StatsViewController: UIViewController, UpdateDisplayDelegate {
    @IBOutlet weak var statsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func compute(_ sender: Any) {
        statsLabel.text = "Computing..."
            
        DispatchQueue(label: "RoyalFlush").asyncAfter(deadline: DispatchTime.now()) {
            self.royalFlush(delegate: self)
        }
    }
    
    func updateDisplay(value: String) {
        DispatchQueue.main.async { [weak self] in
            self?.statsLabel.text = value
        }
    }
    
    func royalFlush(delegate: UpdateDisplayDelegate) {
        var count = 0
        while count < 50000 {
            let deck = makeShuffledDeck()
            guard let hand = try? dealHand(fromDeck: deck, count: 5),
                let river = try? dealHand(fromDeck: hand.remainingDeck, count: 3) else { break }
        
            if let winner = PokerHand(hand: hand.cards + river.cards).royalFlush() {
                delegate.updateDisplay(value: "Royal flush after \(count) hands:\n\(handRepresentation(winner))")
                return
            }
            count += 1
            
            if count % 1000 == 0 {
                delegate.updateDisplay(value: "Tried \(count) hands...")
            }
        }
        delegate.updateDisplay(value: "Did not get a Royal Flush in \(count) hands!")
    }    
}
