# encoding: UTF-8
module Octopress
  module Social
    module GooglePlus
      extend self

      attr_accessor :url, :config

      DEFAULTS = {
        'size'                => 'medium',
        'count_bubble'        => false,
        'share_link_text'     => 'Google+',
        'share_link_title'    => 'Share on Google+',
        'profile_link_text'   => 'Follow on Google+',
        'profile_link_title'  => 'Follow on Google+',
        'width'               => ''
      }

      HEIGHT = {
        'small' => 15,
        'medium' => 20,
        'large' => 24
      }

      def config(site=nil)
        @config ||= begin
          config = site['octopress_social'] || site
          DEFAULTS.merge(config['gplus'] || {})
        end
      end

      def gplus_share_link(site, item)
        %Q{<a 
          class="g-plus-share-link"
          href="https://plus.google.com/share?url=#{Social.full_url(site, item)}"
          title="#{config['share_link_title']}">#{config['share_link_text']}</a>}
      end

      def gplus_one_button(site, item)
        %Q{<div class="g-plusone" data-href="#{Social.full_url(site, item)}" #{count('share')} #{width} #{size}></div>}
      end

      def gplus_share_button(site, item)
        %Q{<div class="g-plus" data-action="share" data-href="#{Social.full_url(site, item)}" #{count('share')} #{width} #{size}></div>}
      end

      def gplus_follow_button(*args)
        %Q{<div class="g-follow" #{count('follow')} #{height} data-href="//plus.google.com/u/0/#{config['userid']}" data-rel="author"></div>}
      end

      def gplus_profile_link(*args)
        %Q{<a
          class="g-plus-profile-link"
          href="//plus.google.com/u/0/#{config['userid']}"
          title="#{config['profile_link_title']}"
          >#{config['profile_link_text']}</a>}
      end

      def count(type)
        if config["#{type}_count"]
          %Q{data-annotation="bubble"}
        else
          %Q{data-annotation="none"}
        end
      end

      def width
        %Q{data-width="#{config['width']}"}
      end

      def size
        %Q{data-size="#{config['size']}"}
      end

      def height
        %Q{data-height="#{HEIGHT[config['size']]}"}
      end

      def lang(item)
        if item['lang']
          "window.___gcfg = {lang: '#{item['lang']}'};"
        else
          ''
        end
      end

      def gplus_script_tag(site, item)
        %Q{
          <script type="text/javascript">
            #{Octopress::Social::GooglePlus.lang(item)}
            (function() {
              var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
              po.src = 'https://apis.google.com/js/platform.js';
              var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
            })();
          </script>
        }
      end

      class Tag < Liquid::Tag
        def initialize(tag, input, tokens)
          @tag = tag.strip
          @input = input.strip
        end

        def render(context)
          item = Octopress::Social.item(context, @input)
          site = context['site']

          Octopress::Social::GooglePlus.config(site)
          Octopress::Social::GooglePlus.send(@tag, site, item).gsub(/(\s{2,}|\n)/, ' ').strip
        end
      end
    end
  end
end
