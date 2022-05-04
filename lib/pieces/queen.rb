# frozen_string_literal: true

require_relative 'piece'

# Please_Insert_Documentation
class Queen
  include Piece

  def initialize(team_white)
    @mov_dir = (STRAIGHTPATHS + DIAGPATHS)
    @char_representation = team_white ? WQUEEN_ICON : BQUEEN_ICON
    @team_white = team_white
  end
end
