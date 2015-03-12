- fix finding of nested files in directories added to the manifest

# 0.9.1
- slimline the Content#get_response methdo to use more default Net::HTTP and not set old (broken) SSLv3

# 0.9.0
- add an "expanded_path" step to Manifest#find to also search for files at an expanded path.

# 0.8.1
- change the "binary" check to instead check for valid encoding

# 0.8.0
- add an `on_conflict` option to borrow and ::put, existing behavior remains overwriting existing files

# 0.7.0
- skip merge & yields on binary content
- implement a manifest file, must be called manifest.borrower for now

# 0.6.0
- add file type option to merge
- fix options being passed to merge from `borrow` method

# 0.5.0
- merge has been removed from Borrower.put
- add coveralls coverage

# 0.4.0
- add file content manipulation by passing a block to `borrow`, (https://github.com/stevenosloan/borrower/issues/3)

# 0.3.0
- combine path & transport modules, will break if you were using them directly

# 0.2.1
- add license type to gemspec (https://github.com/stevenosloan/borrower/issues/1)

# 0.2.0
- layout a public api for singleton methods
- there are possibly breaking changes from 0.1.x

# 0.1.1
- fix missing implementation of the borrow method using find

# 0.1.0
- add manifest for naming files and adding directories
- add merge/concatenation functionality

# 0.0.3
- use content encoding for the file write

# 0.0.2
- fix matching for http responses

# 0.0.1
- implement first version of borrow dsl
- add basic tests for mvp of gem

# 0.0.0
- bootstrap gem