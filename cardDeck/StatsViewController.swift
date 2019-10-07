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
    var trials = [HandTrial]()
    
    @IBOutlet weak var resultStackView: UIStackView!
    var statsLabels = [UITextView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultStackView.distribution = .fillEqually
        
        setupTrials()
    }
    
    @IBAction func compute(_ sender: Any) {
        clearPreviousTrials()
                
        trials.forEach { (trial) in
            makeLabelFor(trial)
            queueTrial(trial)
        }
    }
    
    func setupTrials() {
        trials = [
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
              targetHand: .fourOfAKind(.ace),
              test: { (hand, count, trial) -> Bool in
                guard let winningRank = PokerHand(hand: hand).fourOfAKind() else { return false }
                let winningCards = hand.filter { (card) -> Bool in
                    return card.rank == winningRank
                }
                trial.delegate.updateDisplay(forIndex: trial.index,
                                             value: "Found Four of a Kind after \(count) hands:\n\(compactHandRepresentation(winningCards))")
                return true
            }),
            HandTrial(delegate: self,
              index: 3,
              targetHand: .fullHouse(.ace, .ace),
              test: { (hand, count, trial) -> Bool in
                let result = PokerHand(hand: hand).fullHouse()
                guard result.result == true else { return false }
                
                var winningHand = hand.filter { (card) -> Bool in
                    return card.rank == result.threeRank
                }
                winningHand.append(contentsOf: hand.filter({ (card) -> Bool in
                    return card.rank == result.pairRank
                }))
                trial.delegate.updateDisplay(forIndex: trial.index,
                                             value: "Found Full House after \(count) hands:\n\(compactHandRepresentation(winningHand))")
                return true
            }),
            HandTrial(delegate: self,
              index: 4,
              targetHand: .flush(.ace),
              test: { (hand, count, trial) -> Bool in
                guard let winningHand = PokerHand(hand: hand).flush() else { return false }
                trial.delegate.updateDisplay(forIndex: trial.index,
                                             value: "Found Flush after \(count) hands:\n\(compactHandRepresentation(winningHand))")
                return true
            }),
            HandTrial(delegate: self,
              index: 5,
              targetHand: .straight(.ace),
              test: { (hand, count, trial) -> Bool in
                guard let winningHand = PokerHand(hand: hand).straight() else { return false }
                trial.delegate.updateDisplay(forIndex: trial.index,
                                             value: "Found Straight after \(count) hands:\n\(compactHandRepresentation(winningHand))")
                return true
            }),
            HandTrial(delegate: self,
              index: 6,
              targetHand: .threeOfAKind(.ace),
              test: { (hand, count, trial) -> Bool in
                guard let winningRank = PokerHand(hand: hand).threeOfAKind() else { return false }
                let winningHand = hand.filter { (card) -> Bool in
                    return card.rank == winningRank
                }
                trial.delegate.updateDisplay(forIndex: trial.index,
                                             value: "Found Three of a Kind after \(count) hands:\n\(compactHandRepresentation(winningHand))")
                return true
            }),
            HandTrial(delegate: self,
              index: 7,
              targetHand: .twoPair(.ace, .ace),
              test: { (hand, count, trial) -> Bool in
                guard let result = PokerHand(hand: hand).twoPair() else { return false }
                
                var winningHand = hand.filter { (card) -> Bool in
                    return card.rank == result.highRank1
                }
                winningHand.append(contentsOf: hand.filter({ (card) -> Bool in
                    return card.rank == result.highRank2
                }))
                trial.delegate.updateDisplay(forIndex: trial.index,
                                             value: "Found Two Pair after \(count) hands:\n\(compactHandRepresentation(winningHand))")
                return true
            }),
            HandTrial(delegate: self,
              index: 8,
              targetHand: .pair(.ace),
              test: { (hand, count, trial) -> Bool in
                guard let result = PokerHand(hand: hand).twoOfAKind() else { return false }
                
                let winningHand = hand.filter { (card) -> Bool in
                    return card.rank == result
                }
                trial.delegate.updateDisplay(forIndex: trial.index,
                                             value: "Found Pair after \(count) hands:\n\(compactHandRepresentation(winningHand))")
                return true
            })
        ]
    }
    
    private func makeLabelFor(_ trial: HandTrial) {
        let label = UITextView()
        label.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        label.layer.backgroundColor = trial.index % 2 == 0 ? UIColor.lightGray.cgColor  : UIColor.gray.cgColor
        label.isUserInteractionEnabled = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        statsLabels.append(label)
        resultStackView.addArrangedSubview(label)
    }
    
    private func clearPreviousTrials() {
        while let view = resultStackView.arrangedSubviews.first {
            resultStackView.removeArrangedSubview(view)
        }
        statsLabels.removeAll()
    }
    
    private func queueTrial(_ trial: HandTrial, numberOfRuns: Int = 50000) {
        DispatchQueue(label: "trial-\(trial.index)").async {
            var count = 1
            while count <= numberOfRuns {
                let deck = makeShuffledDeck()
                guard let hand = try? dealHand(fromDeck: deck, count: 2),
                    let shared = try? dealHand(fromDeck: hand.remainingDeck, count: 5) else { break }
                
                if trial.test(PokerHand(hand: hand.cards + shared.cards).hand, count, trial) {
                    return
                }
                
                if count % 100 == 0 {
                    self.updateDisplay(forIndex: trial.index, value: "Tested \(trial.targetHand.toString()) over \(count) hands...")
                }
                count += 1
            }
            self.updateDisplay(forIndex: trial.index, value: "Did not find \(trial.targetHand.toString()) after \(count) hands.")
        }
    }
    
    func updateDisplay(forIndex: Int, value: String) {
        DispatchQueue.main.async { [weak self] in
            self?.statsLabels[forIndex].text = value
        }
    }
}
