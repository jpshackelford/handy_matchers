require File.join(File.dirname(__FILE__), %w[spec_helper])
require 'time'

describe StubTable do
  
  before do
    @table = StubTable.new('
     :date_value  :int_value  :string_value  # comments
      2000-01-01          1          hello   # should be
      2000-01-02          2          world   # discarded
    ')    
  end

  it "uses the first row as column headers" do
    @table.header.should == [:date_value, :int_value, :string_value ]
  end
 
  it "column names accessible via #header or #headers" do
    @table.header.should == @table.headers  
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
  
  it "provides access to an Array of rows" do
    @table.rows.should == @table.row
  end
  
  it "column values are available by index" do
    @table.col[1].should == ['1', '2']  
  end

  it "rows collection uses Array-like iteration" do
    @table.rows.map{|r| r.send(:int_value)}.should == ['1', '2']   
  end
  
  it "parsed table values are available by column, using column header" do
    @table.parse_col(1){|field| field.to_i}
    @table.col[:int_value].should == [1 , 2]    
  end

  it "parsed table values are available by column, using column index" do
    @table.parse_col(1){|field| field.to_i}
    @table.col[1].should == [1 , 2]    
  end

  it "rows and cols collection iterates like Array though it is indexed like a hash" do
    hash = {0 => 'a', 1 => 'b', 2 => 'c'}
    @table.send(:add_array_behavior!, hash, 3)
    hash.map{|s| s.upcase}.should == ['A','B','C']
  end
  
end

