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

    describe 'place mines' do
      before do
        subject.place_mines([1, 3], [0, 1], [2, 0], [3, 2])
      end

      it 'should have 4 mines' do
        subject.mine_count.must_equal(4)
      end

      it 'should print a completely hidden grid' do
        subject.to_s.must_equal <<~RESULT
          Game: 😀, Mines: 4
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

      describe 'Reveal a mine' do
        before do
          subject.reveal([2, 0])
        end

        it 'should lose the game' do
          subject.state.must_equal(:lose)
        end

        it 'updates the game board' do
          subject.to_s.must_equal <<~RESULT
            Game: 😭, Mines: 4
            ====================

            +-+-+-+-+
            |?|💣|?|?|
            +-+-+-+-+
            |?|?|?|💣|
            +-+-+-+-+
            |💥|?|?|?|
            +-+-+-+-+
            |?|?|💣|?|
            +-+-+-+-+
          RESULT
        end
      end

      describe 'Reveal a non-mine' do
        before do
          subject.reveal([0, 0], [2, 2])
        end

        it 'should not change game state' do
          subject.state.must_equal(:in_progress)
        end

        it 'updates the game board' do
          subject.to_s.must_equal <<~RESULT
            Game: 😀, Mines: 4
            ====================

            +-+-+-+-+
            |1|?|?|?|
            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|2|?|
            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
          RESULT
        end
      end

      describe 'Reveal all non mines' do
        before do
          subject.reveal(
            [0, 0],
            [0, 2],
            [0, 3],
            [1, 0],
            [1, 1],
            [1, 2],
            [2, 1],
            [2, 2],
            [2, 3],
            [3, 0],
            [3, 1],
            [3, 3])
        end

        it 'should win the game' do
          subject.state.must_equal(:win)
        end

        it 'updates the game board' do
          subject.to_s.must_equal <<~RESULT
            Game: 😎, Mines: 0
            ====================

            +-+-+-+-+
            |1|🚩|2|1|
            +-+-+-+-+
            |2|2|2|🚩|
            +-+-+-+-+
            |🚩|2|2|2|
            +-+-+-+-+
            |1|2|🚩|1|
            +-+-+-+-+
          RESULT
        end
      end

      describe 'Place a flag on a cell' do
        before do
          subject.place_flags([3, 2])
        end

        it 'decrements the mine count' do
          subject.mine_count.must_equal(3)
        end

        it 'updates the game board' do
          subject.to_s.must_equal <<~RESULT
            Game: 😀, Mines: 3
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
            subject.place_flags([3, 2])
          end

          it 'does not change the mine count' do
            subject.mine_count.must_equal(3)
          end

          it 'does not update the game board' do
            subject.to_s.must_equal <<~RESULT
              Game: 😀, Mines: 3
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
            subject.place_flags([2, 3])
          end

          it 'decrements the mine count' do
            subject.mine_count.must_equal(2)
          end

          it 'updates the game board' do
            subject.to_s.must_equal <<~RESULT
              Game: 😀, Mines: 2
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
            subject.mine_count.must_equal(4)
          end

          it 'updates the game board' do
            subject.to_s.must_equal <<~RESULT
              Game: 😀, Mines: 4
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
            subject.mine_count.must_equal(3)
          end

          it 'game board stays the same' do
            subject.to_s.must_equal <<~RESULT
              Game: 😀, Mines: 3
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

  describe 'beginner game' do
    subject { Game.new(9, 9) }

    before do
      subject.place_mines(
        [0, 2],
        [1, 2],
        [2, 8],
        [3, 4],
        [4, 0],
        [4, 2],
        [5, 4],
        [7, 1],
        [7, 6],
        [8, 1]
      )
    end

    describe 'recursive reveal' do
      before do
        subject.reveal(
          [0, 8],
          [2, 0]
        )
      end

      it 'should reveal neighbors' do
        subject.to_s.must_equal <<~RESULT
          Game: 😀, Mines: 10
          ====================

          +-+-+-+-+-+-+-+-+-+
          | |2|?|2| | | | | |
          +-+-+-+-+-+-+-+-+-+
          | |2|?|2| | | |1|1|
          +-+-+-+-+-+-+-+-+-+
          | |1|?|2|1|1| |1|?|
          +-+-+-+-+-+-+-+-+-+
          |1|2|?|?|?|1| |1|1|
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|2| | | |
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|1| | | |
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|2|1|1| |
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|1| |
          +-+-+-+-+-+-+-+-+-+
          |?|?|?|?|?|?|?|1| |
          +-+-+-+-+-+-+-+-+-+
        RESULT
      end

      describe 'flag and win' do
        before do
          subject.place_flags(
            [0, 2],
            [1, 2],
            [2, 8]
          )

          subject.reveal(
            [2, 2],
            [3, 2],
            [3, 3]
          )

          subject.place_flags([3, 4])
        end

        it 'should win the game' do
          subject.to_s.must_equal <<~RESULT
            Game: 😀, Mines: 6
            ====================

            +-+-+-+-+-+-+-+-+-+
            | |2|🚩|2| | | | | |
            +-+-+-+-+-+-+-+-+-+
            | |2|🚩|2| | | |1|1|
            +-+-+-+-+-+-+-+-+-+
            | |1|1|2|1|1| |1|🚩|
            +-+-+-+-+-+-+-+-+-+
            |1|2|1|2|🚩|1| |1|1|
            +-+-+-+-+-+-+-+-+-+
            |?|?|?|?|?|2| | | |
            +-+-+-+-+-+-+-+-+-+
            |?|?|?|?|?|1| | | |
            +-+-+-+-+-+-+-+-+-+
            |?|?|?|?|?|2|1|1| |
            +-+-+-+-+-+-+-+-+-+
            |?|?|?|?|?|?|?|1| |
            +-+-+-+-+-+-+-+-+-+
            |?|?|?|?|?|?|?|1| |
            +-+-+-+-+-+-+-+-+-+
          RESULT
        end
      end
    end
  end
end
