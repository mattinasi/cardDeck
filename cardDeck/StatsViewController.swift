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
    func updateDisplay(forIndex: Int, value: String)
}

struct HandTrial {
    let delegate: UpdateDisplayDelegate
    let index: Int
    let targetHand: PokerHand.HandRanking
    var test: (Deck, Int, HandTrial) -> Bool
}

class StatsViewController: UIViewController, UpdateDisplayDelegate {
    
    @IBOutlet weak var resultStackView: UIStackView!
    var statsLabels = [UITextView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultStackView.distribution = .fillEqually
    }
    
    fileprivate func makeLabelFor(_ trial: HandTrial) {
        let label = UITextView()
        label.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        label.layer.backgroundColor = trial.index % 2 == 0 ? UIColor.lightGray.cgColor  : UIColor.gray.cgColor
        label.isUserInteractionEnabled = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        statsLabels.append(label)
        resultStackView.addArrangedSubview(label)
    }
    
    @IBAction func compute(_ sender: Any) {
        let trials: [HandTrial] = [
            HandTrial(delegate: self,
              index: 0,
              targetHand: .royalFlush,
              test: { (hand, count, trial) -> Bool in
                guard let winningHand = PokerHand(hand: hand).royalFlush() else { return false }
                trial.delegate.updateDisplay(forIndex: trial.index,
                                             value: "Found Royal Flush after \(count) hands:\n\(compactHandRepresentation(winningHand))")
                return true
            }),
            HandTrial(delegate: self,
              index: 1,
              targetHand: .straightFlush(.ace),
              test: { (hand, count, trial) -> Bool in
                guard let winningHand = PokerHand(hand: hand).straightFlush() else { return false }
                trial.delegate.updateDisplay(forIndex: trial.index,
                                             value: "Found Straight Flush after \(count) hands:\n\(compactHandRepresentation(winningHand))")
                return true
            }),
            HandTrial(delegate: self,
              index: 2,
              targetHand: .straight(.ace),
              test: { (hand, count, trial) -> Bool in
                guard let winningHand = PokerHand(hand: hand).straight() else { return false }
                trial.delegate.updateDisplay(forIndex: trial.index,
                                             value: "Found Straight after \(count) hands:\n\(compactHandRepresentation(winningHand))")
                return true
            }),
            HandTrial(delegate: self,
              index: 3,
              targetHand: .flush(.ace),
              test: { (hand, count, trial) -> Bool in
                guard let winningHand = PokerHand(hand: hand).flush() else { return false }
                trial.delegate.updateDisplay(forIndex: trial.index,
                                             value: "Found Flush after \(count) hands:\n\(compactHandRepresentation(winningHand))")
                return true
            })

        ]
        
        // clear out old views
        while let view = resultStackView.arrangedSubviews.first {
            resultStackView.removeArrangedSubview(view)
        }
        statsLabels.removeAll()
                
        trials.forEach { (trial) in
            makeLabelFor(trial)
            
            DispatchQueue(label: "trial-\(trial.index)").async {
                var count = 1
                while count <= 50000 {
                    let deck = makeShuffledDeck()
                    guard let hand = try? dealHand(fromDeck: deck, count: 5),
                        let shared = try? dealHand(fromDeck: hand.remainingDeck, count: 3) else { break }
                    
                    if trial.test(PokerHand(hand: hand.cards + shared.cards).hand, count, trial) {
                        break
                    }
                    
                    if count % 1000 == 0 {
                        self.updateDisplay(forIndex: trial.index, value: "Tested \(count) hands...")
                    }
                    count += 1
                }
                print("leaving test queue \(trial.index)")
            }
        }
    }
    
    func updateDisplay(forIndex: Int, value: String) {
        DispatchQueue.main.async { [weak self] in
            self?.statsLabels[forIndex].text = value
        }
    }
}
