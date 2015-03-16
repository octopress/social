module Octopress
  module Social
    module Twitter
      extend self

      DEFAULTS = {
        'default_message' => ":title by :username - :url :hashtags",
        'size' => 'normal',
        'show_count' => true,
        'link_text' => "Twitter"
      }

      def config(site=nil)
        @config ||= DEFAULTS.merge(site['twitter'] || {})
      end

      def share_link(site, item)
        %Q{<a href="https://twitter.com/intent/tweet?url=#{Social.full_url(site, item)}&text=#{message(site, item)}" class="twitter-share-link">#{config['link_text']}</a>}
      end

      def share_button(site, item)
        %Q{
          <a href="https://twitter.com/share" class="twitter-share-button" 
          data-url="#{Social.full_url(site, item)}"
          #{'data-size="large"' if config['size'] == 'large'}
          #{button_message(site, item)}
          data-dnt="true">#{config['link_text']}</a>
          #{'data-count="none"' if !config['show_count']}
          #{button_script}
        }.gsub(/\s{2,}/, ' ').gsub("\n", '')
      end

      def username(item)
        if username = item['twitter_username'] || config['username']
          "@#{username.sub('@', '')}" # ensure @ mark, but not two.
        else
          ''
        end
      end

      def hashtags(item)
        hashtags = Array(item['hashtag'] || item['hashtags'])
          .map{|h| "##{h.sub('#', '')}" } # ensure hash mark, but not two.
          .join(' ')
      end

      def message(site, item)
        (item['twitter_default_message'] || config['default_message'])
          .sub(':title', item['title'] || '')
          .sub(':username', username(item))
          .sub(':url', Social.full_url(site, item))
          .sub(':hashtags', hashtags(item))
          .strip
      end

      def button_message(site, item)
        %Q{data-message="#{message(site, item)}"}
      end

      def button_script
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

          if @tag == 'twitter_link'
            Octopress::Social::Twitter.share_link(site, item)
          else
            Octopress::Social::Twitter.share_button(site, item)
          end
        end
      end

      class ScriptTag < Liquid::Tag
        def render(context)
          "<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>"
        end
      end
    end
  end
end
