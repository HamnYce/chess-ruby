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
    @table = STARTINGBOARD
    @wking_pos = STARTWHITEKING
    @bking_pos = STARTBLACKKING
    @curr_player_white = true
    @input_reg = /^[a-h][1-8] [a-h][1-8]$/i
    turn
  end

  def turn
    # Menu screen
    print_intro_menu
    input = gets.chomp
    until %w[l n e].include?(input.downcase)
      puts 'input (n / l / e):'
      input = gets.chomp

      case input
      when 'l'
        load_game
        puts 'Game loaded'
      when 'n'
        puts 'New game'
      end
    end

    # game loop
    print_table unless input.downcase == 'e'

    until input.downcase == 'e'

      input = gets.chomp

      case input.downcase
      when 's'
        save_game
        puts 'Game saved successfully'
        break
      when 'e'
        break
      when @input_reg
        moves = input.downcase.split
        init_pos = parse(moves[0])
        fin_pos = parse(moves[1])

        status = move(init_pos, fin_pos)

        print_table and return 'Game ended' if status == 'Checkmate!'

        print_table
        puts status
      else
        puts 'keep trying inputs'
      end
    end

    puts 'Exiting program. Thank you for playing'
  end

  # NOTE: converts from chess notation to pos notation
  def parse(input)
    input = input.split('').reverse
    input[0] = 8 - input[0].to_i
    input[1] = input[1].ord - 97
    input
  end

  def move(init_pos, fin_pos)
    # Phase 1 conditions
    return response('no piece') unless piece_exists?(init_pos)

    piece = @table[init_pos[0]][init_pos[1]]
    # Phase 2 conditions
    return response('wrong team') if piece.team_white != @curr_player_white

    dir = direction(init_pos, fin_pos)

    return response('no dir') unless piece.can_move?(dir)

    p_moves = piece_moves(piece, init_pos, dir)

    # Phase 3 conditions
    return response('not legal') unless p_moves.include?(fin_pos)
    return response('friendly fire') if same_team?(piece, get_piece(fin_pos))
    return response('rogue pawn') if piece.pawn? && !legal_pawn_move?(fin_pos, dir)

    simulate(init_pos, fin_pos)


    # Phase 4 conditions
    if under_attack?(current_king_pos, !@curr_player_white)
      revert_simulation
      return response('self check')
    end

    if piece.pawn?
      piece.moved
      upgrade_pawn(fin_pos, @curr_player_white) if pawn_reached_end?(fin_pos)
    end

    # Phase 5 conditions
    return 'Checkmate!' if checkmate?(other_king_pos, @curr_player_white)


    flip_current_player
    # maybe move system('clear') into the print function
    'Successful move'
  end


end

Board.new
