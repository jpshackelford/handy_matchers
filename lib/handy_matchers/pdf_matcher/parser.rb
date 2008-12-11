module PDFMatcher    
  class PDF
    class Parser
      
      def initialize( model )
        @model = model
        @current_page = nil
      end
      
      def begin_page( info )
        @current_page = @model.add_page( info )
      end
      
      def show_text( text, *params )
        @current_page.add_text( text )
      end
      
      # there's a few text callbacks, so make sure we process them all
      alias :super_show_text :show_text
      alias :move_to_next_line_and_show_text :show_text
      alias :set_spacing_next_line_show_text :show_text

      def show_text_with_positioning(*params)
        params = params.first
        params.each{ |str| show_text(str) if str.kind_of?(String)}
      end      

      def invoke_xobject(*params)
        @current_page.add_image_ref( params.first )
      end
      
      def resource_xobject( id, image_data )
        # TODO: Need to use the image dumping mechanism in pdftoruby.rb
        # to capture the image in a format we can understand and use with
        # perceptual_diff. See their #resource_xobject
        image = ImageFactory.create( image_data )
        @current_page.add_image( id, image.file_contents )
      end
      
    end
  end
end