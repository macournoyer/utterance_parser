$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'utterance_parser'

require 'minitest/autorun'

class Minitest::Test
  include UtteranceParser
end