require_relative 'index/reverse_index'
require_relative 'formatter/results_formatter'
require 'optparse'

class Options
  def self.parse(args)
    options = OpenStruct.new
    options.index_file = 'index.dat'
    options.file = ''

    opt_parser = OptionParser.new do |opts|
      opts.on('-i', '--index_file', 'Specify where to store the index') do index
        options.index_file = index
      end

      opts.on('-f', '--file', 'Specify an aditional_file_to_index') do file
        options.file = file
      end

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end
end

options = Options.parse(ARGV)
index = Index::ReverseIndex.new(options.index_file)
index.add_file_to_index('projects.json', :project)
index.add_file_to_index('users.json', :user)
index.add_file_to_index(options.file, :custom) unless options.file.empty?

puts 'Enter search term: '
search_string = gets

results = index.search(search_string.chomp)
Formatter::ResultsFormatter.new(results, search_string).print
