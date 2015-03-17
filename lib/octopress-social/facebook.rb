module Octopress
  module Social
    module Facebook
      extend self

      DEFAULTS = {
        'layout'            => 'button',
        'action'            => 'like',
        'show_faces'        => false,
        'share'             => false,
        'colorscheme'       => 'light',
        'kid_directed_site' => false,
        'comment_count'     => 5,
        'link_text'         => 'Facebook',
        'profile_link_text' => 'Friend me on Facebook'
      }

      def config(site=nil)
        @config ||= DEFAULTS.merge(site['facebook'] || {})
      end

      def facebook_share_link(site, item)
        %Q{<a class="facebook-share-link" href="https://www.facebook.com/sharer/sharer.php?u=#{Social.full_url(site, item)}">#{config['link_text']}</a>}
      end

      def facebook_like_button(site, item)
        %Q{<div class="fb-like"
          data-href="#{Social.full_url(site, item)}"
          #{width}
          data-layout="#{config['layout']}"
          data-action="#{config['action']}"
          data-show-faces="#{config['show_faces']}"
          data-colorscheme="#{config['colorscheme']}"
          data-kid-directed-site="#{config['kid_directed_site']}"
          data-share="#{config['share']}"></div>
        }
      end

      def facebook_profile_link(*args)
        %Q{<a class="facebook-profile-link" href="https://www.facebook.com/#{config['profile_id']}">#{config['profile_link_text']}</a>}
      end

      def facebook_follow_button(*args)
        %Q{<div class="fb-follow" 
          data-href="https://www.facebook.com/#{config['profile_id']}"
          #{width}
          data-layout="#{config['layout']}"
          data-layout="#{config['layout']}"
          data-action="#{config['action']}"
          data-colorscheme="#{config['colorscheme']}">
        </div>}
      end

      def facebook_send_button(site, item)
        %Q{<div class="fb-send" 
          data-href="#{Social.full_url(site, item)}"
          #{width}
          data-colorscheme="#{config['colorscheme']}"
          data-kid-directed-site="#{config['kid_directed_site']}"></div>
        }
      end

      def width
        if w = config['width']
          %Q{data-width="#{w}"}
        else
          ''
        end
      end

      def facebook_script_tag(*args)
        %Q{
          <div id="fb-root"></div>
          <script>(function(d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) return;
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.0";
            fjs.parentNode.insertBefore(js, fjs);
          }(document, 'script', 'facebook-jssdk'));</script>
        }
      end

      def facebook_comments(site, item)
        %Q{<div class="fb-comments" 
        data-href="#{Social.full_url(site, item)}" 
        data-numposts="#{config['comment_count']}" 
        data-colorscheme="#{config['colorscheme']}"
        ></div>}
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
          Octopress::Social::Facebook.send(@tag, site, item).gsub(/(\s{2,}|\n)/, ' ').strip
        end
      end
    end
  end
end
