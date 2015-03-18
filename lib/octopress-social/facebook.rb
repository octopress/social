module Octopress
  module Social
    module Facebook
      extend self

      attr_accessor :url, :config

      DEFAULTS = {
        'profile_id'        => nil,
        'app_id'            => nil,
        'layout'            => 'button',
        'action'            => 'like',
        'show_faces'        => false,
        'share'             => false,
        'colorscheme'       => 'light',
        'kid_directed_site' => false,
        'comment_count'     => 5,
        'share_link_text'   => 'Facebook',
        'profile_link_text' => 'Friend me on Facebook',
        'comments_link_text' => 'Comments',
        'disabled_comments_text' => 'Comments disabled'
      }

      def set_config(site)
        @config ||= DEFAULTS.merge(site['facebook'] || {})
      end

      def set_url(site, item)
        @url = Social.full_url(site, item)
      end

      def facebook_share_link(site, item)
        if config['app_id']
          %Q{<a class="facebook-share-link" href="https://www.facebook.com/dialog/share?
          app_id=#{config['app_id']}
          &href=#{url}&redirect_uri=#{url}"
          target="_blank">#{config['share_link_text']}</a>
          }
        else
          %Q{<a class="facebook-share-link" 
          href="https://www.facebook.com/sharer/sharer.php?u=#{url}" 
          target="_blank">#{config['share_link_text']}</a>}
        end
      end

      def facebook_like_button(site, item)
        %Q{<div class="fb-like"
          data-href="#{url}"
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
          data-href="#{url}"
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
        if item['comments'] != false
          %Q{<div class="fb-comments" id="facebook_comments"
          data-href="#{url}" 
          data-numposts="#{config['comment_count']}" 
          data-colorscheme="#{config['colorscheme']}"
          ></div>}
        else
          ''
        end
      end

      def facebook_comments_link(site, item)
        if item['comments'] != false
          link = (item['context'] == 'page' ? '' : url)
          link << '#facebook_comments'
          %Q{<a class="facebook-comments-link" href="#{link}">Comments</a>}
        elsif !config['disabled_comments_text'].empty?
          %Q{<span class="facebook-comments-disabled">#{config['disabled_comments_text']}</span>}
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
          item = Octopress::Social.item(context, @input)
          site = context['site']

          Octopress::Social::Facebook.set_url(site, item)
          Octopress::Social::Facebook.set_config(site)
          Octopress::Social::Facebook.send(@tag, site, item).gsub(/(\s{2,}|\n)/, ' ').strip
        end
      end
    end
  end
end
