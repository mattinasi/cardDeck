//
//  Poker.swift
//  cardDeck
//
//  Created by Marc Attinasi on 9/8/18.
//  Copyright © 2018 Marc Attinasi. All rights reserved.
//

import Foundation

struct PokerHand {
    
    enum HandRanking {
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
    }
    
    struct HandScore {
        var highRank: HandRanking       // the overall rank of the hand
        var winningHand: [Deck]         // the cards making up the winning rank
        var highCards: [Card]           // the remaining cards, in rank-order
        var score: Int                  // experimental numerical score
    }
    
    private let hand: Deck
    private let straightLength = 5

    init(hand: Deck) {
        self.hand = hand
    }

    func score(hand: Deck) -> Int {
        return 100
    }
    
    func handRanking() -> HandScore {
        
        if let result = royalFlush() {
            return HandScore(highRank: .royalFlush,
                             winningHand: [result],
                             highCards: [],
                             score: score(hand: result))
        }
        
        if let sf = straightFlush() {
            return HandScore(highRank: .straightFlush(sf[0].rank),
                                        winningHand: [sf],
                                        highCards: [],
                                        score: score(hand: hand))
        }

        if let foak = fourOfAKind() {
            let winningHand = hand.filter { (card) -> Bool in
                return card.rank == foak
            }
            let highCards = hand.filter { (card) -> Bool in
                return card.rank != foak
            }
            return HandScore(highRank: .fourOfAKind(foak),
                             winningHand: [winningHand],
                             highCards: highCards,
                             score: score(hand: hand))
        }
//
//        let fh = fullHouse()
//        if fh.result { return .fullHouse(fh.threeRank, fh.pairRank) }
//
//        let f = flush()
//        if f.result { return .flush(f.highRank) }
//
        if let st = straight() {
            return HandScore(highRank: .straight(st[0].rank),
                             winningHand: [st],
                             highCards: [],
                             score: score(hand: hand))
        }
        
//
//        let toak = threeOfAKind()
//        if toak.result { return .threeOfAKind(toak.highRank) }
//
//        let tp = twoPair()
//        if tp.result { return .twoPair(tp.highRank1, tp.highRank2) }
//
//        let twooak = twoOfAKind()
//        if twooak.result { return .pair(twooak.highRank) }
//
        let high = highCard()
        if high.result {
            let sorted = hand.sorted { (l, r) -> Bool in
                return l.rank.rawValue > r.rank.rawValue
            }
            return HandScore(highRank: .highCard(high.cardRanking[0]),
                             winningHand: [[sorted[0]]],
                             highCards: sorted,
                             score: score(hand: hand))
        }
        
        let card = Card.defaultCard()
        return HandScore(highRank: .highCard(card.rank), winningHand: [[card]], highCards: [card], score: score(hand: [card]))
    }
    
    func royalFlush() -> Deck? {
        guard hand.count >= 5 else { return nil }
        guard let ace = hand.first(where: { (card) -> Bool in
            card.rank == .ace
        }) else {
            return nil
        }
        

        // all same suit?
        let suit = ace.suit
        let suited = cardsOfSuit(suit, inDeck: hand)
        guard suited.count >= 5 else {
            return nil
        }

        let winningHand = [Card(suit: suit, rank: .ace),
                           Card(suit: suit, rank: .king),
                           Card(suit: suit, rank: .queen),
                           Card(suit: suit, rank: .jack),
                           Card(suit: suit, rank: .ten)]
        for winningCard in winningHand {
            if !hasCard(winningCard, inDeck: hand) {
                return nil
            }
        }
        return winningHand
    }

    func straightFlush() -> Deck? {
        guard hand.count >= 5 else { return nil }
        
        if flush() != nil {
            // we know it is a flush, so see if it is also a straight
            return straight()
        }
        return nil
    }
    
    func straight(deck: Deck? = nil) -> Deck? {
        let hand = deck ?? self.hand
        
        if hand.count <= straightLength {
            return _straight(hand)
        }
        let steps = hand.count - straightLength
        for index in 0..<steps {
            let subHand = Deck(hand[index..<index+straightLength])
            if let result = _straight(subHand) {
                return result
            }
        }
        return nil
    }
    
    private func _straight(_ deck: Deck) -> Deck? {
        guard deck.count >= 5 else {
            return nil
        }
        
        let sortedDeck = deck.sorted { (l, r) -> Bool in
            return l.rank.rawValue > r.rank.rawValue
        }
        
        var result = true

        // now see if they are sequential: first element is the hightest, so start there
        for index in 1..<straightLength {
            if sortedDeck[index].rank.rawValue != (sortedDeck[index-1].rank.rawValue - 1) {
                result = false
                continue
            }
        }
        
        let highCard = sortedDeck[0]

        if result {
            let winningHand = Array(sortedDeck[0..<5])
            return winningHand
        }
        
        // consider ace, which can be a 1: skip the ace and look at the remainder for a 2,3,4,5 straight
        if highCard.rank == .ace {
            let ace = highCard
            let remainder = sortedDeck.filter { (card) -> Bool in
                return card.rank != highCard.rank
            }
            
            guard remainder[0].rank == .five else { return nil }

            result = true

            for index in 1..<straightLength-1 {
                if remainder[index].rank.rawValue != (remainder[index-1].rank.rawValue - 1) {
                    result = false
                    continue
                }
            }

            if result {
                var winningHand = Array(remainder[0..<4])
                winningHand.append(ace)
                return winningHand
            }
        }

        return nil
    }
    
    func flush() -> CardRank? {
        var result = false

        let suits = suitsIn(deck: hand)
        result = suits.count == 1

        let sortedDeck = hand.sorted { (l, r) -> Bool in
            return l.rank.rawValue > r.rank.rawValue
        }
        let highRank = sortedDeck[0].rank
        
        return result ? highRank : nil
    }
    
    func fourOfAKind() -> CardRank? {
        guard hand.count >= 4 else { return nil }
        return countOfAKind(4, inDeck: hand)
    }

    func threeOfAKind() -> CardRank? {
        guard hand.count >= 3 else { return nil }
        return countOfAKind(3, inDeck: hand)
    }
    
    func twoOfAKind() -> CardRank? {
        guard hand.count >= 2 else { return nil }
        return countOfAKind(2, inDeck: hand)
    }
    
    private func countOfAKind(_ count: Int, inDeck: Deck) -> CardRank? {
        guard inDeck.count > 0 else { return nil }
        
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
        
        // first see if there is a pair
        if let firstPair = twoOfAKind() {
            // remove those and look for another pair
            let remaining = hand.filter { (card) -> Bool in
                card.rank != firstPair
            }
            if let secondPair = countOfAKind(2, inDeck: remaining) {
                let result = (highRank1: firstPair.rawValue > secondPair.rawValue ? firstPair : secondPair,
                              highRank2: firstPair.rawValue < secondPair.rawValue ? firstPair : secondPair)
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
            if let pair = countOfAKind(2, inDeck: remaining) {
                result.result = true
                result.pairRank = pair
                result.threeRank = three
            }
        }
        return result
    }
    
    func highCard() -> (result: Bool, cardRanking: [CardRank]) {
        var result = (result: true, cardRanking: [CardRank.ace])
        
        let sortedDeck = hand.sorted { (l, r) -> Bool in
            return l.rank.rawValue > r.rank.rawValue
            }.compactMap { (card) -> CardRank in
                return card.rank
        }
        
        result.cardRanking = sortedDeck
        return result
    }
}
