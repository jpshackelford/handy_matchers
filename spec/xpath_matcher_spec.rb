require File.join(File.dirname(__FILE__), %w[spec_helper])

include FixtureSupport
include XPathMatchers

describe XPathMatchers do
  
  before do
    @doc = xml_fixture('xml')  
  end
  
  it "has a have_xpath matcher" do
    @doc.have_xpath("//parent/child[@attr='val1']") 
  end
  
  it "has a have_nodes matcher" do
    @doc.have_nodes("//parent/child[@attr]", 2)
  end
  
end