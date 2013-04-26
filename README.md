# Variant

it can be useful if you think that case/when smells or isn't powerful enough

example from specs:
```ruby
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
