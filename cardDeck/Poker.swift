//
//  Poker.swift
//  cardDeck
//
//  Created by Marc Attinasi on 9/8/18.
//  Copyright © 2018 Marc Attinasi. All rights reserved.
//
import Foundation

struct PokerHand {    
    enum HandRanking: Equatable {
        case royalFlush
        case straightFlush(CardRank)
        case fourOfAKind(CardRank)
        case fullHouse(CardRank, CardRank)
        case flush(CardRank)
        case straight(CardRank)
        case threeOfAKind(CardRank)
        case twoPair(CardRank, CardRank)
        case pair(CardRank)
        case highCard(CardRank)
        case none
    }
    
    let hand: Deck

    init(hand: Deck) {
        self.hand = hand
    }

    func score(hand: Deck) -> Int {
        return 100
    }
    
    func royalFlush() -> Deck? {
        guard hand.count >= 5 else { return nil }
        
        var result: Deck?
        
        eachHand(of: 5, in: hand) { (currentHand) in
            // is there an ace?
            guard let ace = currentHand.first(where: { (card) -> Bool in
                card.rank == .ace
            }) else {
                return
            }
            
            // at least 5 of same suit as ace?
            let suit = ace.suit
            let suited = cardsOfSuit(suit, inDeck: currentHand)
            guard suited.count >= 5 else {
                return
            }

            // all of the royal family represented?
            let winningHand = [Card(suit: suit, rank: .ace),
                               Card(suit: suit, rank: .king),
                               Card(suit: suit, rank: .queen),
                               Card(suit: suit, rank: .jack),
                               Card(suit: suit, rank: .ten)]
            for card in winningHand {
                if !hasCard(card, inDeck: currentHand) {
                    return
                }
            }
            result = winningHand
        }
        
        return result
    }

    func straightFlush() -> Deck? {
        guard hand.count >= 5 else { return nil }
        
        var result: Deck?

        eachHand(of: 5, in: hand) { (currentHand) in
            if flush(currentHand) != nil {
                // we know it is a flush, so see if it is also a straight
                result = straight(currentHand)
            }

        }
        return result
    }
    
    func straight(_ deck: Deck? = nil) -> Deck? {
        let straightLength = 5

        let deckToOperateOn = deck ?? self.hand
        guard deckToOperateOn.count >= straightLength else {
            return nil
        }
        
        var result: Deck?

        eachHand(of: 5, in: deckToOperateOn) { (currentHand) in
            let sortedDeck = currentHand.sorted { (l, r) -> Bool in
                return l.rank.rawValue > r.rank.rawValue
            }
            
            var handResult = true

            // now see if they are sequential: first element is the hightest, so start there
            for index in 1..<straightLength {
                if sortedDeck[index].rank.rawValue != (sortedDeck[index-1].rank.rawValue - 1) {
                    handResult = false
                    continue
                }
            }
            
            let highCard = sortedDeck[0]

            if handResult {
                let winningHand = Array(sortedDeck[0..<5])
                result = winningHand
                return
            }
            
            // consider ace, which can be a 1: skip the ace and look at the remainder for a 2,3,4,5 straight
            if highCard.rank == .ace {
                let ace = highCard
                let remainder = sortedDeck.filter { (card) -> Bool in
                    return card.rank != highCard.rank
                }
                
                guard remainder.count >= straightLength-1 && remainder[0].rank == .five else { return }

                handResult = true

                for index in 1..<remainder.count-1 {
                    if remainder[index].rank.rawValue != (remainder[index-1].rank.rawValue - 1) {
                        handResult = false
                        continue
                    }
                }

                if handResult {
                    var winningHand = Array(remainder[0..<straightLength-1])
                    winningHand.append(ace)
                    result = winningHand
                }
            }
        }
        
        return result
    }
    
    func flush(_ deck: Deck? = nil) -> Deck? {
        let deckToOperateOn = deck ?? self.hand
        guard deckToOperateOn.count >= 5 else {
            return nil
        }
    
        var result: Deck?

        eachHand(of: 5, in: deckToOperateOn) { (currentHand) in
            var handResult = false

            let suits = suitsIn(deck: currentHand)
            handResult = suits.count == 1

            if handResult {
                let sortedHand = currentHand.sorted { (l, r) -> Bool in
                    return l.rank.rawValue > r.rank.rawValue
                }
                let highRank = sortedHand[0].rank
                
                if let result = result,
                   result[0].rank.rawValue > highRank.rawValue { return }
                
                result = sortedHand
            }
        }
        return result
    }

    func fourOfAKind() -> CardRank? {
        eachOfAKind(4)
    }

    func threeOfAKind() -> CardRank? {
        eachOfAKind(3)
    }
    
    func twoOfAKind() -> CardRank? {
        eachOfAKind(2)
    }
    
    func eachOfAKind(_ count: Int, inDeck: Deck? = nil) -> CardRank? {
        let hand = inDeck ?? self.hand
        guard hand.count >= count else { return nil }
            
        var matches = [CardRank]()
        
        eachHand(of: count, in: hand) { (currentHand) in
            if let rank = countOfAKind(count, inDeck: currentHand) {
                matches.append(rank)
            }
        }
        
        return matches.sorted { (lh, rh) -> Bool in
            return lh.rawValue > rh.rawValue
        }.first
    }
    
    func countOfAKind(_ count: Int, inDeck: Deck) -> CardRank? {
        for card in inDeck {
            let matches = cardsOfRank(card.rank, inDeck: inDeck)
            if matches.count >= count {
                return card.rank
            }
        }
        return nil
    }

    // if two pair, returns the two ranks of the pairs (highest first)
    //
    func twoPair() -> (highRank1: CardRank, highRank2: CardRank)? {
        guard hand.count >= 4 else { return nil }
        
        // get the highestpair first
        if let firstPair = twoOfAKind() {
            // remove those and look for another pair
            let remaining = hand.filter { (card) -> Bool in
                card.rank != firstPair
            }
            
            if let secondPair = eachOfAKind(2, inDeck: remaining) {
                let result = (highRank1: firstPair, highRank2: secondPair)
                return result
            }
        }
        
        return nil
    }
    
    func fullHouse() -> (result: Bool, threeRank: CardRank, pairRank: CardRank) {
        var result = (result: false, threeRank: CardRank.none, pairRank: CardRank.none)
        guard hand.count >= 5 else { return result }

        // first find 3 of a kind
        if let three = threeOfAKind() {
            // remove those and look for a pair
            let remaining = hand.filter { (card) -> Bool in
                card.rank != three
            }
            if let pair = eachOfAKind(2, inDeck: remaining) {
                result.result = true
                result.pairRank = pair
                result.threeRank = three
            }
        }
        return result
    }
    
    func highCard() -> (result: Bool, cardRanking: [CardRank]) {
        var result = (result: !hand.isEmpty, cardRanking: [CardRank.ace])
        
        let sortedDeck = hand.sorted { (l, r) -> Bool in
            return l.rank.rawValue > r.rank.rawValue
            }.compactMap { (card) -> CardRank in
                return card.rank
        }
        
        result.cardRanking = sortedDeck
        return result
    }
}
