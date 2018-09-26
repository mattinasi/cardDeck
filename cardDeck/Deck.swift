//
//  Deck.swift
//  cardDeck
//
//  Created by Marc Attinasi on 9/8/18.
//  Copyright © 2018 Marc Attinasi. All rights reserved.
//

import Foundation

// MARK: - types -

enum Suit : String {
  case hearts = "♥️"
  case spades = "♠️"
  case diamonds = "♦️"
  case clubs = "♣️"
}

enum CardRank: Int {
    case ace    = 14
    case king   = 13
    case queen  = 12
    case jack   = 11
    case ten    = 10
    case nine   = 9
    case eight  = 8
    case seven  = 7
    case six    = 6
    case five   = 5
    case four   = 4
    case three  = 3
    case two    = 2
    case joker  = 0
}

struct Card {
    
    var suit: Suit
    var rank: CardRank
    
    init(suit: Suit, rank: CardRank) {
        self.suit = suit
        self.rank = rank
    }
    
    static func defaultCard() -> Card {
        return Card(suit: .diamonds, rank: .joker)
    }
}

typealias Deck = [Card]

enum DeckError: Error {
    case notEnoughCards
    case cardNotFound
}

let joker = Card(suit: .spades, rank: .joker)

// MARK: - Deck functions -

func makeAllCards(ofSuit suit: Suit) -> Deck {
  var cards = [Card]()
  
  let range = CardRank.two.rawValue...CardRank.ace.rawValue
  range.forEach { (rank) in
    if let rank = CardRank(rawValue: rank) {
      cards.append(Card(suit: suit, rank: rank))
    }
  }
  return cards
}

func cut(deck: Deck) throws -> Deck {
    guard deck.count > 1 else { throw DeckError.notEnoughCards }
    
    let cutPoint = Int.random(in: 1..<deck.count)
    var result = Deck()
  
    deck.suffix(cutPoint).forEach { (card) in
        result.append(card)
    }
  
    deck.prefix(deck.count-cutPoint).forEach { (card) in
        result.append(card)
    }
  
    return result
}

func bury(count: Int = 1, fromDeck deck: Deck) -> Deck {
    guard deck.count >= 1 else { return deck }
    
    return Deck(deck.suffix(from: count))
}

func shuffle(deck: Deck, repeat: Int = 50) -> Deck {
  var resultDeck = deck
  for _ in 1...`repeat` {
    let i = Int.random(in: 0..<deck.count)
    let j = Int.random(in: 0..<deck.count)
    if i != j {
      resultDeck.swapAt(i, j)
    }
  }
  return resultDeck
}

func makeShuffledDeck() -> Deck {
  let deck = makeAllCards(ofSuit: .hearts) +
    makeAllCards(ofSuit: .diamonds) +
    makeAllCards(ofSuit: .spades) +
    makeAllCards(ofSuit: .clubs)
  
  return shuffle(deck: deck)
}

func dealHand(fromDeck: Deck, count: Int) throws -> (hand: Deck, deck: Deck) {
    guard fromDeck.count >= count else { throw DeckError.notEnoughCards }
    
    let dealt = fromDeck[0..<count]
    let hand = dealt.compactMap({ (card) -> Card? in
        return card
    })
    let deck = fromDeck.suffix(from: count).compactMap { (card) -> Card? in
        return card
    }
    return (hand: hand, deck: deck)
}

// MARK: - inquiries about what is in a Deck -

// returns all of the suits in a deck, with the count of how many of each suit
//
func suitsIn(deck: Deck) -> [Suit: Int]{
    var suits = [Suit: Int]()
    
    deck.forEach { (card) in
        let suit = card.suit
        if let count = suits[suit] {
            suits[suit] = count + 1
        } else {
            suits[suit] = 1
        }
    }
    return suits
}

// returns a deck of all of the cards of the given suit
//
func cardsOfSuit(_ suit: Suit, inDeck deck: Deck) -> Deck {
  let result = deck.filter { (card) -> Bool in
    return card.suit == suit
  }
  return result
}

// returns a deck of all of the cards of the given rank
//
func cardsOfRank(_ rank: CardRank, inDeck deck: Deck) -> Deck {
    let result = deck.filter { (card) -> Bool in
        return card.rank == rank
    }
    return result
}

// returns true if the specified card is in the deck
//
func hasCard(_ card: Card, inDeck deck: Deck) -> Bool {
  return deck.first(where: { (c) -> Bool in
    return c.suit == card.suit && c.rank == card.rank
  }) != nil
}

// returns the higest ranked card: since there can be more than one, an array is returned
//
func highCards(inDeck deck: Deck) -> [Card] {
    guard deck.count > 0 else { return [] }
    
    let sorted = deck.sorted(by: { (l, r) -> Bool in
        return l.rank.rawValue > r.rank.rawValue
    })
    return sorted.compactMap({ (card) -> Card? in
        return card.rank == sorted.first!.rank ? card : nil
    })
}

// MARK: - display -

// string representation of a card
//
func cardRepresentation(_ card: Card) -> String {
    var rank: String
    switch card.rank {
    case .ace:
        rank = "A"
    case .king:
        rank = "K"
    case .queen:
        rank = "Q"
    case .jack:
        rank = "J"
    case .joker:
        rank = "Joker!"
    default:
        rank = String(card.rank.rawValue)
    }
    
    if card.rank == .joker {
        return rank
    } else {
        return "\(card.suit.rawValue) \(rank)"
    }
}

func print(deck: Deck) {
  deck.forEach { (card) in
    print("\(cardRepresentation(card))")
  }
}
