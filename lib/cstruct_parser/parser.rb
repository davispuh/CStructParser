# frozen_string_literal: true

require 'ffi_generator'
require 'stringio'
require 'tempfile'
require_relative 'bindata'

module CStructParser
    class Parser

        attr_reader :generator

        def initialize(options = {})
            @options = { module_name: 'CStructModule', endian: :little, indent: 2 }.merge(options)
            @generator = nil
        end

        def load!(headers)
            @options[:headers] = headers
            @options[:headers] = [@options[:headers]] unless @options[:headers].is_a?(Array)
            @generator = FFIGenerate::Generator.new(@options)
            @generator.declarations
            @generator
        end

        def parse!(data)
            if isFile(data)
                load!(data)
            else
                Tempfile.create('struct.h') do |file|
                    file.write(data)
                    file.flush
                    load!(file.path)
                end
            end
            @generator
        end

        def declarations
            return nil unless @generator
            @generator.declarations
        end

        def to_ffi
            @generator.generate_rb
        end

        def to_bindata
            BinData.generate_rb(@generator.declarations, @options)
        end

        def to_pack
            # TODO
            # Ruby String#unpack / Array#pack format
            raise 'Not Implemented!'
        end

        def to_binarystruct
            # TODO
            # https://github.com/ManageIQ/binary_struct
            raise 'Not Implemented!'
        end

        protected

        def isFile(data)
            data.to_s.lines.count == 1 && File.exist?(data.to_s)
        end
    end
end
