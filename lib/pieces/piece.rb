# frozen_string_literal: true

require_relative '../movement'

WKING_ICON = "\u265A"
WQUEEN_ICON = "\u265B"
WROOK_ICON = "\u265C"
WBISHOP_ICON = "\u265D"
WKNIGHT_ICON = "\u265E"
WPAWN_ICON = "\u265F"

BKING_ICON = "\u2654"
BQUEEN_ICON = "\u2655"
BROOK_ICON = "\u2656"
BBISHOP_ICON = "\u2657"
BKNIGHT_ICON = "\u2658"
BPAWN_ICON = "\u2659"

# documentation
module Piece
  attr_accessor :curr_pos # 1D array of [x,y] coordinates
  attr_reader :mov_dir, # (array of symbols, :up, :down etc)
              :char_representation, # Constant
              :team_white # true/false

  def to_s
    @char_representation
  end

  def include_dir?(direction)
    mov_dir.include?(direction)
  end
end
