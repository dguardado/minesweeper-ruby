# coding: utf-8
# frozen_string_literal: true

module Minesweeper
  class Cell
    def initialize
      @flagged = false
      @mined = false
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

    def format
      if flagged?
        '🚩'
      else
        '?'
      end
    end
  end
end
