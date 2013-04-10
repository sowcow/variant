require "variant/version"

module Variant

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
      @returns ? object.instance_eval(&@returns) : self
    end

    def self.abstract!
      @abstract = true
    end
    def self.abstract?
      @abstract
    end
  end
  
  def self.included target
    target.extend ClassMethods
  end

  module ClassMethods
    def choose object
      variants.find { |x| x.accept_this? object }.return! object
    end

    def variants
      constants.map { |x| const_get x }.
                select { |x| x.is_a? Class }.
                select { |x| x < Variant }.
                reject { |x| x.abstract? }
    end
  end
end
