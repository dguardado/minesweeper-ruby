# coding: utf-8
# frozen_string_literal: true

module Minesweeper
  class Game
    attr_reader :state
    attr_reader :mine_count

    def initialize(height, width)
      @state = :in_progress
      @mine_count = 0
      @height = height
      @width = width
      @board = new_board
    end

    def place_mines(*locations)
      locations.each do |row, col|
        changed = @board[row][col].place_mine
        @mine_count += 1 if changed
      end
    end

    def place_flag(row, col)
      changed = @board[row][col].place_flag
      @mine_count -= 1 if changed
    end

    def remove_flag(row, col)
      changed = @board[row][col].remove_flag
      @mine_count += 1 if changed
    end

    def over?
      state != :in_progress
    end

    def to_s
      result = +''
      result << format_state
      result << "\n"
      result << format_board
      result.freeze
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

    def format_state
      <<~RESULT
        Game: 😀, Mines: #{@mine_count}
        ====================
      RESULT
    end

    def format_board
      result = +''
      result << format_board_separator
      @board.each do |row|
        result << format_row(row)
        result << format_board_separator
      end
      result.freeze
    end

    def format_board_separator
      sep = +'+'
      @width.times { sep << '-+' }
      sep << "\n"
      sep.freeze
    end

    def format_row(row)
      result = +'|'
      row.each do |cell|
        result << "#{cell.format}|"
      end
      result << "\n"
      result.freeze
    end
  end
end
