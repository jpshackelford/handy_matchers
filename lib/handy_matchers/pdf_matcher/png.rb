module PDFMatcher    
  class PDF
    
    # TODO: gsw - Make sure we have version 1 - as version 2 will require major havoc 
    # TODO: - also fix the "binary" issue
    #
    # A pure Ruby Portable Network Graphics (PNG) writer.
    #
    # http://www.libpng.org/pub/png/spec/1.2/
    #
    # PNG supports:
    # + 8 bit truecolor PNGs
    #
    # PNG does not support:
    # + any other color depth
    # + extra data chunks
    # + filters
    #
    # = Example
    #
    #   require 'png'
    #   
    #   canvas = PNG::Canvas.new 200, 200
    #   canvas[100, 100] = PNG::Color::Black
    #   canvas.line 50, 50, 100, 50, PNG::Color::Blue
    #   png = PNG.new canvas
    #   png.save 'blah.png'    
    class PNG
      
      # Creates a PNG chunk of type +type+ that contains +data+.      
      def self.chunk(type, data="")
        [data.size, type, data, (type + data).png_crc].pack("Na*a*N")
      end
      
      # Creates a new PNG object using +canvas+      
      def initialize(canvas)
        @height = canvas.height
        @width = canvas.width
        @bits = 8
        @data = canvas.data
      end
      
      # Writes the PNG to +path+.      
      def save(path)
        File.open(path, "wb") do |f|
          f.write [137, 80, 78, 71, 13, 10, 26, 10].pack("C*") # PNG signature
          f.write PNG.chunk('IHDR',
          [ @height, @width, @bits, 2, 0, 0, 0 ].pack("N2C5"))
          # 0 == filter type code "none"
          data = @data.map { |row| [0] + row.map { |p| [p.values[0], p.values[1], p.values[2]] } }.flatten
          #data = @data.map { |row| [0] + row.map { |p| p.values } }.flatten
          f.write PNG.chunk('IDAT', Zlib::Deflate.deflate(data.pack("C*"), 9))
          f.write PNG.chunk('IEND', '')
        end
      end
      
    end # PNG
    
  end
end