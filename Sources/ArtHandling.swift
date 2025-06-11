struct ArtHandling {
    static func valueToSign(_ value: Int) -> String {
        switch value {
        case 13:
            return "K"
        case 12:
            return "Q"
        case 11:
            return "J"
        case 1:
            return "A"
        default:
            return "\(value)"
        }
    }

    static func cardArt(_ card: Card) -> [String] {
        var cardParts: [String] = []

        let padding = card.value == 10 ? " " : "  "
        cardParts.append("╭───╮")
        cardParts.append(
            "│\(valueToSign(card.value))\(padding)│"
        )
        cardParts.append("│ \(card.color) │")
        cardParts.append(
            "│\(padding)\(valueToSign(card.value))│"
        )
        cardParts.append("╰───╯")

        return cardParts
    }

    static func facedownCardArt() -> [String] {
        var cardParts: [String] = []

        cardParts.append("╭───╮")
        cardParts.append("│?  │")
        cardParts.append("│ ? │")
        cardParts.append("│  ?│")
        cardParts.append("╰───╯")

        return cardParts
    }

    static func cardsToArt(_ cards: [Card?]) -> String {

        guard !cards.isEmpty else { return "" }

        var cardsArts: [[String]] = []

        for card in cards {
            if let actualCard = card {
                cardsArts.append(cardArt(actualCard))
            } else {
                cardsArts.append(facedownCardArt())
            }
        }

        let fullArtLength = cardsArts[0].count

        let nrOfCards = cardsArts.count
        var artString = ""

        for artIndex in 0..<fullArtLength {
            for cardIndex in 0..<nrOfCards {
                artString.append(contentsOf: cardsArts[cardIndex][artIndex])
            }
            artString.append("\n")
        }
        return artString
    }
}
