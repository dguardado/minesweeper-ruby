# coding: utf-8
# frozen_string_literal: true

module Minesweeper
  class Cell
    def initialize
      @flagged = false
      @mined = false
      @revealed = false
      @neighboring_mines = 0
    end

    def flagged?
      @flagged
    end

    def place_flag
      if flagged?
        false
      else
        @flagged = true
      end
    end

    def remove_flag
      if flagged?
        @flagged = false
        true
      else
        false
      end
    end

    def mined?
      @mined
    end

    def place_mine
      if mined?
        false
      else
        @mined = true
      end
    end

    def revealed?
      @revealed
    end

    def reveal
      if revealed?
        false
      else
        @revealed = true
      end
    end

    def neighboring_mines?
      @neighboring_mines.positive?
    end

    def state(game_state)
      case game_state
      when :in_progress
        hidden_state
      when :win
        win_state
      else
        lose_state
      end
    end

    def mark_neighboring_mine
      @neighboring_mines += 1
    end

    private

    def hidden_state
      if flagged?
        :flagged
      elsif revealed?
        @neighboring_mines
      else
        :unknown
      end
    end

    def win_state
      if flagged? || mined?
        :flagged
      elsif revealed?
        @neighboring_mines
      else
        :unknown
      end
    end

    def lose_state
      case [revealed?, flagged?, mined?]
      when [true, false, true]
        :boom
      when [false, true, true]
        :flagged
      when [false, true, false]
        :wrong
      when [false, false, true]
        :mined
      when [false, false, false]
        :unknown
      else
        :no_mines
      end
    end
  end
end
