module Formatter
  class ResultsFormatter

    require 'byebug'

    def initialize(results, search_term)
      @results = results
      @search_term = search_term
      @keys = identify_keys(results)
      @max_size = @keys&.map(&:size)
    end

    def print(output_stream=STDOUT)
      if @results.nil? || @results.empty?
        output_stream.puts 'No results found'
        return
      end
      output = @results.map do |result|
        format_results(result)
      end
      print_keys(output_stream)
      output_stream.puts output
    end

    private

    def print_keys(output_stream)
      keys = []
      @keys.each_index { |index| keys << @keys[index].to_s.center(@max_size[index]) }
      output_stream.print keys.join(' | ')
      output_stream.print('\n')
    end

    def format_results(result)
      output_array = Array.new(@keys.size+1)
      result.each do |key, value|
        index = @keys.index(key)
        if index
          if @max_size[index] > value.to_s.size
            value = value.to_s.center(@max_size[index])
          else
            @max_size[index] = value.to_s.size
          end
          output_array[index] = value
        elsif key == :object
          value.each do |k, v|
            i = @keys.index(k)
            if @max_size[i] > v.to_s.size
              v = v.to_s.center(@max_size[i])
            else
              @max_size[i] = v.to_s.size
            end
            output_array[i] = v if i
          end
        end
      end
      output_array.join(' | ')
    end

    def identify_keys(results)
      results&.map do |entry|
        keys = entry.keys.reject { |key| key == :object }
        keys << entry[:object].keys
      end&.flatten&.uniq
    end
  end
end