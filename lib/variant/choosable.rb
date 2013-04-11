module Variant

  # extending by this module modifies target.included, so
  # when that module is included we can do stuff, so
  # this module is for including in other modules, that will be included elsewhere...
  # not sure is it cool practice, but it works
  module Choosable
    def included target
      super
      target.send :include, InstanceMethods
      target.extend ClassMethods
    end    
  end


  module InstanceMethods
    def choose(*a,&b); self.class.choose(*a,&b) end
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