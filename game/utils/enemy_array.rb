module Game
  module Utils
    # Proxy class to represent an Array of Enemy instances.
    # Adds two metods to filter the state of the enemies: 
    #   +bound
    #   +unbound
    class EnemyArray
      def initialize
        @enemies = []
      end

      def bound
        @enemies.select{|e| e.bound?}
      end

      def unbound
        @enemies.select{|e| not e.bound?}
      end

      protected
      def method_missing(name, *args, &block)
        target.send(name, *args, &block)
      end

      def target
        @enemies ||= []
      end
    end
  end
end