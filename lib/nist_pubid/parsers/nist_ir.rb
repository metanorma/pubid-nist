module NistPubid
  module Parsers
    class NistIr < Default
      rule(:revision) do
        str("r") >> (match('\d').repeat(1) | match("[A-Za-z]").repeat(3, 3) >> match('\d').repeat(4, 4)).as(:revision)
      end

      # patterns:
      # NIST IR 85-3273-17
      # NIST IR 88-3099
      #       EDITION_REGEXP = /(?<!Upd)\d{4}+(?<prepend>-)(?<year>\d{4})(?!-)/.freeze
      rule(:report_number) do
        (match('\d').repeat(4, 4).as(:first_report_number) >>
          str("-") >> match('\d').repeat(4, 4).as(:edition_year)) |
          match('\d').repeat(1).as(:first_report_number) >> (str("-") >>
            (match('\d').repeat(1) | str("a")).as(:second_report_number)).maybe
      end
    end
  end
end

