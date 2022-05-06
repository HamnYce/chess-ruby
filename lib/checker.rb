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
  def can_be_attacked?(defender_pos, att_team)
    linear_check(defender_pos, STRAIGHTPATHS, att_team) ||
      linear_check(defender_pos, DIAGPATHS, att_team) ||
      knight_check(defender_pos, att_team) ||
      pawn_check(defender_pos, att_team) ||
      king_check(defender_pos, att_team)
  end

  def linear_check(defender_pos, directions, att_team)
    # get the first piece in a given direction
    all_moves = directions.map { |dir| possible_moves(defender_pos, dir).last }
    all_moves = all_moves.compact.select { |pos| piece_exists?(pos) }
    all_moves.map! { |pos| get_piece(pos) }

    all_moves.each do |piece|
      # if piece is opposite team and appropriate piece then defender_piece is
      # under attack
      if (piece.queen? || (piece.rook? && directions == STRAIGHTPATHS) ||
         (piece.bishop? && directions == DIAGPATHS)) &&
         (piece.team_white == att_team)
        return true
      end
    end

    false
  end

  def knight_check(defender_pos, att_team)
    all_moves = KNIGHTPATHS.map { |dir| possible_move(defender_pos, dir).last }
    all_moves = all_moves.compact.select { |pos| piece_exists?(pos) }
    all_moves.map! { |pos| get_piece(pos) }

    all_moves.each do |piece|

      return true if piece.team_white == att_team && piece.knight?
    end

    false
  end

  def pawn_check(defender_pos, att_team)
    directions = @curr_player_white ? WHITEPAWNATTPATHS : BLACKPAWNATTPATHS

    all_moves = directions.map { |dir| possible_move(defender_pos, dir).last }
    all_moves = all_moves.compact.select { |pos| piece_exists?(pos) }
    all_moves.map! { |pos| get_piece(pos) }

    all_moves.each do |piece|
      return true if piece.team_white == att_team && piece.pawn?
    end

    false
  end

  def king_check(defender_pos, att_team)
    directions = STRAIGHTPATHS + DIAGPATHS

    all_moves = directions.map { |dir| possible_move(defender_pos, dir).last }
    all_moves = all_moves.compact.select { |pos| piece_exists?(pos) }
    all_moves.map! { |pos| get_piece(pos) }

    all_moves.each do |piece|
      return true if piece.team_white == att_team && piece.king?
    end
  end
end
