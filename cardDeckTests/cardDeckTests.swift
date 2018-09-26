//
//  cardDeckTests.swift
//  cardDeckTests
//
//  Created by Marc Attinasi on 9/8/18.
//  Copyright © 2018 Marc Attinasi. All rights reserved.
//

import XCTest
@testable import cardDeck

class cardDeckTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testShuffledDeck() {
      let deck = makeShuffledDeck()
      
      XCTAssertEqual(52, deck.count)
    }

    func testCutDeck() {
      let deck = makeShuffledDeck()
      let cutDeck = try? cut(deck: deck)
      
      XCTAssertEqual(deck.count, cutDeck?.count)
    }

    func testCutEmptyDeck() {
        let deck = Deck()
        do {
            _ = try cut(deck: deck)
            XCTAssertTrue(false)
        } catch DeckError.notEnoughCards {
            XCTAssertTrue(true)
        } catch {
            XCTAssertTrue(false)
        }
    }
    
    func testBury() {
        let deck = makeShuffledDeck()
        var cutDeck = bury(fromDeck: deck)
        XCTAssertEqual(deck.count-1, cutDeck.count)
        
        cutDeck = bury(count: 5, fromDeck: deck)
        XCTAssertEqual(5, deck.count - cutDeck.count)

    }

    func testCutFailure() {
        var deck = [Card]()
        var cutDeck = try? cut(deck: deck)
        XCTAssertNil(cutDeck)
        
        deck = [Card(suit: .spades, rank: .ace)]
        cutDeck = try? cut(deck: deck)
        XCTAssertNil(cutDeck)
        
    }

    func testHand() {
        let deck = makeShuffledDeck()
      
        if let hand = try? dealHand(fromDeck: deck, count: 5) {
            XCTAssertEqual(5, hand.hand.count)
            XCTAssertEqual(47, hand.deck.count)
            
            if let hand2 = try? dealHand(fromDeck: hand.deck, count: 7) {
                XCTAssertEqual(7, hand2.hand.count)
                XCTAssertEqual(40, hand2.deck.count)
            } else { XCTAssertFalse(true, "Failed to deal hand")}
        } else { XCTAssertFalse(true, "Failed to deal hand")}
    }

    func testHandInsufficientCards() {
        let deck = [Card(suit: .hearts, rank: .ace), Card(suit: .clubs, rank: .ace), Card(suit: .diamonds, rank: .ace), Card(suit: .spades, rank: .ace)]
        
        let hand = try? dealHand(fromDeck: deck, count: deck.count + 1)
        XCTAssertNil(hand)
    }
    
    func testHasCard() {
      let deck = [Card(suit: .hearts, rank: .ace), Card(suit: .clubs, rank: .ace), Card(suit: .diamonds, rank: .ace), Card(suit: .spades, rank: .ace)]
      
      XCTAssertTrue(hasCard(Card(suit: .hearts, rank: .ace), inDeck: deck))
      XCTAssertTrue(hasCard(Card(suit: .clubs, rank: .ace), inDeck: deck))
      XCTAssertTrue(hasCard(Card(suit: .diamonds, rank: .ace), inDeck: deck))
      XCTAssertTrue(hasCard(Card(suit: .spades, rank: .ace), inDeck: deck))
      
      XCTAssertFalse(hasCard(Card(suit: .hearts, rank: .two), inDeck: deck))
    }
  
    func testSuitsInDeck() {
        let deck = [Card(suit: .hearts, rank: .nine),
                    Card(suit: .clubs, rank: .three),
                    Card(suit: .diamonds, rank: .king),
                    Card(suit: .diamonds, rank: .five)]
        let suits = suitsIn(deck: deck)
        
        XCTAssertEqual(3, suits.keys.count)
        XCTAssertEqual(1, suits[.hearts])
        XCTAssertEqual(1, suits[.clubs])
        XCTAssertEqual(2, suits[.diamonds])
    }

    func testCardsOfSuit() {
      var deck = [Card(suit: .hearts, rank: .ace), Card(suit: .clubs, rank: .ace), Card(suit: .diamonds, rank: .ace), Card(suit: .spades, rank: .ace)]
      
      XCTAssertEqual(1, cardsOfSuit(.clubs, inDeck: deck).count)
      XCTAssertEqual(1, cardsOfSuit(.diamonds, inDeck: deck).count)
      XCTAssertEqual(1, cardsOfSuit(.hearts, inDeck: deck).count)
      XCTAssertEqual(1, cardsOfSuit(.spades, inDeck: deck).count)
      
      deck = [Card(suit: .hearts, rank: .ace), Card(suit: .hearts, rank: .king), Card(suit: .hearts, rank: .two), Card(suit: .hearts, rank: .five)]
      
      XCTAssertEqual(4, cardsOfSuit(.hearts, inDeck: deck).count)
    }

    func testCardsOfRank() {
        let deck = [Card(suit: .hearts, rank: .ace), Card(suit: .clubs, rank: .ace), Card(suit: .diamonds, rank: .ace), Card(suit: .spades, rank: .ace)]
        let result = cardsOfRank(.ace, inDeck: deck)
        XCTAssertEqual(4, result.count)
    }
    
    func testHighCards() {
        let deck = [Card(suit: .hearts, rank: .king),
                    Card(suit: .clubs, rank: .three),
                    Card(suit: .diamonds, rank: .king),
                    Card(suit: .spades, rank: .five)]
        let highest = highCards(inDeck: deck)
        
        XCTAssertEqual(2, highest.count)
        XCTAssertEqual(.king, highest[0].rank)
        XCTAssertEqual(.hearts, highest[0].suit)
        XCTAssertEqual(.king, highest[1].rank)
        XCTAssertEqual(.diamonds, highest[1].suit)

        let singleHighest = highCards(inDeck: [Card(suit: .spades, rank: .ten), Card(suit: .diamonds, rank: .seven)])
        XCTAssertEqual(1, singleHighest.count)
        XCTAssertEqual(.ten, singleHighest.first!.rank)

        let emptyHighest = highCards(inDeck: [])
        XCTAssertEqual(0, emptyHighest.count)
    }
}
