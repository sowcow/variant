module Variant
  extend Choosable

  # all methods are classmethods...
  # is it cool?
  class Variant
    extend Matchers
    ALL = proc { true }
    NONE = Object.new # sort of nil

    def self.accept param=NONE, &block
      raise 'shit! i take only param or only block at once!' if (given? param) == (!!block)

      (@accepts ||= []) <<  case
                            when block then block
                            when param == :all then ALL
                            when param then param
                            else
                              raise 'impossible!'
                            end
    end

    def self.accepts(*a,&b)
      accept(*a,&b)
    end

    def self.accept_this? object
      @accepts.all? { |criteria| match? object, criteria }
    end

    def self.returns param=NONE, &block
      if    given?(param) && !block; @returns = param; @returns_is_set = true
      elsif block && !given?(param); @returns = block; @returns_is_set = true
      else
        raise 'shit! i take only param or only block at once!'
      end
    end

    def self.return! object
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
    def self.given? given
      not given == NONE
    end    
  end
end