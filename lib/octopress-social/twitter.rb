module Octopress
  module Social
    module Twitter
      extend self

      DEFAULTS = {
        'tweet_message' => ":title by :username - :url :hashtags",
        'size' => 'normal',
        'tweet_count' => false,
        'follow_count' => false,
        'tweet_link_text' => "Twitter",
        'follow_link_text' => "Follow :username"
      }

      def config(site=nil)
        @config ||= DEFAULTS.merge(site['twitter'] || {})
      end

      def tweet_link(site, item)
        %Q{<a href="https://twitter.com/intent/tweet?url=#{Social.full_url(site, item)}&text=#{message(site, item)}" class="twitter-share-link">#{config['tweet_link_text']}</a>}
      end

      def tweet_button(site, item)
        %Q{
          <a href="https://twitter.com/share" class="twitter-share-button" 
          #{'data-size="large"' if config['size'] == 'large'}
          #{'data-count="none"' if !config['tweet_count']}
          #{button_message(site, item)}
          data-dnt="true">#{config['tweet_link_text']}</a>
        }.gsub(/\s{2,}/, ' ').gsub("\n", '').strip
      end

      def username(item={})
        if username = item['twitter_username'] || config['username']
          "@#{username.sub('@', '')}" # ensure @ mark, but not two.
        else
          ''
        end
      end

      def hashtags(item)
        hashtags = Array(item['twitter_hashtag'] || item['twitter_hashtags'])
          .map{|h| "##{h.sub('#', '')}" } # ensure hash mark, but not two.
          .join(' ')
      end

      def message(site, item)
        (item['tweet_message'] || config['tweet_message'])
          .sub(':title', item['title'] || '')
          .sub(':username', username(item))
          .sub(':url', Social.full_url(site, item))
          .sub(':hashtags', hashtags(item))
          .strip
      end

      def button_message(site, item)
        %Q{data-text="#{message(site, item)}"}
      end

      def follow_link_text
        config['follow_link_text'].sub(':username', username)
      end

      def twitter_follow_link(*args)
        %Q{<a href="https://twitter.com/#{username.sub('@', '')}" class="twitter-follow-link">#{follow_link_text}</a>}
      end

      def twitter_follow_button(*args)
        %Q{
          <a href="https://twitter.com/#{username.sub('@', '')}" class="twitter-follow-button" 
          #{'data-show-count="false"' if !config['follow_count']} data-dnt="true">#{follow_link_text}</a>
        }.gsub("\n", '').gsub(/\s{2,}/, ' ').strip
      end

      def twitter_script_tag(*args)
        "<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>"
      end

      class Tag < Liquid::Tag
        def initialize(tag, input, tokens)
          @tag = tag.strip
          @input = input.strip
        end

        def render(context)
          item = context[@input] || context['page']
          site = context['site']

          Octopress::Social::Twitter.config(site)
          Octopress::Social::Twitter.send(@tag, site, item)
        end
      end
    end
  end
end
