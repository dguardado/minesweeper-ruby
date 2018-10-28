# coding: utf-8
# frozen_string_literal: true

module Minesweeper
  class GameView

    ASCII_ICONS = {
      in_progress: '^-^',
      win: 'B-D',
      lose: ';_;',
      flagged: '>',
      mined: 'Q',
      wrong: 'X',
      boom: '*',
      unknown: '?',
      0 => ' '
    }.freeze

    EMOJI_ICONS = {
      in_progress: '😀',
      win: '😎',
      lose: '😭',
      flagged: '🚩',
      mined: '💣',
      wrong: '❌',
      boom: '💥',
      unknown: '❔',
      0 => '⏹ ',
      1 => '1️⃣ ',
      2 => '2️⃣ ',
      3 => '3️⃣ ',
      4 => '4️⃣ ',
      5 => '5️⃣ ',
      6 => '6️⃣ ',
      7 => '7️⃣ ',
      8 => '8️⃣ '
    }.freeze

    def initialize(game, icons)
      @game = game
      @icons = icons
    end

    def self.ascii(game)
      new(game, ASCII_ICONS)
    end

    def self.emoji(game)
      new(game, EMOJI_ICONS)
    end

    def to_s
      result = +''
      result << format_state
      result << "\n"
      result << format_board
      result.freeze
    end

    private

    def format_state
      <<~RESULT
        Game: #{state_icon}, Mines: #{@game.mine_count}
        ====================
      RESULT
    end

    def state_icon
      @icons[@game.state]
    end

    def format_board
      result = +''
      result << format_board_separator
      @game.board.each do |row|
        result << format_row(row)
        result << format_board_separator
      end
      result.freeze
    end

    def format_board_separator
      sep = +'+'
      @game.width.times { sep << '-+' }
      sep << "\n"
      sep.freeze
    end

    def format_row(row)
      result = +'|'
      row.each do |cell|
        result << "#{format_cell(cell)}|"
      end
      result << "\n"
      result.freeze
    end

    def format_cell(cell)
      cell_state = cell.state(@game.state)
      @icons[cell_state] || cell_state
    end
  end
end
