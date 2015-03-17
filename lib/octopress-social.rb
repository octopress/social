require "octopress-social/version"
require "liquid"

module Octopress
  module Social
    extend self

    autoload :Twitter,                'octopress-social/twitter'
    autoload :Facebook,               'octopress-social/facebook'
    autoload :GooglePlus,             'octopress-social/google-plus'
    
    def full_url(site, item)
      unless root = site['url']
        abort "Site url not configured. Please set url: http://your-site.com in Jekyll configuration file."
      end

      File.join(root, site['baseurl'], item['url'].sub('index.html', ''))
    end
  end
end

Liquid::Template.register_tag('tweet_button', Octopress::Social::Twitter::Tag)
Liquid::Template.register_tag('tweet_link', Octopress::Social::Twitter::Tag)
Liquid::Template.register_tag('twitter_script_tag', Octopress::Social::Twitter::Tag)
Liquid::Template.register_tag('twitter_follow_button', Octopress::Social::Twitter::Tag)
Liquid::Template.register_tag('twitter_profile_link', Octopress::Social::Twitter::Tag)
Liquid::Template.register_tag('gplus_share_button', Octopress::Social::GooglePlus::Tag)
Liquid::Template.register_tag('gplus_share_link', Octopress::Social::GooglePlus::Tag)
Liquid::Template.register_tag('gplus_one_button', Octopress::Social::GooglePlus::Tag)
Liquid::Template.register_tag('gplus_follow_button', Octopress::Social::GooglePlus::Tag)
Liquid::Template.register_tag('gplus_profile_link', Octopress::Social::GooglePlus::Tag)
Liquid::Template.register_tag('gplus_script_tag', Octopress::Social::GooglePlus::Tag)
Liquid::Template.register_tag('facebook_like_button', Octopress::Social::Facebook::Tag)
Liquid::Template.register_tag('facebook_share_link', Octopress::Social::Facebook::Tag)
Liquid::Template.register_tag('facebook_send_button', Octopress::Social::Facebook::Tag)
Liquid::Template.register_tag('facebook_follow_button', Octopress::Social::Facebook::Tag)
Liquid::Template.register_tag('facebook_profile_link', Octopress::Social::Facebook::Tag)
Liquid::Template.register_tag('facebook_comments', Octopress::Social::Facebook::Tag)
Liquid::Template.register_tag('facebook_script_tag', Octopress::Social::Facebook::Tag)

if defined? Octopress::Docs
  Octopress::Docs.add({
    name:        "Octopress Social",
    gem:         "octopress-social",
    version:     Octopress::Social::VERSION,
    description: "Easy social network integration for Jekyll sites.",
    path:        File.expand_path(File.join(File.dirname(__FILE__), "../")),
    source_url:  "https://github.com/octopress/social"
  })
end
