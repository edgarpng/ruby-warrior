require 'warrior'

class Player
  attr_reader :warrior

  def initialize
    @warrior = Game::Warrior.new
  end

  def play_turn(turn)
    begin
      warrior.update turn
    rescue      
    end
  end
end