# frozen_string_literal: true

require_relative 'piece'

# Please_Insert_Documentation
class Knight
  include Piece

  def initialize(team_white)
    @mov_dir = KNIGHTPATHS
    @char_representation = team_white ? WKNIGHT_ICON : BKNIGHT_ICON
    @team_white = team_white
  end

  def can_move?(direction)
    direction = "KNIGHT#{direction}".to_sym
    mov_dir.include?(direction)
  end
end
