# Borrower

For borrowing little snippets.

## Use

```ruby
require 'borrower'

borrow "/path/to/file.txt", to: "/destination/file.txt"
borrow "http://code.jquery.com/jquery-1.9.1.js", to: "assets/vendor/jquery.1.9.1.js"
```