module NistPubid
  class DocumentTransform < Parslet::Transform
    rule(series: simple(:series), report_number: simple(:report_number),
         parts: subtree(:parts)) do
      document = Document.new(publisher: Publisher.parse(series),
                              serie: Serie.new(serie: series), docnumber: report_number)
      parts.reduce(document) { |doc, parts| parts.each { |k, v| doc.send("#{k}=", v) }; doc }
    end
  end
end
