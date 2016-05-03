# UtteranceParser

A trainable natural language parser that extracts intent and entities from utterances.

For example, it can turn this:

> Remind me to pick up my kids in two hours

into ...

```ruby
[
  # intent
  "reminder",
  # entities
  {task: "pick up my kids", time: "in two hours"}
]
```

## Installation

Add this line to your application's Gemfile:

    gem 'utterance_parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install utterance_parser

## Usage

```ruby
parser = UtteranceParser.new

parser.train(
  # Utterance => intent
  "Hi" => "greeting",
  "Hello" => "greeting",
  "What time is it" => "time",
  "What's the weather outside" => "weather",

  # Mark entities using XML tags
  "Remind me to <task>get stuff done</task> <time>tomorrow</time>" => "reminder",
  "Remind me to <task>buy milk</task> <time>in one hour</time>" => "reminder",
  "Remind me to <task>pick up the kids</task> <time>in two hours</time>" => "reminder",

  # You can use lists in `{...}` to generate training examples on the fly.
  # The following with generate an example for each category in the sequence.
  "Play some <category>{jazz,blues,rap}</category>" => "play",

  # You can also provide optional parts in `[...]`.
  "Play something[ please]" => "play",
)

parser.parse "Could you play something nice please"
# => ["play", {}]

parser.parse "Play some hip-hop"
# => ["play", {category: "hip-hop"}]

parser.parse "Remind me to buy stuff in three hours"
# => ["reminder", {task: "buy stuff", time: "in three hours"}]
```

## Contributing

1. Fork it ( https://github.com/macournoyer/utterance_parser/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
