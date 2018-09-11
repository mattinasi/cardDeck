//
//  cardPokerTests.swift
//  cardDeckTests
//
//  Created by Marc Attinasi on 9/9/18.
//  Copyright © 2018 Marc Attinasi. All rights reserved.
//

import XCTest
@testable import cardDeck

class cardPokerTests: XCTestCase {

    let royalFlushHand: [(suit: Suit, rank: CardRank)] = [Card(suit: .hearts, rank: .ace), Card(suit: .hearts, rank: .king), Card(suit: .hearts, rank: .queen), Card(suit: .hearts, rank: .jack), Card(suit: .hearts, rank: .ten)]
    
    let straightFlushHand: [(suit: Suit, rank: CardRank)] = [Card(suit: .hearts, rank: .nine), Card(suit: .hearts, rank: .king), Card(suit: .hearts, rank: .queen), Card(suit: .hearts, rank: .jack), Card(suit: .hearts, rank: .ten)]

    let fiveCardStraight: [(suit: Suit, rank: CardRank)] = [Card(suit: .hearts, rank: .jack), Card(suit: .clubs, rank: .ten), Card(suit: .diamonds, rank: .nine), Card(suit: .spades, rank: .eight), Card(suit: .diamonds, rank: .seven)]

    let sevenCardStraight: [(suit: Suit, rank: CardRank)] = [Card(suit: .hearts, rank: .ten), Card(suit: .clubs, rank: .nine), Card(suit: .diamonds, rank: .eight), Card(suit: .spades, rank: .seven), Card(suit: .diamonds, rank: .six), Card(suit: .clubs, rank: .queen), Card(suit: .spades, rank: .two)]

    func testRoyalFlush() {
        let deck = royalFlushHand
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.royalFlush()
        
        XCTAssertTrue(result)
        
        // royal flush is always a straightFlush, a flush and a straight... just sayin'
        XCTAssertTrue(pokerHand.straightFlush().result)
        XCTAssertTrue(pokerHand.straight().result)
        XCTAssertTrue(pokerHand.flush().result)
    }
    
    func testStraightFlush() {
        let deck = straightFlushHand
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straightFlush()
        
        XCTAssertTrue(result.result)
        XCTAssertEqual(.king, result.highRank)
        
        XCTAssertTrue(pokerHand.straight().result)
    }

    func testNotStraightFlush() {
        var deck = straightFlushHand
        deck[0].suit = .spades
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straightFlush()
        
        XCTAssertFalse(result.result)
    }

    func testStraightFiveCards() {
        let deck = fiveCardStraight
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertTrue(result.result)
        XCTAssertEqual(CardRank.jack, result.highRank)
    }

    func testStraightSevenCards() {
        let deck = sevenCardStraight
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertTrue(result.result)
        XCTAssertEqual(CardRank.ten, result.highRank)
    }

    func testStraightWithPairsCards() {
        var deck = Deck(fiveCardStraight)
        deck.append(Card(suit: .hearts, rank: .three))
        deck.append(Card(suit: .spades, rank: .three))
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertTrue(result.result)
        XCTAssertEqual(CardRank.jack, result.highRank)
    }

    func testNotStraight() {
        let deck = [Card(suit: .hearts, rank: .two), Card(suit: .clubs, rank: .king), Card(suit: .diamonds, rank: .queen), Card(suit: .spades, rank: .jack), Card(suit: .diamonds, rank: .ten)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertFalse(result.result)
    }

    func testNotStraightLongHand() {
        let deck = [Card(suit: .diamonds, rank: .ten),
                    Card(suit: .hearts, rank: .ten),
                    Card(suit: .clubs, rank: .king),
                    Card(suit: .diamonds, rank: .eight),
                    Card(suit: .spades, rank: .seven),
                    Card(suit: .diamonds, rank: .six),
                    Card(suit: .clubs, rank: .five),
                    Card(suit: .spades, rank: .two)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertFalse(result.result)
    }

    func testNotStraightLessThanFiveCards() {
        let deck = [Card(suit: .clubs, rank: .king), Card(suit: .diamonds, rank: .queen), Card(suit: .spades, rank: .jack), Card(suit: .diamonds, rank: .ten)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertFalse(result.result)
    }

    func testStraightWithAce() {
        let deck = [Card(suit: .hearts, rank: .ace),
                    Card(suit: .clubs, rank: .two),
                    Card(suit: .diamonds, rank: .three),
                    Card(suit: .spades, rank: .four),
                    Card(suit: .diamonds, rank: .five)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertTrue(result.result)
        XCTAssertEqual(CardRank.five, result.highRank)
    }

    func testLongStraightWithAce() {
        let deck = [Card(suit: .hearts, rank: .ace),
                    Card(suit: .clubs, rank: .two),
                    Card(suit: .diamonds, rank: .three),
                    Card(suit: .spades, rank: .four),
                    Card(suit: .diamonds, rank: .five),
                    Card(suit: .clubs, rank: .king),
                    Card(suit: .diamonds, rank: .queen)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertTrue(result.result)
        XCTAssertEqual(CardRank.five, result.highRank)
    }

    func testFlush() {
        let deck = [Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .four),
                    Card(suit: .hearts, rank: .jack)]
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.flush()
        XCTAssertTrue(result.result)
        XCTAssertEqual(.king, result.highRank)
    }

    func testNotFlush() {
        let deck = [Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .four),
                    Card(suit: .spades, rank: .jack)]
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.flush()
        XCTAssertFalse(result.result)
    }
    
    func testFourOfAKind() {
        let deck = [Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.fourOfAKind()
        XCTAssertTrue(result.result)
        XCTAssertEqual(.three, result.highRank)
    }
    
    func testNotFourOfAKind() {
        let deck = [Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .two),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.fourOfAKind()
        XCTAssertFalse(result.result)
    }

    func testThreeOfAKind() {
        let deck = [Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.threeOfAKind()
        XCTAssertTrue(result.result)
        XCTAssertEqual(.three, result.highRank)
    }

    func testTwoOfAKind() {
        let deck = [Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.twoOfAKind()
        XCTAssertTrue(result.result)
        XCTAssertEqual(.three, result.highRank)
    }
    
    func testTwoPair() {
        let deck = [Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .king)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.twoPair()
        XCTAssertTrue(result.result)
        XCTAssertEqual(.king, result.highRank1)
        XCTAssertEqual(.three, result.highRank2)
    }

    func testFullHouse() {
        let deck = [Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .king)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.fullHouse()
        XCTAssertTrue(result.result)
        XCTAssertEqual(.king, result.pairRank)
        XCTAssertEqual(.three, result.threeRank)
    }

}
