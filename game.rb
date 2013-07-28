module Game
  DIRECTIONS = [:left, :right, :forward, :backward]

  class Warrior

    MAX_HEALTH = 20

    def initialize(turn)
      @turn = turn
      @captives = []
      @enemies = []
      turn.listen do |direction|
        if direction.enemy?
          @enemies << Enemy.new(direction)
        else
          @captives << Captive.new(direction)
        end
      end
    end

    def play_turn(turn)
      @turn = turn
      @enemies.filter(:not_bound).each do |enemy|
        bind enemy
      end

      @enemies.filter(:bound).each do |enemy|
        attack enemy
      end
      
      @captives.each do |enemy|
        self.rescue captive 
      end

      rest if @enemies.empty? && received_damage?

      walk_towards_stairs
    end

    def walk_towards_stairs
      @turn.walk! @turn.direction_of_stairs
    end

    def attack(enemy)
      @turn.attack! enemy.direction
      if @turn.feel.enemy? enemy.direction
        @enemies.remove enemy
      end
    end

    def bind(enemy)
      @turn.bind! enemy.direction
      enemy.bound = true
    end

    def rescue(captive)
      @turn.rescue! captive.direction
      captive.rescued = true
    end

    def rest
      @turn.rest!
    end

    def received_damage?
      @turn.health < MAX_HEALTH
    end
  end
end