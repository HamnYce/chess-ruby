# frozen_string_literal: true

require_relative 'piece'

# Please_Insert_Documentation
class Rook
  include Piece

  def initialize(team_white)
    @mov_dir = STRAIGHTPATHS
    @char_representation = team_white ? WROOK_ICON : BROOK_ICON
    @team_white = team_white
  end
end
