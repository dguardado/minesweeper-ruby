# coding: utf-8
# frozen_string_literal: true

require 'test_helper'

require 'minesweeper'

module Minesweeper
  describe Game do
    let(:game) { Game.new(4, 4) }
    subject { GameView.ascii(game) }

    describe 'initial state' do
      it 'must print a completely hidden grid' do
        subject.to_s.must_equal <<~RESULT
          Game: ^-^, Mines: 0
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
        game.place_mines([1, 3], [0, 1], [2, 0], [3, 2])
      end

      it 'should print a completely hidden grid' do
        subject.to_s.must_equal <<~RESULT
          Game: ^-^, Mines: 4
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
          game.reveal([2, 0])
        end

        it 'updates the game board' do
          subject.to_s.must_equal <<~RESULT
            Game: ;_;, Mines: 4
            ====================

            +-+-+-+-+
            |?|Q|?|?|
            +-+-+-+-+
            |?|?|?|Q|
            +-+-+-+-+
            |*|?|?|?|
            +-+-+-+-+
            |?|?|Q|?|
            +-+-+-+-+
          RESULT
        end
      end

      describe 'Reveal a non-mine' do
        before do
          game.reveal([0, 0], [2, 2])
        end

        it 'updates the game board' do
          subject.to_s.must_equal <<~RESULT
            Game: ^-^, Mines: 4
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
          game.reveal(
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

        it 'updates the game board' do
          subject.to_s.must_equal <<~RESULT
            Game: B-D, Mines: 0
            ====================

            +-+-+-+-+
            |1|>|2|1|
            +-+-+-+-+
            |2|2|2|>|
            +-+-+-+-+
            |>|2|2|2|
            +-+-+-+-+
            |1|2|>|1|
            +-+-+-+-+
          RESULT
        end
      end

      describe 'Place a flag on a cell' do
        before do
          game.place_flags([3, 2])
        end

        it 'updates the game board' do
          subject.to_s.must_equal <<~RESULT
            Game: ^-^, Mines: 3
            ====================

            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|?|?|
            +-+-+-+-+
            |?|?|>|?|
            +-+-+-+-+
          RESULT
        end

        describe 'Place flag on flagged cell' do
          before do
            game.place_flags([3, 2])
          end

          it 'does not update the game board' do
            subject.to_s.must_equal <<~RESULT
              Game: ^-^, Mines: 3
              ====================

              +-+-+-+-+
              |?|?|?|?|
              +-+-+-+-+
              |?|?|?|?|
              +-+-+-+-+
              |?|?|?|?|
              +-+-+-+-+
              |?|?|>|?|
              +-+-+-+-+
            RESULT
          end
        end

        describe 'Place multiple flags' do
          before do
            game.place_flags([2, 3])
          end

          it 'updates the game board' do
            subject.to_s.must_equal <<~RESULT
              Game: ^-^, Mines: 2
              ====================

              +-+-+-+-+
              |?|?|?|?|
              +-+-+-+-+
              |?|?|?|?|
              +-+-+-+-+
              |?|?|?|>|
              +-+-+-+-+
              |?|?|>|?|
              +-+-+-+-+
            RESULT
          end
        end

        describe 'remove a flag' do
          before do
            game.remove_flag(3, 2)
          end

          it 'decrements the mine count' do
            subject.to_s.must_equal <<~RESULT
              Game: ^-^, Mines: 4
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
            game.remove_flag(2, 3)
          end

          it 'does not change the mine count' do
            subject.to_s.must_equal <<~RESULT
              Game: ^-^, Mines: 3
              ====================

              +-+-+-+-+
              |?|?|?|?|
              +-+-+-+-+
              |?|?|?|?|
              +-+-+-+-+
              |?|?|?|?|
              +-+-+-+-+
              |?|?|>|?|
              +-+-+-+-+
            RESULT
          end
        end
      end
    end
  end

  describe 'beginner game' do
    let(:game) { Game.new(9, 9) }
    subject { GameView.ascii(game) }

    before do
      game.place_mines(
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
        game.reveal(
          [0, 8],
          [2, 0],
          [8, 3]
        )
      end

      it 'should reveal neighbors' do
        subject.to_s.must_equal <<~RESULT
          Game: ^-^, Mines: 10
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
          |?|?|1|1|1|2|1|1| |
          +-+-+-+-+-+-+-+-+-+
          |?|?|2| | |1|?|1| |
          +-+-+-+-+-+-+-+-+-+
          |?|?|2| | |1|?|1| |
          +-+-+-+-+-+-+-+-+-+
        RESULT
      end

      describe 'flag and win' do
        before do
          game.place_flags(
            [0, 2],
            [1, 2],
            [2, 8],
            [3, 4],
            [7, 1],
            [7, 6],
            [8, 1]
          )

          game.reveal(
            [2, 2],
            [3, 2],
            [3, 3],
            [4, 4],
            [8, 6]
          )

          game.place_flags([5, 4])

          game.reveal(
            [4, 3],
            [5, 0],
            [5, 1],
            [5, 2],
            [5, 3],
            [6, 0],
            [6, 1],
            [7, 0],
            [8, 0]
          )

          game.place_flags([4, 2])
        end

        it 'should get close to winning' do
          subject.to_s.must_equal <<~RESULT
            Game: ^-^, Mines: 1
            ====================

            +-+-+-+-+-+-+-+-+-+
            | |2|>|2| | | | | |
            +-+-+-+-+-+-+-+-+-+
            | |2|>|2| | | |1|1|
            +-+-+-+-+-+-+-+-+-+
            | |1|1|2|1|1| |1|>|
            +-+-+-+-+-+-+-+-+-+
            |1|2|1|2|>|1| |1|1|
            +-+-+-+-+-+-+-+-+-+
            |?|?|>|3|2|2| | | |
            +-+-+-+-+-+-+-+-+-+
            |1|2|1|2|>|1| | | |
            +-+-+-+-+-+-+-+-+-+
            |1|1|1|1|1|2|1|1| |
            +-+-+-+-+-+-+-+-+-+
            |2|>|2| | |1|>|1| |
            +-+-+-+-+-+-+-+-+-+
            |2|>|2| | |1|1|1| |
            +-+-+-+-+-+-+-+-+-+
          RESULT
        end

        it 'can win in 2 moves by flagging revealing' do
          game.place_flags([4, 0])
          game.reveal([4, 1])

          subject.to_s.must_equal <<~RESULT
            Game: B-D, Mines: 0
            ====================

            +-+-+-+-+-+-+-+-+-+
            | |2|>|2| | | | | |
            +-+-+-+-+-+-+-+-+-+
            | |2|>|2| | | |1|1|
            +-+-+-+-+-+-+-+-+-+
            | |1|1|2|1|1| |1|>|
            +-+-+-+-+-+-+-+-+-+
            |1|2|1|2|>|1| |1|1|
            +-+-+-+-+-+-+-+-+-+
            |>|2|>|3|2|2| | | |
            +-+-+-+-+-+-+-+-+-+
            |1|2|1|2|>|1| | | |
            +-+-+-+-+-+-+-+-+-+
            |1|1|1|1|1|2|1|1| |
            +-+-+-+-+-+-+-+-+-+
            |2|>|2| | |1|>|1| |
            +-+-+-+-+-+-+-+-+-+
            |2|>|2| | |1|1|1| |
            +-+-+-+-+-+-+-+-+-+
          RESULT
        end

        it 'can win in 1 move by revealing' do
          game.reveal([4, 1])

          subject.to_s.must_equal <<~RESULT
            Game: B-D, Mines: 0
            ====================

            +-+-+-+-+-+-+-+-+-+
            | |2|>|2| | | | | |
            +-+-+-+-+-+-+-+-+-+
            | |2|>|2| | | |1|1|
            +-+-+-+-+-+-+-+-+-+
            | |1|1|2|1|1| |1|>|
            +-+-+-+-+-+-+-+-+-+
            |1|2|1|2|>|1| |1|1|
            +-+-+-+-+-+-+-+-+-+
            |>|2|>|3|2|2| | | |
            +-+-+-+-+-+-+-+-+-+
            |1|2|1|2|>|1| | | |
            +-+-+-+-+-+-+-+-+-+
            |1|1|1|1|1|2|1|1| |
            +-+-+-+-+-+-+-+-+-+
            |2|>|2| | |1|>|1| |
            +-+-+-+-+-+-+-+-+-+
            |2|>|2| | |1|1|1| |
            +-+-+-+-+-+-+-+-+-+
          RESULT
        end

        it 'can lose in 1 move by revealing' do
          game.reveal([4, 0])

          subject.to_s.must_equal <<~RESULT
            Game: ;_;, Mines: 1
            ====================

            +-+-+-+-+-+-+-+-+-+
            | |2|>|2| | | | | |
            +-+-+-+-+-+-+-+-+-+
            | |2|>|2| | | |1|1|
            +-+-+-+-+-+-+-+-+-+
            | |1|1|2|1|1| |1|>|
            +-+-+-+-+-+-+-+-+-+
            |1|2|1|2|>|1| |1|1|
            +-+-+-+-+-+-+-+-+-+
            |*|?|>|3|2|2| | | |
            +-+-+-+-+-+-+-+-+-+
            |1|2|1|2|>|1| | | |
            +-+-+-+-+-+-+-+-+-+
            |1|1|1|1|1|2|1|1| |
            +-+-+-+-+-+-+-+-+-+
            |2|>|2| | |1|>|1| |
            +-+-+-+-+-+-+-+-+-+
            |2|>|2| | |1|1|1| |
            +-+-+-+-+-+-+-+-+-+
          RESULT
        end

        it 'game continues if flag the wrong location' do
          game.place_flags([4, 1])

          subject.to_s.must_equal <<~RESULT
            Game: ^-^, Mines: 0
            ====================

            +-+-+-+-+-+-+-+-+-+
            | |2|>|2| | | | | |
            +-+-+-+-+-+-+-+-+-+
            | |2|>|2| | | |1|1|
            +-+-+-+-+-+-+-+-+-+
            | |1|1|2|1|1| |1|>|
            +-+-+-+-+-+-+-+-+-+
            |1|2|1|2|>|1| |1|1|
            +-+-+-+-+-+-+-+-+-+
            |?|>|>|3|2|2| | | |
            +-+-+-+-+-+-+-+-+-+
            |1|2|1|2|>|1| | | |
            +-+-+-+-+-+-+-+-+-+
            |1|1|1|1|1|2|1|1| |
            +-+-+-+-+-+-+-+-+-+
            |2|>|2| | |1|>|1| |
            +-+-+-+-+-+-+-+-+-+
            |2|>|2| | |1|1|1| |
            +-+-+-+-+-+-+-+-+-+
          RESULT
        end

        it 'can lose in 2 move by placing the wrong flag then revealing' do
          game.place_flags([4, 1])
          game.reveal([4, 0])

          subject.to_s.must_equal <<~RESULT
            Game: ;_;, Mines: 0
            ====================

            +-+-+-+-+-+-+-+-+-+
            | |2|>|2| | | | | |
            +-+-+-+-+-+-+-+-+-+
            | |2|>|2| | | |1|1|
            +-+-+-+-+-+-+-+-+-+
            | |1|1|2|1|1| |1|>|
            +-+-+-+-+-+-+-+-+-+
            |1|2|1|2|>|1| |1|1|
            +-+-+-+-+-+-+-+-+-+
            |*|X|>|3|2|2| | | |
            +-+-+-+-+-+-+-+-+-+
            |1|2|1|2|>|1| | | |
            +-+-+-+-+-+-+-+-+-+
            |1|1|1|1|1|2|1|1| |
            +-+-+-+-+-+-+-+-+-+
            |2|>|2| | |1|>|1| |
            +-+-+-+-+-+-+-+-+-+
            |2|>|2| | |1|1|1| |
            +-+-+-+-+-+-+-+-+-+
          RESULT
        end
      end
    end
  end
end
