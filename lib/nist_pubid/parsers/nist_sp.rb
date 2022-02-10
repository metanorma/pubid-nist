module NistPubid
  module Parsers
    class NistSp < Default
      rule(:part) do
        (str("pt") | str("p")) >> match("\\d").as(:part)
      end
    end
  end
end
