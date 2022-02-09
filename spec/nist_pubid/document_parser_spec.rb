require "parslet/rig/rspec"

RSpec.describe NistPubid::DocumentParser do
  describe "parses series" do
    around(:each) do |example|
      example.run
    rescue Parslet::ParseFailed => failure
      raise failure.parse_failure_cause.ascii_tree
    end

    it "parses revision" do
      expect(described_class.new.revision).to parse("r5")
    end

    it "parses series" do
      expect(described_class.new).to parse("NBS FIPS 100")
    end

    it "parses volume" do
      expect(described_class.new).to parse("NIST NCSTAR 1-1Cv1")
    end

    it "parses part end revision" do
      expect(described_class.new).to parse("NIST SP 800-57pt1r4")
    end

    it "parses update" do
      expect(described_class.new.update).to parse("/Upd1-2012")
    end

    it "parses translation" do
      expect(described_class.new.translation.parse("(esp)")).to eq(translation: "esp")
    end

    it "parses edition" do
      expect(described_class.new.edition.parse("e5")).to eq(edition: "5")
    rescue Parslet::ParseFailed => failure
      raise failure.parse_failure_cause.ascii_tree
    end

    it "parses NIST SP(IPD) 800-53e5" do
      expect(described_class.new.parse("NIST SP(IPD) 800-53e5")).to eq("NIST SP(IPD) 800-53e5")
    rescue Parslet::ParseFailed => failure
      raise failure.parse_failure_cause.ascii_tree
    end
    # NIST NCSTAR 1-1Cv1
    # NIST SP 800-57pt1r4
    # NIST IR 8115(esp)
    # NIST SP 800-53r4/Upd3-2015
    # NBS CIRC 24supJan1924
    # NIST GCR 21-917-48v3B
    # NIST FIPS 54-1-Jan15
    # NIST SP 800-38a-add
    # NIST SP(IPD) 800-53r5
    # NBS CRPL-F-B150
  end
end
