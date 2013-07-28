module Game
  module Wrappers
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