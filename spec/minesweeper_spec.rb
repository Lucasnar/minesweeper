require "minesweeper"

describe Minesweeper do

  describe ".new" do
    context "initialization" do
      it "should have still_playing? as true" do
        game = Minesweeper.new
        expect(game.still_playing?).to be true
      end
      it "should have victory? as false" do
        game = Minesweeper.new
        expect(game.victory?).to be false
      end
      it "should have a method called play" do
        game = Minesweeper.new
        expect(game.respond_to? :play).to be true
      end
      it "should have a method called flag" do
        game = Minesweeper.new
        expect(game.respond_to? :flag).to be true
      end
      it "should have a method called victory?" do
        game = Minesweeper.new
        expect(game.respond_to? :victory?).to be true
      end
      it "should have a method called board_state" do
        game = Minesweeper.new
        expect(game.respond_to? :board_state).to be true
      end
    end

    context "no arguments given" do
      it "should create new game" do
        game = Minesweeper.new
        expect(defined? game).to be_truthy
      end
    end
    context "arguments given" do
      it "should create new game" do
        game = Minesweeper.new(5, 5, 3)
        expect(defined? game).to be_truthy
      end
    end
    context "given more mines than cells" do
      it "should raise an ArgumentError" do
        expect{Minesweeper.new(3, 3, 10)}.to raise_error(ArgumentError)
      end
    end
  end

  describe ".play" do
    context "given a board with no mines" do
      it "should end the game in one movement due to the expansion" do
        game = Minesweeper.new(5, 5, 0)
        game.play(0, 0)
        expect(game.still_playing?).to be false
      end
      it "should win the game due to the expansion" do
        game = Minesweeper.new(5, 5, 0)
        game.play(3, 4)
        expect(game.victory?).to be true
      end
      it "should return false after the first movement (game ended)" do
        game = Minesweeper.new(5, 5, 0)
        game.play(0, 0)
        expect(game.play(0, 2)).to be false
      end
    end
    context "given any board" do
      it "should be able to perform at least one movement" do
        game = Minesweeper.new(10, 10, 30)
        expect(game.play(8, 5)).to be true
      end
      it "should not be able to perform a movement in a previous selected cell (game still playing)" do
        game = Minesweeper.new(10, 10, 1)
        game.play(0, 0)
        while (!game.still_playing?)
          game = Minesweeper.new(10, 10, 1)
          game.play(0, 0)
        end
        expect(game.play(0, 0)).to be false
      end
      it "should consider any movement as invalid after a mine was selected" do
        game = Minesweeper.new(4, 4, 16)
        game.play(0, 0)
        expect(game.play(3, 3)).to be false
      end
    end
  end

  describe ".flag" do
    context "given any board" do
      it "should be able to flag any hidden cell" do
        game = Minesweeper.new(10, 10, 10)
        expect(game.flag(3, 3)).to be true
      end
      it "should be able to flag a cell twice (flag and unflag)" do
        game = Minesweeper.new(5, 5, 3)
        game.flag(2, 3)
        expect(game.flag(2, 3)).to be true
      end
      it "should be able to flag and unflag a cell many times" do
        game = Minesweeper.new(5, 5, 3)
        game.flag(2, 3)
        game.flag(2, 3)
        game.flag(2, 3)
        expect(game.flag(2, 3)).to be true
      end
      it "should not be able to flag a revealed cell (game must be still playing)" do
        game = Minesweeper.new(10, 10, 1)
        game.play(3, 3)
        while(!game.still_playing?)
          game = Minesweeper.new(10, 10, 1)
          game.play(3, 3)
        end
        expect(game.flag(3, 3)).to be false
      end
      it "should consider any movement as invalid after a mine was selected" do
        game = Minesweeper.new(4, 4, 16)
        game.play(0, 0)
        expect(game.flag(3, 3)).to be false
      end
    end
  end

  describe ".still_playing?" do
    context "given a board with no mines" do
      it "should end the game in one movement (due to the expansion)" do
        game = Minesweeper.new(5, 5, 0)
        game.play(0, 0)
        expect(game.still_playing?).to be false
      end
    end
  end

  describe ".victory?" do
    context "given a board with no mines" do
      it "should win the game (due to the expansion)" do
        game = Minesweeper.new(5, 5, 0)
        game.play(3, 4)
        expect(game.victory?).to be true
      end
    end
  end
end
