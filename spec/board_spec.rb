# Frozen_string_literal: true

require_relative '../lib/board'

RSpec.describe 'Board' do
  describe '#delete_blocked_moves' do
    subject(:filtered_moves) { Board.new }
    let(:inc_array) do
      arr = Array.new(7)
      (1..7).each { |i| arr[i - 1] = [0, i] }
      arr
    end

    context 'when piece exists at [0, 1]' do
      it 'returns [[0, 1]]' do
        p filtered_moves.instance_variable_get(:@table)[0][1] = 1
        filtered_moves.delete_blocked_moves(inc_array)
        expect(filtered_moves.delete_blocked_moves(inc_array)).to eq([[0, 1]])
      end
    end

    context 'when piece exists at [0, 3]' do
      it 'returns [[0, 1], [0, 2], [0, 3]]' do
        filtered_moves.instance_variable_get(:@table)[0][3] = 1
        result = inc_array.map { |x| x if x[1] < 4 }.compact
        expect(filtered_moves.delete_blocked_moves(inc_array)).to eq(result)
      end
    end

    context 'when piece exists [0, 7]' do
      it 'returns same array' do
        result = inc_array.clone
        expect(filtered_moves.delete_blocked_moves(inc_array)).to eq(result)
      end
    end
  end

  describe '#direction' do
    subject(:move_direction) { Board.new }

    context 'when moving up' do
      it 'returns :UP' do
        result = move_direction.direction([1, 0], [0, 0])
        expect(result).to eq(:UP)
      end
    end

    context 'when moving down' do
      it 'returns :DOWN' do
        result = move_direction.direction([0, 0], [1, 0])
        expect(result).to eq(:DOWN)
      end
    end

    context 'when moving left' do
      it 'returns :LEFT' do
        result = move_direction.direction([0, 1], [0, 0])
        expect(result).to eq(:LEFT)
      end
    end

    context 'when moving right' do
      it 'returns :RIGHT' do
        result = move_direction.direction([0, 0], [0, 1])
        expect(result).to eq(:RIGHT)
      end
    end

    context 'when moving diagonally up-left' do
      it 'returns :UPLEFT' do
        result = move_direction.direction([1, 1], [0, 0])
        expect(result).to eq(:UPLEFT)
      end
    end

    context 'when moving diagonally up-right' do
      it 'returns :UPRIGHT' do
        result = move_direction.direction([1, 1], [0, 2])
        expect(result).to eq(:UPRIGHT)
      end
    end

    context 'when moving diagonally down-left' do
      it 'returns :DOWNLEFT' do
        result = move_direction.direction([1, 1], [2, 0])
        expect(result).to eq(:DOWNLEFT)
      end
    end

    context 'when moving diagonally down-right' do
      it 'returns :DOWNRIGHT' do
        result = move_direction.direction([1, 1], [2, 2])
        expect(result).to eq(:DOWNRIGHT)
      end
    end
  end
end
