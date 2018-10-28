# coding: utf-8
# frozen_string_literal: true

module Minesweeper
  class Cell
    def initialize
      @flagged = false
      @mined = false
      @revealed = false
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
      @revealed = true
    end

    def state(game_state)
      case game_state
      when :lose
        lost_state
      else
        good_state
      end
    end

    def good_state
      if flagged?
        :flagged
      else
        :unknown
      end
    end

    def lost_state
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
