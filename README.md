# Octopress Social

Easy social integrations with Twitter, Facebook, and Google+ with fancy buttons or plain-old links.

[![Build Status](http://img.shields.io/travis/octopress/social.svg)](https://travis-ci.org/octopress/social)
[![Gem Version](http://img.shields.io/gem/v/octopress-social.svg)](https://rubygems.org/gems/octopress-social)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://octopress.mit-license.org)

## Installation

If you're using bundler add this gem to your site's Gemfile in the `:jekyll_plugins` group:

    group :jekyll_plugins do
      gem 'octopress-social'
    end

Then install the gem with Bundler

    $ bundle

To install manually without bundler:

    $ gem install octopress-social

Then add the gem to your Jekyll configuration.

    gems:
      - octopress-social

## Twitter

Configure this plugin in your site's `_config.yml`.

```yaml
twitter:
  username:                      # Add your Twitter handle
  tweet_count:         false     # show number of shares on Twitter
  size:                normal    # or large
  tweet_link_text:     Twitter   # Configure the link text
  tweet_message:       ":title by :username - :url :hashtags"

  follow_count:        false     # show number of followers
  profile_link_text:   "Follow :username"
```

To include hashtags, in your tweet message add them in the YAML front matter of your post or page, like this:

```yaml
twitter_hashtag: tech  # A single hashtag
twitter_hashtags:      # Multiple hashtags
 - tech
 - kittens
```

If your site has multiple authors, you can configure the author's twitter handle in a
post's YAML front-matter and the tweet button (or link) will mention them in the default message.

```yaml
twitter_username: some_author
```

You can also configure a different default message in your post or page's YAML
front-matter:

```
tweet_message: "Yay Jekyll :title by :username - :url :hashtags"
```

Note: This plugin sets the twitter button's "do not track" setting to 'true'. I have
no intention of making this configurable.

### Twitter Tags

To use Twitter's fancy buttons you'll need to add this tag to your site's layout before the closing body tag.

```
{% twitter_script_tag %} # Injects Twitter's widget.js.
```

Sharing tags:
```
{% tweet_button %}
{% tweet_button post %}
{% tweet_link %}          # tweet with a (no js) link
```

The tweet button and tweet link will open a new page with a composed tweet in the format in your Twitter configuration, `:title by :username - :url :hashtags`. If you want tweet buttons to show up on post index or archive pages, add the `post` argument to the tweet button tag.

Follow tags:

```
{% twitter_follow_button %}
{% twitter_profile_link %}
```

## Facebook

Configure this plugin in your site's `_config.yml`.

```yaml
facebook:
  app_id:                            # For a nicer (no js) sharing experience
  profile_id:                        # For follow button or profile link
  action:              like          # Or recommend
  share:               false         # Also add a share button
  layout:              button        # Choices: standard, box_count, button_count, button
  show_faces:          false
  colorscheme:         light         # Or dark
  kid_directed_site:   false         # Is your site directed at kids under 13?
  share_link_text:     Facebook      # Text for plain-old link
  profile_link_text:   "Find me on Facebook"
  comment_count:       5             # Number of facebook comments to show by default
```

These configurations are all based on [Facebook's widget configuration spec](https://developers.facebook.com/docs/plugins/), visit that site for more info.

To get your `profile_id`, take a section from the url to your profile page `https://www.facebook.com/[profile_id]`.

To get an `app_id` you'll need to [register](https://developers.facebook.com/apps) as a developer and go through the process to create an
'app'. This is free and it doesn't mean you're developing software or anything, it's just how Facebook wants to do this. Once you've
created an app, go to the "Basic settings page" by clicking settings, and then finding the "Basic" link. There you should be able to find
your App ID.

### Facebook Tags

To use Facebook's scripted features you'll need to add this tag to your site's layout before the closing body tag.

```
{% facebook_script_tag %} # Injects Facebook's widget.js.
```

Sharing tags:

```
{% facebook_like_button %}
{% facebook_send_button %}   # For private sharing
{% facebook_share_link %}    # share with a (no js) link
```

Friend and Follow tags:

```
{% facebook_follow_button %} # Requires a public profile
{% facebook_profile_link %}
```

Embed Facebook comments widget:

```
{% facebook_comments %}
```

## Google+

Configure this plugin in your site's `_config.yml`.

```yaml
gplus:
  id:                             # Your Google+ userid (for follow button or profile link)
  size:              medium       # choices: small, medium, standard, large
  width:                          # Specify width of button
  share_count:       false        # Show number of shares or +1s
  follow_count:      false        # Show numer of followers
  share_link_text:   Google+      # Text for plain-old link
  profile_link_text: "Follow on Google+"
```

These configurations are based on Google's [web sharing widgets](https://developers.google.com/+/web/+1button/).

### Google+ Tags

To use Google's fancy buttons, you'll need to add this tag to your site's layout before the closing body tag.

```
{% gplus_script_tag %}   # Injects Google's widget.js.
```

Sharing tags:

```
{% gplus_one_button %}
{% gplus_share_button %}
{% gplus_share_link %}   # share with a (no js) link
```

Follow tags:

```
{% gplus_follow_button %}
{% gplus_profile_link %}
```

## Disqus Comments

Configure this plugin in your site's `_config.yml` and optionally on each page or post.

```yaml
disqus_shortname:          # Your site's disqus identifier
```

In any page or post, you can add these configurations to the YAML front-matter.

```
disqus_identifier:     # Unique identifier for this page's comments (defaults to full url)
disqus_title:          # Custom title for comments metadata (defaults to page/post title)
comments: false        # Disable comments for this page or post
```

### Disqus Tags

These tags will help you integrate Disqus comments into your site.

```
{% disqus_comments %}      # Embed comments on a page
```

If you want to link directly to the comments section of a post or page, create a link like this:

```
{% disqus_comments_link %}        # link to the comments section on the current page
{% disqus_comments_link post %}   # link to the comments section on a post (in the posts loop)
```

This will generate a link to the page or post with the on page anchor `#disqus_thread` added, linking you directly to the comments
section.

If you want to show the number of comments in the link, add the following tag to your page layout, somewhere before `</body>`.

```
{% disqus_count_script %}  # Add script for adding counts to comment links
```

This tag will find all comments links on the current page and add the comment count. You can configure this link text from your the admin panel on Disqus's site.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/octopress-social/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
