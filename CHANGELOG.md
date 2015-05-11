# Changelog

### 1.4.2 (2015-05-11)
- Minor: Added UTF-8 encoding headers for better Ruby 1.9 support.

### 1.4.2 (2015-04-01)
- Fix: Doesn't break if email address configured as a top level key, e.g. `email: me@example.com`.

### 1.4.1 (2015-03-24)
- Fix: Added title attribute for email share link.

### 1.4.0 (2015-03-24)
- New: Email sharing and contact tags
- New: GitHub profile link
- New: All links now have title attribute set.

### 1.3.0 (2015-03-21)
- New: Embeddable tweets with {% tweet %} tag.
- Fixed: Default tweet message (without configured username) removes 'by' credit.
- Fixed: Tweets in post loops shared current page instead of post.

### 1.2.0 (2015-03-18)
- New: Added Disqus comments link tag.
- New: Facebook comments link tag.
- New: Tags auto-detect context (sharing a post or the current page).
- Fixed: Hashtags are added on tweet link.

### 1.1.0 (2015-03-17)
- New: Added support Disqus comments.
- New: Disable Facebook comments on any page or post with `comments: false`.

### 1.0.0 (2015-03-17)
- Initial release
