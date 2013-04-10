# Variant

basic example from specs:
```ruby
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
```

## Installation

Add this line to your application's Gemfile:

    gem 'variant'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install variant

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
