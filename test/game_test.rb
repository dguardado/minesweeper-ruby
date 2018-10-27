# coding: utf-8
# frozen_string_literal: true

require 'test_helper'

require 'minesweeper'

module Minesweeper
  describe Game, 'Minesweeper game tests' do
    subject { Game.new }

    describe 'initial state' do
      it 'must start with state in-progress' do
        subject.state.must_equal(:in_progress)
      end

      it 'must start with 10 mines' do
        subject.mine_count.must_equal(10)
      end

      it 'must print a completely hidden grid' do
        subject.to_s.must_equal <<~RESULT
          Game: 😀, Mines: 10
          ====================

          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
        RESULT
      end
    end

    describe 'Place a flag on a cell' do
      before do
        subject.place_flag(4, 3)
      end

      it 'decrements the mine count' do
        subject.mine_count.must_equal(9)
      end

      it 'updates the game board' do
        subject.to_s.must_equal <<~RESULT
          Game: 😀, Mines: 9
          ====================

          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|🚩|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|?|?|
          +-+-+-+-+-+-+-+-+-+
        RESULT
      end
    end
  end
end
