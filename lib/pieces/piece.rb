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
  include GroupedMovementProcs

  attr_reader :mov_dir, # (array of symbols, :up, :down etc)
              :char_representation, # Constant
              :team_white # true/false

  def to_s
    @char_representation
  end

  def include_dir?(direction)
    mov_dir.include?(direction)
  end

  def king?
    is_a? King
  end

  def queen?
    is_a? Queen
  end

  def rook?
    is_a? Rook
  end

  def bishop?
    is_a? Bishop
  end

  def knight?
    is_a? Knight
  end

  def pawn?
    is_a? Pawn
  end
end
