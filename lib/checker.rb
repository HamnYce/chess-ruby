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

  def checkmate?; end

  def king_can_move?(king_pos)
    king = get_piece(king_pos)
    all_moves = KINGPATHS.map { |dir| possible_move(other_king_pos, dir).last }
    all_moves.compact.each do |pos|

      return true if !can_be_attacked?(pos, !king.team_white) &&
                     !same_team?(king, get_piece(pos))
    end
    false
  end

  def all_attacks_blockable?(defender_pos, def_team)
    all_attackers = find_attackers(defender_pos, !def_team)

    all_attackers.each do |attackers|
      attackers.each do |att_pos|
        return false unless attack_blockable?(defender_pos, att_pos, def_team)
      end
    end

    true
  end

  def attack_blockable?(defender_pos, attacker_pos, def_team)
    dir = direction(defender_pos, attacker_pos)
    all_moves = possible_moves(defender_pos, dir)

    # to account for king blocking own move
    temp_piece = @table[defender_pos[0]][defender_pos[1]]
    @table[defender_pos[0]][defender_pos[1]] = nil

    all_moves.each do |pos|
      if under_block?(pos, def_team)
        @table[defender_pos[0]][defender_pos[1]] = temp_piece
        return true
      end

    end

    @table[defender_pos[0]][defender_pos[1]] = temp_piece
    false
  end

  def find_attackers(defender_pos, att_team)
    total = []
    total.push linear_attackers(defender_pos, STRAIGHTPATHS, att_team)
    total.push linear_attackers(defender_pos, DIAGPATHS, att_team)
    total.push pawn_attackers(defender_pos, att_team, true)
    total.select! { |x| x }

    total
  end

  def under_attack?(defender_pos, att_team)
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
