require 'game'

class Player

  def play_turn(turn)
    begin
      warrior = Game::Warrior.new turn
      warrior.kill_nearby_enemies
      warrior.walk_towards_stairs
    rescue
    end
  end
end