# frozen_string_literal: true

require_relative 'piece'

# Please_Insert_Documentation
class Bishop
  include Piece

  def initialize(team_white)
    @mov_dir = %i[UPLEFT UPRIGHT DOWNLEFT DOWNRIGHT]
    @char_representation = team_white ? WBISHOP_ICON : BBISHOP_ICON
    @team_white = team_white
  end
end
