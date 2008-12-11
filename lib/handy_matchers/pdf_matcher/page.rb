module PDFMatcher    
  class PDF
    
    class Page
      
      attr_reader :text, :images, :image_refs, :info
      
      def initialize( info )
        @info = info
        @text = ''
        @images = {}
        @image_refs = []
      end
     
      def add_text( text )
        @text << text
      end
      
      def add_image( id, image )
        @images.store( id , image )
      end
      
      def add_image_ref( id )
        @image_refs << id
      end
      
      def has_text?( regexp )
         text =~ regexp
      end
      
      def has_image?( fixture_name )
        matcher = ImageMatcher::MatchImage.new( fixture_name )
        @images.values.find do |image|           
          matcher.matches?( image )
        end
      end
    
    end 
    
  end
end
