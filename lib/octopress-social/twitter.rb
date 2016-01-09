# encoding: UTF-8
module Octopress
  module Social
    module Twitter
      extend self

      attr_accessor :url, :config

      DEFAULTS = {
        'tweet_message'       => ":title by :username :hashtags - :url",
        'size'                => 'normal',
        'tweet_count'         => false,
        'follow_count'        => false,
        'tweet_link_text'     => "Twitter",
        'tweet_link_title'    => "Share on Twitter",
        'profile_link_text'   => "Follow :username",
        'profile_link_title'  => "Follow :username on Twitter",
        'timeline_link_text'  => "Tweets by :username",
        'timeline_link_title' => "Tweets by :username",
      }

      def set_config(site)
        @config ||= begin
          config = site['octopress_social'] || site
          DEFAULTS.merge(config['twitter'] || {})
        end
      end

      def set_url(site, item)
        @url = Social.full_url(site, item)
      end

      def tweet_link(site, item)
        %Q{<a 
          class="twitter-share-link"
          href="https://twitter.com/intent/tweet?&text=#{ERB::Util.url_encode(message(site, item)).strip}"
          title="#{config['tweet_link_title']}">#{config['tweet_link_text']}</a>}
      end

      def twitter_timeline_tag(*args)
        %Q{<a
          class="twitter-timeline"
          href="https://twitter.com/#{username.sub('@', '')}"
          data-widget-id="#{config['timeline_widget_id']}"
          title="#{timeline_link_title}">#{timeline_link_text}</a>}
      end

      def tweet_button(site, item)
        %Q{
          <a href="https://twitter.com/share" class="twitter-share-button" 
          #{'data-size="large"' if config['size'] == 'large'}
          #{'data-count="none"' if !config['tweet_count']}
          data-url="#{url}"
          #{button_message(site, item)}
          data-dnt="true">#{config['tweet_link_text']}</a>
        }
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

      def profile_link_title(item={})
        config['profile_link_title'].sub(':username', username)
      end

      def timeline_link_title(item={})
        config['timeline_link_title'].sub(':username', username)
      end

      def message(site, item)
        username_var = (username(item).empty? ? 'by :username' : ':username')
        (item['tweet_message'] || config['tweet_message'])
          .sub(':title', item['title'] || '')
          .sub(username_var, username(item))
          .sub(':url', url)
          .sub(':hashtags', hashtags(item))
          .strip
      end

      def button_message(site, item)
        %Q{data-text="#{message(site, item).sub(/\s?#{url}/, '')}"}
      end

      def profile_link_text
        config['profile_link_text'].sub(':username', username)
      end

      def twitter_profile_link(*args)
        %Q{<a
          class="twitter-profile-link"
          href="https://twitter.com/#{username.sub('@', '')}"
          title="#{profile_link_title}">#{profile_link_text}</a>}
      end

      def timeline_link_text
        config['timeline_link_text'].sub(':username', username)
      end

      def twitter_follow_button(*args)
        %Q{
          <a href="https://twitter.com/#{username.sub('@', '')}" class="twitter-follow-button" 
          #{'data-show-count="false"' if !config['follow_count']} data-dnt="true">#{profile_link_text}</a>
        }
      end

      def twitter_script_tag(*args)
        "<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>"
      end

      def tweet(site, item, url, content)
        user = "@#{url.match(/.com\/(.+)?\/status/)[1]}"
        %Q{<blockquote class="twitter-tweet"
          data-link-color="#{config['embedded_link_color']}"
          lang="#{item['lang'] || site['lang']}">
          <p>#{content}</p>
          <a href="#{url}"> — #{user}</a>
          </blockquote>
        }
      end

      class Tweet < Liquid::Block
        def initialize(tag, input, tokens)
          super
          @tag = tag.strip
          @input = input.strip
        end

        def render(context)
          content = super(context)
          site = context['site']
          item = context['page']
          Octopress::Social::Twitter.tweet(site, item, @input, content).gsub(/(\s{2,}|\n)/, ' ').strip
        end
      end

      class Tag < Liquid::Tag
        def initialize(tag, input, tokens)
          @tag = tag.strip
          @input = input.strip
        end

        def render(context)
          site = context['site']
          item = Octopress::Social.item(context, @input)

          Octopress::Social::Twitter.set_config(site)
          Octopress::Social::Twitter.set_url(site, item)
          Octopress::Social::Twitter.send(@tag, site, item).gsub(/(\s{2,}|\n)/, ' ').strip
        end
      end
    end
  end
end
