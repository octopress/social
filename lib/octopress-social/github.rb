# encoding: UTF-8
module Octopress
  module Social
    module GitHub

      attr_accessor :config

      extend self

      DEFAULTS = {
        'username'            => nil,
        'profile_link_text'   => ':username on GitHub',
        'profile_link_title'  => ':username on GitHub',
      }

      def set_config(site)
        @config ||= begin
          config = site['octopress_social'] || site
          DEFAULTS.merge(config['github'] || {})
        end
      end

      def username(item={})
        config['username'] || ''
      end

      def profile_link_text
        config['profile_link_text'].sub(':username', username)
      end

      def profile_link_title
        config['profile_link_title'].sub(':username', username)
      end

      def github_profile_link
        %Q{<a
          class="github-profile-link"
          href="https://github.com/#{username.sub('@', '')}"
          title="#{profile_link_title}">#{profile_link_text}</a>}
      end

      def username(item={})
        if username = item['github_username'] || config['username']
          "@#{username.sub('@', '')}" # ensure @ mark, but not two.
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
          Octopress::Social::GitHub.set_config(context['site'])
          Octopress::Social::GitHub.send(@tag).gsub(/(\s{2,}|\n)/, ' ').strip
        end
      end

    end
  end
end
