# frozen_string_literal: true

require_relative 'init'
require_relative 'pieces/piece'
require_relative 'movement'
require_relative 'serializer'
require_relative 'simulator'
require_relative 'checker'
require_relative 'gui'
require_relative 'board_helper'

# insert_documentation_here
class Board
  include Piece
  include MovementAlgorithms
  include Serializer
  include Simulator
  include Checker
  include Gui
  include BoardHelper

  # TODO: convert implementation of @table to hash (at the end)
  def initialize
    @table = STARTING_BOARD
    @wking_pos = [7, 4]
    @bking_pos = [0, 4]
    @curr_player_white = true
    print_table
    turn
  end

  # TODO: menu options:
  #   e (exit), s (save), se (save & exit), l (load), h (help)
  #   create module for saving
  def turn
    puts "enter e to exit or positions to move from/to\nformat: a1 a2"
    input = gets.chomp

    # TODO: create load menu (let it read from a folder called loads method
    #   inside module Serialiser)
    load_game if input == 'l'

    until input[-1] == 'e'
      input = input.split
      # TODO: add regex for input to avoid exception raising
      init_pos = parse(input[0])
      fin_pos = parse(input[1])

      puts move(init_pos, fin_pos)

      puts 'input:'
      input = gets.chomp

      save_game if input[0] == 'se'
    end

    puts 'game ended'
  end

  # NOTE: converts from chess notation to pos notation
  def parse(input)
    input = input.split('').reverse
    input[0] = 8 - input[0].to_i
    input[1] = input[1].ord - 97
    input
  end

  def move(init_pos, fin_pos)
    # change phases into methods

    # Phase 1 conditions
    return response('no piece') unless piece_exists?(init_pos)

    piece = @table[init_pos[0]][init_pos[1]]
    # Phase 2 conditions
    return response('wrong team') if other_team?(piece)

    dir = direction(init_pos, fin_pos)

    return response('no dir') unless piece.include_dir?(dir)

    p_moves = piece_moves(piece, init_pos, dir)

    # Phase 3 conditions
    return response('not legal') unless p_moves.include?(fin_pos)
    return response('friendly fire') if same_team?(piece, get_piece(fin_pos))

    if piece.pawn? && !legal_pawn_move?(fin_pos, dir)
      return response('rogue pawn')
    end

    simulate(init_pos, fin_pos)

    # Phase 4 conditions
    if can_be_attacked?(current_king_pos)
      revert_simulation
      return response('self check')
    end

    return 'Checkmate!' if checkmate?(other_king_pos)

    update_curr_king_pos(fin_pos) if @attacker[1].king?

    # Phase 5 conditions
    # return 'Checkmate!' if checkmate?


    flip_current_player

    # maybe move system('clear') into the print function
    system('clear')
    print_table

    'successful move'
  end

  # NOTE: can_be_attacked? on the spaces around the king (can king move away?)
  #   on other_king_pos.
  #   can_be_attacked? on spaces between king and attacker (can attack be
  #   blocked)
  #   can_be_attacked? on attacking piece (can attacker be captured)
  def checkmate?(king_pos)
    # if piece can't move out of the way
    # cant block
    # piece attacker isn't capturable
  end


  def king_can_move?(king_pos)
    all_moves = KINGPATHS.map { |dir| possible_move(king_pos, dir) }
  end

  # assuming it's not a knight
  # check if same team piece can move inbetween the 2 positions (use class to
  # pick the direction for possible moves)
  def attack_blockable?(attacker_pos, king_pos, attacker_class); end

  # DOC: check if target pos can be attacked by opposite team
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
    directions = @curr_player_white ? WHITEPAWNATTPATHS : BLACKPAWNATTPATHS

    all_moves = directions.map { |dir| possible_move(defender_pos, dir).last }

    all_moves.compact.each do |attacker_pos|
      next unless piece_exists?(attacker_pos)

      piece = get_piece(attacker_pos)

      return true if other_team?(piece) && piece.pawn?
    end

    false
  end

  def legal_pawn_move?(fin_pos, dir)
    (DIAGPATHS.include?(dir) && piece_exists?(fin_pos)) ||
      ([:UP, :DOWN].include?(dir) && !piece_exists?(fin_pos))
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

  # TODO: create module for ANY & ALL methods containing string || puts
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

  def response(code)
    { 'no piece' => 'sorry there is no piece at given starting position',
      'no dir' => 'sorry piece can\'t move in that direction',
      'not legal' => 'not legal move',
      'friendly fire' => 'cannot capture own piece',
      'rogue pawn' => 'pawn cannot move like that',
      'self check' => 'your own king is in check!'}[code]
  end

end

b = Board.new

gets

puts b.move([6, 0], [5, 0])

gets

puts b.move([7, 1], [5, 2])

gets

puts b.move([6, 2], [5, 2])
