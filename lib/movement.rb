# frozen_string_literal: true

# contains procs for each movement direction (ALL off them) :up, :down etc
module MovementProcs
  # TODO: create Proc as CONSTANT
  # TODO: create procs and use loop in PieceBase#possible_moves (stop when need)
  # NOTE: let the procs only go in direction by ONE. then the piece can loop and
  #   yield to it!!!!!
  UP = proc { |x, y| [x - 1, y] }
  DOWN = proc { |x, y| [x + 1, y] }
  LEFT = proc { |x, y| [x, y - 1] }
  RIGHT = proc { |x, y| [x, y + 1] }
  UPRIGHT = proc { |x, y| [x - 1, y + 1] }
  UPLEFT = proc { |x, y| [x - 1, y - 1] }
  DOWNRIGHT = proc { |x, y| [x + 1, y + 1] }
  DOWNLEFT = proc { |x, y| [x + 1, y - 1] }

  KNIGHTUPLEFT = proc { |x, y| [x - 2, y - 1] }
  KNIGHTLEFTUP = proc { |x, y| [x - 1, y - 2] }

  KNIGHTUPRIGHT = proc { |x, y| [x - 2, y + 1] }
  KNIGHTRIGHTUP = proc { |x, y| [x - 1, y + 2] }

  KNIGHTDOWNLEFT = proc { |x, y| [x + 2, y - 1] }
  KNIGHTLEFTDOWN = proc { |x, y| [x + 1, y - 2] }

  KNIGHTDOWNRIGHT = proc { |x, y| [x + 2, y + 1] }
  KNIGHTRIGHTDOWN = proc { |x, y| [x + 1, y + 2] }
end

# top level documentation
module MovementAlgs
  include MovementProcs

  def possible_move(curr_pos, direction)
    p_moves = []

    pos = MovementProc.const_get(direction).call(curr_pos)

    p_moves << pos if valid_pos?(pos)

    p_moves
  end

  # DOC: returns array of posible moves in given direction
  def possible_moves(curr_pos, direction)
    p_moves = []

    pos = MovementProcs.const_get(direction).call(curr_pos)

    while valid_pos?(pos)
      p_moves << pos
      pos = MovementProcs.const_get(direction).call(pos)
    end

    p_moves
  end

  def knight_possible_moves(curr_pos, direction)
    direction_two = flip_knight_direction(direction)
    direction = "KNIGHT#{direction}".to_sym

    p_moves = []

    pos = MovementProcs.const_get(direction).call(curr_pos)
    p_moves << pos if valid_pos?(pos)
    pos = MovementProcs.const_get(direction_two).call(curr_pos)
    p_moves << pos if valid_pos?(pos)

    p_moves
  end

  def flip_knight_direction(direction)
    if direction.start_with? 'U'
      "KNIGHT#{direction[2..]}UP"
    else
      "KNIGHT#{direction[4..]}DOWN"
    end
  end

  def valid_pos?(pos)
    pos[0].between?(0, 7) && pos[1].between?(0, 7)
  end
end
