require './index/reverse_index'

module Index
  RSpec.describe ReverseIndex do
    let(:index_file) { 'spec/tmp/index.dat' }

    after(:each) do
      FileUtils.rm index_file
    end

    describe '#add_file_to_index' do
      context 'with no existing index' do
        it 'should create an index' do
          index = ReverseIndex.new(index_file)
          index.add_file_to_index('spec/fixtures/projects.json', 'project')
          expect(File.size?(index_file)).to_not be_nil
        end
      end

      context 'with a corrupt index' do
        it 'should delete the corrupt index and start a new one' do
          FileUtils.cp 'spec/fixtures/broken_index.dat', index_file
          index = ReverseIndex.new(index_file)
          index.add_file_to_index('spec/fixtures/projects.json', 'project')
          expect(File.size?(index_file)).to_not be_nil
        end
      end

      context 'with an existing index' do
        let(:index) { ReverseIndex.new(index_file) }

        before(:each) do
          index.add_file_to_index('spec/fixtures/projects.json', 'project')
        end

        it 'should not re-index existing entries' do
          size_before_reindex = File.size?(index_file)
          index.add_file_to_index('spec/fixtures/projects.json', 'project')
          expect(File.size?(index_file)).to eq size_before_reindex
        end
      end
    end

    describe '#search' do
      let(:index) { ReverseIndex.new(index_file) }

      before(:each) do
        index.add_file_to_index('spec/fixtures/projects.json', 'project')
      end

      it 'should find expected results' do
        result = index.search("project")
        expect(result.size).to eq 2
      end
    end
  end
end