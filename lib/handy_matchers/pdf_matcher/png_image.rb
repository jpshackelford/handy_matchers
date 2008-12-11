module PDFMatcher    
  class PDF
   
    class PNGImage
      
      attr_reader :height, :width
      
      def initialize( image_data )        
        @height     = image_data.hash[:Height]
        @width      = image_data.hash[:Width]
        @image_data = image_data
      end
      
      def file_contents

        # Handle index color image
        colorspace = @image_data.hash[:ColorSpace]
        colorspacetype = colorspace[0]
        if colorspacetype.to_s == "Indexed"
          cdata = String.new(colorspace[3])
        end
        
        # Convert to PNG
        canvas = PNG::Canvas.new( @width, @height )
  
        position = 0
        for x in (0..@height-1)
          for y in (0..@width-1)
            c = @image_data[position]
            offset = c * 3
            canvas[y,x] = PNG::Color.new( cdata[offset], 
                                          cdata[offset+1], 
                                          cdata[offset+2], 0x00)
            position = position + 1
          end
        end
        png = PNG.new( canvas )        
      
      end
      
    end
    
  end
end