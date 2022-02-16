module NistPubid
  class DocumentTransform < Parslet::Transform
    def self.create_document(series, report_number, parts, **args)
      document = Document.new(publisher: Publisher.parse(series),
                              serie: Serie.new(serie: series.to_s.gsub(".", " ")),
                              docnumber: report_number.to_s, **args)
      parts.each do |attrs|
        attrs.each { |k, v| document.send("#{k}=", v.to_s) }
      end
      document
    end

    rule(series: simple(:series), report_number: simple(:report_number),
         stage: simple(:stage), parts: subtree(:parts)) do |x|
      create_document(x[:series], x[:report_number], x[:parts], stage: Stage.new(x[:stage].to_s))
    end

    rule(series: simple(:series), report_number: simple(:report_number),
         parts: subtree(:parts)) do |x|
      create_document(x[:series], x[:report_number], x[:parts])
    end

    rule(series: simple(:series), report_number: simple(:report_number),
         parts: subtree(:parts)) do |x|
      create_document(x[:series], x[:report_number], x[:parts])
    end

    def apply(tree, context = nil)
      series = tree[:series]
      document_parameters = tree.reject { |k, _| %i[first_report_number second_report_number series parts].include?(k) }
      tree[:parts].each { |p| document_parameters.merge!(p) } if tree[:parts]

      Document.new(publisher: Publisher.parse(series),
                   serie: Serie.new(serie: series.to_s.gsub(".", " ")),
                   docnumber: tree.values_at(:first_report_number, :second_report_number).compact.join("-"),
                   **document_parameters)
    end
  end
end
