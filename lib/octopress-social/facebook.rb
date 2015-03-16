module Octopress
  module Social
    module Facebook
      extend self

      DEFAULTS = {
        'layout' => 'button_count',
        'action' => 'like',
        'show_faces' => false,
        'share' => false,
        'colorscheme' => 'light',
        'kid_directed_site' => false,
        'link_text' => "Facebook"
      }

      def config(site=nil)
        @config ||= DEFAULTS.merge(site['facebook'] || {})
      end

      def share_link(site, item)
        %Q{<a facebook-share-link href="https://www.facebook.com/sharer/sharer.php?u=#{Social.full_url(site, item)}">#{config['link_text']}</a>}
      end

      def like_button(site, item)
        %Q{<div class="fb-like" 
          data-href="#{Social.full_url(site, item)}"
          #{width}
          data-layout="#{config['layout']}"
          data-action="#{config['action']}"
          data-show-faces="#{config['show_faces']}"
          data-colorscheme="#{config['colorscheme']}"
          data-kid-directed-site="#{config['kid_directed_site']}"
          data-share="#{config['share']}"></div>
        }.gsub("\n", '').gsub(/\s{2,}/, ' ').strip
      end

      def width
        if w = config['width']
          %Q{data-width="#{w}"}
        else
          ''
        end
      end

      class Tag < Liquid::Tag
        def initialize(tag, input, tokens)
          @tag = tag.strip
          @input = input.strip
        end

        def render(context)
          item = context[@input] || context['page']
          site = context['site']

          Octopress::Social::Facebook.config(site)

          if @tag == 'facebook_link'
            Octopress::Social::Facebook.share_link(site, item)
          else
            Octopress::Social::Facebook.like_button(site, item)
          end
        end
      end

      class ScriptTag < Liquid::Tag
        def render(context)
          %Q{
          <div id="fb-root"></div>
          <script>(function(d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.0";
            fjs.parentNode.insertBefore(js, fjs);
          }(document, 'script', 'facebook-jssdk'));</script>
          }.gsub(/\s{2,}/, '').gsub("\n", '').strip
        end
      end
    end
  end
end
