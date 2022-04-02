# frozen_string_literal: true

Dir['lib/pieces/*.rb'].each { |file| require_relative file[4..] }

# insert_documentation_here
class Board
  def initialize
    # 8x8
  end

  # NOTE: use pos and search. (assume piece is present)
  # diagonal paths for bishop || queen || pawn (opposite team)
  # straight paths for rook || queen (opposite team)
  # knight paths for knight (opposite team)
  def can_be_captured?(pos); end

  def move(init_pos, fin_pos)
    # does piece exist at init_pos?
    # check direction of movement
    # send message to piece with direction and returns possible moves
    # send message to board with possible_moves and returns filtered moves
    # if filtered moves containes fin_pos check if there is a piece in fin_pos
    # if there is a piece at fin_pos check teams are different
  end

  # NOTE: check if piece exists at position
  def piece_exists?(pos); end

  # NOTE: returns direction (symbol) using the difference in fin_pos & init_pos
  # NOTE: try to optimise it
  def direction(init_pos, fin_pos); end

  # loops through p_moves, if piece is present at pos
  # deletes everything AFTER (not including) that pos
  # returns f_moves
  def filter_moves(p_moves); end

  # returns true if a_piece@team_white != b_piece@team_white
  def diff_teams?(a_piece, b_piece); end

  # copies piece reference to fin_pos and removes reference from init_pos
  def capture(init_pos, fin_pos); end
end
