# This is a hack of Tempfile. All I needed to do was add File::BINARY mode on 
# file open, but there was no easy way to do this.
require 'tempfile'

BinaryTempfile = Tempfile.dup
class BinaryTempfile

  def initialize(basename, tmpdir=Dir::tmpdir)
    if $SAFE > 0 and tmpdir.tainted?
      tmpdir = '/tmp'
    end
    
    lock = nil
    n = failure = 0
    
    begin
      Thread.critical = true
      
      begin
        tmpname = File.join(tmpdir, make_tmpname(basename, n))
        lock = tmpname + '.lock'
        n += 1
      end while @@cleanlist.include?(tmpname) or
      File.exist?(lock) or File.exist?(tmpname)
      
      Dir.mkdir(lock)
    rescue
      failure += 1
      retry if failure < MAX_TRY
      raise "cannot generate tempfile `%s'" % tmpname
    ensure
      Thread.critical = false
    end
    
    @data = [tmpname]
    @clean_proc = self.class.callback(@data)
    ObjectSpace.define_finalizer(self, @clean_proc)
    
    @tmpfile = File.open(tmpname, File::RDWR|File::CREAT|File::EXCL|File::BINARY, 0600)
    @tmpname = tmpname
    @@cleanlist << @tmpname
    @data[1] = @tmpfile
    @data[2] = @@cleanlist
    
    super(@tmpfile)
    
    # Now we have all the File/IO methods defined, you must not
    # carelessly put bare puts(), etc. after this.
    
    Dir.rmdir(lock)
  end  

end
