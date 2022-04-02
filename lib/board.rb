# frozen_string_literal: true

require 'pieces/bishop'

b = Bishop.new

# insert_documentation_here
class Board
  def initialize
    # 8x8
  end

  # NOTE: use piece@current_pos
  def can_be_captured(piece); end

  def move(init_pos, fin_pos)
    # does piece exist at init_pos?
    # check direction of movement
    # send message to piece with direction and returns possible moves
    # send message to board with possible_moves and returns filtered moves
    # if filtered moves containes fin_pos check if there is a piece in fin_pos
    # if there is a piece at fin_pos check teams are different
  end

  # NOTE: check if piece exists at position (returns null or no?)
  def piece_exists?(pos); end

  # NOTE: returns direction (symbol) using the difference in fin_pos & init_pos
  # NOTE: try using case statement
  def direction(init_pos, fin_pos); end

  # loops through p_moves, if piece is present at pos
  # deletes everything AFTER (not including) that pos
  def filter_moves(p_moves); end

  def diff_teams?(a_piece, b_piece); end
end
