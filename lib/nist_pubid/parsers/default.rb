module NistPubid
  module Parsers
    class Default < Parslet::Parser
      rule(:identifier) do
        stage.maybe >> (str(" ") | str(".")) >> report_number >> parts.repeat.as(:parts)
      end

      rule(:digits) { match('\d').repeat(1) }
      rule(:letters) { match('[A-Za-z]').repeat(1) }
      rule(:year_digits) { match('\d').repeat(4, 4) }
      rule(:month_letters) { match('[A-Za-z]').repeat(3, 3) }
      rule(:number_suffix) { match("[aA-Z]") }
      # rule(:small)

      rule(:parts) do
        (edition | revision | version | volume | part | update | addendum | translation |
           supplement | errata | index | insert | section | appendix)
      end

      rule(:appendix) do
        str("app").as(:appendix)
      end

      rule(:supplement) do
        (str("supp") | str("sup")) >> match('\d').repeat.as(:supplement)
      end

      rule(:errata) do
        str("-").maybe >> str("errata").as(:errata)
      end

      rule(:index) do
        (str("index") | str("indx")).as(:index)
      end

      rule(:insert) do
        (str("insert") | str("ins")).as(:insert)
      end

      rule(:stage) do
        (str("(") >> (STAGES.keys.reduce do |acc, s|
          (acc.is_a?(String) ? str(acc) : acc) | str(s)
        end).as(:stage) >> str(")"))
      end

      rule(:digits_with_suffix) do
        digits >> # do not match with 428P1
          (number_suffix >> match('\d').absent?).maybe
      end

      rule(:report_number) do
        digits_with_suffix.as(:first_report_number) >>
          (str("-") >> digits_with_suffix.as(:second_report_number)).maybe
      end

      rule(:part) do
        (str("pt") | str("p")) >> digits.as(:part)
      end

      rule(:revision) do
        str("r") >> ((digits >> match("[a-z]").maybe).maybe).as(:revision)
      end

      rule(:volume) do
        str("v") >> digits.as(:volume)
      end

      rule(:version) do
        str("ver") >> digits.as(:version)
      end

      rule(:update) do
        (str("/Upd") | str("/upd")) >> digits.as(:update_number) >> str("-") >> digits.as(:update_year)
      end

      rule(:translation) do
        (str("(") >> match('\w').repeat(3, 3).as(:translation) >> str(")")) |
          (str(".") >> match('\w').repeat(3, 3).as(:translation))
      end

      rule(:edition) do
        str("e") >> digits.as(:edition)
      end

      rule(:addendum) do
        (str("-add") | str(".add-1")).as(:addendum)
      end

      rule(:section) do
        str("sec") >> digits.as(:section)
      end

      root(:identifier)
    end
  end
end
