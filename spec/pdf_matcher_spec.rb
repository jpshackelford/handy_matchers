require File.join(File.dirname(__FILE__), %w[spec_helper])

include FixtureSupport
include PDFMatcher

describe PDFMatcher do
  
  before do
    @pdf = pdf_fixture('test01')
  end
  
  it "can count the number of pages in a pdf" do
    @pdf.pages.size.should == 2
  end
  
  it "provides page info" do
    @pdf.pages[0].info[:Rotate].should == 90.0
    @pdf.pages[0].info[:MediaBox].should == [0.0, 0.0, 792.0, 1224.0]
  end
  
  it "provides access to text on each page" do
    @pdf.pages[0].should have_text(/Team One/)
  end
  
  it "searches for text across pages" do
    @pdf.should have_text(/Team Two/)
  end
  
  it "can count the number of images on a page" do
    @pdf.pages[0].image_refs.size.should == 3
    @pdf.pages[0].images.size.should == 2
  end

  it "can find embedded images" do
    @pdf.should have_image( 'burndown3.png' )   
  end 
  
  it "can detect missing images" do
    @pdf.should_not have_image( 'burndown4.png' )   
  end  
  
end