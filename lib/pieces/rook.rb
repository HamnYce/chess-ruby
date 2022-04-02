# frozen_string_literal: true

require 'piece_base'

class Rook
  include PieceBase

  def initialize(team_white)
    @movement_direction = %i[up down left right]
    @char_representation = team_white ? WROOK : BROOK
    @team_white = team_white
  end

  def possible_moves(direction)
    
  end

  def to_s
    @char_representation
  end
end
