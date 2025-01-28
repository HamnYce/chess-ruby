# Chess Game in Ruby

Welcome to the Chess Game project! This is a command-line chess game implemented in Ruby.

## Features

- Almost Full implementation of chess rules (en-pessant left out)
- Command-line interface
- Supports two-player mode
- Move validation and check/checkmate detection

## Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/HamnYce/chess-ruby.git
   ```

2. Navigate to the project directory:

   ```sh
   cd chess-ruby
   ```

## Usage

To start the game, run the following command:

```sh
ruby lib/main.rb
```

## Code Structure

The project is organized into several modules and classes, each handling different aspects of the game:

- `lib/checker.rb`: Contains methods to check for check and checkmate conditions.
- `lib/simulator.rb`: Provides methods for reversible simulation of piece movements.
- `lib/gui.rb`: Handles the command-line interface and user interactions.
- `lib/init.rb`: Initializes the starting state of the chessboard.
- `lib/main.rb`: Entry point for the game.
- `lib/serializer.rb`: Handles saving and loading game states.
- `lib/pieces/`: Directory containing classes for each chess piece (King, Queen, Rook, Bishop, Knight, Pawn).
- `lib/board.rb`: Main class that integrates all modules and manages the game state.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

- Ruby documentation and community for their support and resources.
- Chess enthusiasts for inspiring this project.
- The Odin Project for providing their course and resources.
  Enjoy playing chess!
