require File.join(File.dirname(__FILE__), %w[spec_helper])

include FixtureSupport
include FileContentMatcher

describe FileContentMatcher do
  
  it "matches files which are the same" do
    fixture('burndown1.png').should have_the_same_bits_as('burndown1.png')
  end
 
  it "does not match files which differ" do
    fixture('burndown1.png').should_not have_the_same_bits_as('burndown2.png')
  end

end