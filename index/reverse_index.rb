require_relative 'file_importer'
require 'logger'

module Index
  class ReverseIndex
    def initialize(filepath = 'index.dat')
      @logger = Logger.new('log/index.log')
      @filepath = filepath
      load_index
    end

    def add_file_to_index(file_name, document_type)
      @logger.info("Indexing file #{file_name}")
      index_array = FileImporter.import_json(file_name)
      index_array.each_with_index do |object, index|
        add_object_to_index(object, document_type, index)
      end
      sync_index_to_file
    end

    def search(query)
      @index[query.to_s.downcase.to_sym]
    end

    private

    def tokenize(object)
      # could do a lot more here
      if object.is_a?(Hash)
        tokenize(object.values)
      elsif object.is_a?(Array)
        object.map { |obj| tokenize(obj) }.flatten
      else
        object.to_s.downcase.split
      end
    end

    def add_object_to_index(object, document_type, document_position)
      @logger.debug("Adding object #{object}")
      object.each do |key, value|
        array_entry = {
          document_type: document_type,
          document_position: document_position,
          object: object
        }
        tokens = tokenize(value)
        tokens.each do |token|
          docs = @index[token.to_sym] || []
          unless docs.include? array_entry
            docs << array_entry
            @index[token.to_sym] = docs
          end
        end
      end
    end

    def sync_index_to_file
      # TODO make this async
      file = File.open(@filepath, 'w')
      Marshal.dump(@index, file)
      file.flush
    end

    def load_index
      if File.exist?(@filepath)
        begin
          @index = Marshal.load(File.open(@filepath))
        rescue Exception => e
          FileUtils.cp @filepath, "#{@filepath}.corrupt.#{Time.now}"
          @logger.error('Existing index was corrupt. Creating new index. Old index has been backed up.')
          @logger.error(e)
          @index = {}
        end
      else
        @index = {}
      end
    end
  end
end