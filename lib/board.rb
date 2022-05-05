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
end

b = Board.new
