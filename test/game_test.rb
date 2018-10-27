# coding: utf-8
# frozen_string_literal: true

require 'test_helper'

require 'minesweeper'

module Minesweeper
  describe Game do
    subject { Game.new(4, 4) }

    describe 'initial state' do
      it 'must start with state in-progress' do
        subject.state.must_equal(:in_progress)
      end

      it 'must start with 0 mines' do
        subject.mine_count.must_equal(0)
      end

      it 'must print a completely hidden grid' do
        subject.to_s.must_equal <<~RESULT
          Game: 😀, Mines: 0
          ====================

          +-+-+-+-+
          |?|?|?|?|
          +-+-+-+-+
          |?|?|?|?|
          +-+-+-+-+
          |?|?|?|?|
          +-+-+-+-+
          |?|?|?|?|
          +-+-+-+-+
        RESULT
      end
    end

    describe 'Place a flag on a cell' do
      before do
        subject.place_flag(3, 2)
      end

      it 'decrements the mine count' do
        subject.mine_count.must_equal(-1)
      end

      it 'updates the game board' do
        subject.to_s.must_equal <<~RESULT
          Game: 😀, Mines: -1
          ====================

          +-+-+-+-+
          |?|?|?|?|
          +-+-+-+-+
          |?|?|?|?|
          +-+-+-+-+
          |?|?|?|?|
          +-+-+-+-+
          |?|?|🚩|?|
          +-+-+-+-+
        RESULT
      end

      describe 'Place flag on flagged cell' do
        before do
          subject.place_flag(3, 2)
        end

        it 'does not change the mine count' do
          subject.mine_count.must_equal(-1)
        end

        it 'does not update the game board' do
          subject.to_s.must_equal <<~RESULT
            Game: 😀, Mines: -1
            ====================

            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|🚩|?|
            +-+-+-+-+
          RESULT
        end
      end

      describe 'Place multiple flags' do
        before do
          subject.place_flag(2, 3)
        end

        it 'decrements the mine count' do
          subject.mine_count.must_equal(-2)
        end

        it 'updates the game board' do
          subject.to_s.must_equal <<~RESULT
            Game: 😀, Mines: -2
            ====================

            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|?|🚩|
            +-+-+-+-+
            |?|?|🚩|?|
            +-+-+-+-+
          RESULT
        end
      end

      describe 'remove a flag' do
        before do
          subject.remove_flag(3, 2)
        end

        it 'increments the mine count' do
          subject.mine_count.must_equal(0)
        end

        it 'updates the game board' do
          subject.to_s.must_equal <<~RESULT
            Game: 😀, Mines: 0
            ====================

            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
          RESULT
        end
      end

      describe 'Remove flag from unflagged cell' do
        before do
          subject.remove_flag(2, 3)
        end

        it 'does not change the mine count' do
          subject.mine_count.must_equal(-1)
        end

        it 'game board stays the same' do
          subject.to_s.must_equal <<~RESULT
            Game: 😀, Mines: -1
            ====================

            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|🚩|?|
            +-+-+-+-+
          RESULT
        end
      end
    end
  end
end
