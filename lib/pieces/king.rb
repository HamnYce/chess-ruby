# frozen_string_literal: true

require_relative 'piece'

# Please_Insert_Documentation
class King
  include Piece

  def initialize(team_white)
    @mov_dir = (STRAIGHTPATHS + DIAGPATHS)
    @char_representation = team_white ? WKING_ICON : BKING_ICON
    @team_white = team_white
  end
end
