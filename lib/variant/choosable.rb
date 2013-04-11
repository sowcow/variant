module Variant
  module Choosable
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

  module IsChoosable
    def included target
      target.extend Choosable # call super?
    end    
  end
end