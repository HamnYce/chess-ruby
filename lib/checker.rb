# frozen_string_literal: true

require_relative 'movement'

# contains methods to look for check on a given piece
module Checker
  include MovementAlgorithms
  include GroupedMovementProcs

  def checkmate?(king_pos, att_team)
    under_attack?(king_pos, att_team) &&
      !king_has_valid_move?(king_pos, att_team) &&
      !all_attacks_blockable?(king_pos, !att_team)
  end

  def king_has_valid_move?(king_pos, att_team)
    all_moves = KINGPATHS.map { |dir| possible_move(king_pos, dir).last }

    all_moves.compact.each do |pos|
      piece = get_piece(pos)
      if piece
        return true if piece.team_white == att_team && !under_attack?(pos, att_team)
      else
        return true unless under_attack?(pos, att_team)
      end
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
      linear_check(defender_pos, DIAGPATHS, att_team,) ||
      knight_check(defender_pos, att_team) ||
      pawn_check(defender_pos, att_team, true) ||
      king_check(defender_pos, att_team)
  end

  def under_block?(defender_pos, att_team)
    linear_check(defender_pos, STRAIGHTPATHS, att_team) ||
      linear_check(defender_pos, DIAGPATHS, att_team) ||
      knight_check(defender_pos, att_team) ||
      pawn_check(defender_pos, att_team, false) ||
      king_check(defender_pos, att_team)
  end

  def linear_check(defender_pos, dir, att_team)
    linear_stub(defender_pos, dir, att_team) { |_result, _pos| return true }
  end

  def linear_attackers(defender_pos, dir, att_team)
    linear_stub(defender_pos, dir, att_team) { |result, pos| result << pos }
  end

  def knight_check(defender_pos, att_team)
    knight_stub(defender_pos, att_team) { |_result, _pos| return true }
  end

  def knight_attackers(defender_pos, att_team)
    knight_stub(defender_pos, att_team) { |result, pos| result << pos }
  end

  def pawn_check(defender_pos, att_team, att)
    pawn_stub(defender_pos, att_team, att) { |_result, _pos| return true }
  end

  def pawn_attackers(defender_pos, att_team, att)
    pawn_stub(defender_pos, att_team, att) { |result, pos| result << pos }
  end

  def king_check(defender_pos, att_team)
    king_stub(defender_pos, att_team) { |_result, _pos| return true }
  end

  def king_attackers(defender_pos, att_team)
    king_stub(defender_pos, att_team) { |result, pos| result << pos }
  end

  def linear_stub(defender_pos, directions, att_team, &blk)
    # get the first piece in a given direction
    result = []

    all_moves = directions.map { |dir| possible_moves(defender_pos, dir).last }
    all_moves = all_moves.compact.select { |pos| piece_exists?(pos) }

    all_moves.each do |pos|
      piece = get_piece(pos)

      next unless
        (piece.queen? || (piece.rook? && directions == STRAIGHTPATHS) ||
          (piece.bishop? && directions == DIAGPATHS)) &&
          (piece.team_white == att_team)

      blk.call(result, pos)
    end
    result.empty? ? false : result
  end

  def knight_stub(defender_pos, att_team, &blk)
    result = []

    all_moves = KNIGHTPATHS.map { |dir| possible_move(defender_pos, dir).last }
    all_moves = all_moves.compact.select { |pos| piece_exists?(pos) }

    all_moves.each do |pos|
      piece = get_piece(pos)

      blk.call(result, pos) if piece.team_white == att_team && piece.knight?
    end

    result.empty? ? false : result
  end

  def pawn_stub(defender_pos, att_team, att)
    result = []

    directions = if att
                   @curr_player_white ? WHITEPAWNATTPATHS : BLACKPAWNATTPATHS
                 else
                   @curr_player_white ? WHITEPAWNBLOCKPATHS : BLACKPAWNBLOCKPATHS
                 end

    all_moves = directions.map { |dir| possible_move(defender_pos, dir).last }
    all_moves = all_moves.compact.select { |pos| piece_exists?(pos) }

    all_moves.each do |pos|
      piece = get_piece(pos)

      yield(result, pos) if piece.team_white == att_team && piece.pawn?
    end

    result.empty? ? false : result
  end

  def king_stub(defender_pos, att_team)
    result = []

    all_moves = KINGPATHS.map { |dir| possible_move(defender_pos, dir).last }
    all_moves = all_moves.compact.select { |pos| piece_exists?(pos) }

    all_moves.each do |pos|
      piece = get_piece(pos)

      yield(result, pos) if piece.team_white == att_team && piece.king?
    end

    result.empty? ? false : result
  end

end
