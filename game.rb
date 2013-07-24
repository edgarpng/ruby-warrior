module Game
  DIRECTIONS = [:left, :right, :forward, :backward]

  class Warrior

    MAX_HEALTH = 20

    def play_turn(turn)
      @turn = turn
    end

    def walk_towards_stairs
      @turn.walk! @turn.direction_of_stairs
    end

    def attack_nearby_enemies
      Game::DIRECTIONS.each do |direction|
        if @turn.feel(direction).enemy?
          @turn.attack! direction
          return true
        end
      end
      false
    end

    def rest
      @turn.rest! if received_damage?
    end

    def received_damage?
      @turn.health < MAX_HEALTH
    end
  end
end