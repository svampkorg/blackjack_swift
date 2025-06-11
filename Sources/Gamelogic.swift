enum Standing {
    case Player
    case Dealer
    case PlayerBlackjack
    case DealerBlackjack
    case PlayerBust
    case DealerBust
    case Draw

    var value: Int {
        switch self {
        case .Player:
            return 1
        case .Dealer:
            return 2
        case .PlayerBlackjack:
            return 3
        case .DealerBlackjack:
            return 4
        case .PlayerBust:
            return 5
        case .DealerBust:
            return 6
        case .Draw:
            return 7
        }
    }

    static func getHandValue(_ hand: Hand) -> Int {
        var value = 0

        for card in hand {
            guard let card = card else { continue }

            if card.value - 10 > 0 {
                value += 10
            } else if card.value == 1 {
                if (value + 11) > 21 {
                    value += 1
                } else {
                    value += 11
                }
            } else {
                value += card.value
            }
        }

        return value
    }

    static func getStanding(player: Int, dealer: Int) -> Standing {
        if player > 21 { return .PlayerBust } else if dealer > 21 { return .DealerBust }
        if dealer == 21 {
            return .DealerBlackjack
        } else if player == 21 {
            return .PlayerBlackjack
        } else if player == dealer {
            return .Draw
        } else if player > dealer {
            return .Player
        } else {
            return .Dealer
        }
    }

    static func printStanding(_ standing: Standing) {
        switch standing
        {
        case .Draw:
            print("It's a draw! Nobody wins! ¯\\_(ツ)_/¯")
        case .PlayerBlackjack:
            print("You win on Blackjack! ⊂(◉‿◉)つ")
        case .DealerBlackjack:
            print("Dealer wins on Blackjack! (´סּ︵סּ`)")
        case .Player:
            print("You Win! ᕕ( ᐛ )ᕗ")
        case .Dealer:
            print("Dealer Wins! (ⱺ ʖ̯ⱺ)")
        case .DealerBust:
            print("Dealer is Bust! You Win! (͠≖ ͜ʖ͠≖) hehe")
        case .PlayerBust:
            print("You are Bust! Dealer wins! ୧༼ಠ益ಠ༽୨")
        }
    }
}
