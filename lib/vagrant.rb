libdir = File.dirname(__FILE__)
$:.unshift(libdir)
PROJECT_ROOT = File.join(libdir, '..') unless defined?(PROJECT_ROOT)

# The libs which must be loaded prior to the rest
%w{tempfile open-uri json pathname logger uri net/http virtualbox net/ssh archive/tar/minitar
  net/scp fileutils vagrant/util vagrant/actions/base vagrant/downloaders/base vagrant/actions/runner}.each do |f|
  require f
end

# Glob require the rest
Dir[File.join(PROJECT_ROOT, "lib", "vagrant", "**", "*.rb")].each do |f|
  require f
end