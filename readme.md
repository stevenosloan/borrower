Borrower
========

For borrowing and/or concatenating little snippets.

[![Build Status](https://travis-ci.org/stevenosloan/borrower.png?branch=feature/borrow_merge)](https://travis-ci.org/stevenosloan/borrower) [![Coverage Status](https://coveralls.io/repos/stevenosloan/borrower/badge.png?branch=master)](https://coveralls.io/r/stevenosloan/borrower?branch=master) [![Code Climate](https://codeclimate.com/github/stevenosloan/borrower.png)](https://codeclimate.com/github/stevenosloan/borrower)

Check out the ruby versions we're testing against in [travis.yml](.travis.yml). Don't see a ruby version you're using? Pull requests are welcome.

Use
---

To use borrower you first need to require it, then borrow a file from a source to a local destination.

```ruby
require 'borrower'

borrow "/path/to/file.txt", to: "/destination/file.txt"
borrow "http://code.jquery.com/jquery-1.9.1.js", to: "assets/vendor/jquery.1.9.1.js"
```

You can also manipulate the content of the file before it is written by passing a block, and returning your desired output

```ruby
require 'borrower'

borrow '/path/to/file.txt', to: '/now/with/feeling.txt' do |content|
  content.gsub('.', '!')
end
```


#### Named files & lookup paths

To avoid having to type out the full path of a file each time you'd like to borrow it, you can setup names for files or lookup paths.

```ruby
Borrower.manifest do |m|
  m.file "jquery", "http://code.jquery.com/jquery-1.9.1.js"
  m.dir "/long/path/name/to/the/desired/directory"
end
```

After configuring the manifest so, you can now borrow jquery by just using it's name:

```ruby
borrow "jquery", to: "/destination/jquery.1.9.1.js"
```

Borrower will also look for a manifest file named `manifest.borrower`. You can write your directory and file names in yaml format and they will be loaded from the manifest file.

```ruby
files:
  name: path
  jquery: "http://code.jquery.com/jquery-1.9.1.js"

directories:
  first/directory
  another/directory
```

You can also use paths relative to the directories you described. Note that the shortest match wins, so in cases where there are two files in a given directory -- the file closest to the root (or with the shortest dir name) will be grabbed:

```ruby
# file structure
# /foo.txt
# /woo.txt
# /subdir/woo.txt
# /subdir/baz.txt

borrow "foo.txt", to: "/destination/foo.txt"
borrow "woo.txt", to: "/destination/woo.txt"
# note that this takes the /woo.txt, not /subdir/woo.txt

borrow "baz.txt", to: "/destination/baz.txt"
# this finds baz.txt at /subdir/baz.txt
```


#### Merging/Concatenation

Borrower also supports merging files it knows about as it is moving them by passing the `merge: true` param. Just add `#= borrow 'file_name'` anywhere in the file you're moving.

```ruby
# foo.rb
I'm a line from foo.rb

# woo.rb
#= borrow 'foo.rb'

borrow 'woo.rb', to: 'concat.rb', merge: true
# => results in the file:
# concat.rb
I'm a line from foo.rb
```

Borrower defaults to `#` as the comment character, but you can pass a file type to look for other comment symbols.

```javascript
# script.js
//= borrow 'jquery'
$(document).ready( function(){
  alert("the document is ready");
})
```
```ruby
# borrow.rb
borrow 'script.js', to: 'public/script.js', merge: true, type: 'js'
```

You can set a custom comment character as well, so if you were working in a language we don't have a comment symbol for (though please add a pull request for that), you could do it like so:

```
# your_file.txt
??= borrow 'jquery'
$(document).ready( function(){
  alert("the document is ready");
});

# borrow.rb
borrow 'your_file.txt', to: 'foo.txt', merge: true, comment: '??'
```

### File Conflicts

In the case that a file already exists at the destination_path, by default Borrower will overwrite the file. To change this behavior you can pass an `:on_conflict` option.

```ruby
borrow 'from', to: 'to', on_conflict: :overwrite
# => the default, will overwrite the file

borrow 'from', to: 'to', on_conflict: :prompt
# => will ask if the file should be overwritten

borrow 'from', to: 'to', on_conflict: :skip
# => skips existing files

borrow 'from', to: 'to', on_conflict: :raise_error
# => raises an error
```


## Utilities

At its core borrower abstracts some common tasks over the file system.

### Fetch Content
```ruby
Borrower.take 'path/to/file'
```

### Write Content
```ruby
on_conflict = :overwrite
Borrower.put "content for file", 'path/to/destination', on_conflict

on_conflict = :overwrite
# => replaces the contents of the file if already present

on_conflict = :skip
# => skips putting content

on_conflict = :propt
# => asks via stdout & stdin if the file should be overwriten

on_conflict = :raise_error
# => raises an error
```

### Add lookup paths or files
```ruby
Borrower.manifest do |m|
  m.file "jquery", "http://code.jquery.com/jquery-1.10.2.min.js"
  # => adds an alias for jquery
  m.dir  "vendor"
  # => adds the vendor dir to the lookup paths
end
```

### Find file in borrower paths
```ruby
Borrower.find 'partial/path/to/file'
# => full path to file
```


Testing
-------

```bash
$ rspec
```


Contributing
------------

If there is any thing you'd like to contribute or fix, please:

- Fork the repo
- Add tests for any new functionality
- Make your changes
- Verify all new &existing tests pass
- Make a pull request


License
-------
The borrower gem is distributed under the MIT License.
