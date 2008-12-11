module FileContentMatcher
    
  class HaveTheSameBitsAs
    
    def initialize( fixture_name )
      @fixture_name = fixture_name
    end
    
    def matches?(target)
      write_test_output(@fixture_name, target) == fixture(@fixture_name)
    end
    
    def failure_message
      "expected #{output_path(@fixture_name)} to match " +
      "#{fixture_path(@fixture_name)}."
    end
    
    def negative_failure_message
      "expected #{output_path(@fixture_name)} not to match " +
      "#{fixture_path(@fixture_name)}."
    end  
            
  end
  
  def have_the_same_bits_as( fixture )
    HaveTheSameBitsAs.new( fixture )    
  end
  
end