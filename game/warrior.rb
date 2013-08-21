require 'game/enemy'
require 'game/captive'
require 'game/utils/enemy_array'

module Game
  DIRECTIONS = [:left, :right, :forward, :backward]

  # Contains the main strategies and actions a warrior can take.
  # It keeps the state of the turns played, allowing it to react
  # to health damage. In addition, it keeps track of enemies and
  # captives in its immediate sorroundings.
  # TODO: This class is huge. Separate methods into smaller
  # classes.
  class Warrior
    attr_reader :turn
    attr_accessor :enemies, :captives, :last_attack
    MAX_HEALTH = 20

    # Updates logic and state of the warrior. Must be called on
    # each turn.
    def update(t)
      @turn = t
      strategy()
    end

    protected
    # Defines important things the warrior must do in a given turn,
    # sorted by order of priority (it can only take one action per
    # turn)
    def strategy
      look_around unless surrounded?
      surrounded_strategy if surrounded?
      rest if received_damage?
      if found_captives?
        rescue_captive captives.first
      end
      walk_to next_objective || stairs
    end

    # Defines what to do if there are enemies on every direction
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

    # Senses each direction, storing enemies found to deal with
    # them later if necessary
    def look_around
      @captives = []
      @enemies = Utils::EnemyArray.new
      
      DIRECTIONS.each do |direction|
        space = turn.feel direction
        if space.enemy?
          @enemies << Enemy.new(direction)
        elsif space.captive?
          @captives << Captive.new(direction)
        end
      end
    end

    # Decides where the next objective is, which could be a slug or a
    # captive
    def next_objective
      next_obj = turn.listen.first
      return unless next_obj
      next_direction = turn.direction_of next_obj
      if turn.feel(next_direction).stairs?
        empty_directions = DIRECTIONS.select do |dir|
          turn.feel(dir).empty?
        end
        empty_directions.first
      else
        next_direction
      end
    end

    def walk_to(direction)
      turn.walk! direction
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