require 'enemy'
require 'enemy_array'
require 'captive'

module Game
  DIRECTIONS = [:left, :right, :forward, :backward]

  class Warrior
    attr_reader :turn
    attr_accessor :enemies, :captives, :last_attack
    MAX_HEALTH = 20

    def update(t)
      @turn = t
      strategy()
    end

    protected
    def strategy
      look_around
      surrounded_strategy if surrounded?
      rest if received_damage?
      if found_captives?
        rescue_captive captives.first
      end
      walk_to (objectives.first || stairs)
    end

    def surrounded_strategy
      unbound = enemies.unbound
      if unbound.size > 1
        bind unbound.first
      end
      attack unbound.first
      rest if received_damage?
      attack enemies.bound.first
    end

    def surrounded?
      enemies && !enemies.empty?
    end

    def found_captives?
      captives && !captives.empty?
    end

    def look_around
      @captives = []
      @enemies = Wrappers::EnemyArray.new
      
      DIRECTIONS.each do |direction|
        space = turn.feel direction
        if space.enemy?
          @enemies << Enemy.new(direction)
        elsif space.captive?
          @captives << Captive.new(direction)
        end
      end
    end

    def objectives
      turn.listen
    end

    def walk_to(direction)
      if direction.class == Symbol
        turn.walk! direction
      else
        turn.walk! turn.direction_of(direction)
      end
    end

    def stairs
      turn.direction_of_stairs
    end

    def attack(enemy)
      return if !enemy
      if enemy.killed_by? self
        enemies.delete enemy
      else
        turn.attack! enemy.direction
        enemy.bound = false
      end
      @last_attack = enemy.direction
    end

    def bind(enemy)
      turn.bind! enemy.direction
      enemy.bound = true
    end

    def rescue_captive(captive)
      return if !captive
      turn.rescue! captive.direction
      captives.delete captive
    end

    def rest
      turn.rest!
    end

    def received_damage?
      turn.health < MAX_HEALTH
    end
  end
end