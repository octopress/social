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

Liquid::Template.register_tag('twitter_button', Octopress::Social::Twitter::Tag)
Liquid::Template.register_tag('twitter_link', Octopress::Social::Twitter::Tag)
Liquid::Template.register_tag('twitter_script_tag', Octopress::Social::Twitter::ScriptTag)
Liquid::Template.register_tag('gplus_button', Octopress::Social::GooglePlus::Tag)
Liquid::Template.register_tag('gplus_link', Octopress::Social::GooglePlus::Tag)
Liquid::Template.register_tag('gplus_script_tag', Octopress::Social::GooglePlus::ScriptTag)
Liquid::Template.register_tag('facebook_button', Octopress::Social::Facebook::Tag)
Liquid::Template.register_tag('facebook_link', Octopress::Social::Facebook::Tag)
Liquid::Template.register_tag('facebook_script_tag', Octopress::Social::Facebook::ScriptTag)
