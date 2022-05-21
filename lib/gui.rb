# frozen_string_literal: true


module Gui
  WKING_ICON = "\u265A"
  WQUEEN_ICON = "\u265B"
  WROOK_ICON = "\u265C"
  WBISHOP_ICON = "\u265D"
  WKNIGHT_ICON = "\u265E"
  WPAWN_ICON = "\u265F"

  BKING_ICON = "\u2654"
  BQUEEN_ICON = "\u2655"
  BROOK_ICON = "\u2656"
  BBISHOP_ICON = "\u2657"
  BKNIGHT_ICON = "\u2658"
  BPAWN_ICON = "\u2659"
  #   e (exit), s (save), se (save & exit), l (load), h (help)
  #   create module for saving


  def print_intro_menu
    system('clear')
    puts "
    Chess Menu
    (n) start fresh
    (l) load saved game
    (e) exit program
    "
  end

  def print_get_input
    puts "
    Enter:
    (s) to save and exit
    (e) to exit without saving
    ('a2 a3') to move a piece
    "
  end

  def print_table
    system('clear')

    puts '   --- --- --- --- --- --- --- ---'
    @table.each_with_index do |row, i|
      print "#{8 - i} |"

      row.each do |panel|
        print " #{panel || ' '} |"
      end

      puts "\n   --- --- --- --- --- --- --- ---"
    end
    puts '    a   b   c   d   e   f   g   h '
    puts " Current player: #{@curr_player_white ? 'White' : 'Black'}"
    print_get_input
    puts 'input (s / e / b1 c3)'
  end

  def response(code)
    { 'wrong team' => "It is currently #{@curr_player_white ? 'White' : 'Black'}'s turn",
      'no piece' => 'There is no piece at given starting position',
      'no dir' => 'piece Can\'t move like that',
      'not legal' => 'illegal move',
      'friendly fire' => 'friendly fire not enabled (cannot capture own piece)',
      'rogue pawn' => 'Pawn refuses to move like that',
      'self check' => 'Your king is under attack!'}[code]
  end

  def print_upgrade_screen(team)
    system('clear')

    queen = team ? WQUEEN_ICON : BQUEEN_ICON
    rook = team ? WROOK_ICON : BROOK_ICON
    bishop = team ? WBISHOP_ICON : BBISHOP_ICON
    knight = team ? WKNIGHT_ICON : BKNIGHT_ICON

    puts "Pawn upgrade in progress:\nInput:\n"
    puts "1 - #{queen} for Queen"
    puts "2 - #{rook} for Rook"
    puts "3 - #{bishop} for Bishop"
    puts "4 - #{knight} for Knight"
  end
end
