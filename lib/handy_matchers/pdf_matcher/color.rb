module PDFMatcher    
  class PDF
    
    class PNG
      
      # RGBA colors
      class Color
        
        attr_reader :values
        
        # Creates a new color with values +red+, +green+, +blue+, and +alpha+.      
        def initialize(red, green, blue, alpha)
          @values = [red, green, blue, alpha]
        end
        
        # Transparent white
        
        Background = Color.new 0xFF, 0xFF, 0xFF, 0x00
        
        White      = Color.new 0xFF, 0xFF, 0xFF, 0xFF
        Black      = Color.new 0x00, 0x00, 0x00, 0xFF
        Gray       = Color.new 0x7F, 0x7F, 0x7F, 0xFF
        
        Red        = Color.new 0xFF, 0x00, 0x00, 0xFF
        Orange     = Color.new 0xFF, 0xA5, 0x00, 0xFF
        Yellow     = Color.new 0xFF, 0xFF, 0x00, 0xFF
        Green      = Color.new 0x00, 0xFF, 0x00, 0xFF
        Blue       = Color.new 0x00, 0x00, 0xFF, 0xFF
        Purple     = Color.new 0XFF, 0x00, 0xFF, 0xFF
        
        # Red component
        def r; @values[0]; end
        
        # Green component
        def g; @values[1]; end
        
        # Blue component
        def b; @values[2]; end
        
        # Alpha transparency component
        def a; @values[3]; end
        
        # Blends +color+ into this color returning a new blended color.
        def blend(color)
          return Color.new((r * (0xFF - color.a) + color.r * color.a) >> 8,
           (g * (0xFF - color.a) + color.g * color.a) >> 8,
           (b * (0xFF - color.a) + color.b * color.a) >> 8,
           (a * (0xFF - color.a) + color.a * color.a) >> 8)
        end
        
        # Returns a new color with an alpha value adjusted by +i+.
        def intensity(i)
          return Color.new(r,b,g,(a*i) >> 8)
        end
        
        def inspect # :nodoc:
          "#<%s %02x %02x %02x %02x>" % [self.class, *@values]
        end
        
      end # Color    
      
    end # PNG
  end #PDF 
end
