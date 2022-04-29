# frozen_string_literal: true

require_relative 'piece'

# Please_Insert_Documentation
class Queen
  include Piece

  def initialize(curr_pos, team_white)
    @curr_pos = curr_pos
    @mov_dir = %i[UP DOWN LEFT RIGHT UPLEFT UPRIGHT DOWNLEFT DOWNRIGHT]
    @char_representation = team_white ? WQUEEN_ICON : BQUEEN_ICON
    @team_white = team_white
  end
end
