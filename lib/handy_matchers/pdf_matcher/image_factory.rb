module PDFMatcher    
  class PDF
    
    class ImageFactory
      
      def self.create( image_data )
        case
          when image_data.hash[:Filter] == :DCTDecode
            return DCTImage.new( image_data )
          when image_data.hash[:ColorSpace] == :DeviceRGB
            return RBGImage.new( image_data )
          else
            return PNGImage.new( image_data )
        end
        
      end
      
    end # ImageFactory
    
  end # PDF 
end
