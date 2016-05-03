require 'test_helper'

class ExampleTest < Minitest::Test
  def test_tokens
    assert_equal [["What", "WP", nil], ["time", "NN", nil], ["is", "VBZ", nil], ["it", "PRP", nil], ["?", "PP", nil]],
                 Example.new("What time is it?", "time").labeled_tokens
  end

  def test_single_labeled_tokens
    assert_equal [["Play", "NNP", nil], ["some", "DET", nil], ["jazz", "NN", "category"]],
                 Example.new("Play some <category>jazz</category>", "play").labeled_tokens
  end

  def test_multi_labeled_tokens
    assert_equal [["Play", "NNP", nil], ["some", "DET", nil],
                  ["smooth", "JJ", "category"], ["jazz", "NN", "category"],
                  ["now", "RB", "time"], ["please", "VB", nil]],
                 Example.new("Play some <category>smooth jazz</category> <time>now</time> please", "play").labeled_tokens
  end
end
