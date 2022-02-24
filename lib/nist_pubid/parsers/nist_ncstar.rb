module NistPubid
  module Parsers
    class NistNcstar < Default
      rule(:number_suffix) { match("[abcdefghijA-Z]") }
    end
  end
end
