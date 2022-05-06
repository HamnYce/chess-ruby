# frozen_string_literal: true

module Gui
  #   e (exit), s (save), se (save & exit), l (load), h (help)
  #   create module for saving
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
    puts " Current player: #{@curr_player_white ? 'White' : 'Black'}"
  end

  def response(code)
    { 'wrong team' => "It is currently #{@curr_player_white ? 'White' : 'Black'}'s turn",
      'no piece' => 'sorry there is no piece at given starting position',
      'no dir' => 'sorry piece can\'t move in that direction',
      'not legal' => 'not legal move',
      'friendly fire' => 'cannot capture own piece',
      'rogue pawn' => 'pawn cannot move like that',
      'self check' => 'your own king is in check!'}[code]
  end
end
