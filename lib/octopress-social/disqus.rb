module Octopress
  module Social
    module Disqus
      extend self

      def config(site=nil)
        @config ||= site['disqus_shortname']
      end

      def url(site, item)
        Social.full_url(site, item)
      end

      def identifier(site, item)
        item['disqus_identifier'] || url(site, item)
      end

      def disqus_comments(site, item)
        %Q{<div id="disqus_thread"></div>
          <script type="text/javascript">
            var disqus_shortname = '#{config}';
            var disqus_url = '#{url(site, item)}';
            var disqus_identifier = '#{identifier(site, item)}';
            var disqus_title = '#{item['title']}';
            #{embed_script('embed')}
          </script>
          <noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments powered by Disqus.</a></noscript>
        }
      end

      def disqus_count_script(site, item)
        %Q{<script type="text/javascript">
        var disqus_shortname = '#{config}';
        #{embed_script('count')}
        </script>  
        }
      end

      def embed_script(script)
        %Q{(function () {
            var s = document.createElement('script'); s.async = true;
            s.type = 'text/javascript';
            s.src = '//#{config}.disqus.com/#{script}.js';
            (document.getElementsByTagName('HEAD')[0] || document.getElementsByTagName('BODY')[0]).appendChild(s);
          }());
        }
      end

      class Tag < Liquid::Tag
        def initialize(tag, input, tokens)
          @tag = tag.strip
          @input = input.strip
        end

        def render(context)
          item = context[@input] || context['page']
          site = context['site']

          config = Octopress::Social::Disqus.config(site)
          if config && item['comments'] != false
            Octopress::Social::Disqus.send(@tag, site, item).gsub(/(\s{2,}|\n)/, ' ').strip
          end
        end
      end
    end
  end
end
