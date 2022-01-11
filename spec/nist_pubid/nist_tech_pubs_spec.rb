RSpec.describe NistPubid::NistTechPubs, vcr: true do
  describe "#fetch" do
    it "fetch doc identifiers from nist_tech_pubs" do
      expect(described_class.fetch.map { |d| d[:id] })
        .to include("NBS BH 1",
                    "NIST SP 1800-15",
                    "NIST SP 1265",
                    "NBS FIPS 83",
                    "NISTIR 8379")
    end

    it "fetches doi identifiers" do
      expect(described_class.fetch.map { |d| d[:doi] })
        .to include("NBS.BH.1",
                    "NIST.SP.1800-15",
                    "NIST.SP.1265",
                    "NBS.FIPS.83",
                    "NIST.IR.8379")
    end
  end

  describe "#convert" do
    it "converts old pubid to new NIST PubID" do
      expect(described_class.convert({ id: "NISTIR 8379" }).to_s)
        .to eq("NIST IR 8379")
    end

    it "keeps correct NIST PubID the same" do
      expect(described_class.convert({ id: "NIST SP 800-133r2e2" }).to_s)
        .to eq("NIST SP 800-133r2e2")
      expect(described_class.convert({ id: "NIST SP 800-160v1" }).to_s)
        .to eq("NIST SP 800-160v1")
    end

    it "uses doi when cannot parse document id" do
      expect(described_class.convert(
               { id: "NBS CIRC re3", doi: "NBS.CIRC.5e3" },
             ).to_s).to eq("NBS CIRC 5e3")
    end

    it "uses doi when doi more complete then id" do
      expect(described_class.convert(
               { id: "NIST SP 260-162", doi: "NIST SP 260-162 2006ed." },
             ).to_s).to eq("NIST SP 260-162e2006")
    end

    it "combines data from id and doi" do
      expect(described_class.convert(
               { id: "NIST SP 260-162r1", doi: "NIST SP 260-162 2006ed." },
             ).to_s).to eq("NIST SP 260-162r1e2006")
    end

    context "when doi code is wrong" do
      it "skips merging with doi" do
        expect(described_class.convert(
                 { id: "NIST TN 1648", doi: "NISTPUB.0413171251" },
               ).to_s).to eq("NIST TN 1648")
      end
    end
  end

  describe "#comply_with_pubid" do
    it "returns identifier comply with NIST PubID" do
      expect(described_class.comply_with_pubid.map { |d| d[:id] })
        .to include("NIST SP 260-14")
    end
  end

  describe "#different_with_pubid" do
    it "returns identifiers not comply with NIST PubID" do
      expect(described_class.different_with_pubid.map { |d| d[:id] })
        .to include("NISTIR 8379")
    end
  end

  describe "#parse_fail_with_pubid" do
    it "returns identifiers fail to parse" do
      expect(described_class.parse_fail_with_pubid.map { |d| d[:id] })
        .to include("NBS CIRC e2")
    end
  end

  describe "#status" do
    let(:id) { "LCIRC 897" }
    let(:doi) { "NBS.LCIRC.897" }
    let(:mr) { "NBS.LCIRC.897" }
    let(:title) do
      "Letter Circular 897: tables for transforming chromaticity coordinates"\
        " from the I.C.I system to the R-U-C-S system"
    end
    let(:finalPubId) { "NBS LC 897" }

    before do
      described_class.documents = [
        { id: id,
          doi: doi,
          title: title },
      ]
    end

    subject { described_class.status }

    it do
      is_expected
        .to eq([
                 { id: id, doi: doi, title: title, mr: mr,
                   finalPubId: finalPubId },
               ])
    end

    context "when cannot parse id and doi" do
      let(:id) { "NBS CIRC e2" }
      let(:doi) { "NBS.CIRC.e2" }

      it do
        is_expected
          .to eq([
                   { id: id, doi: doi, title: title, finalPubId: "parse error",
                     mr: "parse_error" },
                 ])
      end
    end
  end
end
