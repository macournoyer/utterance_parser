require 'nbayes'
require 'wapiti'

module UtteranceParser
  class Parser
    def initialize(save_path=nil)
      build_save_paths(save_path) if save_path

      if save_path && File.exist?(@classifier_file)
        @classifier = NBayes::Base.from(@classifier_file)
      else
        @classifier = NBayes::Base.new
      end

      if save_path && File.exist?(@labeller_file)
        @labeller = Wapiti::Model.load(@labeller_file)
      else
        @labeller = Wapiti::Model.new pattern: "#{__dir__}/pattern.txt"
      end
    end

    def train(examples)
      case examples
      when Array
        # All good!
      when Hash
        examples = examples.map { |utterance, intent| Example.new(utterance, intent) }
      else
        raise ArgumentError, "Expected [<Example>, ...] or { utterance => intent, ... }"
      end

      examples.each do |example|
        @classifier.train(example.pos_tokens, example.intent)
      end

      labeled_examples = examples.map do |example|
        example.labeled_tokens.map { |word, tag, entity| [word, tag, entity || "_"].join(" ") }
      end

      @labeller.train labeled_examples
    end

    def parse(text)
      utterance = Utterance.new(text)
      intent = @classifier.classify(utterance.pos_tokens).max_class
      labeled = @labeller.label([ utterance.pos_tokens.map { |t| t.join(" ") } ]).first
      [intent, extract_entities(labeled)]
    end

    def save(path=nil)
      build_save_paths path if path

      if !defined?(@classifier_file) || !defined?(@labeller_file)
        raise ArgumentError, "Path to save directory missing"
      end

      @classifier.dump(@classifier_file)
      @labeller.compact
      @labeller.save(@labeller_file)
    end

    private
      # Extract entities from tokens.
      # Eg.::
      #   [ ["Play NNP", "_"], ["some DET", "_"], ["jazz NN", "category"] ]
      # Returns:
      #   { category: "jazz" }
      def extract_entities(tokens)
        # FIXME this will not handle duplicated labels, eg.: category being used twice.
        labeled = tokens.group_by { |tagged_word, label| label }
        labeled.delete("_")
        
        labeled.each_with_object({}) do |(label, words), entities|
          entities[label.to_sym] = words.map do |word, _|
            # Remove the POS tag from. Eg.: `word == 'jazz NN'`
            word[0, word.rindex(" ")]
          end.join(" ")
        end
      end

      def build_save_paths(save_path)
        raise ArgumentError, "Path to save directory missing" unless File.directory?(save_path)

        @classifier_file = File.join(save_path, "classifier.yml")
        @labeller_file = File.join(save_path, "labeller.mod")
      end
  end
end