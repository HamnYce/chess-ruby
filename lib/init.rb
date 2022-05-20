# Frozen_string_literal: true

require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'
require_relative 'pieces/queen'
require_relative 'pieces/rook'

# might convert board 8x8 array to hash (same logic)
# might store some information in a hash (king positions maybe?)
STARTINGBOARD = Array.new(8) { Array.new(8, nil) }
STARTWHITEKING = []
STARTBLACKKING = []
module StartState
  def self.normal
    # Black's side
    STARTINGBOARD[0][0] = Rook.new(false)
    STARTINGBOARD[0][1] = Knight.new(false)
    STARTINGBOARD[0][2] = Bishop.new(false)
    STARTINGBOARD[0][3] = Queen.new(false)
    STARTINGBOARD[0][4] = King.new(false)
    STARTBLACKKING << 0 << 4
    STARTINGBOARD[0][5] = Bishop.new(false)
    STARTINGBOARD[0][6] = Knight.new(false)
    STARTINGBOARD[0][7] = Rook.new(false)
    # initialise black pawns
    (0..7).each { |i| STARTINGBOARD[1][i] = Pawn.new(false) }

    # White's side
    STARTINGBOARD[7][0] = Rook.new(true)
    STARTINGBOARD[7][1] = Knight.new(true)
    STARTINGBOARD[7][2] = Bishop.new(true)
    STARTINGBOARD[7][3] = Queen.new(true)
    STARTINGBOARD[7][4] = King.new(true)
    STARTWHITEKING << 7 << 4
    STARTINGBOARD[7][5] = Bishop.new(true)
    STARTINGBOARD[7][6] = Knight.new(true)
    STARTINGBOARD[7][7] = Rook.new(true)
    # initialise white pawns
    (0..7).each { |i| STARTINGBOARD[6][i] = Pawn.new(true) }
  end

  def self.checkmate_in_one
    STARTINGBOARD[0][0] = King.new(false)
    STARTINGBOARD[2][0] = King.new(true)
    STARTINGBOARD[2][3] = Queen.new(true)
    STARTWHITEKING << 2 << 0
    STARTBLACKKING << 0 << 0
  end
end

StartState.normal
