module UtteranceParser
  class Utterance
    TAG_RE = /<(.+?)>(.*?)<.+?>/

    attr_reader :text

    def initialize(text)
      @text = text
    end

    def ==(other)
      other.class == self.class && other.text == @text
    end

    def pos_tokens
      PosTagger.add_tags(@text).scan(TAG_RE).map { |tag, word| [word, tag.upcase] }
    end
  end
end