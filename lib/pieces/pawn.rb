# Frozen_string_literal: true

require_relative 'piece'

# Please_Insert_Documentation
class Pawn
  include Piece

  def initialize(curr_pos, team_white)
    # NOTE: if statement for mov_dir (black or white team move different direction)
    # because pawn movement has directionality
    @mov_dir = team_white ? %i[UPLEFT UPRIGHT] : %i[DOWNLEFT DOWNRIGHT]
    @char_representation = team_white ? WPAWN_ICON : BPAWN_ICON
    @team_white = team_white
  end
end
