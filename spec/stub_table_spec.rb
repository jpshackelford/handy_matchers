require File.join(File.dirname(__FILE__), %w[spec_helper])
require 'time'

describe StubTable do
  
  before do
    @table = StubTable.new('
     :date_value  :int_value  :string_value
      2000-01-01          1          hello
      2000-01-02          2          world
    ')    
  end

  it "uses the first row as column headers" do
    @table.header.should == [:date_value, :int_value, :string_value ]
  end
 
  it "parses rows into objects using the header symbol as a method name" do    
    @table.row[0].should respond_to( :date_value )
    @table.row[0].date_value == '2001-01-01'
  end
  
  it "converts fields when instructed to do so" do
    @table.parse_col(0){|field| Time.parse( field )}
    @table.row[1].date_value.should be_kind_of( Time )
  end
  
  it "indexes rows by a column value" do
    @table.index_by_col(0)
    @table['2000-01-01'].int_value.should == '1'
  end
  
  it "indexes rows by a computed value" do
    @table.index_by{|row| row.string_value.to_sym }
    @table[:hello].int_value.should == '1'  
  end
  
end

