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
        returns { |x| new x }
      end      

      class Other < Variant
        accept :all
        returns nil
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

  example :with_wrapping do
    module My
      include Variant::Wrap
      
      class Num < Variant
        accept /^\d+$/
        
        def data
          object.to_i
        end
      end

      class Range < Variant
        accept /^\d+\.\.\d+$/

        def data
          ::Range.new *object.scan(/\d+/).map(&:to_i)
        end
      end      

      class Other < Variant
        accept :all
        returns { raise }
      end
    end   

    My.choose('123').data.should == 123
    My.choose('0..5').data.should == (0..5)
    expect { My.choose(:abra) }.to raise_error
  end

  example :with_class do
    
    class My < Struct.new :objects
      def format
        objects.map { |x| choose x }.compact
      end

      include Variant

      class Num < Variant
        accept Numeric
        returns { |x| {numeric: x} }
      end

      class Str < Variant
        accept String
        returns { |x| {string: x} }
      end

      class Other < Variant
        accept :all
        returns nil
        # returns { |x| raise "... #{x.inspect}" }
      end       
    end

    My.new([1,'2',:bla,:bla,:bla]).format.should == [{numeric: 1}, {string: '2'}]
  end

  # example 'with use of: any, all' do
  #   module My
  #     include Variant

  #     class Collection
  #       accept any(Array, Set)
  #       returns ','
  #     end
  #     class Pattern
  #       accept any(Regexp, Range)
  #       returns '~'
  #     end
  #     class Positive
  #       accept any(
  #                all(String, proc { match /(good|nice)/ }),
  #                all(Integer, proc { self > 0 })
  #              )
  #       returns '+'
  #     end
  #     class Negative
  #       accept any(
  #                all(String, proc { match /crap/ }),
  #                all(Integer, proc { self < 0 })
  #              )
  #       returns '-'
  #     end      
  #     class Other
  #       accept :all
  #       returns nil
  #     end
  #   end

  #   My.choose("it\'s nice to meet you").should == '+'
  # end

end

# value?
# accept a,b,c?
# priorities?
# extra agility by include/extend , not subclassing?
# choose one, if more - raise ?