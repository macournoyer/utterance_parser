require 'test_helper'
require 'fileutils'

class ParserTest < Minitest::Test
  def setup
    @parser = Parser.new
    @parser.train(
      "Hi" => "greeting",
      "Hello" => "greeting",
      "What time is it" => "time",
      "What's the weather outside" => "weather",
      "Remind me to <task>{buy milk,pick up the kids,get stuff done}</task> <time>{tomorrow,in one hour,in two hours}</time>" => "reminder",
      "Play some <category>{jazz,blues,rap}</category>" => "play",
      "Play something[ please]" => "play",
    )
  end

  def test_save
    FileUtils.mkdir_p "tmp/parser"
    FileUtils.rm_rf "tmp/parser/*"
    @parser.save "tmp/parser"
    assert File.file? "tmp/parser/classifier.yml"
    assert File.file? "tmp/parser/classifier.yml"
    @parser = Parser.new("tmp/parser")
  end

  def self.test_parses(utterance, intent, entities=nil)
    define_method "test_parses \"#{utterance}\"" do
      actual_intent, actual_entities = @parser.parse utterance
      assert_equal actual_intent, intent, "Unexpected intent"
      assert_equal(actual_entities, entities, "Unexpected entities") if entities
    end
  end

  test_parses "Hello there", "greeting"

  test_parses "Could you play something nice please", "play"

  test_parses "Play some hip-hop", "play", category: "hip-hop"

  test_parses "Remind me to buy stuff in three hours",
              "reminder", task: "buy stuff", time: "in three hours"

  test_parses "Remind me to go play outside tomorrow",
              "reminder", task: "go play outside", time: "tomorrow"
end
