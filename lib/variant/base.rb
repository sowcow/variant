module Variant
  extend IsChoosable

  class Variant
    ALL = proc { true }

    def self.accept param=nil, &block
      if    param && !block; param == :all ? accept(&ALL) : accept { param === self }
      elsif block && !param; (@accepts ||= []) << block
      else
        raise 'shit! i take only param or only block at once!'
      end
    end

    def self.accepts(*a,&b)
      accept(*a,&b)
    end

    def self.accept_this? object
      @accepts.all? { |check| object.instance_eval &check }
    end

    def self.returns &block
      @returns = block
    end

    def self.return! object
      # @returns ? object.instance_eval(&@returns) : self
      @returns ? @returns.call(object) : self
    end

    def self.abstract!
      @abstract = true
    end
    def self.abstract?
      @abstract
    end
  end
end