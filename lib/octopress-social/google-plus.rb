module Octopress
  module Social
    module GooglePlus
      extend self

      DEFAULTS = {
        'size' => 'medium',
        'count_bubble' => 'horizontal',
        'link_text' => "Google+"
      }

      SIZES = {
        'large' => '24',
        'medium' => false,
        'small' => '15'
      }

      COUNT_BUBBLE = {
        'horizontal' => 'bubble',
        'vertical' => 'vertical-bubble',
        'none' => 'none',
        'inline' => false
      }

      def config(site=nil)
        @config ||= DEFAULTS.merge(site['google_plus'] || {})
      end

      def share_link(site, item)
        %Q{<a class='gplus-share-link' href="https://plus.google.com/share?url=#{Social.full_url(site, item)}">#{config['link_text']}</a>}
      end

      def share_button(site, item)
        %Q{<div class="g-plus" data-action="share" #{bubble} #{width} #{height}></div>}
      end

      def bubble
        if b = COUNT_BUBBLE[config['count_bubble']]
          %Q{data-annotation="#{b}"}
        else
          ''
        end
      end

      def width
        if w = config['width']
          %Q{data-width="#{w}"}
        else
          ''
        end
      end

      def height
        if size = SIZES[config['size']]
          %Q{data-height="#{size}"}
        else
          ''
        end
      end

      def lang(item)
        if item['lang']
          "window.___gcfg = {lang: '#{item['lang']}'};"
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

          Octopress::Social::GooglePlus.config(site)

          if @tag == 'gplus_link'
            Octopress::Social::GooglePlus.share_link(site, item)
          else
            Octopress::Social::GooglePlus.share_button(site, item)
          end
        end
      end

      class ScriptTag < Liquid::Tag
        def render(context)
          item = context['page']

          %Q{
            <script type="text/javascript">
              #{Octopress::Social::GooglePlus.lang(item)}
              (function() {
                var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
                po.src = 'https://apis.google.com/js/platform.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
              })();
            </script>
          }.gsub(/\s{2,}/, ' ').gsub("\n", '').strip
        end
      end
    end
  end
end
