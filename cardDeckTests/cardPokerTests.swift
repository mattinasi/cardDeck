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

    let royalFlushHand = shuffle(deck: [Card(suit: .hearts, rank: .ace),
                                        Card(suit: .hearts, rank: .king),
                                        Card(suit: .hearts, rank: .queen),
                                        Card(suit: .hearts, rank: .jack),
                                        Card(suit: .hearts, rank: .ten)])
    
    let straightFlushHand = shuffle(deck: [Card(suit: .hearts, rank: .nine),
                                           Card(suit: .hearts, rank: .king),
                                           Card(suit: .hearts, rank: .queen),
                                           Card(suit: .hearts, rank: .jack),
                                           Card(suit: .hearts, rank: .ten)])

    let straightWithAce = shuffle(deck: [Card(suit: .hearts, rank: .ace),
                                         Card(suit: .clubs, rank: .two),
                                         Card(suit: .diamonds, rank: .three),
                                         Card(suit: .spades, rank: .four),
                                         Card(suit: .diamonds, rank: .five)])

    let fiveCardStraight = shuffle(deck: [Card(suit: .hearts, rank: .jack),
                                          Card(suit: .clubs, rank: .ten),
                                          Card(suit: .diamonds, rank: .nine),
                                          Card(suit: .spades, rank: .eight),
                                          Card(suit: .diamonds, rank: .seven)])

    let sevenCardStraight = shuffle(deck: [Card(suit: .hearts, rank: .ten),
                                           Card(suit: .clubs, rank: .nine),
                                           Card(suit: .diamonds, rank: .eight),
                                           Card(suit: .spades, rank: .seven),
                                           Card(suit: .diamonds, rank: .six),
                                           Card(suit: .clubs, rank: .queen),
                                           Card(suit: .spades, rank: .two)])

    let flushHand = shuffle(deck: [Card(suit: .hearts, rank: .king),
                                   Card(suit: .hearts, rank: .three),
                                   Card(suit: .hearts, rank: .four),
                                   Card(suit: .hearts, rank: .jack),
                                   Card(suit: .hearts, rank: .seven)])
                        
    let randomHand = shuffle(deck: [Card(suit: .hearts, rank: .two),
                                    Card(suit: .clubs, rank: .king),
                                    Card(suit: .diamonds, rank: .queen),
                                    Card(suit: .spades, rank: .jack),
                                    Card(suit: .diamonds, rank: .ten)])
    
    let extraCards = shuffle(deck: [Card(suit: .clubs, rank: .five),
                                    Card(suit: .diamonds, rank: .nine)])
    
    func testRoyalFlushFiveCards() {
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

        // royal flush is always a straightFlush, a flush and a straight too
        XCTAssertNotNil(pokerHand.straightFlush())
        XCTAssertNotNil(pokerHand.straight())
        XCTAssertNotNil(pokerHand.flush())
    }

    func testRoyalFlushBuried() {
        let deck = straightFlushHand + royalFlushHand + fiveCardStraight
        let pokerHand = PokerHand(hand: deck)

        let result = pokerHand.royalFlush()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(5, result?.count)
        XCTAssertEqual(.ace, result?[0].rank)
        XCTAssertEqual(.king, result?[1].rank)
        XCTAssertEqual(.queen, result?[2].rank)
        XCTAssertEqual(.jack, result?[3].rank)
        XCTAssertEqual(.ten, result?[4].rank)
    }

    func testNotRoyalFlush() {
        let deck = straightFlushHand
        let pokerHand = PokerHand(hand: deck)

        let result = pokerHand.royalFlush()
        
        XCTAssertNil(result)
    }

    func testRoyalFlushMultipleSuits() {
        var deck = [Card(suit: .clubs, rank: .ace)]
        deck = deck + royalFlushHand
        let pokerHand = PokerHand(hand: deck)

        let result = pokerHand.royalFlush()
        
        XCTAssertNotNil(result)
    }

    func testRoyalFlushInsufficientCards() {
        var deck = royalFlushHand
        deck.removeLast()
        let pokerHand = PokerHand(hand: deck)

        let result = pokerHand.royalFlush()
        
        XCTAssertNil(result)
    }

    func testStraightFlushFiveCards() {
        let deck = straightFlushHand
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.straightFlush()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(.king, result?[0].rank)
        
        XCTAssertNotNil(pokerHand.straight())
        XCTAssertNotNil(pokerHand.flush())
    }

    func testStraightFlushBuried() {
        let deck = extraCards + straightFlushHand
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

    func testNotStraightFlushInsufficientCards() {
        var deck = straightFlushHand
        deck.removeLast()
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

    func testStraightBuried() {
        let deck = sevenCardStraight
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.straight()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(CardRank.ten, result?[0].rank)
    }

    func testStraightWithPairsCards() {
        var deck = fiveCardStraight
        deck.append(Card(suit: .hearts, rank: .three))
        deck.append(Card(suit: .spades, rank: .three))
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.straight()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(CardRank.jack, result?[0].rank)
    }

    func testNotStraight() {
        let deck = randomHand
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.straight()
        
        XCTAssertNil(result)
    }

    func testNotStraightLongHand() {
        let deck = flushHand + randomHand
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.straight()
        
        XCTAssertNil(result)
    }

    func testNotStraightLessThanFiveCards() {
        var deck = fiveCardStraight
        deck.removeFirst()
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.straight()
        
        XCTAssertNil(result)
    }

    func testStraightWithAce() {
        let deck = straightWithAce
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(CardRank.five, result?[0].rank)
    }

    func testLongStraightWithAce() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .ace),
                                  Card(suit: .clubs, rank: .two),
                                  Card(suit: .diamonds, rank: .three),
                                  Card(suit: .spades, rank: .four),
                                  Card(suit: .diamonds, rank: .five),
                                  Card(suit: .clubs, rank: .king),
                                  Card(suit: .diamonds, rank: .queen)])
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(CardRank.five, result?[0].rank)
    }

    func testNotStraightWithAce() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .ace),
                                  Card(suit: .clubs, rank: .two),
                                  Card(suit: .diamonds, rank: .three),
                                  Card(suit: .spades, rank: .three),
                                  Card(suit: .diamonds, rank: .five)])
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.straight()
        
        XCTAssertNil(result)
    }

    func testFlush() {
        let deck = flushHand
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.flush()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(.king, result?[0].rank)
    }

    func testFlushBurried() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .two),
                                  Card(suit: .hearts, rank: .five),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .diamonds, rank: .three),
                                  Card(suit: .clubs, rank: .three),
                                  Card(suit: .hearts, rank: .ace)])
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.flush()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(.ace, result?[0].rank)
    }
    
    func testFlushMultiple() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .two),
                                  Card(suit: .hearts, rank: .five),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .ace),
                                  Card(suit: .clubs, rank: .queen),
                                  Card(suit: .clubs, rank: .two),
                                  Card(suit: .clubs, rank: .five),
                                  Card(suit: .clubs, rank: .three),
                                  Card(suit: .clubs, rank: .king)])
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.flush()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(.ace, result?[0].rank)
    }
    
    func testNotFlush() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .four),
                                  Card(suit: .spades, rank: .jack)])
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.flush()
        XCTAssertNil(result)
    }
    
    func testFourOfAKind() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .three)])
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.fourOfAKind()

        XCTAssertNotNil(result)
        XCTAssertEqual(.three, result)
    }
    
    func testMultipleFourOfAKind() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .king),
                                  Card(suit: .diamonds, rank: .king),
                                  Card(suit: .spades, rank: .king),
                                  Card(suit: .clubs, rank: .king)])
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.fourOfAKind()

        XCTAssertNotNil(result)
        XCTAssertEqual(.king, result)
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

    func testFourOfAKindInsufficientCards() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .two),
                                  Card(suit: .hearts, rank: .three)])
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.fourOfAKind()
        
        XCTAssertNil(result)
    }

    func testThreeOfAKind() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .king),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three),
                    Card(suit: .hearts, rank: .three)])
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.threeOfAKind()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(.three, result)
    }

    func testMultipleThreeOfAKind() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .ace),
                                  Card(suit: .spades, rank: .ace),
                                  Card(suit: .diamonds, rank: .ace),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .spades, rank: .three),
                                  Card(suit: .diamonds, rank: .three)])
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.threeOfAKind()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(.ace, result)
    }

    func testThreeOfAKindInsufficientCards() {
        let deck = shuffle(deck: [Card(suit: .diamonds, rank: .two)])
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.threeOfAKind()
        
        XCTAssertNil(result)
    }
    
    func testTwoOfAKind() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .three)])
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.twoOfAKind()

        XCTAssertNotNil(result)
        XCTAssertEqual(.three, result)
    }

    func testMultipleTwoOfAKind() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .king),
                                  Card(suit: .spades, rank: .king),
                                  Card(suit: .hearts, rank: .nine),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .three)])
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.twoOfAKind()

        XCTAssertNotNil(result)
        XCTAssertEqual(.king, result)
    }

    func testTwoPair() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .king),
                                  Card(suit: .diamonds, rank: .ace)])
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.twoPair()

        XCTAssertNotNil(result)
        XCTAssertEqual(.king, result?.highRank1)
        XCTAssertEqual(.three, result?.highRank2)
    }

    func testTwoPairBuried() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .king),
                                  Card(suit: .diamonds, rank: .ace),
                                  Card(suit: .diamonds, rank: .jack),
                                  Card(suit: .diamonds, rank: .queen)])
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.twoPair()

        XCTAssertNotNil(result)
        XCTAssertEqual(.king, result?.highRank1)
        XCTAssertEqual(.three, result?.highRank2)
    }

    func testNotTwoPair() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .two),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .king),
                                  Card(suit: .diamonds, rank: .ace)])
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.twoPair()

        XCTAssertNil(result)
    }

    func testNotTwoPairInsufficientCards() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .three),
                                  Card(suit: .diamonds, rank: .ace)])
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.twoPair()

        XCTAssertNil(result)
    }

    func testFullHouse() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .king)])
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.fullHouse()
        
        XCTAssertTrue(result.result)
        XCTAssertEqual(.king, result.pairRank)
        XCTAssertEqual(.three, result.threeRank)
    }

    func testFullHouseMultiplePairs() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .five),
                                  Card(suit: .hearts, rank: .five),
                                  Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .king)])
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.fullHouse()
        
        XCTAssertTrue(result.result)
        XCTAssertEqual(.king, result.pairRank)
        XCTAssertEqual(.three, result.threeRank)
    }

    func testFullHouseInsufficientCards() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .king)])
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.fullHouse()
        
        XCTAssertFalse(result.result)
    }
    
    func testHighCardRanking() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .three),
                                  Card(suit: .hearts, rank: .four),
                                  Card(suit: .spades, rank: .three),
                                  Card(suit: .diamonds, rank: .seven),
                                  Card(suit: .hearts, rank: .ace)])
        let pokerHand = PokerHand(hand: deck)
        
        let result = pokerHand.highCard()
        
        XCTAssertTrue(result.result)
        XCTAssertEqual(.ace, result.cardRanking[0])
        XCTAssertEqual(.seven, result.cardRanking[1])
        XCTAssertEqual(.four, result.cardRanking[2])
        XCTAssertEqual(.three, result.cardRanking[3])
        XCTAssertEqual(.three, result.cardRanking[4])
    }
    
    // MARK: handRanking
    
    func testRoyalFlushHandRanking() {
        let deck = shuffle(deck: royalFlushHand + extraCards)
        
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.handRanking()
        
        switch result.highRank {
        case .royalFlush:
            XCTAssertTrue(true)
        default:
            XCTAssertTrue(false)
        }
        
        XCTAssertEqual(5, result.winningHand.count)
        XCTAssertEqual(CardRank.ace, result.winningHand[0].rank)
        XCTAssertEqual(CardRank.king, result.winningHand[1].rank)
        XCTAssertEqual(CardRank.queen, result.winningHand[2].rank)
        XCTAssertEqual(CardRank.jack, result.winningHand[3].rank)
        XCTAssertEqual(CardRank.ten, result.winningHand[4].rank)

        XCTAssertEqual(0, result.highCards.count)
    }
    
    func testStraightFlushHandRanking() {
        let deck = shuffle(deck: straightFlushHand + extraCards)
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.handRanking()
        
        switch result.highRank {
        case .straightFlush( let rank ):
            XCTAssertTrue(rank == .king)
        default:
            XCTFail("Expected straight flush as high rank")
        }

        XCTAssertEqual(5, result.winningHand.count)
        XCTAssertEqual(CardRank.king, result.winningHand[0].rank)
        
        XCTAssertEqual(0, result.highCards.count)
    }
    
    func testFourOfAKindHandRanking() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .two),
                                  Card(suit: .hearts, rank: .five),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .spades, rank: .three),
                                  Card(suit: .diamonds, rank: .three),
                                  Card(suit: .clubs, rank: .three)])
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.handRanking()
        
        switch result.highRank {
        case .fourOfAKind( let rank ):
            XCTAssertEqual(rank, .three)
            break
        default:
            XCTFail("")
        }

        XCTAssertEqual(4, result.winningHand.count)
        XCTAssertEqual(3, result.highCards.count)
        
        XCTAssertEqual(.three, result.winningHand[0].rank)
        XCTAssertEqual(.three, result.winningHand[1].rank)
        XCTAssertEqual(.three, result.winningHand[2].rank)
        XCTAssertEqual(.three, result.winningHand[3].rank)
        XCTAssertEqual(.king, result.highCards[0].rank)
        XCTAssertEqual(.five, result.highCards[1].rank)
        XCTAssertEqual(.two, result.highCards[2].rank)

    }
    
    func testFullHouseHandRanking() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .two),
                                  Card(suit: .clubs, rank: .king),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .diamonds, rank: .three),
                                  Card(suit: .clubs, rank: .three),
                                  Card(suit: .hearts, rank: .ace)])
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.handRanking()
        
        switch result.highRank {
        case .fullHouse(let threeRank, let pairRank):
            XCTAssertEqual(pairRank, .king)
            XCTAssertEqual(threeRank, .three)
            break
        default:
            XCTFail("Expected FullHouse ranking")
        }
    }
    
    func testFlushHandRanking() {
        let deck = shuffle(deck: [Card(suit: .hearts, rank: .king),
                                  Card(suit: .hearts, rank: .two),
                                  Card(suit: .hearts, rank: .five),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .diamonds, rank: .three),
                                  Card(suit: .clubs, rank: .three),
                                  Card(suit: .hearts, rank: .ace)])
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.handRanking()
        
        switch result.highRank {
        case .flush(let rank):
            XCTAssertEqual(rank, .ace)
            guard let topCard = result.winningHand.first else {
                XCTFail("Winning Hand is empty!")
                return
            }
            XCTAssertNotNil(topCard)
            XCTAssertEqual(.hearts, topCard.suit)
            XCTAssertEqual(.ace, topCard.rank)
            XCTAssertEqual(2, result.highCards.count)
            XCTAssertEqual(.three, result.highCards[0].rank)
            break
        default:
            XCTFail("Expected Flush ranking")
        }
    }

    func testThreeOfAKindHandRanking() {
        let deck = shuffle(deck: [Card(suit: .clubs, rank: .king),
                                  Card(suit: .hearts, rank: .ace),
                                  Card(suit: .hearts, rank: .two),
                                  Card(suit: .spades, rank: .five),
                                  Card(suit: .hearts, rank: .three),
                                  Card(suit: .diamonds, rank: .three),
                                  Card(suit: .clubs, rank: .three)])
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.handRanking()
        
        switch result.highRank {
        case .threeOfAKind(let rank):
            XCTAssertEqual(rank, .three)
            XCTAssertEqual(4, result.highCards.count)
            XCTAssertEqual(.ace, result.highCards[0].rank)
            break
        default:
            XCTFail("Expected Three Of A Kind ranking")
        }
    }

    func testTwoPairHandRanking() {
        let deck = shuffle(deck: [Card(suit: .clubs, rank: .king),
                                  Card(suit: .hearts, rank: .ace),
                                  Card(suit: .clubs, rank: .five),
                                  Card(suit: .spades, rank: .five),
                                  Card(suit: .diamonds, rank: .three),
                                  Card(suit: .hearts, rank: .three)])
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.handRanking()
        
        switch result.highRank {
        case .twoPair(let highRank1, let highRank2):
            XCTAssertEqual(highRank1, .five)
            XCTAssertEqual(highRank2, .three)
            XCTAssertEqual(2, result.highCards.count)
            XCTAssertEqual(.ace, result.highCards[0].rank)
            break
        default:
            XCTFail("Expected TwoPair ranking")
        }
    }
    
    func testPairHandRanking() {
        let deck = shuffle(deck: [Card(suit: .clubs, rank: .king),
                                  Card(suit: .hearts, rank: .ace),
                                  Card(suit: .clubs, rank: .five),
                                  Card(suit: .clubs, rank: .two),
                                  Card(suit: .spades, rank: .jack),
                                  Card(suit: .diamonds, rank: .three),
                                  Card(suit: .hearts, rank: .three)])
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.handRanking()
        
        switch result.highRank {
        case .pair(let highRank):
            XCTAssertEqual(highRank, .three)
            XCTAssertEqual(5, result.highCards.count)
            XCTAssertEqual(.ace, result.highCards[0].rank)
            break
        default:
            XCTFail("Expected Pair ranking")
        }
    }
    
    func testHighCardHandRanking() {
        let deck = shuffle(deck: [Card(suit: .clubs, rank: .king),
                                  Card(suit: .hearts, rank: .jack),
                                  Card(suit: .clubs, rank: .nine),
                                  Card(suit: .clubs, rank: .seven),
                                  Card(suit: .spades, rank: .five),
                                  Card(suit: .diamonds, rank: .three),
                                  Card(suit: .hearts, rank: .ace)])
        let pokerHand = PokerHand(hand: deck)
        let result = pokerHand.handRanking()
        
        switch result.highRank {
        case .highCard(let highRank):
            XCTAssertEqual(highRank, .ace)
            XCTAssertEqual(6, result.highCards.count)
            XCTAssertEqual(.king, result.highCards[0].rank)
            XCTAssertEqual(.jack, result.highCards[1].rank)
            break
        default:
            XCTFail("Expected High Card ranking")
        }

    }
}
