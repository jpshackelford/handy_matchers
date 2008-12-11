# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  load 'tasks/setup.rb'
end

ensure_in_path 'lib'
require 'handy_matchers'

task :default => 'spec:run'

PROJ.name = 'handy_matchers'
PROJ.authors = 'FIXME (who is writing this software)'
PROJ.email = 'FIXME (your e-mail)'
PROJ.url = 'FIXME (project homepage)'
PROJ.version = HandyMatchers::VERSION
PROJ.rubyforge.name = 'handy_matchers'

PROJ.spec.opts << '--color'

PROJ.gem.need_tar = false
# EOF
