# frozen_string_literal: true

require_relative 'movement'

# contains methods to look for check on a given piece
module Checker
  # NOTE: can_be_attacked? on the spaces around the king (can king move away?)
  #   on other_king_pos.
  #   can_be_attacked? on spaces between king and attacker (can attack be
  #   blocked)
  #   can_be_attacked? on attacking piece (can attacker be captured)
  include MovementAlgorithms
  include GroupedMovementProcs

  def checkmate?
    !king_can_move? &&
      !can_be_attacked?(attacker_pos) &&
      can_be_attacked?(king_pos)
  end

  def king_can_move?
    king = get_piece(other_king_pos)
    all_moves = KINGPATHS.map { |dir| possible_move(other_king_pos, dir).last }
    all_moves.compact.each do |pos|

      # if position around king is not under attack AND there exists an
      # opposite colored piece OR no piece at all then king can move

      return true if !can_be_attacked?(pos) && !same_team?(king, get_piece(pos))
    end
    false
  end

  # assuming it's not a knight
  # check if same team piece can move inbetween the 2 positions (use class to
  # pick the direction for possible moves)
  def attack_blockable?(attacker_pos, king_pos, attacker_class); end

  # DOC: check if target pos can be attacked by opposite team
  def can_be_attacked?(defender_pos)
    linear_check(defender_pos, STRAIGHTPATHS) ||
      linear_check(defender_pos, DIAGPATHS) ||
      knight_check(defender_pos) ||
      pawn_check(defender_pos)
  end

  def linear_check(defender_pos, directions)
    # for each direction we get the last possible movement using
    # possible_moves & last
    # this gives us an array with positions that should either be an empty
    # space next to a wall or occupied by a piece
    all_moves = directions.map { |dir| possible_moves(defender_pos, dir).last }
    all_moves = all_moves.compact.select { |pos| piece_exists?(pos) }

    puts "all: #{all_moves}"
    all_moves.each do |attacker_pos|
      # skip if no piece at pos
      next unless piece_exists?(attacker_pos)

      piece = get_piece(attacker_pos)

      # if piece is opposite team and appropriate piece then defender_piece is
      # under attack
      if (piece.queen? || (piece.rook? && directions == STRAIGHTPATHS) ||
        (piece.bishop? && directions == DIAGPATHS)) && other_team?(piece)
        return true
      end
    end

    false
  end

  def knight_check(defender_pos)
    all_moves = KNIGHTPATHS.map { |dir| possible_move(defender_pos, dir).last }

    all_moves.compact.each do |attacker_pos|
      next unless piece_exists?(attacker_pos)

      piece = get_piece(attacker_pos)

      return true if other_team?(piece) && piece.knight?
    end

    false
  end

  def pawn_check(defender_pos)
    directions = @curr_player_white ? WHITEPAWNATTPATHS : BLACKPAWNATTPATHS

    all_moves = directions.map { |dir| possible_move(defender_pos, dir).last }

    all_moves.compact.each do |attacker_pos|
      next unless piece_exists?(attacker_pos)

      piece = get_piece(attacker_pos)

      return true if other_team?(piece) && piece.pawn?
    end

    false
  end
end
