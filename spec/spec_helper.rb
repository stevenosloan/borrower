require 'rspec'
require 'fileutils'

TMP = File.join( Dir.pwd, "tmp" )

def given_files list
  FileUtils.mkdir_p TMP
  Array(list).each do |f|
    file_path = File.join( TMP, f )
    FileUtils.mkdir_p( File.dirname(file_path) )
    FileUtils.touch( file_path )
  end
end

def given_file name, content
  file_path = File.join( TMP, name )
  FileUtils.mkdir_p( File.dirname(file_path) )
  File.open( file_path, 'w' ) do |file|
    file.write content
  end
end

def given_config contents
  File.open( File.join( TMP, '.borrower' ), 'w' ) do |file|
    file.write content
  end
end

def cleanup_tmp
  `rm -rf #{TMP}`
end

require 'coveralls'
Coveralls.wear!

require 'borrower'