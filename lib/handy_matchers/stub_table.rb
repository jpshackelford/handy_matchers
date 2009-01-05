require 'ostruct'

class StubTable
  
  def initialize( table_string )
    lines = table_string.split("\n").compact          # split into array of lines
    lines = lines.map{|line| line.split('#').first}   # remove comments
    @raw_table = lines.compact.map{|line| line.split} # split into words
    @raw_table.reject!{|row| row.empty? }
    @row_table = nil
    @col_table = nil
    @row_count = @raw_table.size - 1 # data rows, no header row 
    @header = nil
    @parse_blocks = []
  end
  
  def header
    unless @header
      @header = @raw_table[0].map do |col|
        # chop off leading colon
        col.slice!(0) if ':' == col[0..0] 
        col.to_sym
      end
    end
    return @header
  end
  
  alias headers header
  
  def row
    init_row_table!
    @row_table
  end

  alias rows row
  
  def []( index )
    row[ index ]
  end
  
  def parse_col( column_index, &block )
    if column_index && block_given?
      @row_table = nil # force rebuilding of result table
      @parse_blocks[ column_index ] = block 
    end
  end

  def index_by_col( column_index )
    init_row_table!
    @raw_table[1..-1].each_with_index do |raw_row, row_index|
      @row_table.store( raw_row[ column_index ], row[ row_index ])
    end
  end
  
  def index_by    
    if block_given?
      init_row_table!
      @raw_table[1..-1].each_with_index do |raw_row, row_index|
        @row_table.store( yield( row[row_index] ), row[ row_index ])
      end      
    end
  end
  
  def col
    init_col_table!
    @col_table
  end
  
  alias cols col
  
  private 
  
  def init_row_table!
    unless @row_table
      # go through data rows, converting each column to an object
      @row_table = {}
      @raw_table[1..-1].each_with_index do |raw_row, index|
        @row_table.store( index, mkstub( raw_row ) )
      end
      add_array_behavior!( @row_table, @row_count)
    end    
  end
  
  def init_col_table!
    unless @col_table
      @col_table = {}
      headers.each_with_index do |name,index|
        column_values = rows.map{|r| r.send(name)}
        @col_table.store( name,  column_values )
        @col_table.store( index, column_values )
      end
      add_array_behavior!( @col_table, headers.size )      
    end    
  end
  
  # Modify the Hash iteration behaviors so that iterates only through elements 
  # indexed by Fixnum, just as an Array would be. Note that if ones uses one of 
  # the index by functions to index with Fixnums in the same range as 0..count
  # this will return unexpected results.
  def add_array_behavior!( hash, count ) 
    class << hash        
      def map
        result = []
        @original_size.times do |i|
          result << yield(self[i])
        end
        return result
      end       
      def each       
        @original_size.times do |i|
          yield(self[i])
        end
      end      
      def each_with_index
        @original_size.times do |i|
          yield(self[i],i)
        end        
      end
      def select
        array = []
        @original_size.times do |i|
          array << self[i] unless yield(self[i]) == false
        end
        return array
      end      
    end
    hash.instance_variable_set :@original_size, count
  end

  def mkstub( raw_row )
    o = OpenStruct.new
    header.each_with_index do |col_name, index|
      o.send("#{col_name}=".to_sym, parse_by_col(index, raw_row[index]))
    end 
    return o
  end
  
  def parse_by_col( column_index, raw_value )
    if @parse_blocks[column_index].kind_of?( Proc )
      value = @parse_blocks[column_index].call( raw_value )  
    else
      value = raw_value
    end 
    return value
  end

end