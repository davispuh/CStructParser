require 'stringio'

module CStructParser::BinData

    TYPES = {
        :bool        => :bit1,
        :char        => :int8,
        :s_char      => :int8,
        :char_s      => :int8,
        :u_char      => :uint8,
        :short       => :int16,
        :u_short     => :uint16,
        :int         => :int32,
        :u_int       => :uint32,
        :long_long   => :int64,
        :u_long_long => :uint64,
        :float       => :float,
        :double      => :double,
        :long_double => :long_double
    }

    TYPES_32 = {
        :long        => :int32,
        :u_long      => :uint32
    }

    TYPES_64 = {
        :long        => :int64,
        :u_long      => :uint64
    }

    def self.toBinDataType(type, options)
        if type.is_a?(FFIGenerate::Generator::PrimitiveType)
            types = TYPES.merge(options[:long32] ? TYPES_32 : TYPES_64)
            raise "Unknown primitive type #{type.clang_type}" unless types.include?(type.clang_type)
            types[type.clang_type]
        elsif type.is_a?(FFIGenerate::Generator::StringType)
            :string
        elsif type.is_a?(FFIGenerate::Generator::ArrayType)
            :array
        elsif type.is_a?(FFIGenerate::Generator::ByValueType)
            type.name.to_ruby_downcase
        elsif type.is_a?(FFIGenerate::Generator::StructOrUnion)
            ('p' + type.ruby_name).to_sym
        elsif type.is_a?(FFIGenerate::Generator::PointerType)
            types = TYPES.merge(options[:long_32] ? TYPES_32 : TYPES_64)
            typeName = type.ruby_name
            typeName = 's_char' if typeName == 'schar'
            typeName = 'u_char' if typeName == 'uchar'
            typeName = 'u_short' if typeName == 'ushort'
            typeName = 'u_int' if typeName == 'uint'
            typeName = 'u_long' if typeName == 'ulong'
            typeName = 'long_long' if typeName == 'longlong'
            typeName = 'u_long_long' if typeName == 'ulonglong'
            typeName = 'long_double' if typeName == 'longdouble'
            typeName = types[typeName.to_sym].to_s if types.include?(typeName.to_sym)
            ('p' * type.depth + typeName).to_sym
        else
            raise "Unexpected type #{type}"
        end
    end

    def self.buildField(field, attributes, i, options, indent = 2)
        params = []
        if field[:type].is_a?(FFIGenerate::Generator::ArrayType)
            typeName = 'array'
            elementType = toBinDataType(field[:type].element_type, options)
            params << ['type', ':' + elementType.to_s].join(': ')
            params << ['initial_length', field[:type].constant_size].join(': ')
        else
            typeName = toBinDataType(field[:type], options)
        end
        if attributes[:aligned]
            params << ['byte_align', attributes[:aligned]].join(': ')
        end
        fieldName = field[:name] ? field[:name].to_ruby_downcase : 'field' + (i + 1).to_s
        comment = ''
        comment = " # #{field[:comment].join(' ')}" unless field[:comment].empty?
        ' ' * indent + "#{typeName} :#{fieldName}#{params.empty? ? '' : ', ' + params.join(', ')}#{comment}\n"
    end

    def self.generate_rb(declarations, options = {})
        result = StringIO.new
        indent = options[:indent].to_i
        declarations.each do |declaration|
            if declaration.is_a?(FFIGenerate::Generator::StructOrUnion)
                name = declaration.name.format(:downcase, :camelcase, FFIGenerate::Generator::Name::RUBY_KEYWORDS)
                classLine = "class #{name} < BinData::Record\n"
                classLine += ' ' * indent + "endian :#{options[:endian]}\n"
                classLine += ' ' * indent + "# TODO Choice/Union\n" if declaration.union?
                result << classLine
                declaration.fields.each_with_index do |field, i|
                    fieldLine = buildField(field, declaration.attributes, i, options, declaration.union? && i > 0 ? 0 : indent)
                    fieldLine = ' ' * indent + '# ' + fieldLine if declaration.union? && i > 0
                    result << fieldLine
                end
                result << "end\n\n"
            end
        end
        result.string
    end
end
