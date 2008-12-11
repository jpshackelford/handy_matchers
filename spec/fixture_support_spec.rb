require File.join(File.dirname(__FILE__), %w[spec_helper])
require 'ostruct'

include FixtureSupport

describe FixtureSupport do
  
  before do
    fixture_path_is nil
    output_path_is nil
  end
  
  after do
    #output_path_delete!  
  end
  
  it "has a reasonable default for fixture path" do
    fixture_path('').should == File.join(Dir.pwd, 'fixtures/')
  end
  
  it "has a reasonable default for output path" do
    output_path('').should == File.join(Dir.pwd, 'test_output/')
  end

  it "allows me to define a path for fixture files" do     
    fixture_path_is 'dir1'
    fixture_path('file').should == File.join( 'dir1','file' )
  end
  
  it "allows me to define a path for output files" do
    output_path_is 'dir2' 
    output_path('file').should == File.join( 'dir2','file' )
  end
  
  it "reads binary files" do
    fixture('burndown1.png').should == 
      File.open( fixture_path('burndown1.png'),'rb'){|f| f.read}
  end
  
  it "writes test output" do    
    write_test_output('test.txt','look ma, no brain')
    output('test.txt').should == 'look ma, no brain'
  end
  
  it "reads xml data" do
    doc = xml_fixture('xml')
    doc.should be_kind_of( REXML::Document )
    match = REXML::XPath.match(doc, '/root/parent/*')
    match.size.should == 2
  end
  
  it "reads yml data" do
    a = yml_fixture('yaml')
    a.should be_kind_of( Array )
    a.first.message.should == 'hi'
    a.last.message.should == 'bye'
  end
 
end

# EOF
