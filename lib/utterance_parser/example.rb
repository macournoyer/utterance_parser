module UtteranceParser
  # An example utterance for training the parser.
  # Can be labeled with entities via XML tags: `Play some <category>rap</category>`.
  class Example < Utterance
    attr_reader :labeled_text, :intent

    def initialize(labeled_text, intent)
      super(labeled_text.gsub(TAG_RE, '\2'))
      @labeled_text = labeled_text
      @intent = intent
    end

    def ==(other)
      other.class == self.class && other.labeled_text == @labeled_text
    end

    def labeled_tokens
      labels = tags_with_position(@labeled_text)

      tags_with_position(PosTagger.add_tags(@text)).map do |tag, word, word_position|
        label = labels.detect do |name, content, label_position|
          # If the word position intersect with the label's, it's a match
          if label_position.include? word_position.begin
            break name
          end
        end
        [word, tag.upcase, label]
      end
    end

    private
      # Return tags, their content, and their position in the `text` *without the tags*.
      def tags_with_position(text)
        tags = []
        tags_offset = 0

        text.scan(TAG_RE) do |tag, content|
          tags_offset += tag.size + 2 # <tag>
          index = $~.offset(2)[0] - tags_offset
          tags << [tag, content, (index..index + content.size)]
          tags_offset += tag.size + 3 # </tag>
        end

        tags
      end
  end
end
