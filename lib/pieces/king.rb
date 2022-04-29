# frozen_string_literal: true

require_relative 'piece'

# Please_Insert_Documentation
class King
  include Piece

  def initialize(team_white)
    @mov_dir = %i[UP DOWN LEFT RIGHT UPLEFT UPRIGHT DOWNLEFT DOWNRIGHT]
    @char_representation = team_white ? WKING_ICON : BKING_ICON
    @team_white = team_white
  end
end
