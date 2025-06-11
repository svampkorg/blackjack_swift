import Foundation

class GameState: @unchecked Sendable {

    static let shared = GameState()

    var currentlyDealt: Deck
    var playerHand: Hand
    var dealerHand: Hand
    var playerWallet: Int
    var playerBet: Int

    private init() {
        playerWallet = 25
        playerBet = 0
        currentlyDealt = [:]
        playerHand = []
        dealerHand = []
    }

    func shuffle() {
        currentlyDealt = [:]
        playerHand = []
        dealerHand = []
    }

    func initialDeal() {
        // NOTE: Player
        var availableCards = availableDeck(currentlyDealt: currentlyDealt)
        let dealerPlayerData = dealCards(
            availableCards: availableCards, dealt: currentlyDealt, nrToDeal: 2)
        currentlyDealt = dealerPlayerData.currentlyDealt
        playerHand.append(contentsOf: dealerPlayerData.dealtCards)

        // NOTE: Dealer
        availableCards = availableDeck(currentlyDealt: currentlyDealt)
        let dealerDealerData = dealCards(
            availableCards: availableCards, dealt: currentlyDealt, nrToDeal: 2)
        currentlyDealt = dealerDealerData.currentlyDealt
        dealerHand.append(contentsOf: dealerDealerData.dealtCards)
    }

    var dealerHandValue: Int {
        return Standing.getHandValue(dealerHand)
    }

    var playerHandValue: Int {
        return Standing.getHandValue(playerHand)
    }

    var standing: Standing {
        return Standing.getStanding(player: playerHandValue, dealer: dealerHandValue)
    }

    func hitPlayer() {
        print("currentlyDealt: \(currentlyDealt)")
        let availableCards = availableDeck(currentlyDealt: currentlyDealt)

        let dealData = dealCards(
            availableCards: availableCards, dealt: currentlyDealt, nrToDeal: 1)

        currentlyDealt = dealData.currentlyDealt
        playerHand.append(contentsOf: dealData.dealtCards)
    }

    func hitDealer() {
        let availableCards = availableDeck(currentlyDealt: currentlyDealt)

        let dealData = dealCards(
            availableCards: availableCards, dealt: currentlyDealt, nrToDeal: 1)

        currentlyDealt = dealData.currentlyDealt
        dealerHand.append(contentsOf: dealData.dealtCards)
    }

    func bet() {
        var keepAsking = true

        while keepAsking {
            print("First, place a bet $", terminator: "")
            guard let amount = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                continue
            }
            guard amount != "?" else {
                drawRules()
                continue
            }

            guard let amountValue = Int(amount) else {
                print("You have to enter a valid value")
                continue
            }

            guard amountValue <= playerWallet else {
                print("You cannot bet more than you have")
                continue
            }

            keepAsking = false
            playerBet = amountValue
            playerWallet -= amountValue

        }
        drawLogo()
    }

    var playerWon: Bool {
        switch standing {
        case .Player:
            return true
        case .DealerBust:
            return true
        case .PlayerBlackjack:
            return true
        default:
            return false
        }
    }

    func maybePayout() {
        var multiple: Double = 0

        if standing == .Draw {
            multiple = 0
        } else if standing == .PlayerBlackjack {
            multiple = 1.5
        } else if playerWon {
            multiple = 1
        } else {
            return
        }

        let payout = Double(playerBet) * multiple
        playerWallet += playerBet + Int(round(payout))
    }

    func drawRules() {

        drawLogo()

        print("\nThe rules are as follow:\n")
        print(
            "Get as close to 21 as possible by either stand, or hit (Hit means draw a card)."
        )
        print("Ace counts as 11, unless your total pass 21, in which case it counts as 1.")
        print("2 through 9 counts as is.")
        print("10, Jackal, Queen and King all count as 10.\n")
        print("A hand over 21 is considered a bust, a loss.\n")
        print(
            "Total of 21 equals Jackpot, a win. Unless dealer also has Jackpot, in which case dealer wins."
        )
        print("Dealer must draw at a hand < 16, and stand at 17 or above.\n")
        print("Jackpot payoff is 3/2 and a regular win is 1/1.\n")
        print("Press any key to continue.")
    }

    func drawLogo() {
        clearConsole()
        print(Art.logo)
        print("Player wallet: \(playerWallet)")
    }

    func clearConsole() {
        // NOTE: Clear screen escape codes
        print("\u{001B}[2J\u{001B}[H", terminator: "")
        fflush(stdout)
    }

    func randomCardFrom(availableCards: Deck) -> Card? {

        guard let color = availableCards.keys.randomElement() else { return nil }
        guard let value = availableCards[color]?.randomElement() else { return nil }

        return Card(color: color, value: value)
    }

    func availableDeck(currentlyDealt: Deck) -> Deck {
        var fullDeck = deck

        // NOTE: For every possible suit in currently dealth Deck
        for color in currentlyDealt.keys {

            // NOTE: make sure the current suit exists (it really should :D)
            // and assign to fullDeckSuit, to loop through the suit
            guard let currentSuitValues: [Int] = fullDeck[color] else { continue }

            // NOTE: Check all currentlyDealt cards of currentSuit
            for cardValue in currentSuitValues {

                // NOTE: If card exists in currentlyDealt of suit
                guard let cardExists = currentlyDealt[color]?.contains(cardValue), cardExists else {
                    continue
                }
                fullDeck[color, default: []].append(cardValue)
            }
        }

        return fullDeck
    }

    func addCardToDeck(currentDeck: Deck, card: Card) -> Deck {
        var newCurrentDeck = currentDeck
        newCurrentDeck[card.color, default: []].append(card.value)
        return newCurrentDeck
    }

    func dealCards(availableCards: Deck, dealt: Deck, nrToDeal: Int) -> (
        dealtCards: [Card?], currentlyDealt: Deck
    ) {
        var newCards: [Card?] = []
        var currentlyDealt = dealt

        for _ in 0..<nrToDeal {
            let newCard = randomCardFrom(availableCards: availableCards)
            guard let newCard = newCard else { continue }
            currentlyDealt = addCardToDeck(currentDeck: currentlyDealt, card: newCard)
            newCards.append(newCard)
        }

        return (newCards, currentlyDealt)
    }

    func drawBoard(concealDealer: Bool = true) {
        if concealDealer {
            drawLogo()
            print(
                "Your hand:\n\(ArtHandling.cardsToArt(playerHand))Value: \(playerHandValue)\n"
            )
            print("Dealer's hand:\n\(ArtHandling.cardsToArt([dealerHand[0], nil]) )")
        } else {
            drawLogo()
            print(
                "Your hand:\n\(ArtHandling.cardsToArt(playerHand))Value: \(playerHandValue)\n"
            )
            print(
                "Dealer's hand:\n\(ArtHandling.cardsToArt(dealerHand))Value: \(dealerHandValue)\n"
            )
        }
    }

}
