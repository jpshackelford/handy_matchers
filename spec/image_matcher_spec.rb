require File.join(File.dirname(__FILE__), %w[spec_helper])

include FixtureSupport
include ImageMatcher

describe ImageMatcher do
  
  it "matches exact images" do
    fixture('burndown1.png').should match_image('burndown1.png')
  end
 
  it "matches like images" do
    fixture('burndown1.png').should match_image('burndown2.png')
  end

  it "doesn't match unlike images" do
    fixture('burndown1.png').should_not match_image('burndown3.png')
  end
  
end

# EOF
