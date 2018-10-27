# coding: utf-8
require 'test_helper'

require 'minesweeper'

module Minesweeper
  describe Game, 'Minesweeper game tests' do
    subject { Game.new }

    describe 'initial state', 'Minesweeper initial state' do
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
  end
end
