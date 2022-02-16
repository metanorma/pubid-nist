module NistPubid
  class DocumentParser < Parslet::Parser
    attr_accessor :parsed

    rule(:series) do
      (SERIES["long"].keys
                     .sort_by(&:length).reverse
                     .map { |v| [v, v.gsub(" ", ".")] } # parse MRI
                     .flatten
                     .reduce do |acc, s|
        (acc.is_a?(String) ? str(acc) : acc) | str(s)
      end).as(:series) >> any.repeat.as(:remaining)
    end

    root(:series)

    def parse(code)
      parsed = super(code)
      series = parsed[:series].to_s.gsub(".", " ")
      parser = find_parser(series)
      parser.new.parse(parsed[:remaining].to_s).merge({ series: series })
    end

    def find_parser(series)
      PARSERS_CLASSES[series] || NistPubid::Parsers::Default
    end
  end
end
