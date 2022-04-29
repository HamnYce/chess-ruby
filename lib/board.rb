# frozen_string_literal: true

require_relative 'init'
require_relative 'pieces/piece'
require_relative 'movement'

# insert_documentation_here
class Board
  include Piece
  include MovementAlgs

  def initialize
    @table = STARTING_BOARD
    @wking_pos = [0, 4]
    @bking_pos = [7, 4]
    @curr_player_white = true
  end

  def move(init_pos, fin_pos)
    return 'no piece at pos' unless piece_exists?(init_pos)

    piece = @table[init_pos[0]][init_pos[1]]

    dir = direction(init_pos, fin_pos)

    return 'piece can\'t move like that' unless piece.include_mov?(dir)

    p_moves = piece_moves(init_pos, dir)

    f_moves = delete_blocked_moves(p_moves) unless piece.is_a? Knight

    return 'piece is blocked' unless f_moves.include?(fin_pos)

    return 'cannot capture own piece' if same_team?(piece, get_piece(fin_pos))

    simulate(init_pos, fin_pos)

    kings = @curr_player_white ? [@wking_pos, @bking_pos] : [@bking_pos, @wking_pos]

    if check?(kings[0])
      revert_simulation(@attacker, @defender)
      return 'illegal move, own king in check'
    end

    if checkmate?(kings[1])
      winner = @curr_player_white ? 'white' : 'black'
      return "#{winner} is the winner"
    end
    # if own king is in check revert simulation

    @curr_player_white = !@curr_player_white
  end

  def piece_moves(init_pos, dir)
    case piece
    when Knight
      knight_possible_moves(init_pos, dir)
    when Pawn || King
      possible_move(init_pos, dir)
    else
      possible_moves(init_pos, dir)
    end
  end

  # creates a new board with the movement passed having already occured
  # TODO: search for check state in simulated board
  # if no checks against player king in simulated board
  # check for check against opponent king
  # NOTE: instead of simulating the whole board -> simulate piece movements
  def simulate(init_pos, fin_pos)
    @attacker = [init_pos, get_piece(init_pos)]
    @defender = [fin_pos, get_piece(fin_pos)]

    if @attacker.is_a? King
      @curr_player_white ? @wking_pos = fin_pos : @bking_pos = fin_pos
    end

    move_and_overwrite(init_pos, fin_pos)
  end

  def revert_simulation(attacker, defender)
    row, col = attacker[0]
    @table[row][col] = attacker[1]

    if attacker.is_a? King
      @curr_player_white ? @wking_pos = attacker[0] : @bking_pos = attacker[0]
    end

    row, col = defender[1]
    @table[row][col] = defender
  end

  # loops through p_moves, if piece is present at pos (piece_exists)
  # deletes everything AFTER (not including) that pos
  # returns f_moves
  def delete_blocked_moves(p_moves)
    blockage_index = first_blockage(p_moves)
    (p_moves.length - blockage_index - 1).times { p_moves.pop }
    p_moves
  end

  # DOC: returns index of first non-nil element in array using @table
  #       or moves length if none is found
  def first_blockage(moves)
    (0..(moves.length - 1)).each do |i|
      pos = moves[i]
      return i unless @table[pos[0]][pos[1]].nil?
    end
    moves.length
  end

  # copies piece reference to fin_pos and removes reference from init_pos
  def move_and_overwrite(board, init_pos, fin_pos)
    attacker = @table[init_pos[0]][init_pos[1]]

    @table[fin_pos[0]][fin_pos[1]] = attacker
    @table[init_pos[0]][init_pos[1]] = nil
  end

  # use @current_player_white to figure out which king
  def checkmate?
    # if piece can't move out of the way
    # cant block
    # piece attacker isn't capturable
  end

  # check if king can move anywhere without being in check in resulting move
  # NOTE: check if empty spaces around the king can be attacked
  # NOTE: use position instead of simulating
  # TODO: Implement can_be_attacked? first then just check the spaces around the king
  def king_can_move?(king_pos); end

  # can the distance between attacker and king be blocked by another piece?
  # assuming it's not a knight
  # check if same team piece can move inbetween the 2 positions
  def attack_blockable?(attacker_pos, king_pos); end

  # NOTE: use to check around king in all directions for check? & checkmate?
  # diagonal paths for bishop || queen || pawn (opposite team)
  # straight paths for rook || queen (opposite team)
  # check all movemment directions
  # FIXME: doesn't account for knight or Pawn
  # DOC: check if target pos can be attacked by opposite team
  def can_be_attacked?(def_pos, att_pos, team)
    def_dir = direction(def_pos, att_pos)
    p_moves = possible_moves(direction)
    piece_pos = p_moves.each do |pos|
        break pos unless @table[pos[0]][pos[1]].nil?
      end
    piece = @table[piece_pos[0]][piece_pos[1]]
    def_dir = %i[UP DOWN RIGHT LEFT].include?(def_dir) ? :STRAIGHT : :DIAG
    if def_dir == STRAIGHT && (piece.is_a?(Rook) || piece.is_a?(Queen))
      return true
    elsif piece.is_a?(Bishop) || piece.is_a?(Knight) || piece.is_a?(Queen)
      return true
    end
    false
  end

  # DOC: returns direction (symbol)
  def direction(init_pos, fin_pos)
    direction = ''
    vertical = fin_pos[0] - init_pos[0]
    horizontal = fin_pos[1] - init_pos[1]

    if vertical.positive? then direction += 'DOWN'
    elsif vertical.negative? then direction += 'UP'
    end

    if horizontal.positive? then direction += 'RIGHT'
    elsif horizontal.negative? then direction += 'LEFT'
    end

    direction.to_sym
  end

  # DOC: checks if piece exists at pos
  def piece_exists?(pos)
    !@table[pos[0]][pos[1]].nil?
  end

  # returns true if a_piece@team_white != b_piece@team_white
  def same_team?(a_piece, b_piece)
    return false if b_piece.nil?

    a_piece.team_white == b_piece.team_white
  end

  def get_piece(pos)
    @table[pos[0]][pos[1]]
  end
end
