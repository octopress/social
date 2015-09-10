# encoding: UTF-8
module Octopress
  module Social
    module HackerNews
      extend self

      attr_accessor :url, :config

      DEFAULTS = {
        'share_link_text'     => 'Hacker News',
        'share_link_title'    => 'Share on HackerNews',
        'share_title'         => ':title - :url',
      }

      def set_config(site)
        @config ||= begin
          config = site['octopress_social'] || site
          DEFAULTS.merge(config['hacker_news'] || {})
        end
      end

      def set_url(site, item)
        @url = Social.full_url(site, item)
      end

      def hacker_news_share_link(site, item)
        %Q{<a
          class="hacker-news-share-link"
          href="#{hacker_news_share_url(site, item)}"
          title="#{config['share_link_title']}">#{config['share_link_text']}</a>}
      end

      def hacker_news_share_url(site, item)
        encoded_url = ERB::Util.url_encode(url)
        encoded_share_title = ERB::Util.url_encode(share_title(site, item))
        "http://news.ycombinator.com/submitlink".
          concat("?t=#{encoded_share_title}").
          concat("&u=#{encoded_url}")
      end

      def share_title(site, item)
        (item['hacker_news_share_title'] || config['share_title'])
          .gsub(':title', item['title'] || '')
          .gsub(':url', url)
          .strip
      end

      class Tag < Liquid::Tag
        def initialize(tag, input, tokens)
          @tag = tag.strip
          @input = input.strip
        end

        def render(context)
          site = context['site']
          item = Octopress::Social.item(context, @input)

          Octopress::Social::HackerNews.set_config(site)
          Octopress::Social::HackerNews.set_url(site, item)
          Octopress::Social::HackerNews.send(@tag, site, item).gsub(/(\s{2,}|\n)/, ' ').strip
        end
      end
    end
  end
end
