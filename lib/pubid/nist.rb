# frozen_string_literal: true

require "yaml"
require "parslet"
require "pubid-core"

module Pubid
  module Nist

  end
end

require_relative "nist/serie"
require_relative "nist/parsers/default"
require_relative "nist/update"
require_relative "nist/transformer"
require_relative "nist/parser"
require_relative "nist/renderer"

Dir[File.join(__dir__, 'nist/parsers', '*.rb')].each do |file|
  require file
end

PARSERS_CLASSES = Pubid::Nist::Parsers.constants.select do |c|
  Pubid::Nist::Parsers.const_get(c).is_a?(Class)
end.map do |parser_class|
  parser = Pubid::Nist::Parsers.const_get(parser_class)
  [parser.name.split("::").last.gsub(/(.)([A-Z])/, '\1 \2').upcase, parser]
end.to_h

require_relative "nist/identifier"
require_relative "nist/publisher"
require_relative "nist/stage"
require_relative "nist/errors"
require_relative "nist/nist_tech_pubs"
require_relative "nist/edition"
