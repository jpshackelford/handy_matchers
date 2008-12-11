require 'fileutils'

module ImageMatcher
  
  include FixtureSupport
  
  class MatchImage
    
    def self.perceptualdiff_installed?
      begin
        return true if `perceptualdiff`
      rescue SystemCallError
        return false
      end
    end
    
    # Run perceptualdiff utility from the commandline and return true if 
    # the files match.
    def self.perceptual_diff( file1, file2 )      
      begin
        commandline = "perceptualdiff \"#{file1}\" \"#{file2}\""
        output = IO.popen( commandline ){|io| io.gets }        
        result = output !~ /FAIL|Unknown filetype/       
      rescue SystemCallError
        result = false
      end
      return result      
    end
    
    def initialize( fixture_name )
      @fixture_name = fixture_name
      @tempfile = nil
    end
    
    def matches?( target )      
      # Since we are calling perceptualdiff on the command line 
      # we have to write out the target to a file and then pass the path
      # as an argument to the command. The approach we take here is to 
      # use a tempfile, but then to copy the file to the test output path
      # if it doesn't match so that the files can be manually inspected when
      # troubleshooting a failure.
      @tempfile = capture( target, @fixture_name )
      MatchImage.perceptual_diff( fixture_path(@fixture_name), @tempfile.path )
    end
    
    def capture( data, basename )
      f = BinaryTempfile.new( @fixture_name )
      f.write( data )
      f.close
      return f
    end
    
    def save_output( tempfile )
      outpath = output_path( File.basename( tempfile.path ) )
      FileUtils.mkdir_p( output_path(''))
      FileUtils.cp( tempfile.path, outpath)
      return outpath
    end

    def failure_message
      outpath = save_output( @tempfile )     
      "expected #{outpath} to match #{fixture_path(@fixture_name)}."
    end
    
    def negative_failure_message
      outpath = save_output( @tempfile )
      "expected #{outpath} not to match #{fixture_path(@fixture_name)}." \
      "Note that we used a perceptual rather than bitwise comparison."
    end     
  end
  
  def match_image( fixture )
    if MatchImage.perceptualdiff_installed?
      MatchImage.new( fixture )
    else      
      FileContentMatcher::HaveTheSameBitsAs.new( fixture )
    end  
  end  
end

# Re-open HaveTheSameBitsAs to clarify that we could deliver better
# results with perceptualdiff installed.
module FileContentMatcher
  class HaveTheSameBitsAs      
    def failure_message
      "expected #{output_path(@fixture_name)} to match " +
      "#{fixture_path(@fixture_name)}. Bitwise comparison isn't 100% reliable. " + 
      "Visually compare or install perceptualdiff."
    end
  end    
end
