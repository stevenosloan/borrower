require 'rspec'
require 'fileutils'

begin
  require 'pry-debugger'
rescue LoadError
  puts "no biggie, but pry debugger isn't available"
end

require_relative 'support/fake_stdin'
require_relative 'support/given'

TMP  = File.join( Dir.pwd, "tmp" )
ROOT = Dir.pwd

# Silence $stdout
$stdout = StringIO.open('','w+')

RSpec.configure do |config|
  config.include FakeStdin
  config.include Given
end

def cleanup_tmp
  `rm -rf #{TMP}`
end

require 'coveralls'
Coveralls.wear!

require 'borrower'