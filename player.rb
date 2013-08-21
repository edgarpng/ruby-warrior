require 'game/warrior'

class Player
  attr_reader :warrior

  def initialize
    @warrior = Game::Warrior.new
  end

  def play_turn(turn)
    # The warrior can only do one thing each turn, but the strategy
    # defines several actions, so most likely it will raise an
    # Exception. Fells dirty and it should be natural. Needs refactoring.
    begin
      warrior.update turn
    rescue
    end
  end
end