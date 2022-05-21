# frozen_string_literal: true


require 'json'
require_relative 'pieces/piece'

# Module to serialise the board
module Serializer
  def save_game
    File.open('save/save.json', 'w') do |file|
      json = { wking_pos: @wking_pos,
               bking_pos: @bking_pos,
               curr_player_white: @curr_player_white,
               table: @table }.to_json

      file.write(json)
    end
  end

  def load_game
    file = File.open('save/save.json', 'r')
    hash = JSON.parse(file.read)
    file.close


    @wking_pos = hash['wking_pos']
    @bking_pos = hash['bking_pos']
    @curr_player_white = hash['curr_player_white']
    table = hash['table']

    table.each_index do |i|
      table[i].each_index do |j|
        @table[i][j] = case table[i][j]
                       when WKING_ICON then King.new(true)
                       when WQUEEN_ICON then Queen.new(true)
                       when WROOK_ICON then Rook.new(true)
                       when WBISHOP_ICON then Bishop.new(true)
                       when WKNIGHT_ICON then Knight.new(true)
                       when WPAWN_ICON
                         pawn = Pawn.new(true)
                         pawn.moved if i != 6
                         pawn
                       when BKING_ICON then King.new(true)
                       when BQUEEN_ICON then Queen.new(false)
                       when BROOK_ICON then Rook.new(false)
                       when BBISHOP_ICON then Bishop.new(false)
                       when BKNIGHT_ICON then Knight.new(false)
                       when BPAWN_ICON
                         pawn = Pawn.new(false)
                         pawn.moved if i != 1
                         pawn
                       end
      end
    end
  end
end
