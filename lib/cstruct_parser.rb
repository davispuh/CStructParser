# frozen_string_literal: true

require_relative 'cstruct_parser/version'
require_relative 'cstruct_parser/parser'


module CStructParser
    class Error < StandardError; end

    def self.load(headers, options = {})
        parser = Parser.new(options)
        parser.load!(headers)
        parser
    end

    def self.parse(data, options = {})
        parser = Parser.new(options)
        parser.parse!(data)
        parser
    end

    def self.to_ffi(data, options = {})
        self.parse(data, options).to_ffi
    end

    def self.to_bindata(data, options = {})
        self.parse(data, options).to_bindata
    end

    def self.to_pack(data, options = {})
        self.parse(data, options).to_pack
    end

    def self.to_binarystruct(data, options = {})
        self.parse(data, options).to_binarystruct
    end

end
