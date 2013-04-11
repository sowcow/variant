module Variant
  module Wrap
    extend IsChoosable

    class Variant < Variant
      def initialize object
        @object = object
      end
      attr_reader :object

      def self.return! object
        @returns ? super : new(object)
      end
    end
  end
end