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
    
    private let hand: Deck
    private let straightLength = 5

    init(hand: Deck) {
        self.hand = hand
    }

    func handRanking() -> HandRanking {
        if royalFlush() { return .royalFlush }
        
        let sf = straightFlush()
        if sf.result { return .straightFlush(sf.highRank) }
        
        let foak = fourOfAKind()
        if foak.result { return .fourOfAKind(foak.highRank) }
        
        let fh = fullHouse()
        if fh.result { return .fullHouse(fh.threeRank, fh.pairRank) }
        
        let f = flush()
        if f.result { return .flush(f.highRank) }
        
        let st = straight()
        if st.result { return .straight(st.highRank) }
        
        let toak = threeOfAKind()
        if toak.result { return .threeOfAKind(toak.highRank) }
        
        let tp = twoPair()
        if tp.result { return .twoPair(tp.highRank1, tp.highRank2) }
        
        let twooak = twoOfAKind()
        if twooak.result { return .pair(twooak.highRank) }
        
        let high = highCards(inDeck: hand)
        return .highCard(high[0].rank)
    }
    
    func royalFlush() -> Bool {
        guard hand.count >= 5 else { return false }
        guard let ace = hand.first(where: { (card) -> Bool in
            card.rank == .ace
        }) else {
            return false
        }
        let suit = ace.suit

        // all same suit?
        let suited = cardsOfSuit(suit, inDeck: hand)
        guard suited.count == 5 else {
            return false
        }

        return hasCard(Card(suit: suit, rank: .king), inDeck: hand) &&
            hasCard(Card(suit: suit, rank: .queen), inDeck: hand) &&
            hasCard(Card(suit: suit, rank: .jack), inDeck: hand) &&
            hasCard(Card(suit: suit, rank: .ten), inDeck: hand)
    }

    func straightFlush() -> (result: Bool, highRank: CardRank) {
        let suits = suitsIn(deck: hand)
        guard suits.count == 1 else { return (result: false, highRank: .joker) }
        
        // we know it is a flush, so see if it is also a straight
        return straight()
    }
    
    func straight() -> (result: Bool, highRank: CardRank) {
        if hand.count <= straightLength {
            return _Straight(hand)
        }
        let steps = hand.count - straightLength
        for index in 0..<steps {
            let subHand = Deck(hand[index..<index+straightLength])
            let result = _Straight(subHand)
            if result.result == true {
                return result
            }
        }
        return (result: false, highRank: CardRank.joker)
    }
    
    private func _Straight(_ deck: Deck) -> (result: Bool, highRank: CardRank) {
        var result = (result: false, highRank: CardRank.joker)
        
        guard deck.count >= 5 else {
            return result
        }
        
        let sortedDeck = deck.sorted { (l, r) -> Bool in
            return l.rank.rawValue > r.rank.rawValue
        }
        
        result.result = true

        // now see if they are sequential: first element is the hightest, so start there
        for index in 1..<straightLength {
            if sortedDeck[index].rank.rawValue != (sortedDeck[index-1].rank.rawValue - 1) {
                result.result = false
                continue
            }
        }
        result.highRank = sortedDeck[0].rank
        
        // consider ace, which can be a 1: skip the ace and look at the remainder for a 2,3,4,5 straight
        if result.result == false && result.highRank == .ace {
            let remainder = sortedDeck.filter { (card) -> Bool in
                return card.rank != result.highRank
            }
            
            guard remainder[0].rank == .five else { return result }

            result.result = true

            for index in 1..<straightLength-1 {
                if remainder[index].rank.rawValue != (remainder[index-1].rank.rawValue - 1) {
                    result.result = false
                    continue
                }
            }

            result.highRank = remainder[0].rank
        }

        return result
    }
    
    func flush() -> (result: Bool, highRank: CardRank) {
        var result = (result: false, highRank: CardRank.joker)

        let suits = suitsIn(deck: hand)
        result.result = suits.count == 1

        let sortedDeck = hand.sorted { (l, r) -> Bool in
            return l.rank.rawValue > r.rank.rawValue
        }
        result.highRank = sortedDeck[0].rank
        
        return result
    }
    
    func fourOfAKind() -> (result: Bool, highRank: CardRank) {
        let result = (result: false, highRank: CardRank.joker)
        guard hand.count >= 4 else { return result }

        return countOfAKind(4, inDeck: hand)
    }

    func threeOfAKind() -> (result: Bool, highRank: CardRank) {
        let result = (result: false, highRank: CardRank.joker)
        guard hand.count >= 3 else { return result }
        
        return countOfAKind(3, inDeck: hand)
    }
    
    func twoOfAKind() -> (result: Bool, highRank: CardRank) {
        let result = (result: false, highRank: CardRank.joker)
        guard hand.count >= 2 else { return result }
        
        return countOfAKind(2, inDeck: hand)
    }
    
    private func countOfAKind(_ count: Int, inDeck: Deck) -> (result: Bool, highRank: CardRank) {
        var result = (result: false, highRank: CardRank.joker)
        guard inDeck.count > 0 else { return result }
        
        for card in inDeck {
            let matches = cardsOfRank(card.rank, inDeck: inDeck)
            if matches.count == count {
                result.highRank = card.rank
                result.result = true
                break
            }
        }
        return result
    }

    // if two pair, returns the two ranks of the pairs (highest first)
    //
    func twoPair() -> (result: Bool, highRank1: CardRank, highRank2: CardRank) {
        var result = (result: false, highRank1: CardRank.joker, highRank2: CardRank.joker)
        guard hand.count >= 4 else { return result }
        
        // first see if there is a pair
        let firstPair = twoOfAKind()
        if firstPair.result {
            // remove those and look for another pair
            let remaining = hand.filter { (card) -> Bool in
                card.rank != firstPair.highRank
            }
            let secondPair = countOfAKind(2, inDeck: remaining)
            if secondPair.result {
                result.result = true
                result.highRank1 = firstPair.highRank.rawValue > secondPair.highRank.rawValue ? firstPair.highRank : secondPair.highRank
                result.highRank2 = firstPair.highRank.rawValue < secondPair.highRank.rawValue ? firstPair.highRank : secondPair.highRank
            }
        }
        
        return result
    }
    
    func fullHouse() -> (result: Bool, threeRank: CardRank, pairRank: CardRank) {
        var result = (result: false, threeRank: CardRank.joker, pairRank: CardRank.joker)
        guard hand.count >= 5 else { return result }

        // first find 3 of a kind
        let three = threeOfAKind()
        if three.result {
            // remove those and look for a pair
            let remaining = hand.filter { (card) -> Bool in
                card.rank != three.highRank
            }
            let pair = countOfAKind(2, inDeck: remaining)
            if pair.result {
                result.result = true
                result.pairRank = pair.highRank
                result.threeRank = three.highRank
            }
        }
        return result
    }
}
