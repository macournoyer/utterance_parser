# EngTagger generates two tons of warnings (metric however).
# It also uses globals and monkey patches core classes.
# But it's easy to install and just works, so ...
#
#                 ¯\_(ツ)_/¯
#
UtteranceParser::Utils.ignore_warnings do
  require 'engtagger'
end

module UtteranceParser
  PosTagger = Utils.ignore_warnings { EngTagger.new }
end