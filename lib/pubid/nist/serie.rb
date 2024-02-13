SERIES = YAML.load_file(File.join(File.dirname(__FILE__), "../../../series.yaml"))

module Pubid::Nist
  class Serie
    attr_accessor :serie, :parsed

    def initialize(serie:, parsed: nil)
      raise Errors::SerieInvalidError, "#{serie} is not valid serie" unless SERIES["long"].key?(serie)

      @serie = serie
      @parsed = parsed
    end

    def to_s(format = :short)
      # return SERIES["abbrev"][@serie] ||
      return @serie if format == :short

      result = SERIES[format.to_s][@serie]
      return @serie if result.nil? && format == :mr

      return SERIES["long"][@serie] if result.nil?

      result
    end

    def ==(other)
      other.serie == @serie
    end
  end
end
