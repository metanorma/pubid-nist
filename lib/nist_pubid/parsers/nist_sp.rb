module NistPubid
  module Parsers
    class NistSp < Default
      rule(:parts) do
        (edition | revision | version | volume | part | update | translation | addendum)
      end

      rule(:part) do
        (str("pt") | str("p")) >> match("\\d").as(:part)
      end

      rule(:version) do
        ((str("ver") >> match('\d').repeat(1).as(:version)) |
          (str("v") >> (match('\d') >> str(".") >> match('\d') >> str(".") >> match('\d')).as(:version)))
      end

      rule(:report_number_first) do
        match('\d').repeat(1) >> (str("GB") | str("a")).maybe
      end

      rule(:report_number) do
        # (\d+-\d{1,3}).as(:report_number)
        # (\d+-\d{4}).as(:report_number) when first number is 250
        # (\d+).as(:report_number)-(\d{4}).as(:edition)
        # or \d-\d-(\d).as(:revision)
        (report_number_first.capture(:first_number) >>
          (str("-") >>
            # match('\d').repeat)).as(:report_number)
            dynamic do |source, context|
              # consume 4 numbers or any amount of numbers
              # for document ids starting from 250
              (if context.captures[:first_number] == "250"
                 match('\d').repeat
               else
                 # skip edition numbers (parse only if have not 4 numbers)
                 match('\d').repeat(4, 4).absent? >> match('\d').repeat
               end# |
                # parse last number as edition if have 4 numbers
                #match('\d').repeat(1).as(:edition)
              )
            end >>
            # parse A-Z and abcd as part of report number
            match["[A-Zabcd]"].maybe
          ).maybe).as(:report_number)
          # str("-") >> match('\d').repeat(1).as(:revision)
      end

      rule(:edition) do
        ((str("e") >> match("\\d").repeat(1).as(:edition)) | (str("-") >> match("\\d").repeat(4,4).as(:edition)))
      end

      rule(:revision) do
        ((str("rev") | str("r") | str("-")) >> (match('\d').repeat(1) >> match("[a-z]").maybe).as(:revision)) |
          (str("r") >> match("[a-z]").as(:revision))
      end
    end
  end
end
