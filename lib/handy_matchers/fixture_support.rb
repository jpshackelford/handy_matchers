require 'rexml/document'
require 'yaml'

module FixtureSupport
    
  # set fixture directory base path used in computing #fixture_path 
  def fixture_path_is( path )
    @fixture_path = path    
  end
  
  # set output directory base path used in computing #output_path
  def output_path_is( path )
    @output_path = path
  end
  
  # Return the contents of a fixture file. The file is read binary on Windows.
  def fixture(file)
    File.open(fixture_path(file),'rb'){|f| f.read}
  end
  
  # Return the contents of a fixture file. The file is read binary on Windows.
  def output(file)
    File.open(output_path(file),'rb'){|f| f.read}
  end 
  
  # Return a REXML document for a fixture file. The file name should omit the
  # <tt>.xml</tt> extension as it will be added automatically.
  def xml_fixture( file )
    return REXML::Document.new( fixture( file + '.xml'))
  end
  
  # Return an object graph loaded from the YAML file specified. The file name 
  # should omit the <tt>.yml</tt> extension as it will be added automatically.
  def yml_fixture(file)
    return YAML.load( fixture(file + '.yml'))  
  end
  
  # path to a file in the fixtures directory
  def fixture_path(filename)
    return File.join(@fixture_path || File.join( Dir.pwd, 'fixtures'), filename)
  end
  
  # path to a file in the output directory
  def output_path(filename) 
    out_path = (@output_path || File.join( Dir.pwd, 'test_output'))  
    return File.join(out_path, filename)
  end
  
  # write file in the test output directory 
  def write_test_output(file,data)
    begin
      FileUtils.mkdir_p(output_path(''))
    rescue SystemCallError
      # ignore the error if the directory already exists
    end
    File.open(output_path(file),'wb'){|f| f.write(data)}
    return File.open(output_path(file),'rb'){|f| f.read}
  end
  
  def output_path_delete!
    FileUtils.rm_rf(output_path(''))
  end

end