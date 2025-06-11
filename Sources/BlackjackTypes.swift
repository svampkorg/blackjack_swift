let deck: Deck = [
    "󰣎": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
    "󰣑": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
    "󰣐": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
    "󰣏": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
]
typealias Hand = [Card?]
typealias Deck = [String: [Int]]

struct Card {
    let color: String
    let value: Int

    init(color: String, value: Int) {
        self.color = color
        self.value = value
    }
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: Card) {
        appendInterpolation("\(value.color):\(value.value)")
    }
}
