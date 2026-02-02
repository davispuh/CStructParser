# frozen_string_literal: true

RSpec.describe CStructParser do
    it 'has a version number' do
        expect(CStructParser::VERSION).not_to be nil
    end

    let (:simpleStruct) {
        %{
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
    }

    describe '#to_ffi' do
        it 'can parse simple C struct for FFI' do
            ffi = CStructParser.to_ffi(simpleStruct)
            expect(ffi).to include('class Elf64Ehdr < FFI::Struct')
            expect(ffi).to include('layout :e_ident, [:uchar, 16]')
            expect(ffi).to include(':e_type, :ushort')
            expect(ffi).to include(':e_machine, :ushort')
            expect(ffi).to include(':e_version, :uint')
            expect(ffi).to include(':e_entry, :ulong')
        end
    end

    describe '#to_bindata' do
        it 'can parse simple C struct for BinData' do
            ffi = CStructParser.to_bindata(simpleStruct)
            expect(ffi).to include('class Elf64Ehdr < BinData::Record')
            expect(ffi).to include('array :e_ident, type: :uint8, initial_length: 16')
            expect(ffi).to include('uint16 :e_type')
            expect(ffi).to include('uint16 :e_machine')
            expect(ffi).to include('uint32 :e_version')
            expect(ffi).to include('uint64 :e_entry')
        end
    end

end
