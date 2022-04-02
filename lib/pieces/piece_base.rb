# frozen_string_literal: true

WKING = "\u2654"
WQUEEN = "\u2655"
WROOK = "\u2656"
WBISHOP = "\u2657"
WKNIGHT = "\u2658"
WPAWN = "\u2659"

BKING = "\u265A"
BQUEEN = "\u265B"
BROOK = "\u265C"
BBISHOP = "\u265D"
BKNIGHT = "\u265E"
BPAWN = "\u265F"

module PieceBase
  attr_accessor :current_position # 1D array of [x,y] coordinates
  attr_reader :movement_direction, # (array of symbols, :up, :down etc)
              :char_representation, # Constant
              :team_white # true/false

  def possible_moves; end
  def to_s; end
end
