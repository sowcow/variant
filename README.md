# Variant

it can be useful if you think that case/when smells or not powerful enough

example from specs:
```ruby
class My < Struct.new :objects
  def format
    objects.map { |x| choose x }
  end

  include Variant

  class Num < Variant
    accepts Numeric # takes block or uses === matching
    returns { |x| {numeric: x} }
  end

  class Str < Variant
    accepts String
    returns { |x| {string: x} }
  end

  class Other < Variant
    accepts :all
    returns { |x| raise "unknown object given: #{x.inspect}" }
  end       
end

My.new([1, '2', 3, '4']).format.should == [{numeric: 1}, {string: '2'}, {numeric: 3}, {string: '4'}]
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
