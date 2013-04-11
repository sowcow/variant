module Variant
  extend Choosable

  class Variant
    ALL = proc { true }
    NIL = Object.new

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

    def self.returns param=NIL, &block
      if    (param != NIL) && !block; @returns = param; @returns_is_set = true
      elsif block && (param == NIL);  @returns = block; @returns_is_set = true
      else
        raise 'shit! i take only param or only block at once!'
      end
    end

    def self.return! object
      # @returns ? object.instance_eval(&@returns) : self
      # @returns.call(object)
      @returns_is_set ? try_to_call(@returns, object) : self
    end

    def self.abstract!
      @abstract = true
    end
    def self.abstract?
      @abstract
    end

    private
    def self.try_to_call any, *a
      any.respond_to?(:call) ? any.call(*a) : any
    end    
  end
end