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

sourceCode = %{
  #include <stdint.h>

  #define EI_NIDENT (16)

  typedef uint64_t Elf64_Addr;
  typedef uint16_t Elf64_Half;
  typedef uint32_t Elf64_Word;

  typedef struct
  {
    unsigned char e_ident[EI_NIDENT];
    Elf64_Half e_type;
    Elf64_Half e_machine;
    Elf64_Word e_version;
    Elf64_Addr e_entry;
  } Elf64_Ehdr;
}

# Note that you can specify path to C header file instead of passing string
CStructParser.to_ffi(sourceCode)
# class Elf64Ehdr < FFI::Struct
#   layout :e_ident, [:uchar, 16],
#          :e_type, :ushort,
#          :e_machine, :ushort,
#          :e_version, :uint,
#          :e_entry, :ulong
# end
```

### For usage with [BinData](https://github.com/dmendel/bindata)
```ruby
records = CStructParser.to_bindata('stuff.h')
# class Elf64Ehdr < BinData::Record
#  endian :little
#  array :e_ident, type: :uint8, initial_length: 16
#  uint16 :e_type
#  uint16 :e_machine
#  uint32 :e_version
#  uint64 :e_entry
#end
require 'bindata'
# Currently we get it as string so need to require/eval but it would be better to implement that objects are directly created
eval(records)
Elf64Ehdr.read(File.open('/bin/ruby'))
# => {e_ident: [127, 69, 76, 70, 2, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0], e_type: 3, e_machine: 62, e_version: 1, e_entry: 4272}
```

### Other use cases

Not implemented, but should be quite simple to add support for other uses like [BinaryStruct](https://github.com/ManageIQ/binary_struct), `String#unpack` format etc.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davispuh/CStructParser.
