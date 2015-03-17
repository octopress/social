# Octopress Social

Easy social features from Twitter, Facebook, and Google+ with fancy buttons or plain-old links.

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

To use Twitter's fancy buttons you'll need to add this tag to your site's layout before the closing body tag.

```
{% twitter_script_tag %} # Injects Twitter's widget.js.
```

Share options:
```
{% tweet_button %}
{% tweet_button post %}
{% tweet_link %}          # tweet with a (no js) link
```

The tweet button and tweet link will open a new page with a composed tweet in the format in your Twitter configuration, `:title by :username - :url :hashtags`. If you want tweet buttons to show up on post index or archive pages, add the `post` argument to the tweet button tag.

Follow options:

```
{% twitter_follow_button %}
{% twitter_profile_link %}
```

### Twitter Configuration

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

If you want your default tweet message to include one or more hashtags, you can set
them in the YAML front matter of your post or page, like this:

```yaml
twitter_hashtag: tech  # A single hashtag
twitter_hashtags:      # Multiple hashtags
 - tech
 - kittens
```

If your site has multiple authors, you can configure the author's twitter handle in
the post's YAML front-matter like this.

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

## Facebook

To use Facebook's scripted features you'll need to add this tag to your site's layout before the closing body tag.

```
{% facebook_script_tag %} # Injects Facebook's widget.js.
```

Sharing options:

```
{% facebook_like_button %}
{% facebook_send_button %}   # For private sharing
{% facebook_share_link %}    # share with a (no js) link
```

Add Friends and Followers:

```
{% facebook_follow_button %} # Requires a public profile
{% facebook_profile_link %}
```

Embed Facebook comments widget:

```
{% facebook_comments %}
```

### Facebook Configuration

These configurations are all based on [Facebook's widget configuration spec](https://developers.facebook.com/docs/plugins/), visit that site for more info.

```yaml
facebook:
  profile_id:                        # For follow button or profile link
  action:              like          # Or recommend
  share:               false         # Also add a share button
  layout:              button        # Choices: standard, box_count, button_count, button
  show_faces:          false
  colorscheme:         light         # Or dark
  kid_directed_site:   false         # Is your site directed at kids under 13?
  link_text:           Facebook      # Text for plain-old link
  profile_link_text:   "Find me on Facebook"
  comment_count:       5             # Number of facebook comments to show by default
```

## Google+

To use Google's fancy buttons, you'll need to add this tag to your site's layout before the closing body tag.

```
{% gplus_script_tag %} # Injects Google's widget.js.
```

Sharing:

```
{% gplus_one_button %}
{% gplus_share_button %}
{% gplus_share_link %}   # share with a (no js) link
```

Following:

```
{% gplus_follow_button %}
{% gplus_profile_link %}
```

### Google+ Configuration

These configurations are based on Google's [web sharing widgets](https://developers.google.com/+/web/+1button/).

```yaml
gplus:
  userid:                         # Your Google+ userid (for follow button or profile link)
  size:              medium       # choices: small, medium, standard, large
  width:                          # Specify width of button
  share_count:       false        # Show number of shares or +1s
  follow_count:      false        # Show numer of followers
  link_text:         Google+      # Text for plain-old link
  profile_link_text:  "Follow on Google+"
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/octopress-social/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
