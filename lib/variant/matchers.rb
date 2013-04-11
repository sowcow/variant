module Variant

  # to replace respond_to with refinements?
  module Matchers

    # uses instance eval for block or === otherwise
    # instance_eval is kind of sugar...
    def match? object, criteria
      criteria.respond_to?(:call) ? object.instance_eval(&criteria) : criteria === object
    end

    def all *a
      matcher = method(:match?) # cuz instance_eval...
      proc { |object| a.all? { |criteria| matcher.call object, criteria }  }
    end
    def any *a
      matcher = method(:match?) # cuz instance_eval...
      proc { |object| a.any? { |criteria| matcher.call object, criteria }  }
    end
  end
end