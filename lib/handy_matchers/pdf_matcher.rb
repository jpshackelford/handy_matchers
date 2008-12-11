require 'rubygems'
require 'pdf/reader'

module PDFMatcher
  
  class PDF

    def self.parse( file )
      model = new()
      parser = PDFMatcher::PDF::Parser.new( model )
      ::PDF::Reader.file( file, parser )
      return model
    end
    
    attr_reader :pages

    def initialize
      @pages = []
    end
    
    def add_page( info )
      new_page = Page.new( info )
      @pages << new_page
      return new_page
    end
    
    def has_text?( regexp )
      @pages.find{|p| p.has_text?( regexp )}
    end
    
    def has_image?( image_name )
      @pages.find{|p| p.has_image?( image_name )}
    end
    
  end
  
  def pdf_fixture( name )
    PDFMatcher::PDF.parse( fixture_path( name + '.pdf'))
  end
  
end