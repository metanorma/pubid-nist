module Pubid::Nist
  module Parsers
    class NistSp < Default
      rule(:version) do
        ((str("ver") >> (digits >> (str(".") >> digits).maybe).as(:version)) |
          (str("v") >>
            (match('\d') >> str(".") >> match('\d') >> (str(".") >> match('\d')).maybe).as(:version)))
      end

      rule(:number_suffix) { match["[A-Zabcd]"] }

      rule(:first_report_number) do
        digits >> (str("GB") | str("a")).maybe
      end

      rule(:report_number) do
        # (\d+-\d{1,3}).as(:report_number)
        # (\d+-\d{4}).as(:report_number) when first number is 250
        # (\d+).as(:report_number)-(\d{4}).as(:edition)
        # or \d-\d-(\d).as(:revision)
        (first_report_number.capture(:first_number).as(:first_report_number) >>
          (str("-") >>
            dynamic do |_source, context|
              # consume 4 numbers or any amount of numbers
              # for document ids starting from 250
              (if context.captures[:first_number] == "250"
                 digits
               else
                 # do not consume edition numbers (parse only if have not 4 numbers)
                 year_digits.absent? >> digits
               end >> number_suffix.maybe
                # parse last number as edition if have 4 numbers
              ) | (str("NCNR") | str("PERMIS") | str("BFRL"))
            end.as(:second_report_number)
            # parse A-Z and abcd as part of report number
          ).maybe
        )
      end

      rule(:edition) do
        ((str("e") >> year_digits.as(:edition_year)) | (str("-") >> year_digits.as(:edition_year)) |
          (str("e") >> digits.as(:edition)))
      end

      rule(:revision) do
        ((str("rev") | str("r")) >> (digits >> match("[a-z]").maybe).as(:revision)) |
          (str("-") >> digits.as(:revision)) |
          (str("r") >> match("[a-z]").as(:revision)) |
          (str("r") >> str("").as(:revision))
      end
    end
  end
end