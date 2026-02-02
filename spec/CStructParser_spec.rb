# frozen_string_literal: true

RSpec.describe CStructParser do
    it 'has a version number' do
        expect(CStructParser::VERSION).not_to be nil
    end

    let (:simpleStruct) { 'struct simple { int a; float b; };' }

    describe '#to_ffi' do
        it 'can parse simple C struct for FFI' do
            ffi = CStructParser.to_ffi(simpleStruct)
            expect(ffi).to include('class Simple < FFI::Struct')
            expect(ffi).to include('layout :a, :int')
            expect(ffi).to include(':b, :float')
        end
    end

    describe '#to_bindata' do
        it 'can parse simple C struct for BinData' do
            ffi = CStructParser.to_bindata(simpleStruct)
            expect(ffi).to include('class Simple < BinData::Record')
            expect(ffi).to include('int32 :a')
            expect(ffi).to include('float :b')
        end
    end

end
