Borrower
==========

For borrowing little snippets.


Use
---

```ruby
require 'borrower'

borrow "/path/to/file.txt", to: "/destination/file.txt"
borrow "http://code.jquery.com/jquery-1.9.1.js", to: "assets/vendor/jquery.1.9.1.js"
```


Testing
-------

```bash
$ autotest
```


Contributing
------------

If there is any thing you'd like to contribute or fix, please:

- Fork the repo
- Add tests for any new functionality
- Make your changes
- Verify all existing tests work properly
- Make a pull request


License
-------
The borrower gem is distributed under the MIT License.