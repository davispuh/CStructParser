# CStructParser

Parse C structs into usable Ruby objects like BinData records.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add CStructParser
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install CStructParser
```

## Usage

### For usage with [FFI](https://github.com/ffi/ffi)
```ruby
require 'cstruct_parser'
sourceCode = 'struct s { int a; float b; };' # Can be path to file aswell
CStructParser.to_ffi(sourceCode)
# class S < FFI::Struct
#   layout :a, :int,
#          :b, :float
# end
```

### For usage with [BinData](https://github.com/dmendel/bindata)
```ruby
CStructParser.to_bindata('stuff.h')
# class S < BinData::Record
#  endian :little
#  int32 :a
#  float :b
#end
```

### Other use cases

Not implemented, but should be quite simple to add support for other uses like [BinaryStruct](https://github.com/ManageIQ/binary_struct), `String#unpack` format etc.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davispuh/CStructParser.
