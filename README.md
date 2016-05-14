# UtteranceParser

A trainable natural language parser that extracts intent and entities from utterances.

It uses a [Naive Bayes classifier](https://en.wikipedia.org/wiki/Naive_Bayes_classifier) to determine intent and [Conditional random fields](https://en.wikipedia.org/wiki/Conditional_random_field) to extract entities.

For example, it can turn this:

> Remind me to pick up the kids in two hours

into ...

```ruby
[
  # intent
  "reminder",
  # entities
  {task: "pick up the kids", time: "in two hours"}
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

  "Play some <playlist>jazz</playlist>" => "play",
  "Play some <playlist>blues</playlist>" => "play",
  "Play some <playlist>rap</playlist>" => "play"
)

parser.parse "Hello there!"
# => ["greeting", {}]

parser.parse "Play some rock"
# => ["play", {playlist: "rock"}]

parser.parse "Remind me to buy stuff in three hours"
# => ["reminder", {task: "buy stuff", time: "in three hours"}]
```

## Contributing

1. Fork it ( https://github.com/macournoyer/utterance_parser/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
