# encoding: UTF-8
module Octopress
  module Social
    module Disqus
      extend self

      attr_accessor :url, :config

      DEFAULTS = {
        'comments_link_text'     => 'Comments',
        'comments_link_title'    => 'View comments',
        'disabled_comments_text' => 'Comments disabled'
      }

      def set_config(site)
        @config ||= begin
          config = site['octopress_social'] || site
          DEFAULTS.merge(config['disqus'] || {})
        end
      end

      def set_url(site, item)
        @url = Social.full_url(site, item)
      end

      def identifier(site, item)
        item['disqus_identifier'] || url
      end

      def disqus_comments(site, item)
        if item['comments'] != false
          %Q{<div id="disqus_thread"></div>
            <script type="text/javascript">
              var disqus_shortname = '#{config['shortname']}';
              var disqus_url = '#{url}';
              var disqus_identifier = '#{identifier(site, item)}';
              var disqus_title = '#{item['title']}';
              #{embed_script('embed')}
            </script>
            <noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
          }
        else
          ''
        end
      end

      def embed_script(script)
        %Q{(function () {
            var s = document.createElement('script'); s.async = true;
            s.type = 'text/javascript';
            s.src = '//#{config['shortname']}.disqus.com/#{script}.js';
            (document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s);
          }());
        }
      end

      def disqus_comments_link(site, item)
        if item['comments'] != false
          link = (item['context'] == 'page' ? '' : url)
          link << '#disqus_thread'
          %Q{<a class="disqus-comments-link" title="#{config['comments_link_title']}" href="#{link}">Comments</a>}
        elsif !config['disabled_comments_text'].empty?
          %Q{<span class="disqus-comments-disabled">#{config['disabled_comments_text']}</span>}
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
          site   = context['site']
          item   = Octopress::Social.item(context, @input)

          Octopress::Social::Disqus.set_config(site)
          Octopress::Social::Disqus.set_url(site, item)
          Octopress::Social::Disqus.send(@tag, site, item).gsub(/(\s{2,}|\n)/, ' ').strip
        end
      end
    end
  end
end
