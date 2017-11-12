module Index
  class FileImporter
    require 'json'

    def self.import_json(file_name)
      file = File.read(file_name)
      JSON.parse(file)
    end
  end
end
