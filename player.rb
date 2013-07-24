require 'game'

class Player

  def initialize
    @warrior = Game::Warrior.new
  end

  def play_turn(turn)
    begin
      @warrior.play_turn turn
      @warrior.attack_nearby_enemies || @warrior.rest
      @warrior.walk_towards_stairs
    rescue
    end
  end
end