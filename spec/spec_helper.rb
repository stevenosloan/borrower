require 'rspec'
require 'fileutils'

unless ENV['TRAVIS']

  # try and load pry
  begin
    require 'pry'
  rescue LoadError
    puts "no biggie, but pry isn't available"
  end

  # Silence $stdout
  $stdout = StringIO.open('','w+')

end

require_relative 'support/fake_stdin'
require_relative 'support/given'

TMP  = File.join( Dir.pwd, "tmp" )
ROOT = Dir.pwd

RSpec.configure do |config|
  config.include FakeStdin
  config.include Given
end

def cleanup_tmp
  `rm -rf #{TMP}`
end

if ENV['TRAVIS'] || ENV['COVERAGE']
  require 'simplecov'

  if ENV['TRAVIS']
    require 'coveralls'
    SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  end

  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'borrower'