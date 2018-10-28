# coding: utf-8
# frozen_string_literal: true

module Minesweeper
  class Game
    attr_reader :state
    attr_reader :board
    attr_reader :height
    attr_reader :width

    def initialize(height, width)
      @state = :in_progress
      @mine_count = 0
      @flag_count = 0
      @height = height
      @width = width
      @board = new_board
      @revealed = 0
    end

    def mine_count
      if state == :win
        0
      else
        flags_left
      end
    end

    def flags_left
      @mine_count - @flag_count
    end

    def place_mines(*locations)
      locations.each do |row, col|
        changed = @board[row][col].place_mine
        if changed
          @mine_count += 1
          mark_neighbors(row, col)
        end
      end
    end

    def reveal(*locations)
      locations.each do |row, col|
        cell = @board[row][col]
        changed = cell.reveal

        next unless changed

        @revealed += 1

        if cell.mined?
          @state = :lose
          break
        end

        reveal(*neighbors(row, col)) unless cell.neighboring_mines?

        @state = :win if won?
      end
    end

    def won?
      board_size = @width * @height
      unrevealed = board_size - @revealed

      unrevealed == @mine_count
    end

    def place_flags(*locations)
      locations.each do |row, col|
        changed = @board[row][col].place_flag
        @flag_count += 1 if changed
      end
    end

    def remove_flag(row, col)
      changed = @board[row][col].remove_flag
      @flag_count -= 1 if changed
    end

    def over?
      state != :in_progress
    end

    def random_locations(mine_count)
      locations = Set.new
      until locations.length >= mine_count
        row = rand(@height)
        col = rand(@width)
        locations << [row, col]
      end
      locations.to_a
    end

    private

    def new_board
      board = []
      @height.times do
        row = []
        @width.times do
          row << Cell.new
        end
        board << row
      end
      board
    end

    def mark_neighbors(row, col)
      neighbors(row, col).each do |nrow, ncol|
        @board[nrow][ncol].mark_neighboring_mine
      end
    end

    def neighbors(row, col)
      locations = []

      rows = [row - 1, row, row + 1].select { |r| (0...@height).cover?(r) }
      cols = [col - 1, col, col + 1].select { |c| (0...@width).cover?(c) }

      rows.each do |nrow|
        cols.each do |ncol|
          locations << [nrow, ncol] unless [nrow, ncol] == [row, col]
        end
      end

      locations
    end
  end
end
