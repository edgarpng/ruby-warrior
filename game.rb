module Game
  DIRECTIONS = [:left, :right, :forward, :backward]

  class Warrior

    def initialize(warrior)
      @warrior = warrior
    end

    def walk_towards_stairs
      @warrior.walk! @warrior.direction_of_stairs
    end

    def kill_nearby_enemies
      Game::DIRECTIONS.each do |direction|
        if @warrior.feel(direction).enemy?
          @warrior.attack! direction
        end
      end
    end
    
  end
end