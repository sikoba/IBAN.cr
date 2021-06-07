require "./spec_helper"

describe Iban do

  it "should fail on IBAN that is too short" do
    iban = "BE71 0961 2345 67"
    res = Iban.validate_with_feedback(iban)
    res.should eq "IBAN is too short"
  end
    
  it "should fail on IBAN that is too long" do
    iban = "BE71 0961 2345 6769 6769 6769 6769 6769 676"
    res = Iban.validate_with_feedback(iban)
    res.should eq "IBAN is too long"
  end

  it "should fail on IBAN contains illegal characters" do
    iban = "BE71 0961 2345 +769"
    res = Iban.validate_with_feedback(iban)
    res.should eq "IBAN contains illegal characters"
  end

  it "should fail if the country code is not recognised" do
    iban = "BB71 0961 2345 6769"
    res = Iban.validate_with_feedback(iban)
    res.should eq "IBAN country code not recognised"
  end

  it "should fail if the country code is not recognised" do
    iban = "BE71 0961 2345 676X"
    res = Iban.validate_with_feedback(iban)
    res.should eq "IBAN format for country BE incorrect"
  end

  it "should fail if the checksum is incorrect" do
    iban = "BE17 0961 2345 6769"
    res = Iban.validate_with_feedback(iban)
    res.should eq "IBAN checksum incorrect"
  end

  it "should succeed on correct IBAN" do
    iban = "BE71 0961 2345 6769"
    res = Iban.validate_with_feedback(iban)
    res.should eq "OK"
  end
  
  it "should succeed on correct IBAN" do
    iban = "BE71 0961 2345 6769"
    res = Iban.validate(iban)
    res.should eq true
  end

  # examples from wikipedia

  a = Array(String).new
  a << "BE71 0961 2345 6769"
  a << "BR15 0000 0000 0000 1093 2840 814 P2"
  a << "FR76 3000 6000 0112 3456 7890 189"
  a << "DE91 1000 0000 0123 4567 89"
  a << "GR96 0810 0010 0000 0123 4567 890"
  a << "PK70 BANK 0000 1234 5678 9000"
  a << "PL10 1050 0099 7603 1234 5678 9123"
  a << "RO09 BCYP 0000 0012 3456 7890"
  a << "LC14 BOSL 1234 5678 9012 3456 7890 1234"
  a << "SA44 2000 0001 2345 6789 1234"
  a << "ES79 2100 0813 6101 2345 6789"
  a << "CH56 0483 5012 3456 7800 9"
  a << "GB98 MIDL 0700 9312 3456 78"

  a.each do |iban|
    it "should succeed for #{iban}" do
      res = Iban.validate(iban)
      res.should eq true
    end
  end
  
  # formatting

  it "should format IBAN accounts correctly" do
    iban = "  Br150  0000000000  01093 2840814p2   "
    res = Iban.display(iban)
    res.should eq "BR15 0000 0000 0000 1093 2840 814P 2"
  end
  
end
