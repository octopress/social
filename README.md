# Octopress Social

Easy social sharing on Twitter, Facebook, and Google+ with fancy buttons or plain-old links.

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

## Usage

To use those fancy social buttons, add the script tags for the services
you use to your site's layout. If you want to use plain-old sharing links, you won't need these.

```
{% twitter_script_tag %}
{% facebook_script_tag %}
{% gplus_script_tag %}
```

Next add the button or link tags. For fancy buttons:

```
{% twitter_button %}
{% facebook_button %}
{% gplus_button %}
```


For plain-old privacy-friendly, bandwith-conservative links use these:

```
{% twitter_link %}
{% facebook_link %}
{% gplus_link %}
```

And feel less icky.

## Configuration

Configure this plugin in your site's `_config.yml`.

### Twitter

```yaml
twitter:
  username:                # Add your Twitter handle
  show_count:    true      # vanity by default
  size:          normal    # large is the other option
  link_text:     Twitter   # Configure the link text
  default_message: ":title by :username - :url :hashtags"
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
twitter_default_message: "Yay Jekyll :title by :username - :url :hashtags"
```

Note: This plugin sets the twitter button's "do not track" setting to 'true'. I have
no intention of making this configurable.


### Facebook

These configurations are all based on [Facebook's official like button spec](https://developers.facebook.com/docs/plugins/like-button), visit that site for more info.

```yaml
action:              like          # or recommend
share:               false         # also add a share button
layout:              button_count  # choices: standard, box_count, button_count, button
show_faces:          false         # Please don't
colorscheme:         light         # or dark
kid_directed_site:   false         # Is your site directed at kids under 13?
link_text:           Facebook      # Text for plain-old link
```

### Google+

These configurations are based on the [offical Google+ share button generator](https://developers.google.com/+/web/share/).

```yaml
size:         medium       # choices: large, medium, small
count_bubble: horizontal   # choices: horizontal, vertical, inline, none
link_text:    Google+
```

## TODO:

- Add follow buttons.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/octopress-social/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
