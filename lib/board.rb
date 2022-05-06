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
  include Serializer
  include Simulator
  include Checker
  include Gui
  include BoardHelper

  def initialize
    @table = STARTING_BOARD
    @wking_pos = [7, 4]
    @bking_pos = [0, 4]
    @curr_player_white = true
    print_table
    turn
  end

  # TODO: convert implementation of @table to hash (at the end)
  # TODO: menu options: create menu (check gui.rb)
  # TODO: add regex for input to avoid exception raising
  # TODO: pawn should be able to move 2 squares on initial movement
  # TODO: test checkmate (RSpec)
  # TODO: pawn upgrade once it gets to end (create seperate menu)

  def turn
    puts "enter e to exit or positions to move from/to\nformat: a1 a2"
    input = gets.chomp


    load_game if input == 'l'

    until input[-1] == 'e'
      input = input.split
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
end

b = Board.new
