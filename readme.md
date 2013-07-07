Borrower
========

For borrowing and/or concatenating little snippets.

[![Build Status](https://travis-ci.org/stevenosloan/borrower.png?branch=feature/borrow_merge)](https://travis-ci.org/stevenosloan/borrower) [![Code Climate](https://codeclimate.com/github/stevenosloan/borrower.png)](https://codeclimate.com/github/stevenosloan/borrower)

Use
---

To use borrower you first need to require it, then borrow a file from a source to a local destination.

```ruby
require 'borrower'

borrow "/path/to/file.txt", to: "/destination/file.txt"
borrow "http://code.jquery.com/jquery-1.9.1.js", to: "assets/vendor/jquery.1.9.1.js"
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

You can set the comment character as well, so in the case we would like to merge jquery into the head of a js file, you could do it like so:

```javascript
//= borrow 'jquery'
$(document).ready( function(){
  alert("the document is ready");
})
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
