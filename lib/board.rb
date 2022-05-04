# frozen_string_literal: true

require_relative 'init'
require_relative 'pieces/piece'
require_relative 'movement'

# insert_documentation_here
class Board
  include Piece
  include MovementAlgs
  include GroupedMovementProcs

  # TODO: convert implementation of @table to hash
  def initialize
    @table = STARTING_BOARD
    @wking_pos = [0, 4]
    @bking_pos = [7, 4]
    @curr_player_white = true
    print_table
  end

  def move(init_pos, fin_pos)
    return 'no piece at pos' unless piece_exists?(init_pos)

    piece = @table[init_pos[0]][init_pos[1]]

    dir = direction(init_pos, fin_pos)

    return 'piece can\'t move like that' unless piece.include_dir?(dir)

    # TODO: seperate out the pawn movement from capturing.
    #   you can add all pawn movement and just revert when an illegal move is
    #   done. (moving diagonally or capturing straight)
    #   since movement and capturing are considered the same action all you have
    #   to do is add if statement
    p_moves = piece_moves(piece, init_pos, dir)

    return 'piece is blocked' unless p_moves.include?(fin_pos)
    return 'cannot capture own piece' if same_team?(piece, get_piece(fin_pos))
    return 'pawn cannot move like that' if illegal_pawn_move?(fin_pos, dir)

    simulate(init_pos, fin_pos)

    return revert_simulation if can_be_attacked?(current_king_pos)
    return 'Checkmate!' if checkmate?(other_king_pos)

    # Updating king position if king is the one that moved
    update_curr_king_pos(fin_pos) if @attacker[1].king?

    system('clear')
    print_table

    flip_current_player
  end

  def piece_moves(piece, init_pos, dir)
    case piece
    when Knight
      knight_possible_moves(init_pos, dir)
    when Pawn || King
      possible_move(init_pos, dir)
    else
      possible_moves(init_pos, dir)
    end
  end

  def simulate(init_pos, fin_pos)
    @attacker = [init_pos, get_piece(init_pos)]
    @defender = [fin_pos, get_piece(fin_pos)]

    move_and_overwrite(init_pos, fin_pos)
  end

  def revert_simulation
    row, col = @attacker[0]
    @table[row][col] = @attacker[1]

    row, col = @defender[0]
    @table[row][col] = @defender[1]

    'illegal move, own king is in check'
  end

  # copies piece reference to fin_pos and removes reference from init_pos
  def move_and_overwrite(init_pos, fin_pos)
    attacker = @table[init_pos[0]][init_pos[1]]

    @table[fin_pos[0]][fin_pos[1]] = attacker
    @table[init_pos[0]][init_pos[1]] = nil
  end

  # use @current_player_white to figure out which king
  def checkmate?(king_pos)
    # if piece can't move out of the way
    # cant block
    # piece attacker isn't capturable
  end

  # check all surrounding panels from the other_king(use king movement)
  # TODO: Implement can_be_attacked? first then just check the spaces around the king
  #   use this for checkmate on other_king_pos
  #   check space around king to see if he has a possible move, for checkmate
  def king_can_move?(king_pos)
    all_moves = KINGPATHS.map { |dir| possible_move(king_pos, dir) }

    all_moves.compact.each { |pos| return true unless piece_exists?(pos) }
  end

  # assuming it's not a knight
  # check if same team piece can move inbetween the 2 positions (use class to
  # pick the direction for possible moves)
  def attack_blockable?(attacker_pos, king_pos, attacker_class); end

  # NOTE: use to check around king in all directions for check? & checkmate?
  # diagonal paths for bishop || queen || pawn (opposite team)
  # straight paths for rook || queen (opposite team)
  # check all movement directions
  # DOC: check if target pos can be attacked by opposite team
  # this is check
  def can_be_attacked?(defender_pos)
    linear_check(defender_pos, STRAIGHTPATHS, Rook) ||
      linear_check(defender_pos, DIAGPATHS, Bishop) ||
      knight_check(defender_pos) ||
      pawn_check(defender_pos)
  end

  def linear_check(defender_pos, directions, class_name)
    # for each direction we get the last possible movement using
    # possible_moves & last
    # this gives us an array with positions that should either be an empty
    # space next to a wall or occupied by a piece
    all_moves = directions.map { |dir| possible_moves(defender_pos, dir).last }

    all_moves.compact.each do |attacker_pos|
      # skip if no piece at pos
      next unless piece_exists?(attacker_pos)

      piece = get_piece(attacker_pos)

      # if piece is opposite team and appropriate piece then defender_piece is
      # under attack
      case piece when class_name || Queen then return true end if other_team?(piece)
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
    directions = @curr_player_white ? WHITEPAWNPATHS : BLACKPAWNPATHS

    all_moves = directions.map { |dir| possible_move(defender_pos, dir) }

    all_moves.compact.each do |attacker_pos|
      next unless piece_exists?(attacker_pos)

      piece = get_piece(attacker_pos)

      return true if other_team?(piece) && piece.pawn?
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

  # FIXME: piece_exists? && diff_team? (maybe create this with nil being false)
  #   && diagpath || (UP && !piece_exists?)
  def illegal_pawn_move?(fin_pos, dir); end

  # returns true if a_piece@team_white != b_piece@team_white
  def same_team?(a_piece, b_piece)
    return false if b_piece.nil?

    a_piece.team_white == b_piece.team_white
  end

  def get_piece(pos)
    @table[pos[0]][pos[1]]
  end

  def flip_current_player
    @curr_player_white = !@curr_player_white
  end

  def current_king_pos
    @curr_player_white ? @wking_pos  : @bking_pos
  end

  def other_king_pos
    @curr_player_white ? @bking_pos : @wking_pos
  end

  def update_curr_king_pos(new_pos)
    if @curr_player_white
      @wking_pos = new_pos
    else
      @bking_pos = new_pos
    end
  end

  def other_team?(piece)
    piece.team_white != @curr_player_white
  end

  def print_table
    puts '   --- --- --- --- --- --- --- ---'
    @table.each_with_index do |row, i|
      print "#{8 - i} |"

      row.each do |panel|
        print " #{panel.nil? ? ' ' : panel} |"
      end

      puts "\n   --- --- --- --- --- --- --- ---"
    end
    puts '    a   b   c   d   e   f   g   h '
  end

  # example user input:
  # init_a,init_b int,letter
  # fin_a,fin_b int, letter
  def translate
  end
end

b = Board.new

gets

b.move([6, 0], [5, 1])

gets

b.move([7, 1], [5, 2])

gets
