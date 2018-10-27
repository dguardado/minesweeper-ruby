# coding: utf-8
# frozen_string_literal: true

module Minesweeper
  class Cell
    def initialize
      @flagged = false
    end

    def flagged?
      @flagged
    end

    def place_flag
      @flagged = true
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
