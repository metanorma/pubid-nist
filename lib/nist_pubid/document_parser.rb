require "parslet"

module NistPubid
  class DocumentParser < Parslet::Parser
    rule(:identifier) do
      series >> stage >> (str(" ") | str(".")) >> report_number >> parts.repeat.as(:parts)
    end

    rule(:parts) do
      (revision | version | volume | part | update | translation | edition | addendum)
    end

    rule(:stage) do
      (str("(") >> (STAGES.keys.reduce do |acc, s|
        (acc.is_a?(String) ? str(acc) : acc) | str(s)
      end).as(:stage) >> str(")")).maybe
    end

    rule(:report_number) do
      (match('\d').repeat(1) >> str("-").maybe >> match('\d').repeat >> match("[aA-Z]").maybe).as(:report_number)
    end

    rule(:part) do
      str("pt") >> match("\\d").as(:part)
    end

    rule(:revision) do
      str("r") >> (match('\d').repeat >> match("[a-z]").maybe).as(:revision)
    end

    rule(:volume) do
      str("v") >> match("\\d").as(:volume)
    end

    rule(:version) do
      str("ver") >> match("\\d").as(:version)
    end

    rule(:update) do
      str("/Upd") >> match("\\d+").repeat(1).as(:update_number) >> str("-") >> match("\\d+").repeat(1).as(:update_year)
    end

    rule(:translation) do
      str("(") >> match("\\w").repeat(3,3).as(:translation) >> str(")")
    end

    # (?<year>\d{4})|(?<sequence>\d+[A-Z]?)
    rule(:edition) do
      str("e") >> match("\\d").repeat(1).as(:edition)
    end

    rule(:addendum) do
      (str("-add") | str(".add-1")).as(:addendum)
    end

    rule(:series) do
      (SERIES["long"].keys
                     .map { |v| [v, v.gsub(" ", ".")]}
                     .flatten
                     .reduce do |acc, s|
        (acc.is_a?(String) ? str(acc) : acc) | str(s)
      end).as(:series)
    end

    root(:identifier)
  end

  # def parse(str)
  #   super(str)
  # rescue Parslet::ParseFailed => failure
  #   raise "#{failure.message}\ncause: #{failure.parse_failure_cause.ascii_tree}"
  # end
end
