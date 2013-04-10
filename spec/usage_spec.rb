describe Variant do
  after { Object.send :remove_const, :My }

  example :using_blocks do
    module My
      include Variant
      
      class One < Variant
        accept { self == 1 }
      end

      class Many < Variant
        accept { |x| x > 1 }
      end

      class Other < Variant
        accept { true }
      end
    end

    My.variants.should have(3).classes
    My.choose(1).should == My::One
    My.choose(2).should == My::Many
    My.choose(-3).should == My::Other
  end


  example :using_params do
    module My
      include Variant
      
      class Num < Variant
        accept Integer
        accept 0..100
      end

      class Big < Variant
        accept Integer
      end

      class Other < Variant
        accept :all
      end
    end

    My.choose(1).should == My::Num
    My.choose(101).should == My::Big
    My.choose(0.1).should == My::Other
  end

  example :with_returns do
    module My
      include Variant

      class Variant < Variant # :)
        abstract!
        def initialize data; @data = data end
        attr_reader :data
      end
      
      class Num < Variant
        accept /^\d+$/
        returns &:to_i
      end

      class Wrap < Variant
        accept Range
        returns { Wrap.new self }
      end      

      class Other < Variant
        accept :all
        returns { nil }
      end

      class Never < Variant
        accept :all
        returns { raise }
      end      
    end  

    My.choose('123').should == 123
    My.choose(0..5).data.should == (0..5)
    My.choose(:abra).should == nil
  end

end

# value?
# accept a,b,c?
# priorities?