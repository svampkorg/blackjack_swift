@main
struct Blackjack {
    let state = GameState.shared

    static func main() {
        let game = Blackjack()

        game.run()
    }

    public func run() {
        gameLoop()

        if state.playerWallet > 25 {
            print("You've earned $\(state.playerWallet - 25). Congratulations! Bye!")

        } else {
            print("You've lost $\(25 - state.playerWallet). Very unfortunate. Bye!")
        }
    }

    func gameLoop() {

        var isPlayAgain = true

        while isPlayAgain {
            state.shuffle()
            state.initialDeal()

            state.drawLogo()

            state.bet()

            var isHit = true

            state.drawBoard(concealDealer: true)

            while state.standing != .PlayerBlackjack && state.standing != .PlayerBust && isHit {
                print("Hit? (enter 'y' to draw another card): ", terminator: "")
                guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), input == "y" else {
                    isHit = false
                    continue
                }
                state.hitPlayer()
                state.drawBoard()
            }

            // NOTE: No need for dealer to play if Player is bust
            if state.standing != .PlayerBust {
                while state.standing != .DealerBlackjack && state.standing != .DealerBust
                    && state.dealerHandValue < 17
                {
                    state.hitDealer()
                }
            }

            state.maybePayout()
            state.drawBoard(concealDealer: false)

            Standing.printStanding(state.standing)

            if state.playerWallet <= 0 {
                isPlayAgain = false
            } else {
                print("Do you want to keep going? (enter 'y' to continue): ", terminator: "")
                guard let choice = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines), choice == "y" else {
                    isPlayAgain = false
                    continue
                }
                isPlayAgain = true
            }
        }

        if state.playerWallet <= 0 {
            print("Game's Over! You have nothing left to bet with.")
        }

    }
}
