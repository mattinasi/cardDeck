//
//  Poker+HandRanking.swift
//  cardDeck
//
//  Created by Marc Attinasi on 10/4/19.
//  Copyright © 2019 Marc Attinasi. All rights reserved.
//
import Foundation

extension PokerHand {
    struct HandScore {
        var highRank: HandRanking       // the overall rank of the hand
        var winningHand: Deck           // the cards making up the winning rank
        var highCards: Deck             // the remaining cards, in rank-order
        var score: Int                  // experimental numerical score
    }
    
    func handRanking() -> HandScore {
            if let rf = royalFlush() {
                return HandScore(highRank: .royalFlush,
                                 winningHand: rf,
                                 highCards: [],
                                 score: score(hand: rf))
            }
            
            if let sf = straightFlush() {
                return HandScore(highRank: .straightFlush(sf[0].rank),
                                            winningHand: sf,
                                            highCards: [],
                                            score: score(hand: sf))
            }

            if let foak = fourOfAKind() {
                let winningHand = hand.filter { (card) -> Bool in
                    return card.rank == foak
                }
                
                let highCards = hand.filter { (card) -> Bool in
                    return card.rank != foak
                }.sorted { (lh, rh) -> Bool in
                    return lh.rank.rawValue > rh.rank.rawValue
                }
                
                return HandScore(highRank: .fourOfAKind(foak),
                                 winningHand: winningHand,
                                 highCards: highCards,
                                 score: score(hand: winningHand))
            }
    
            let fh = fullHouse()
            if fh.result {
                let winningHand = hand.filter { (card) -> Bool in
                    return card.rank == fh.threeRank || card.rank == fh.pairRank
                }
                
                let highCards = hand.filter { (card) -> Bool in
                    return card.rank != fh.threeRank && card.rank != fh.pairRank
                }.sorted { (lh, rh) -> Bool in
                    return lh.rank.rawValue > rh.rank.rawValue
                }
                
                return HandScore(highRank: .fullHouse(fh.threeRank, fh.pairRank),
                                 winningHand: winningHand,
                                 highCards: highCards,
                                 score: score(hand: winningHand))
            }
    
            if let flush = flush() {
                let topCard = flush[0]
                
                let winningHand = flush
                
                let highCards = hand.filter { (card) -> Bool in
                    return !isCard(card, inHand: winningHand)
                }.sorted { (lh, rh) -> Bool in
                    return lh.rank.rawValue > rh.rank.rawValue
                }
                
                return HandScore(highRank: .flush(topCard.rank),
                                 winningHand: winningHand,
                                 highCards: highCards,
                                 score: score(hand: winningHand))
            }
    
            if let st = straight() {
                let winningHand = st
                
                let highCards = hand.filter { (card) -> Bool in
                    return !isCard(card, inHand: winningHand)
                }.sorted { (lh, rh) -> Bool in
                    return lh.rank.rawValue > rh.rank.rawValue
                }

                return HandScore(highRank: .straight(st[0].rank),
                                 winningHand: winningHand,
                                 highCards: highCards,
                                 score: score(hand: winningHand))
            }
            
    
            if let toak = threeOfAKind() {
                let winningHand = hand.filter { (card) -> Bool in
                    return card.rank == toak
                }
                
                let highCards = hand.filter { (card) -> Bool in
                    return card.rank != toak
                }.sorted { (lh, rh) -> Bool in
                    return lh.rank.rawValue > rh.rank.rawValue
                }
                
                return HandScore(highRank: .threeOfAKind(toak),
                                 winningHand: winningHand,
                                 highCards: highCards,
                                 score: score(hand: winningHand))
            }
        
            if let tp = twoPair() {
                let winningHand = hand.filter { (card) -> Bool in
                    return card.rank == tp.highRank1 || card.rank == tp.highRank2
                }
                
                let highCards = hand.filter { (card) -> Bool in
                    return card.rank != tp.highRank1 && card.rank != tp.highRank2
                }.sorted { (lh, rh) -> Bool in
                    return lh.rank.rawValue > rh.rank.rawValue
                }
                
                return HandScore(highRank: .twoPair(tp.highRank1, tp.highRank2),
                                 winningHand: winningHand,
                                 highCards: highCards,
                                 score: score(hand: winningHand))
            }
        
            if let twooak = twoOfAKind() {
                let winningHand = hand.filter { (card) -> Bool in
                    return card.rank == twooak
                }
                
                let highCards = hand.filter { (card) -> Bool in
                    return card.rank != twooak
                }.sorted { (lh, rh) -> Bool in
                    return lh.rank.rawValue > rh.rank.rawValue
                }
                
                return HandScore(highRank: .pair(twooak),
                                 winningHand: winningHand,
                                 highCards: highCards,
                                 score: score(hand: winningHand))
        }
        
        let high = highCard()
        if high.result {
            let sortedHand = hand.sorted { (l, r) -> Bool in
                return l.rank.rawValue > r.rank.rawValue
            }
            var highCards = sortedHand
            highCards.removeFirst()
            return HandScore(highRank: .highCard(sortedHand[0].rank),
                             winningHand: [sortedHand[0]],
                             highCards: highCards,
                             score: score(hand: hand))
        }
        
        return HandScore(highRank: .none,
                         winningHand: [],
                         highCards: [],
                         score: score(hand: []))
    }
        
    private func isCard(_ card: Card, inHand hand: Deck) -> Bool {
        return hand.contains { (testCard) -> Bool in
            return testCard.suit == card.suit &&
                testCard.rank == card.rank
        }
    }
}
