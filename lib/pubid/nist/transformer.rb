module Pubid::Nist
  class Transformer < Parslet::Transform
    rule(first_report_number: subtree(:first_report_number)) do |context|
      { number:
          context.values_at(:first_report_number, :second_report_number).compact.join("-").upcase }
    end

    rule(report_number: subtree(:report_number)) do |context|
      { number: context[:report_number] }
    end

    rule(series: subtree(:series)) do |context|
      { serie: Serie.new(serie: context[:series].to_s.gsub(".", " ")),
        publisher: Publisher.parse(context[:series]) }
    end

    # remove :second_report_number from output
    rule(second_report_number: simple(:second_report_number)) do
      {}
    end

    rule(parts: subtree(:parts)) do |context|
      context[:parts].inject({}, :merge)
    end

    rule(update: subtree(:update)) do |context|
      { update: Update.new(**context[:update]) }
    end
  end
end