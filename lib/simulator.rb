# frozen_string_literal: true

# methods for reversable simulation of piece movement
module Simulator
  def simulate(init_pos, fin_pos)
    @attacker = [init_pos, get_piece(init_pos)]
    @defender = [fin_pos, get_piece(fin_pos)]

    move_and_overwrite(init_pos, fin_pos)

    update_curr_king_pos(fin_pos) if @attacker[1].king?
  end

  def revert_simulation
    row, col = @attacker[0]
    @table[row][col] = @attacker[1]

    row, col = @defender[0]
    @table[row][col] = @defender[1]

    update_curr_king_pos(@attacker[0]) if @attacker[1].king?
  end

  def move_and_overwrite(init_pos, fin_pos)
    attacker = @table[init_pos[0]][init_pos[1]]

    @table[fin_pos[0]][fin_pos[1]] = attacker
    @table[init_pos[0]][init_pos[1]] = nil
  end
end
