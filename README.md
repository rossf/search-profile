# search-profile
An implementation of a reverse index (like Lucene) in ruby. It parses the included json files (and an optionally specified extra file) and creates an index of all the searchable values. Then prompts for a search string. It attempts to format the output as a table, combining the headers for the different document types encountered.

## Usage
Assuming ruby and bundler are installed:

- Install the required gems (only required the first time)
  ```bash
  bundle install
  ```
- Run the program
  ```bash
  ruby search.rb
  ```

Passing -h will give a list of optional arguments.

## Testing
Tests are written using rspec. To run them run rspec after bundle.
```bash
rspec
```

## TODO
- The tokenizer could be smarter and use stemming so the matches can be less exact.
- I started to implement a highlighter for showing where in the document the match was found but didn't get it finished
- Input files shouldn't be hard coded
- Boolean values should be handled better
