module Game
  class Enemy
    attr_accessor :bound, :direction
    alias_method :bound?, :bound
    
    def initialize(direction)
      @direction = direction
    end

    def killed_by?(warrior)
      !warrior.turn.feel(direction).enemy? && warrior.last_attack == direction
    end
  end
end