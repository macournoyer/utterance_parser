require_relative 'utterance_parser/version'
require_relative 'utterance_parser/utils'
require_relative 'utterance_parser/utterance'
require_relative 'utterance_parser/example'
require_relative 'utterance_parser/generator'
require_relative 'utterance_parser/pos_tagger'
require_relative 'utterance_parser/parser'

module UtteranceParser
  def self.new(*args)
    Parser.new(*args)
  end
end

