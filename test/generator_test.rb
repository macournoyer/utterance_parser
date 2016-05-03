require 'test_helper'

class GeneratorTest < Minitest::Test
  def test_generate_plain
    assert_equal [
                   Example.new("Play some <category>blues</category>", "play"),
                 ],
                 Generator.generate("Play some <category>blues</category>" => "play")
  end

  def test_generate_single_sequence
    assert_equal [
                   Example.new("Play some <category>blues</category>", "play"),
                   Example.new("Play some <category>jazz</category>", "play"),
                   Example.new("Play some <category>rap</category>", "play"),
                 ],
                 Generator.generate("Play some <category>{blues,jazz,rap}</category>" => "play")
  end

  def test_generate_multiple_sequences
    assert_equal [
                   Example.new("Play some <category>blues</category> <time>now</time>", "play"),
                   Example.new("Play some <category>blues</category> <time>tomorrow</time>", "play"),
                   Example.new("Play some <category>jazz</category> <time>now</time>", "play"),
                   Example.new("Play some <category>jazz</category> <time>tomorrow</time>", "play"),
                   Example.new("Play some <category>rap</category> <time>now</time>", "play"),
                   Example.new("Play some <category>rap</category> <time>tomorrow</time>", "play"),
                 ],
                 Generator.generate("Play some <category>{blues,jazz,rap}</category> <time>{now,tomorrow}</time>" => "play")
  end

  def test_optional
    assert_equal [
                   Example.new("Play some <category>blues</category>", "play"),
                   Example.new("Play some <category>blues</category> please", "play"),
                   Example.new("Play some <category>jazz</category>", "play"),
                   Example.new("Play some <category>jazz</category> please", "play"),
                 ],
                 Generator.generate("Play some <category>{blues,jazz}</category>[ please]" => "play")
  end

  # TODO
  def xtest_optional_sequence
    assert_equal [
                   Example.new("Play some", "play"),
                   Example.new("Play some <category>blues</category>", "play"),
                   Example.new("Play some <category>jazz</category>", "play"),
                 ],
                 Generator.generate("Play some[ <category>{blues,jazz}</category>]" => "play")
  end
end
