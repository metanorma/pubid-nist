require "parslet"

module NistPubid
  class DocumentParser < Parslet::Parser
    rule(:identifier) do
      series >> str(" ") >> report_number >> parts.repeat.as(:parts)
    end

    rule(:parts) do
      (revision | version | volume | part)
    end

    rule(:report_number) do
      match("[\\d-]|[A-Z]").repeat(1).as(:report_number)
    end

    rule(:part) do
      str("pt") >> match("\\d").as(:part)
    end

    rule(:revision) do
      str("r") >> match("\\d").as(:revision)
    end

    rule(:volume) do
      str("v") >> match("\\d").as(:volume)
    end

    rule(:version) do
      str("ver") >> match("\\d").as(:version)
    end

    rule(:series) do
      (SERIES["long"].keys.reduce do |acc, s|
        (acc.is_a?(String) ? str(acc) : acc) | str(s)
      end).as(:series)
    end

    root(:identifier)
  end
end
