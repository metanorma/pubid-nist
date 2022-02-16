module NistPubid
  module Parsers
    class NbsSp < Default
      rule(:part) do
        (str("p") | str("P")) >> match("\\d").as(:part)
      end
    end
  end
end
