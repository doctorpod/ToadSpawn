# ToadSpawn

A basic persistent hash. Behaves similar to a normal hash but the key value
pairs persist between instantiations. The keys must be symbols and only 
strings, floats and fixnums can be stored as their original types, anything 
else is converted to a string. A simple file based store is used under the 
hood.

## Installation

Add this line to your application's Gemfile:

    gem 'toad_spawn'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install toad_spawn

## Usage

Say you want a simple key/value based persistent data store:

    whatever = ToadSpawn::Base.new('/path/folder/A') 
    
The path argument must be an existing, writable folder and gives the ToadSpawn
it's uniqueness. If you instantiate ToadSpawn with this path anywhere again, 
it will have the same data.

So later, or in another program:
    
    data = ToadSpawn::Base.new('/path/folder/A') 
    
    data[:string] = 'ant'
    data[:float]  = 1.2345
    data[:fixnum] = 1001
    
    data[:string] # => 'ant'
    data[:float]  # => 1.2345
    data[:fixnum] # => 1001
    
    another_spawn = ToadSpawn::Base.new('/path/folder/B')
    another_spawn.size  # => 0
    
These methods work just like in Hash:

    data.to_hash          # => {:string => 'ant', :float => 1.2345, :fixnum => 1001}
    data.empty?           # => false
    data.any?             # => true
    data.has_key?(:float) # => true
    data.has_value?(100)  # => false
    data.keys             # => [:string, :float, :fixnum]
    data.values           # => ['ant', 1.2345, 1001]
    data.size             # => 3
    data.delete(:float)   # => deletes the value and returns it: 1.2345
    data.clear            # => clears the ToadSpawn and returns {}

### Don't forget to flush!

Because ToadSpawn uses caching under the hood to improve performance, please 
be aware that it is not automatically mutiprocess safe - meaning that if a spawn is 
instantiated and another process opens the same spawn and changes an element,
that change will not be seen by the original spawn - until it is 
re-instantiated or the *flush* method is called to re-read the filesystem.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
