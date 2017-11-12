require './formatter/results_formatter'

module Formatter
  RSpec.describe ResultsFormatter do
    describe '#print' do
      let(:outstream)  { StringIO.new }
      let(:result_hash) {
        {
          key1: 'value1',
          key2: 'value2',
          key3: 'value3',
          key4: 'value4',
          object: {}
        }
      }

      it 'should print a message for no results' do
        formatter = ResultsFormatter.new(nil, 'test')
        expect(STDOUT).to receive(:puts).with('No results found')
        formatter.print
      end

      it 'should print a header row' do
        formatter = ResultsFormatter.new([result_hash], 'value1')
        expect(outstream).to receive(:puts)
        formatter.print(outstream)
        result_hash.keys.reject { |key| key == :object }.each do |key|
          expect(outstream.string).to include(key.to_s)
        end
      end
    end
  end
end
