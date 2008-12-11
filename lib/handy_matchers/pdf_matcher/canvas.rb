module PDFMatcher    
  class PDF
    
    class PNG
      
      # PNG canvas      
      class Canvas
        
        # Height of the canvas      
        attr_reader :height
        
        # Width of the canvas
        attr_reader :width
        
        # Raw data
        attr_reader :data
        
        def initialize(height, width, background = Color::White)
          @height = height
          @width = width
          @data = Array.new(@width) { |x| Array.new(@height) { background } }
        end
        
        # Retrieves the color of the pixel at (+x+, +y+).      
        def [](x, y)
          raise "bad x value #{x} >= #{@height}" if x >= @height
          raise "bad y value #{y} >= #{@width}" if y >= @width
          @data[y][x]
        end
        
        # Sets the color of the pixel at (+x+, +y+) to +color+.      
        def []=(x, y, color)
          raise "bad x value #{x} >= #{@height}" if x >= @height
          raise "bad y value #{y} >= #{@width}"  if y >= @width
          @data[y][x] = color
        end
        
        # Iterates over each pixel in the canvas.      
        def each
          @data.each_with_index do |row, y|
            row.each_with_index do |pixel, x|
              yield x, y, color
            end
          end
        end
        
        # Blends +color+ onto the color at point (+x+, +y+).      
        def point(x, y, color)
          self[x,y] = self[x,y].blend(color)
        end
        
        # Draws a line using Xiaolin Wu's antialiasing technique.
        # http://en.wikipedia.org/wiki/Xiaolin_Wu's_line_algorithm      
        def line(x0, y0, x1, y1, color)
          dx = x1 - x0
          sx = dx < 0 ? -1 : 1
          dx *= sx # TODO: abs?
          dy = y1 - y0
          
          # 'easy' cases
          if dy == 0 then
            Range.new(*[x0,x1].sort).each do |x|
              point(x, y0, color)
            end
            return
          end
          
          if dx == 0 then
           (y0..y1).each do |y|
              point(x0, y, color)
            end
            return
          end
          
          if dx == dy then
            Range.new(*[x0,x1].sort).each do |x|
              point(x, y0, color)
              y0 += 1
            end
            return
          end
          
          # main loop
          point(x0, y0, color)
          e_acc = 0
          if dy > dx then # vertical displacement
            e = (dx << 16) / dy
             (y0...y1-1).each do |i|
              e_acc_temp, e_acc = e_acc, (e_acc + e) & 0xFFFF
              x0 = x0 + sx if (e_acc <= e_acc_temp) 
              w = 0xFF-(e_acc >> 8)
              point(x0, y0, color.intensity(w))
              y0 = y0 + 1
              point(x0 + sx, y0, color.intensity(0xFF-w))
            end
            point(x1, y1, color)
            return
          end
          
          # horizontal displacement
          e = (dy << 16) / dx
           (x0...(x1-sx)).each do |i|
            e_acc_temp, e_acc = e_acc, (e_acc + e) & 0xFFFF
            y0 += 1 if (e_acc <= e_acc_temp)
            w = 0xFF-(e_acc >> 8)
            point(x0, y0, color.intensity(w))
            x0 += sx
            point(x0, y0 + 1, color.intensity(0xFF-w))
          end
          point(x1, y1, color)
        end
        
      end # Canvas
      
    end
  end
end