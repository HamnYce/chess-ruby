# frozen_string_literal: true

require 'piece_base'

class Rook
  include PieceBase

  def initialize(team_white)
    @movement_direction = %i[up down right left up_left up_right down_left down_right]
    @char_representation = team_white ? WROOK : BROOK
    @team_white = team_white
  end
end
