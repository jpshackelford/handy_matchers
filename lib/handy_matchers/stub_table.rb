require 'ostruct'

class StubTable
  
  def initialize( table_string )
    @raw_table = table_string.split("\n").map{|line| line.split}
    @raw_table.reject!{|row| row.empty? }
    @result_table = nil
    @header = nil
    @index = nil
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
  
  def row
    unless @result_table
      # go through data rows, converting each column to an object
      @result_table = @raw_table[1..-1].map do |row|
        o = OpenStruct.new
        # for each column, add a method to the OpenStruct so that 
        # one may call o.col_name # => value at row, col
        header.each_with_index do |col_name, index|
          o.send( "#{col_name}=".to_sym , parse_by_col( index, row[index] ))
        end
        o # return OpenStruct record
      end
    end
    @result_table
  end

  def parse_col( column_index, &block )
    if column_index && block_given?
      @result_table = nil # force rebuilding of result table
      @parse_blocks[ column_index ] = block 
    end
  end

  def index_by_col( column_index )
    @index = {}
    @raw_table[1..-1].each_with_index do |raw_row, row_index|
      @index.store( raw_row[ column_index ], row[ row_index ])
    end
  end
  
  def index_by
    if block_given?
      @index = {}
      @raw_table[1..-1].each_with_index do |raw_row, row_index|
        @index.store( yield( row[row_index] ), row[ row_index ])
      end      
    end
  end
  
  def [](index)
    if @index.is_a?( Hash )
      @index[ index ]
    elsif index.is_a?( Fixnum ) 
      return row[ index ]
    else
      return nil
    end
  end
  
  private 
  
  def parse_by_col( column_index, raw_value )
    if @parse_blocks[column_index].kind_of?( Proc )
      value = @parse_blocks[column_index].call( raw_value )  
    else
      value = raw_value
    end 
    return value
  end

end