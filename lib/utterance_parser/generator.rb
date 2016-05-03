module UtteranceParser
  # Generates examples for training by expanding sequences, eg.: `{1,2,3}`
  # and optionals, eg.: `[ please]`
  class Generator
    def initialize(template, intent)
      @template = template
      @intent = intent
    end

    def self.generate(example_templates)
      example_templates.each_pair.flat_map do |template, intent|
        new(template, intent).generate
      end
    end

    def generate
      # Replace optionals w/ sequences
      template = @template.gsub(/\[(.+?)\]/, '{,\1}')

      # Find sequences
      sequences = template.scan(/\{(.*?,.*?)\}/).flatten

      # Compile items from sequences
      items = sequences.map do |sequence|
        sequence.split(',')
      end

      if items.none?
        return [ Example.new(@template, @intent) ]
      end

      # Compile all the possible combinations
      permutations = items[0].product(*items[1..-1])

      # Replace the values in the template to for the final example
      permutations.map do |permutation|
        text = template.dup
        sequences.each_with_index do |sequence, i|
          text.gsub! "{#{sequence}}", permutation[i]
        end
        Example.new(text, @intent)
      end
    end
  end
end