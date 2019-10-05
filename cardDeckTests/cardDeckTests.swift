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
    
    func testDefaultCard() {
        XCTAssertNotNil(Card.defaultCard())
    }
    
    func testUnshuffledDeck() {
        let deck = makeStandardDeck()
        
        XCTAssertEqual(52, deck.count)
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
            XCTFail("Should throw exception cutting empty deck")
        } catch DeckError.notEnoughCards {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Should throw notEnoughCards exception cutting empty deck")
        }
    }
    
    func testCutSingleCardDeck() {
        let deck = [Card(suit: .spades, rank: .ace)]

        do {
            _ = try cut(deck: deck)
            XCTFail("Should throw exception cutting single-card deck")
        } catch DeckError.notEnoughCards {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Should throw notEnoughCards exception cutting single-card deck")
        }
    }

    func testBury() {
        let deck = makeShuffledDeck()

        let buryDeck = bury(fromDeck: deck)
        XCTAssertEqual(deck.count-1, buryDeck.count)
    }

    func testBuryMoreThanOne() {
        let deck = makeShuffledDeck()

        let buryDeck = bury(count: 5, fromDeck: deck)
        XCTAssertEqual(5, deck.count - buryDeck.count)
    }
    
    func testBuryEmptyDeck() {
        let deck = [Card]()
        
        let buryDeck = bury(fromDeck: deck)
        XCTAssertEqual(0, buryDeck.count)
    }
    
    func testDealHand() {
        let deck = makeShuffledDeck()
      
        if let hand = try? dealHand(fromDeck: deck, count: 5) {
            XCTAssertEqual(5, hand.cards.count)
            XCTAssertEqual(47, hand.remainingDeck.count)
        } else {
            XCTFail("Failed to deal hand")
        }
    }

    func testDealHandInsufficientCards() {
        let deck = [Card(suit: .hearts, rank: .ace), Card(suit: .clubs, rank: .ace), Card(suit: .diamonds, rank: .ace), Card(suit: .spades, rank: .ace)]
        var hand: (cards: Deck, remainingDeck: Deck)?
        
        do {
            hand = try dealHand(fromDeck: deck, count: deck.count + 1)
            XCTFail("Should have thrown notEnoughCards exception")
        } catch DeckError.notEnoughCards {
            XCTAssertNil(hand)
        } catch {
            XCTFail("Should have thrown notEnoughCards exception")
        }
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
    
    func testCardRepresentationForJack() {
        let card = Card(suit: .hearts, rank: .jack)
        
        let representation = cardRepresentation(card)
        XCTAssertEqual("♥️ J", representation)
    }
    
    func testCardRepresentationForNumericalRank() {
        let range = CardRank.two.rawValue...CardRank.ten.rawValue
        range.forEach { (rank) in
            guard let cardRank = CardRank(rawValue: rank) else {
                XCTFail()
                return
            }
            let representation = cardRepresentation(Card(suit: .hearts, rank: cardRank))
            XCTAssertEqual("♥️ \(rank)", representation)
        }
    }
    
    func testEachPossibleHandCount() {
        let deck = [Card(suit: .hearts, rank: .nine),
                    Card(suit: .clubs, rank: .jack),
                    Card(suit: .clubs, rank: .three),
                    Card(suit: .diamonds, rank: .king),
                    Card(suit: .diamonds, rank: .five),
                    Card(suit: .spades, rank: .five),
                    Card(suit: .spades, rank: .ace)]
        var counter = 0
        eachHand(of: 5, in: deck) { hand in
            counter += 1
        }
        
        // picking 5 out of 7 cards makes 7! / (5!(7-5)!) = 21
        XCTAssertEqual(21, counter)
    }
    
    func testEachPossibleHandCountWhereCountEqualsHandSize() {
        let deck = [Card(suit: .hearts, rank: .nine),
                    Card(suit: .clubs, rank: .jack),
                    Card(suit: .clubs, rank: .three),
                    Card(suit: .diamonds, rank: .king),
                    Card(suit: .diamonds, rank: .five)]
        var counter = 0
        eachHand(of: 5, in: deck) { hand in
            counter += 1
        }
        
        XCTAssertEqual(1, counter)
    }

    func testEachPossibleHandCountWhereCountExceedsHandSize() {
        let deck = [Card(suit: .hearts, rank: .nine),
                    Card(suit: .clubs, rank: .jack),
                    Card(suit: .clubs, rank: .three),
                    Card(suit: .diamonds, rank: .king),
                    Card(suit: .diamonds, rank: .five)]
        var counter = 0
        eachHand(of: 7, in: deck) { hand in
            counter += 1
        }
        
        XCTAssertEqual(0, counter)
    }
    
    func testEachPossibleHandCountEmptyDeck() {
        let deck = [Card]()
        
        var counter = 0
        eachHand(of: 5, in: deck) { hand in
            counter += 1
        }
        
        XCTAssertEqual(0, counter)
    }
    
    func testEachPossibleHandInvalidTakingSize() {
        let deck = [Card(suit: .hearts, rank: .nine),
                    Card(suit: .clubs, rank: .jack),
                    Card(suit: .clubs, rank: .three),
                    Card(suit: .diamonds, rank: .king),
                    Card(suit: .diamonds, rank: .five)]
        var counter = 0
        eachHand(of: 0, in: deck) { hand in
            counter += 1
        }
        
        XCTAssertEqual(0, counter)
    }
}
