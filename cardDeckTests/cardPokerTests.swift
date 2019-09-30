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

    let royalFlushHand = [Card(suit: .hearts, rank: .ace), Card(suit: .hearts, rank: .king), Card(suit: .hearts, rank: .queen), Card(suit: .hearts, rank: .jack), Card(suit: .hearts, rank: .ten)]
    
    let straightFlushHand = [Card(suit: .hearts, rank: .nine), Card(suit: .hearts, rank: .king), Card(suit: .hearts, rank: .queen), Card(suit: .hearts, rank: .jack), Card(suit: .hearts, rank: .ten)]

    let fiveCardStraight = [Card(suit: .hearts, rank: .jack), Card(suit: .clubs, rank: .ten), Card(suit: .diamonds, rank: .nine), Card(suit: .spades, rank: .eight), Card(suit: .diamonds, rank: .seven)]

    let sevenCardStraight = [Card(suit: .hearts, rank: .ten), Card(suit: .clubs, rank: .nine), Card(suit: .diamonds, rank: .eight), Card(suit: .spades, rank: .seven), Card(suit: .diamonds, rank: .six), Card(suit: .clubs, rank: .queen), Card(suit: .spades, rank: .two)]

    func testRoyalFlush() {
        let deck = royalFlushHand
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.royalFlush()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(5, result?.count)
        XCTAssertEqual(.ace, result?[0].rank)
        XCTAssertEqual(.king, result?[1].rank)
        XCTAssertEqual(.queen, result?[2].rank)
        XCTAssertEqual(.jack, result?[3].rank)
        XCTAssertEqual(.ten, result?[4].rank)

        // royal flush is always a straightFlush, a flush and a straight... just sayin'
        XCTAssertNotNil(pokerHand.straightFlush())
        XCTAssertNotNil(pokerHand.straight())
        XCTAssertNotNil(pokerHand.flush())
    }

    func testRoyalFlushBuried() {
        var deck = royalFlushHand
        deck = [Card(suit: .clubs, rank: .seven)] + deck
        deck.append(Card(suit: .clubs, rank: .two))
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.royalFlush()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(5, result?.count)
        XCTAssertEqual(.ace, result?[0].rank)
        XCTAssertEqual(.king, result?[1].rank)
        XCTAssertEqual(.queen, result?[2].rank)
        XCTAssertEqual(.jack, result?[3].rank)
        XCTAssertEqual(.ten, result?[4].rank)
        
        // royal flush is always a straightFlush, a flush and a straight... just sayin'
        XCTAssertNotNil(pokerHand.straightFlush())
        XCTAssertNotNil(pokerHand.straight())
        XCTAssertNotNil(pokerHand.flush())
    }
    

    func testStraightFlush() {
        let deck = straightFlushHand
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straightFlush()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(.king, result?[0].rank)
        
        XCTAssertNotNil(pokerHand.straight())
        XCTAssertNotNil(pokerHand.flush())
    }

    func testNotStraightFlush() {
        var deck = straightFlushHand
        deck[0].suit = .spades
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straightFlush()
        
        XCTAssertNil(result)
    }

    func testStraightFiveCards() {
        let deck = fiveCardStraight
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(CardRank.jack, result?[0].rank)
    }

    func testStraightSevenCards() {
        let deck = sevenCardStraight
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(CardRank.ten, result?[0].rank)
    }

    func testStraightWithPairsCards() {
        var deck = Deck(fiveCardStraight)
        deck.append(Card(suit: .hearts, rank: .three))
        deck.append(Card(suit: .spades, rank: .three))
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(CardRank.jack, result?[0].rank)
    }

    func testNotStraight() {
        let deck = [Card(suit: .hearts, rank: .two), Card(suit: .clubs, rank: .king), Card(suit: .diamonds, rank: .queen), Card(suit: .spades, rank: .jack), Card(suit: .diamonds, rank: .ten)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertNil(result)
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
        
        XCTAssertNil(result)
    }

    func testNotStraightLessThanFiveCards() {
        let deck = [Card(suit: .clubs, rank: .king), Card(suit: .diamonds, rank: .queen), Card(suit: .spades, rank: .jack), Card(suit: .diamonds, rank: .ten)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertNil(result)
    }

    func testStraightWithAce() {
        let deck = [Card(suit: .hearts, rank: .ace),
                    Card(suit: .clubs, rank: .two),
                    Card(suit: .diamonds, rank: .three),
                    Card(suit: .spades, rank: .four),
                    Card(suit: .diamonds, rank: .five)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(CardRank.five, result?[0].rank)
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
        
        XCTAssertNotNil(result)
        XCTAssertEqual(CardRank.five, result?[0].rank)
    }

    func testFlush() {
        let deck = [Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .four),
                    Card(suit: .hearts, rank: .jack)]
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.flush()
        XCTAssertNotNil(result)
        XCTAssertEqual(.king, result)
    }

    func testNotFlush() {
        let deck = [Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .four),
                    Card(suit: .spades, rank: .jack)]
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.flush()
        XCTAssertNil(result)
    }
    
    func testFourOfAKind() {
        let deck = [Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.fourOfAKind()

        XCTAssertNotNil(result)
        XCTAssertEqual(.three, result)
    }
    
    func testNotFourOfAKind() {
        let deck = [Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .two),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.fourOfAKind()
        XCTAssertNil(result)
    }

    func testThreeOfAKind() {
        let deck = [Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.threeOfAKind()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(.three, result)
    }

    func testTwoOfAKind() {
        let deck = [Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.twoOfAKind()

        XCTAssertNotNil(result)
        XCTAssertEqual(.three, result)
    }
    
    func testTwoPair() {
        let deck = [Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .king),
                    Card(suit: .diamonds, rank: .ace)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.twoPair()

        XCTAssertNotNil(result)
        XCTAssertEqual(.king, result?.highRank1)
        XCTAssertEqual(.three, result?.highRank2)
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

    func testHighCardRanking() {
        let deck = [Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .four),
                    Card(suit: .spades, rank: .three),
                    Card(suit: .diamonds, rank: .seven),
                    Card(suit: .hearts, rank: .king)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.highCard()
        
        XCTAssertTrue(result.result)
        XCTAssertEqual(.king, result.cardRanking[0])
        XCTAssertEqual(.seven, result.cardRanking[1])
        XCTAssertEqual(.four, result.cardRanking[2])
        XCTAssertEqual(.three, result.cardRanking[3])
        XCTAssertEqual(.three, result.cardRanking[4])
    }
    
    // MARK: handRanking
    
    func testRoyalFlushHandRanking() {
        let deck = royalFlushHand
        
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.handRanking()
        
        switch result.highRank {
        case .royalFlush:
            XCTAssertTrue(true)
        default:
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(1, result.winningHand.count)
        XCTAssertEqual(5, result.winningHand[0].count)
        XCTAssertEqual(CardRank.ace, result.winningHand[0][0].rank)
        
        XCTAssertEqual(0, result.highCards.count)
    }
    
    func testStraightFlushHandRanking() {
        let deck = straightFlushHand
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.handRanking()
        
        switch result.highRank {
        case .straightFlush( let rank ):
            XCTAssertTrue(rank == .king)
        default:
            XCTAssertTrue(false)
        }

        XCTAssertEqual(1, result.winningHand.count)
        XCTAssertEqual(5, result.winningHand[0].count)
        XCTAssertEqual(CardRank.king, result.winningHand[0][0].rank)
        
        XCTAssertEqual(0, result.highCards.count)
    }
    
    func testFourOfAKindHandRanking() {
        let deck = [Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three)]
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.handRanking()
        
        switch result.highRank {
        case .fourOfAKind( let rank ):
            XCTAssertEqual(rank, .three)
            break
        default:
            XCTAssertTrue(false)
        }

        XCTAssertEqual(1, result.winningHand.count)
        XCTAssertEqual(4, result.winningHand[0].count)
        XCTAssertEqual(1, result.highCards.count)
        
        XCTAssertEqual(.three, result.winningHand[0][0].rank)
        XCTAssertEqual(.three, result.winningHand[0][1].rank)
        XCTAssertEqual(.three, result.winningHand[0][2].rank)
        XCTAssertEqual(.three, result.winningHand[0][3].rank)
        XCTAssertEqual(.king, result.highCards[0].rank)
    }
}
